#!/usr/bin/ruby

file="input"
file="simple" if ARGV[0] == "--simple"

lat = 0
lon = 0

waypoint_lat = 1
waypoint_lon = 10

INSTRUCTION_REGEXP = /^([NSEWLRF]{1})([0-9]+)$/

f = File.open(file, "r")
f.each_line do |line|
  line.match(INSTRUCTION_REGEXP) do |m|
    raise 'Parse error' if m.nil?

    instruction = m.captures[0]
    amount = m.captures[1].to_i

    case instruction
    when "N"
      waypoint_lat += amount
    when "S"
      waypoint_lat -= amount
    when "E"
      waypoint_lon += amount
    when "W"
      waypoint_lon -= amount
    when "L"
      # anticlockwise
      radians = amount * Math::PI / 180
      la = waypoint_lat
      lo = waypoint_lon
      waypoint_lat = (lo * Math.sin(radians) + la * Math.cos(radians)).round
      waypoint_lon = (lo * Math.cos(radians) - la * Math.sin(radians)).round
    when "R"
      # clockwise
      radians = -1 * amount * Math::PI / 180
      la = waypoint_lat
      lo = waypoint_lon
      waypoint_lat = (lo * Math.sin(radians) + la * Math.cos(radians)).round
      waypoint_lon = (lo * Math.cos(radians) - la * Math.sin(radians)).round
    when "F"
      # move ship to waypoint amount times
      lat += waypoint_lat * amount
      lon += waypoint_lon * amount
    end

    puts "#{line.strip} Boat: #{lon},#{lat} Waypoint: #{waypoint_lon},#{waypoint_lat}"
  end
end
f.close

puts lat.abs + lon.abs
