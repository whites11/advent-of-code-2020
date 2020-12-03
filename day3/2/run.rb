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

# iterate through all lines
cases = [[1,1], [3,1], [5,1], [7,1], [1,2]]
mul = 1
cases.each do |c|
  row_idx = 0
  col_idx = 0
  trees = 0
  while row_idx < rows.length
    line = rows[row_idx]
    char = line[col_idx % (rows[0].length - 1)]

    trees += 1 if char == "#"

    col_idx += c[0]
    row_idx += c[1]
  end
  mul *= trees
end

puts mul
