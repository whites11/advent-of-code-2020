#!/usr/bin/ruby

file="input"
file="simple" if ARGV[0] == "--simple"

max = -1

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
  max = seat_id if seat_id > max
end
f.close

puts max
