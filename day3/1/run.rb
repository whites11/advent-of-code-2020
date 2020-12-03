#!/usr/bin/ruby

file="input"

rows = []

# number of columns in a row.
cols_in_row = 0

f = File.open(file, "r")
f.each_line do |line|
  rows << line
  cols_in_row = line.length if cols_in_row == 0
end
f.close

col_idx = 0
trees = 0

# iterate through all lines
rows.each_with_index do |line, row_idx|
  char = line[col_idx % (rows[0].length - 1)]

  trees += 1 if char == "#"

  col_idx += 3
end

puts trees
