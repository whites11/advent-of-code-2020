#!/usr/bin/ruby

file="input"

if ARGV[0] == "--simple"
  file="simple"
end

class Boat
  def initialize(file)
    @seats = ""
    @width = 0
    @height = 0
    f = File.open(file, "r")
    f.each_line do |line|
      @seats += line.strip
      @width = line.strip.length if @width == 0
      @height += 1
    end
    f.close
  end

  def seats
    @seats
  end

  def to_s
    ret = "-"*@width + "\n"
    i = 0
    while i < @seats.length
      ret += @seats[i..(i+@width - 1)] + "\n"
      i += @width
    end
    ret += "-"*@width + "\n"
    ret
  end

  def round
    # iterate on the seats
    i = 0
    new_seats = @seats.dup
    while i < @seats.length
      seat = @seats[i]

      if seat == "."
        # floor
        i += 1
        next
      end

      adiacents = self.get_adiacents(i)
      occupied = adiacents.select do |as| as == "#" end.length

      # If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
      if seat == "L"
        if occupied == 0
          # seat becomes occupied
          new_seats[i] = "#"
        end
      end

      # If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
      if seat == "#"
        if occupied >= 4
          # seat becomes empty
          new_seats[i] = "L"
        end
      end

      i += 1
    end

    changed = @seats.dup == new_seats

    @seats = new_seats

    changed
  end

  private

  def get_adiacents(i)
    first_row = (i / @width == 0)
    last_row = (i / @width == (@height - 1))
    first_column = (i % @width == 0)
    last_column = (i % @width == (@width - 1))

    ret = []
    unless first_column
      ret << @seats[i - 1]
      ret << @seats[i - @width - 1] unless first_row
      ret << @seats[i + @width - 1] unless last_row
    end
    unless last_column
      ret << @seats[i + 1]
      ret << @seats[i - @width + 1] unless first_row
      ret << @seats[i + @width + 1] unless last_row
    end
    unless first_row
      ret << @seats[i - @width]
    end
    unless last_row
      ret << @seats[i + @width]
    end

    ret
  end
end

boat = Boat.new(file)

changed = false
until changed
  changed = boat.round
end

puts boat.seats.gsub(/[.L]+/, "").length
