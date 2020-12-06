#!/usr/bin/ruby

require 'json'

file="input"
file="simple" if ARGV[0] == "--simple"

group_answers = []

current_group_answers = []
f = File.open(file, "r")
f.each_line do |line|
  if line.strip == ""
    group_answers << current_group_answers if current_group_answers.length > 0
    current_group_answers = []
    next
  end
  current_group_answers << line.strip.split("")
end
f.close
group_answers << current_group_answers if current_group_answers.length > 0

sum = 0

# Count shared answers
group_answers.map do |group|
  first = []
  group.each_with_index do |answers,i|
    if i == 0
      first = answers
    else
      # intersection
      first = first & answers

      # no common answers
      if first.length == 0
        break
      end
    end
  end
  sum += first.length
end

puts sum
