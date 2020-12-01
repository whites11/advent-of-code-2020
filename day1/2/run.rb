#!/usr/bin/ruby

file="input"

candidates = []

f = File.open(file, "r")
f.each_line { |line|
  candidates << line.to_i
}
f.close

candidates.sort!

i=0
j=candidates.size - 1

while i != j do
  small=candidates[i]
  big=candidates[j]
  sum=small+big

  if sum == 2020 then
    puts "Numbers are #{big} and #{small}, answer is #{big*small}"
    exit
  end


  if sum > 2020 then
    j -= 1
  else
    i += 1
  end
end

puts "ERROR"
