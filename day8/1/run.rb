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
    @program_counter = 0
    @loop_check = {}
    @instructions = instructions
  end

  def run
    while @program_counter < @instructions.length
      puts "Running instruction at PC #{@program_counter}"

      @loop_check[@program_counter] ||= 0

      if @loop_check[@program_counter] > 0
        puts "Program is looping at PC #{@program_counter}"
        puts "Global registry value is #{@global}"
        return
      end

      @loop_check[@program_counter] += 1

      # get next instruction
      i = @instructions[@program_counter]

      # execute
      global_change, pc_change = i.execute

      # update registries
      @global += global_change
      @program_counter += pc_change
    end
  end
end

p = Program::from_file(file)

p.run
