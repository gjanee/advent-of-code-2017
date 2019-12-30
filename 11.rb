# --- Day 11: Hex Ed ---
#
# Crossing the bridge, you've barely reached the other side of the
# stream when a program comes up to you, clearly in distress.  "It's
# my child process," she says, "he's gotten lost in an infinite grid!"
#
# Fortunately for her, you have plenty of experience with infinite
# grids.
#
# Unfortunately for you, it's a hex grid.
#
# The hexagons ("hexes") in this grid are aligned such that adjacent
# hexes can be found to the north, northeast, southeast, south,
# southwest, and northwest:
#
#   \  n  /
# nw +---+ ne
#   /     \
# -+       +-
#   \     /
# sw +---+ se
#   /  s  \
#
# You have the path the child process took.  Starting where he
# started, you need to determine the fewest number of steps required
# to reach him.  (A "step" means to move from the hex you are in to
# any adjacent hex.)
#
# --------------------
#
# From https://www.redblobgames.com/grids/hexagons/#distances: there's
# a terrifically clever way of representing hex grid positions as
# coordinate tuples x,y,z with x+y+z = 0.  The distance between two
# grid cells is just the maximum absolute coordinate difference!

Origin = [0, 0, 0]

Steps = {
  "n"  => [1, -1, 0],
  "ne" => [0, -1, 1],
  "se" => [-1, 0, 1],
  "s"  => [-1, 1, 0],
  "sw" => [0, 1, -1],
  "nw" => [1, 0, -1]
}

class Array
  def move!(offset)
    self.replace(self.zip(offset).map{|a,b|a+b})
  end
  def distance(other)
    self.zip(other).map{|a,b|(a-b).abs}.max
  end
end

def solve
  l = Origin.clone
  m = 0
  IO.read("11.in").chomp.split(",").each do |s|
    l.move!(Steps[s])
    m = [m, l.distance(Origin)].max
  end
  [l.distance(Origin), m]
end

puts solve[0]

# --- Part Two ---
#
# How many steps away is the furthest he ever got from his starting
# position?

puts solve[1]
