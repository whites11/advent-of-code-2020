#!/usr/bin/ruby

file="input"

candidates = []

f = File.open(file, "r")
f.each_line { |line|
  candidates << line.to_i
}
f.close

candidates.sort!

candidates.each_with_index do |d, k|
  target = 2020-d
  i=0
  j=candidates.size - 1

  while i != j do
    if i == k then
      i = i+1
      next
    end
    if j == k then
      j = j-1
      next
    end

    small=candidates[i]
    big=candidates[j]
    sum=small+big

    if sum == target then
      puts "Numbers are #{big},  #{small}, and #{d}. Answer is #{big*small*d}"
      exit
    end

    if sum > target then
      j -= 1
    else
      i += 1
    end
  end
end

puts "ERROR"
