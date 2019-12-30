# --- Day 14: Disk Defragmentation ---
#
# Suddenly, a scheduled job activates the system's disk defragmenter.
# Were the situation different, you might sit and watch it for a
# while, but today, you just don't have that kind of time.  It's
# soaking up valuable system resources that are needed elsewhere, and
# so the only option is to help it finish its task as soon as
# possible.
#
# The disk in question consists of a 128x128 grid; each square of the
# grid is either free or used.  On this disk, the state of the grid is
# tracked by the bits in a sequence of knot hashes.
#
# A total of 128 knot hashes are calculated, each corresponding to a
# single row in the grid; each hash contains 128 bits which correspond
# to individual grid squares.  Each bit of a hash indicates whether
# that square is free (0) or used (1).
#
# The hash inputs are a key string (your puzzle input), a dash, and a
# number from 0 to 127 corresponding to the row.  For example, if your
# key string were flqrgnkx, then the first row would be given by the
# bits of the knot hash of flqrgnkx-0, the second row from the bits of
# the knot hash of flqrgnkx-1, and so on until the last row,
# flqrgnkx-127.
#
# The output of a knot hash is traditionally represented by 32
# hexadecimal digits; each of these digits correspond to 4 bits, for a
# total of 4 * 32 = 128 bits.  To convert to bits, turn each
# hexadecimal digit to its equivalent binary value, high-bit first: 0
# becomes 0000, 1 becomes 0001, e becomes 1110, f becomes 1111, and so
# on; a hash that begins with a0c2017... in hexadecimal would begin
# with 10100000110000100000000101110000... in binary.
#
# Continuing this process, the first 8 rows and columns for key
# flqrgnkx appear as follows, using # to denote used squares, and . to
# denote free ones:
#
# ##.#.#..-->
# .#.#.#.#
# ....#.#.
# #.#.##.#
# .##.#...
# ##..#..#
# .#...#..
# ##.#.##.-->
# |      |
# V      V
#
# In this example, 8108 squares are used across the entire 128x128
# grid.
#
# Given your actual key string, how many squares are used?
#
# --------------------
#
# We reuse our knot hash code from day 10.  We represent the grid as a
# set of the [row,column] positions of the grid squares in use.

require "set"

Input = "hxtvlmkl"
N = 256

def hash_round(lengths, a, p, s)
  lengths.each do |l|
    a[0,l] = a[0,l].reverse
    a.rotate!(l+s)
    p = (p+l+s)%N
    s += 1
  end
  [p, s]
end

def knot_hash(string)
  lengths = string.chars.map{|c|c.ord} + [17, 31, 73, 47, 23]
  a = (0...N).to_a
  p = s = 0
  64.times { p, s = hash_round(lengths, a, p, s) }
  a.rotate!(-p)
  a.each_slice(16).map {|s| "%02x" % s.reduce(:^) }.join
end

$grid = Set.new
(0...128).each do |r|
  ("%0128b" % knot_hash("#{Input}-#{r}").to_i(16)).chars
    .each_with_index {|b,c| $grid.add([r,c]) if b == "1" }
end

puts $grid.length

# --- Part Two ---
#
# Now, all the defragmenter needs to know is the number of regions.  A
# region is a group of used squares that are all adjacent, not
# including diagonals.  Every used square is in exactly one region:
# lone used squares form their own isolated regions, while several
# adjacent squares all count as a single region.
#
# In the example above, 1242 regions are present.
#
# How many regions are present given your key string?

def walk(p)
  return if not $grid.member? p
  $grid.delete p
  r, c = p
  [[r-1,c], [r+1,c], [r,c-1], [r,c+1]].each {|q| walk(q) }
end

n = 0
while $grid.length > 0 do
  walk($grid.first)
  n += 1
end
puts n
