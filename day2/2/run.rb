#!/usr/bin/ruby

file="input"

LINE_FORMAT = /^(\d+)-(\d+) ([a-z]): ([a-z]+)$/

valid = 0

f = File.open(file, "r")
f.each_line do |line|
  line.match(LINE_FORMAT) do |m|
    raise 'Parse error' if m.nil?

    first_idx = m.captures[0].to_i - 1
    last_idx = m.captures[1].to_i - 1
    target = m.captures[2]
    candidate = m.captures[3]

    first = candidate[first_idx]
    last = candidate[last_idx]

    if first == target && last != target ||
        first != target && last == target
      valid += 1
    end

  end
end
f.close

puts valid
