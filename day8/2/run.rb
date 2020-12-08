#!/usr/bin/ruby

require 'json'

file="input"
file="simple" if ARGV[0] == "--simple"

INSTRUCTION_REGEX = /^(nop|acc|jmp) ([+-][0-9]+)$/

class Instruction
  NOP = "nop"
  ACC = "acc"
  JMP = "jmp"

  def initialize(instruction, argument)
    unless [NOP, ACC, JMP].include? instruction
      raise 'Unknown instruction'
    end
    @instruction = instruction
    @argument = argument
  end

  def execute
    case @instruction
    when NOP
      return 0, 1
    when ACC
      return @argument, 1
    when JMP
      return 0, @argument
    end
  end

  def to_s
    "#{@instruction} #{@argument}"
  end

  def correctable?
    [NOP, JMP].include? @instruction
  end

  def correct!
    case @instruction
    when NOP
      @instruction = JMP
    when JMP
      @instruction = NOP
    else
      raise "Instruction #{@instruction} is not correctable"
    end
  end
end

class Program
  class << self
    # ensure that your constructor can't be called from the outside
    protected :new

    def from_file(file)
      instructions = []
      f = File.open(file, "r")
      f.each_line do |line|
        line.match(INSTRUCTION_REGEX) do |m|
          instruction = m.captures[0]
          argument = m.captures[1].to_i

          i = Instruction.new(instruction, argument)
          instructions << i
        end
      end
      f.close

      new(instructions)
    end
  end

  def initialize(instructions)
    @global = 0
    @program_counter = 1
    @loop_check = {}
    @instructions = instructions
    @previous = -1
    @last_correction = -1
  end

  def run_with_auto_correct
    while @program_counter <= @instructions.length
      @loop_check[@program_counter] ||= 0

      if @loop_check[@program_counter] > 0
        if @last_correction >= 0
          # revert previous correction
          @instructions[@last_correction].correct!
        end

        # try to apply a correction
        corrected = false
        while @last_correction < @instructions.length
          @last_correction += 1
          if @instructions[@last_correction].correctable?
            @instructions[@last_correction].correct!
            corrected = true
            break
          end
        end

        unless corrected
          raise "Unable to correct program"
        end

        # restart program
        @global = 0
        @program_counter = 1
        @loop_check = {}
        @previous = -1
        next
      end

      @loop_check[@program_counter] += 1

      # get next instruction
      i = @instructions[@program_counter-1]

      # execute
      global_change, pc_change = i.execute

      # update registries
      @global += global_change
      @previous = @program_counter
      @program_counter += pc_change
    end
    puts "Program terminated normally"
    puts "We corrected instruction #{@last_correction}"
    puts "Global #{@global}"
  end
end

p = Program::from_file(file)

p.run_with_auto_correct
