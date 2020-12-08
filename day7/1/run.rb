#!/usr/bin/ruby

require 'json'

file="input"
file="simple" if ARGV[0] == "--simple"

CONTAINER_REGEXP = /^(.*) bags contain/

containers = {}

f = File.open(file, "r")
f.each_line do |line|
  container = ""
  line.match(CONTAINER_REGEXP) do |m|
    raise 'Parse error' if m.nil?

    container = m.captures[0]
  end

  rest = line[(container.length + 14)..-1].strip

  if rest != "no other bags."
    while rest.length > 0
      scan = rest.scan(/^(([1-9][0-9]*) ([^,]+) bags?,?\s?\.?)/)
      matches = scan[0]
      count = matches[1]
      color = matches[2]

      containers[color] ||= []
      containers[color] << container

      rest = rest[(matches[0].length)..-1]
    end
  end
end
f.close

targets = ["shiny gold"]
results = []
while targets.length > 0
  targets.each do |target|
    unless containers[target].nil?
      targets = targets | containers[target]
      results = results | containers[target]
    end
    targets.delete(target)
  end
end

results.uniq!

puts results.length
