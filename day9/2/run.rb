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

target = -1
i = preamble_size
while i < numbers.length
  n = numbers[i]

  addends = numbers[(i-preamble_size)..(i-1)].sort!

  unless find_sum(addends, n)
    target = n
    break
  end

  i += 1
end

puts "Looking for contiguous numbers that sum up to #{target}"

start = 0
len = 0
sum = 0
while start + len < numbers.length
  sum += numbers[start + len]

  if sum == target
    list = numbers[start..(start+len)]
    list.sort!
    puts list.first + list.last
    break
  end

  if sum > target
    # exceeded, start over with next number
    len = 0
    start += 1
    sum = 0
    next
  end

  if sum < target
    len += 1
  end
end
