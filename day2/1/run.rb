#!/usr/bin/ruby

file="input"

LINE_FORMAT = /^(\d+)-(\d+) ([a-z]): ([a-z]+)$/

valid = 0

f = File.open(file, "r")
f.each_line do |line|
  line.match(LINE_FORMAT) do |m|
    raise 'Parse error' if m.nil?

    min = m.captures[0].to_i
    max = m.captures[1].to_i
    target = m.captures[2]
    candidate = m.captures[3]

    len = candidate.length
    candidate.gsub!(/#{target}/, "")

    count = len-candidate.length

    if count >= min && count <= max
      valid += 1
    end
  end
end
f.close

puts valid

