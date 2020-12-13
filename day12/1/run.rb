#!/usr/bin/ruby

file="input"
file="simple" if ARGV[0] == "--simple"

# North = 0
# East = 1
# South = 2
# West = 3
direction = 1
lat = 0
lon = 0

INSTRUCTION_REGEXP = /^([NSEWLRF]{1})([0-9]+)$/

f = File.open(file, "r")
f.each_line do |line|
  line.match(INSTRUCTION_REGEXP) do |m|
    raise 'Parse error' if m.nil?

    instruction = m.captures[0]
    amount = m.captures[1].to_i

    case instruction
    when "N"
      lat += amount
    when "S"
      lat -= amount
    when "E"
      lon += amount
    when "W"
      lon -= amount
    when "L"
      direction -= (amount / 90)
      direction = direction % 4
    when "R"
      direction += (amount / 90)
      direction = direction % 4
    when "F"
      case direction
      when 0 # north
        lat += amount
      when 1 # east
        lon += amount
      when 2 # south
        lat -= amount
      when 3 # west
        lon -= amount
      end
    end
  end
end
f.close

puts lat.abs + lon.abs
