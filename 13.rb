# --- Day 13: Packet Scanners ---
#
# You need to cross a vast firewall.  The firewall consists of several
# layers, each with a security scanner that moves back and forth
# across the layer.  To succeed, you must not be detected by a
# scanner.
#
# By studying the firewall briefly, you are able to record (in your
# puzzle input) the depth of each layer and the range of the scanning
# area for the scanner within it, written as depth: range.  Each layer
# has a thickness of exactly 1.  A layer at depth 0 begins immediately
# inside the firewall; a layer at depth 1 would start immediately after
# that.
#
# For example, suppose you've recorded the following:
#
# 0: 3
# 1: 2
# 4: 4
# 6: 4
#
# This means that there is a layer immediately inside the firewall
# (with range 3), a second layer immediately after that (with range
# 2), a third layer which begins at depth 4 (with range 4), and a
# fourth layer which begins at depth 6 (also with range 4).  Visually,
# it might look like this:
#
#  0   1   2   3   4   5   6
# [ ] [ ] ... ... [ ] ... [ ]
# [ ] [ ]         [ ]     [ ]
# [ ]             [ ]     [ ]
#                 [ ]     [ ]
#
# Within each layer, a security scanner moves back and forth within
# its range.  Each security scanner starts at the top and moves down
# until it reaches the bottom, then moves up until it reaches the top,
# and repeats.  A security scanner takes one picosecond to move one
# step.
#
# Your plan is to hitch a ride on a packet about to move through the
# firewall.  The packet will travel along the top of each layer, and
# it moves at one layer per picosecond.  Each picosecond, the packet
# moves one layer forward (its first move takes it into layer 0), and
# then the scanners move one step.  If there is a scanner at the top
# of the layer as your packet enters it, you are caught.  (If a
# scanner moves into the top of its layer while you are there, you are
# not caught: it doesn't have time to notice you before you leave.)
#
# The severity of getting caught on a layer is equal to its depth
# multiplied by its range.  (Ignore layers in which you do not get
# caught.)  The severity of the whole trip is the sum of these values.
# In the example above, the trip severity is 0*3 + 6*4 = 24.
#
# Given the details of the firewall you've recorded, if you leave
# immediately, what is the severity of your whole trip?
#
# --------------------
#
# A scanner moving back and forth along a layer of range r is
# equivalent to moving circularly with period 2*r-2.  The packet
# reaches the layer at depth d at time d.  Hence we are caught if
# d = 0 (mod 2*r-2).

firewall = IO.readlines("13.in").map {|l|
  m = /^(\d+): (\d+)$/.match(l)
  [m[1].to_i, m[2].to_i]
}

puts firewall
  .map {|d,r| if d%(2*r-2) == 0 then d*r else 0 end }
  .reduce(:+)

# --- Part Two ---
#
# Now, you need to pass through the firewall without being caught -
# easier said than done.
#
# You can't control the speed of the packet, but you can delay it any
# number of picoseconds.  For each picosecond you delay the packet
# before beginning your trip, all security scanners move one step.
# You're not in the firewall during this time; you don't enter layer 0
# until you stop delaying the packet.
#
# In the example above, if you delay 10 picoseconds (picoseconds 0 -
# 9), you won't get caught.  Because all smaller delays would get you
# caught, the fewest number of picoseconds you would need to delay to
# get through safely is 10.
#
# What is the fewest number of picoseconds that you need to delay the
# packet to pass through the firewall without being caught?

n = 0
while true
  caught = false
  firewall.each do |d,r|
    if (d+n)%(2*r-2) == 0
      caught = true
      break
    end
  end
  break if not caught
  n += 1
end
puts n
