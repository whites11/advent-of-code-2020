#!/usr/bin/ruby

file="input"
file="simple" if ARGV[0] == "--simple"

class Instruction
  def initialize(mem, val)
    @mem = mem
    @val = val
  end

  def mem
    @mem
  end

  def to_s
    "mem[#{@mem}] = #{@val}"
  end

  def bitmasked_val(bitmask)
    bin = @val.to_s(2).rjust(bitmask.length, '0')
    i = 0
    while i < bitmask.length
      c = bitmask[i]

      case c
      when "0"
        bin[i] = "0"
      when "1"
        bin[i] = "1"
      end

      i += 1
    end

    bin.reverse.chars.map.with_index do |digit, index|
      digit.to_i * 2**index
    end.sum
  end
end

mask = ""
memory = {}

INSTRUCTION_REGEX = /^mem\[([1-9]+[0-9]*)\] = ([0-9]+)$/

f = File.open(file, "r")
f.each_line.with_index do |line, idx|
  if line.start_with?("mask = ")
    mask = line[7..-1].strip
  else
    line.match(INSTRUCTION_REGEX) do |m|
      mem = m.captures[0].to_i
      val = m.captures[1].to_i

      i = Instruction.new(mem, val)
      memory[i.mem] = i.bitmasked_val(mask)
    end
  end
end
f.close

sum = 0
memory.each_pair do |m,v|
  sum += v
end

puts sum
