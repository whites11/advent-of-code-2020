#!/usr/bin/ruby

require 'prime'

file="input"
file="simple" if ARGV[0] == "--simple"

buses = nil

f = File.open(file, "r")
f.each_line.with_index do |line, idx|
  buses = line.strip.split(",").map do |x| x end if idx == 1
end
f.close

t = 0
step = 1
buses.each_with_index do |b, offset|
  next if b == "x"

  while (t + offset) % b.to_i != 0
    t += step
  end

  step = step * b.to_i
end

puts t
