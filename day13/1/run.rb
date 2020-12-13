#!/usr/bin/ruby

file="input"
file="simple" if ARGV[0] == "--simple"

timestamp = 0
buses = ""

f = File.open(file, "r")
f.each_line.with_index do |line, idx|
  timestamp = line.to_i if idx == 0
  buses = line.strip.split(",").keep_if do |x| x != "x" end.map do |x| x.to_i end if idx == 1
end
f.close

min_wait = Float::INFINITY
bus_num = -1
buses.each do |b|
  if timestamp % b == 0
    min_wait = 0
    bus_num = b
    break
  end

  wait = b - (timestamp % b)
  if wait < min_wait
    bus_num = b
    min_wait = wait
  end
end

puts min_wait * bus_num
