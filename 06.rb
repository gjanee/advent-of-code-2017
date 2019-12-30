# --- Day 6: Memory Reallocation ---
#
# A debugger program here is having an issue: it is trying to repair a
# memory reallocation routine, but it keeps getting stuck in an
# infinite loop.
#
# In this area, there are sixteen memory banks; each memory bank can
# hold any number of blocks.  The goal of the reallocation routine is
# to balance the blocks between the memory banks.
#
# The reallocation routine operates in cycles.  In each cycle, it
# finds the memory bank with the most blocks (ties won by the
# lowest-numbered memory bank) and redistributes those blocks among
# the banks.  To do this, it removes all of the blocks from the
# selected bank, then moves to the next (by index) memory bank and
# inserts one of the blocks.  It continues doing this until it runs
# out of blocks; if it reaches the last memory bank, it wraps around
# to the first one.
#
# The debugger would like to know how many redistributions can be done
# before a blocks-in-banks configuration is produced that has been
# seen before.
#
# Given the initial block counts in your puzzle input, how many
# redistribution cycles must be completed before a configuration is
# produced that has been seen before?

Input = [11, 11, 13, 7, 0, 15, 5, 5, 4, 4, 1, 1, 7, 1, 15, 11]

def solve
  m = Input.clone
  n = 0
  seen = { m.clone => n }
  while true
    n += 1
    i = m.index(m.max)
    v = m[i]
    m[i] = 0
    v.times do
      i = (i+1)%m.length
      m[i] += 1
    end
    return n, seen[m] if seen.member? m
    seen[m.clone] = n
  end
end

puts solve[0]

# --- Part Two ---
#
# Out of curiosity, the debugger would also like to know the size of
# the loop: starting from a state that has already been seen, how many
# block redistribution cycles must be performed before that same state
# is seen again?
#
# How many cycles are in the infinite loop that arises from the
# configuration in your puzzle input?

puts solve.reduce(:-)
