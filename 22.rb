# --- Day 22: Sporifica Virus ---
#
# Diagnostics indicate that the local grid computing cluster has been
# contaminated with the Sporifica Virus.  The grid computing cluster
# is a seemingly-infinite two-dimensional grid of compute nodes.  Each
# node is either clean or infected by the virus.
#
# To prevent overloading the nodes (which would render them useless to
# the virus) or detection by system administrators, exactly one virus
# carrier moves through the network, infecting or cleaning nodes as it
# moves.  The virus carrier is always located on a single node in the
# network (the current node) and keeps track of the direction it is
# facing.
#
# To avoid detection, the virus carrier works in bursts; in each
# burst, it wakes up, does some work, and goes back to sleep.  The
# following steps are all executed in order one time each burst:
#
#   - If the current node is infected, it turns to its right.
#     Otherwise, it turns to its left.  (Turning is done in-place; the
#     current node does not change.)
#   - If the current node is clean, it becomes infected.  Otherwise,
#     it becomes cleaned.  (This is done after the node is considered
#     for the purposes of changing direction.)
#   - The virus carrier moves forward one node in the direction it is
#     facing.
#
# Diagnostics have also provided a map of the node infection status
# (your puzzle input).  Clean nodes are shown as .; infected nodes are
# shown as #.  This map only shows the center of the grid; there are
# many more nodes beyond those shown, but none of them are currently
# infected.
#
# The virus carrier begins in the middle of the map facing up.
#
# Given your actual map, after 10000 bursts of activity, how many
# bursts cause a node to become infected?  (Do not count nodes that
# begin infected.)

def load
  g = Hash.new(".")
  r = 0
  IO.foreach("22.in") do |l|
    l.chomp.chars.each_with_index {|v,c| g[[r,c]] = v }
    r += 1
  end
  [g, r]
end

directions = [[0,1], [-1,0], [0,-1], [1,0]]

grid, n = load
r = c = n/2
d = 1
i = 0
10000.times do
  case grid[[r,c]]
  when "."
    d = (d+1)%4
    grid[[r,c]] = "#"
    i += 1
  when "#"
    d = (d-1)%4
    grid[[r,c]] = "."
  end
  r += directions[d][0]; c += directions[d][1]
end
puts i

# --- Part Two ---
#
# As you go to remove the virus from the infected nodes, it evolves to
# resist your attempt.
#
# Now, before it infects a clean node, it will weaken it to disable
# your defenses.  If it encounters an infected node, it will instead
# flag the node to be cleaned in the future.  So:
#
#   - Clean nodes become weakened.
#   - Weakened nodes become infected.
#   - Infected nodes become flagged.
#   - Flagged nodes become clean.
#
# Every node is always in exactly one of the above states.
#
# The virus carrier still functions in a similar way, but now uses the
# following logic during its bursts of action:
#
#   - Decide which way to turn based on the current node:
#       - If it is clean, it turns left.
#       - If it is weakened, it does not turn, and will continue
#         moving in the same direction.
#       - If it is infected, it turns right.
#       - If it is flagged, it reverses direction, and will go back
#         the way it came.
#   - Modify the state of the current node, as described above.
#   - The virus carrier moves forward one node in the direction it is
#     facing.
#
# Start with the same map (still using . for clean and # for infected)
# and still with the virus carrier starting in the middle and facing
# up.
#
# Given your actual map, after 10000000 bursts of activity, how many
# bursts cause a node to become infected?  (Do not count nodes that
# begin infected.)

grid, n = load
r = c = n/2
d = 1
i = 0
10000000.times do
  case grid[[r,c]]
  when "."
    d = (d+1)%4
    grid[[r,c]] = "W"
  when "W"
    grid[[r,c]] = "#"
    i += 1
  when "#"
    d = (d-1)%4
    grid[[r,c]] = "F"
  when "F"
    d = (d+2)%4
    grid[[r,c]] = "."
  end
  r += directions[d][0]; c += directions[d][1]
end
puts i
