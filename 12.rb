# --- Day 12: Digital Plumber ---
#
# Walking along the memory banks of the stream, you find a small
# village that is experiencing a little confusion: some programs can't
# communicate with each other.
#
# Programs in this village communicate using a fixed system of pipes.
# Messages are passed between programs using these pipes, but most
# programs aren't connected to each other directly.  Instead, programs
# pass messages between each other until the message reaches the
# intended recipient.
#
# For some reason, though, some of these messages aren't ever reaching
# their intended recipient, and the programs suspect that some pipes
# are missing.  They would like you to investigate.
#
# You walk through the village and record the ID of each program and
# the IDs with which it can communicate directly (your puzzle input).
# Each program has one or more programs with which it can communicate,
# and these pipes are bidirectional; if 8 says it can communicate with
# 11, then 11 will say it can communicate with 8.
#
# You need to figure out how many programs are in the group that
# contains program ID 0.

def load_graph
  $graph = {}
  IO.foreach("12.in") do |l|
    m = /^([0-9]+) <-> ((?:[0-9]+, )*[0-9]+)$/.match(l)
    $graph[m[1]] = m[2].split(", ")
  end
end

def walk(n)
  return 0 if not $graph.member? n
  to_visit = $graph[n]
  $graph.delete n
  1 + to_visit.map{|m|walk(m)}.reduce(:+)
end

load_graph
puts walk("0")

# --- Part Two ---
#
# There are more programs than just the ones in the group containing
# program ID 0.  The rest of them have no way of reaching that group,
# and still might have no way of reaching each other.
#
# A group is a collection of programs that can all communicate via
# pipes either directly or indirectly.  The programs you identified
# just a moment ago are all part of the same group.  Now, they would
# like you to determine the total number of groups.
#
# How many groups are there in total?

load_graph
ng = 0
while not $graph.empty? do
  walk($graph.each_key.first)
  ng += 1
end
puts ng
