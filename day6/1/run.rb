#!/usr/bin/ruby

file="input"
file="simple" if ARGV[0] == "--simple"

group_answers = []

current_group_answer = []
f = File.open(file, "r")
f.each_line do |line|
  if line.strip == ""
    group_answers << current_group_answer if current_group_answer.length > 0
    current_group_answer = []
    next
  end
  line.strip.each_char do |ans|
    current_group_answer << ans
  end
end
f.close
group_answers << current_group_answer if current_group_answer.length > 0

counts = group_answers.map do |ga| ga.uniq.length end

puts counts.sum
