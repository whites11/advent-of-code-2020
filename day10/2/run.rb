#!/usr/bin/ruby

file="input"

if ARGV[0] == "--simple"
  file="simple"
end

numbers = [0]

f = File.open(file, "r")
f.each_line do |line|
  n = line.strip.to_i

  numbers << n
end
f.close

numbers.sort!

# add the built-in adapter
numbers << numbers.last + 3

paths = {}

numbers.each_with_index do |n, idx|
  i = idx + 1
  count = 0
  while i < numbers.length
    diff = numbers[i] - n
    break if diff > 3
    count += 1
    paths[numbers[i]] ||= []
    paths[numbers[i]] << n
    i += 1
  end
end

cache = {}

def get_count(paths, cache, n)
  sources = paths[n]
  return 1 if sources.nil?

  unless cache[n].nil?
    return cache[n]
  end

  sum = 0
  sources.each do |s|
    sum += get_count(paths, cache, s)
  end

  cache[n] = sum

  sum
end

puts get_count(paths, cache, numbers.last)
