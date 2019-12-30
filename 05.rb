# --- Day 5: A Maze of Twisty Trampolines, All Alike ---
#
# An urgent interrupt arrives from the CPU: it's trapped in a maze of
# jump instructions, and it would like assistance from any programs
# with spare cycles to help find the exit.
#
# The message includes a list of the offsets for each jump.  Jumps are
# relative: -1 moves to the previous instruction, and 2 skips the next
# one.  Start at the first instruction in the list.  The goal is to
# follow the jumps until one leads outside the list.
#
# In addition, these instructions are a little strange; after each
# jump, the offset of that instruction increases by 1.  So, if you
# come across an offset of 3, you would move three instructions
# forward, but change it to a 4 for the next time it is encountered.
#
# How many steps does it take to reach the exit?

def run(adjust)
  a = IO.read("05.in").split.map{|o|o.to_i}
  i = 0
  n = 0
  while true
    n += 1
    j = i + a[i]
    a[i] = adjust.(a[i])
    i = j
    return n if i < 0 or i >= a.length
  end
end

puts run(lambda {|o| o+1 })

# --- Part Two ---
#
# Now, the jumps are even stranger: after each jump, if the offset was
# three or more, instead decrease it by 1.  Otherwise, increase it by
# 1 as before.
#
# How many steps does it now take to reach the exit?

puts run(lambda {|o| if o >= 3 then o-1 else o+1 end })
