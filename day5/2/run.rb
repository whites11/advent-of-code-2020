#!/usr/bin/ruby

file="input"
file="simple" if ARGV[0] == "--simple"

occupied = []

f = File.open(file, "r")
f.each_line do |line|
  min_row = 0
  max_row = 127
  min_col = 0
  max_col = 7

  line.strip.each_char.with_index do |c,i|
    if i < 7
      mean = (min_row + max_row) / 2
      case c
      when "F"
        max_row = mean
      when "B"
        min_row = mean + 1
      else
        raise "Unexpected char in position #{i}: #{c}"
      end
    else
      mean = (min_col + max_col) / 2
      case c
      when "L"
        max_col = mean
      when "R"
        min_col = mean + 1
      else
        raise "Unexpected char in position #{i}: #{c}"
      end
    end
  end

  raise "Can't determine row for #{line.strip}: #{min_row} #{max_row}" if min_row != max_row
  raise "Can't determine col for #{line.strip}: #{min_col} #{max_col}" if min_col != max_col

  seat_id = min_row * 8 + min_col

  occupied << seat_id
end
f.close

occupied.sort!

# look for a hole in the list

i = 0
while i < occupied.length - 1
  if occupied[i+1] - occupied[i] > 1
    puts occupied[i+1] - 1
  end
  i += 1
end

