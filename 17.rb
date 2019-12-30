# --- Day 17: Spinlock ---
#
# Suddenly, whirling in the distance, you notice what looks like a
# massive, pixelated hurricane: a deadly spinlock.  This spinlock
# isn't just consuming computing power, but memory, too; vast, digital
# mountains are being ripped from the ground and consumed by the
# vortex.
#
# If you don't move quickly, fixing that printer will be the least of
# your problems.
#
# This spinlock's algorithm is simple but efficient, quickly consuming
# everything in its path.  It starts with a circular buffer containing
# only the value 0, which it marks as the current position.  It then
# steps forward through the circular buffer some number of steps (your
# puzzle input) before inserting the first new value, 1, after the
# value it stopped on.  The inserted value becomes the current
# position.  Then, it steps forward from there the same number of
# steps, and wherever it stops, inserts after it the second new value,
# 2, and uses that as the new current position again.
#
# It repeats this process of stepping forward, inserting a new value,
# and using the location of the inserted value as the new current
# position a total of 2017 times, inserting 2017 as its final
# operation, and ending with a total of 2018 values (including 0) in
# the circular buffer.
#
# Perhaps, if you can identify the value that will ultimately be after
# the last value written (2017), you can short-circuit the spinlock.
#
# What is the value after 2017 in your completed circular buffer?

Input = 370

b = [0]
p = 0
2017.times do
  p = (p+Input)%b.length + 1
  b.insert(p, b.length)
end
puts b[(p+1)%b.length]

# --- Part Two ---
#
# The spinlock does not short-circuit.  Instead, it gets more angry.
# At least, you assume that's what happened; it's spinning
# significantly faster than it was a moment ago.
#
# You have good news and bad news.
#
# The good news is that you have improved calculations for how to stop
# the spinlock.  They indicate that you actually need to identify the
# value after 0 in the current state of the circular buffer.
#
# The bad news is that while you were determining this, the spinlock
# has just finished inserting its fifty millionth value (50000000).
#
# What is the value after 0 the moment 50000000 is inserted?
#
# --------------------
#
# The large number of iterations demands a different approach.  We
# take advantage of the fact that we only need to know the value after
# 0 (which is the first value in the buffer); the other buffer values
# are never used.  Therefore the buffer itself never need be
# materialized, and we can keep track of only the buffer length, l,
# and the current position, p.

v = nil # value after 0
p = 0
l = 1
50000000.times do
  p = (p+Input)%l
  v = l if p == 0
  p += 1
  l += 1
end
puts v
