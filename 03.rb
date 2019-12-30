# --- Day 3: Spiral Memory ---
#
# You come across an experimental new kind of memory stored on an
# infinite two-dimensional grid.
#
# Each square on the grid is allocated in a spiral pattern starting at
# a location marked 1 and then counting up while spiraling outward.
# For example, the first few squares are allocated like this:
#
# 17  16  15  14  13
# 18   5   4   3  12
# 19   6   1   2  11
# 20   7   8   9  10
# 21  22  23---> ...
#
# While this is very space-efficient (no squares are skipped),
# requested data must be carried back to square 1 (the location of the
# only access port for this memory system) by programs that can only
# move up, down, left, or right.  They always take the shortest path:
# the Manhattan Distance between the location of the data and square
# 1.
#
# How many steps are required to carry the data from the square
# identified in your puzzle input all the way to the access port?

Input = 347991

def spiral(steps=-1)
  if block_given?
    directions = [[1,0], [0,1], [-1,0], [0,-1]]
    d = 0
    stride = 1
    s = 0
    x,y = 0,0
    yield x,y if steps > 0
    n = 0
    while steps < 0 or n < steps-1
      x += directions[d][0]; y += directions[d][1]
      yield x,y
      s += 1
      if s == stride
        d = (d+1)%4
        stride += 1 if d%2 == 0
        s = 0
      end
      n += 1
    end
  else
    self.to_enum(:spiral, steps)
  end
end

puts spiral(Input).to_a.last.map{|x|x.abs}.reduce(:+)

# --- Part Two ---
#
# As a stress test on the system, the programs here clear the grid and
# then store the value 1 in square 1.  Then, in the same allocation
# order as shown above, they store the sum of the values in all
# adjacent squares, including diagonals.
#
# Once a square is written, its value does not change.  Therefore, the
# first few squares would receive the following values:
#
# 147  142  133  122   59
# 304    5    4    2   57
# 330   10    1    1   54
# 351   11   23   25   26
# 362  747  806--->   ...
#
# What is the first value written that is larger than your puzzle
# input?

grid = { [0,0] => 1 }
spiral.each do |x,y|
  grid[[x,y]] = (-1..1)
    .map {|i| (-1..1)
      .map {|j| grid[[x+i,y+j]] or 0 }
      .reduce(:+)
    }
    .reduce(:+)
  if grid[[x,y]] > Input
    puts grid[[x,y]]
    break
  end
end
