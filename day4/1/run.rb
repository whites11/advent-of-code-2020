#!/usr/bin/ruby

file="input"
file="simple" if ARGV[0] == "--simple"

passports = []

# number of columns in a row.
cols_in_row = 0

current_passport = {}
f = File.open(file, "r")
f.each_line do |line|
  if line.strip == ""
    passports << current_passport if current_passport.length > 0
    current_passport = {}
    next
  end
  line.split(" ").each do |kvs|
    kv = kvs.split(":")
    current_passport[kv[0]] = kv[1]
  end
  cols_in_row = line.length if cols_in_row == 0
end
f.close
passports << current_passport if current_passport.length > 0

valid = 0
required_fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

passports.each do |p|
  valid += 1 if (required_fields - p.keys).length == 0
end

puts valid
