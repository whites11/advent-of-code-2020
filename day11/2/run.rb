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
    @adiacent_ids = {}

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
        if occupied >= 5
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
    if @adiacent_ids[i].nil?
      row = i / @width
      column = i - row * @width

      ids = []

      # left
      (i - 1).downto(row * @width) do |c|
        if @seats[c] != "."
          ids << c
          break
        end
      end

      # right
      (i + 1).upto((row + 1) * @width - 1) do |c|
        if @seats[c] != "."
          ids << c
          break
        end
      end

      # up
      c = i - @width
      while c > 0
        if @seats[c] != "."
          ids << c
          break
        end
        c = c - @width
      end

      # down
      c = i + @width
      while c < @seats.length
        if @seats[c] != "."
          ids << c
          break
        end
        c = c + @width
      end

      # top left
      1.upto(column) do |col|
        c = i - (col * @width) - col
        break if c < 0
        if @seats[c] != "."
          ids << c
          break
        end
      end

      # bottom left
      1.upto(column) do |col|
        c = i + (col * @width) - col
        break if c > @seats.length
        if @seats[c] != "."
          ids << c
          break
        end
      end

      # top right
      1.upto(@width - column - 1) do |col|
        c = i - (col * @width) + col
        break if c < 0
        if @seats[c] != "."
          ids << c
          break
        end
      end

      # bottom right
      1.upto(@width - column - 1) do |col|
        c = i + (col * @width) + col
        break if c > @seats.length
        if @seats[c] != "."
          ids << c
          break
        end
      end

      @adiacent_ids[i] = ids

      # if i == 39
      #   b = @seats.dup
      #
      #   b[i] = "X"
      #   ids.each do |id|
      #     b[id] = "@"
      #   end
      #
      #   puts self
      #
      #   k = "-"*@width + "\n"
      #   j = 0
      #   while j < b.length
      #     k += b[j..(j+@width - 1)] + "\n"
      #     j += @width
      #   end
      #   k += "-"*@width + "\n"
      #   puts k
      # end
    end

    ret = []
    @adiacent_ids[i].each do |id|
      ret << @seats[id]
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
