#!/usr/bin/ruby

require 'json'

file="input"
file="simple" if ARGV[0] == "--simple"

CONTAINER_REGEXP = /^(.*) bags contain/

contained = {}

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
      count = matches[1].to_i
      color = matches[2]

      contained[container] ||= {}
      contained[container][color] = count

      rest = rest[(matches[0].length)..-1]
    end
  end
end
f.close

targets = [{"color" => "shiny gold", "count" => 1}]
count = 0
while targets.length > 0
  target_with_number = targets[0]
  target = target_with_number["color"]
  unless contained[target].nil?
    contained[target].each_pair do |color,num|
      targets << { "color" => color, "count" => num * target_with_number["count"] }
      count += num * target_with_number["count"]
    end
  end
  targets.delete_at 0
end

puts count
