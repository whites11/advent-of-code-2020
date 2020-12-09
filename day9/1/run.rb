#!/usr/bin/ruby

file="input"
preamble_size = 25

if ARGV[0] == "--simple"
  preamble_size = 5
  file="simple"
end

numbers = []

f = File.open(file, "r")
f.each_line do |line|
  n = line.strip.to_i

  numbers << n
end
f.close

def find_sum(addends, n)
  i = 0
  j = addends.length - 1
  while i != j
    sum = addends[i] + addends[j]
    return true if sum == n

    if sum > n
      j -= 1
    else
      i += 1
    end
  end

  false
end

i = preamble_size
while i < numbers.length
  n = numbers[i]

  addends = numbers[(i-preamble_size)..(i-1)].sort!

  unless find_sum(addends, n)
    puts "First failed is #{n}"
    break
  end

  i += 1
end
