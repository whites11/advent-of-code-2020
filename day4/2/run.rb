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

def validate_password(p)
  p.each_pair do |field,val|
    case field
    when "byr"
      # 4 digits
      match = /\A[0-9]{4}\Z/.match(val)
      return false if match.nil?

      # >= 1920 <= 2002
      y = match[0].to_i
      return false unless y >= 1920 && y <= 2002
    when "iyr"
      # 4 digits
      match = /\A[0-9]{4}\Z/.match(val)
      return false if match.nil?

      # >= 2010 <= 2020
      y = match[0].to_i
      return false unless y >= 2010 && y <= 2020
    when "eyr"
      # 4 digits
      match = /\A[0-9]{4}\Z/.match(val)
      return false if match.nil?

      # >= 2020 <= 2030
      y = match[0].to_i
      return false unless y >= 2020 && y <= 2030
    when "hgt"
      # number followed by either "cm" or "in"
      match = /\A([0-9]+)(cm|in)\Z/.match(val)
      return false if match.nil?

      h = match[1].to_i
      # if cm >= 150 <= 193
      return false if match[2] == "cm" && (h < 150 || h > 193)
      # if in >= 59 <= 76
      return false if match[2] == "in" && (h < 59 || h > 76)
    when "hcl"
      # Starts with #, followed by 6 hex
      match = /\A#[0-9a-fA-F]{6}\Z/.match(val)
      return false if match.nil?
    when "ecl"
      # one of [amb blu brn gry grn hzl oth]
      return false unless ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].include? val
    when "pid"
      # nine digit number including leading zeros
      match = /\A[0-9]{9}\Z/.match(val)
      return false if match.nil?
    end
  end
end

passports.each do |p|
  next unless (required_fields - p.keys).length == 0

  valid += 1 if validate_password p
end

puts valid
