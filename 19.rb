# --- Day 19: A Series of Tubes ---
#
# Somehow, a network packet got lost and ended up here.  It's trying
# to follow a routing diagram (your puzzle input), but it's confused
# about where to go.
#
# Its starting point is just off the top of the diagram.  Lines (drawn
# with |, -, and +) show the path it needs to take, starting by going
# down onto the only line connected to the top of the diagram.  It
# needs to follow this path until it reaches the end (located
# somewhere within the diagram) and stop there.
#
# Sometimes, the lines cross over each other; in these cases, it needs
# to continue going the same direction, and only turn left or right
# when there's no other option.  In addition, someone has left letters
# on the line; these also don't change its direction, but it can use
# them to keep track of where it's been.  For example:
#
#       |
#       |  +--+
#       A  |  C
#   F---|----E|--+
#       |  |  |  D
#       +B-+  +--+
#
# The little packet looks up at you, hoping you can help it find the
# way.  What letters will it see (in the order it would see them) if
# it follows the path?
#
# --------------------
#
# Our code is greatly simplified by the facts that the puzzle input
# includes a margin of spaces on all four sides; that turns exactly
# correspond with plus signs; and that the spacing is sufficient to
# ensure that turns are unambiguous.

Board = IO.readlines("19.in")

def solve
  r, c = 0, Board[0].index("|")
  directions = [[0,1], [-1,0], [0,-1], [1,0]]
  d = 3
  letters = ""
  n = 0
  loop do
    if Board[r][c] == "+"
      d = directions.each_with_index
        .find_index {|dir,i| i != (d+2)%4 && Board[r+dir[0]][c+dir[1]] != " " }
    elsif Board[r][c] =~ /[A-Z]/
      letters += Board[r][c]
    elsif Board[r][c] == " "
      break
    end
    n += 1
    r += directions[d][0]; c += directions[d][1]
  end
  [letters, n]
end

puts solve[0]

# --- Part Two ---
#
# The packet is curious how many steps it needs to go.
#
# How many steps does the packet need to go?

puts solve[1]
