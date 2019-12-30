# --- Day 16: Permutation Promenade ---
#
# You come upon a very unusual sight; a group of programs here appear
# to be dancing.
#
# There are sixteen programs in total, named a through p.  They start
# by standing in a line: a stands in position 0, b stands in position
# 1, and so on until p, which stands in position 15.
#
# The programs' dance consists of a sequence of dance moves:
#
#   - Spin, written sX, makes X programs move from the end to the
#     front, but maintain their order otherwise.  (For example, s3 on
#     abcde produces cdeab.)
#   - Exchange, written xA/B, makes the programs at positions A and B
#     swap places.
#   - Partner, written pA/B, makes the programs named A and B swap
#     places.
#
# You watch the dance for a while and record their dance moves (your
# puzzle input).  In what order are the programs standing after their
# dance?

Moves = IO.read("16.in").chomp.split(",")

$p = "abcdefghijklmnop".chars

def permute
  Moves.each do |m|
    case m[0]
    when "s"
      $p.rotate!($p.length - m[1..-1].to_i)
    when "x"
      a, b = m[1..-1].split("/").map {|v| v.to_i }
      $p[a], $p[b] = $p[b], $p[a]
    when "p"
      a, b = m[1..-1].split("/").map {|n| $p.index(n) }
      $p[a], $p[b] = $p[b], $p[a]
    end
  end
end

permute
puts $p.join

# --- Part Two ---
#
# Now that you're starting to get a feel for the dance moves, you turn
# your attention to the dance as a whole.
#
# Keeping the positions they ended up in from their previous dance,
# the programs perform it again and again: including the first dance,
# a total of one billion (1000000000) times.
#
# In what order are the programs standing after their billion dances?
#
# --------------------
#
# A permutation repeats in a simple cycle.  As it turns out, the cycle
# length in this case is only 48.

seen = [$p.clone]
loop do
  permute
  break if $p == seen[0]
  seen.push($p.clone)
end

puts seen[(10**9)%seen.length - 1].join
