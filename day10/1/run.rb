#!/usr/bin/ruby

file="input"

if ARGV[0] == "--simple"
  file="simple"
end

numbers = []

f = File.open(file, "r")
f.each_line do |line|
  n = line.strip.to_i

  numbers << n
end
f.close

numbers.sort!

joltage = 0
diffs = {}

# add the built-in adapter
numbers << numbers.last + 3

numbers.each do |n|
  diff = n - joltage
  if diff > 3
    raise "Cannot jump from #{joltage} to #{n}"
  end
  joltage = n

  diffs[diff] ||= 0
  diffs[diff] += 1
end

puts diffs[1] * diffs[3]
