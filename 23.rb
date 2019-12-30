# --- Day 23: Coprocessor Conflagration ---
#
# You decide to head directly to the CPU and fix the printer from
# there.  As you get close, you find an experimental coprocessor doing
# so much work that the local programs are afraid it will halt and
# catch fire.  This would cause serious issues for the rest of the
# computer, so you head in and see what you can do.
#
# The code it's running seems to be a variant of the kind you saw
# recently on that tablet.  The general functionality seems very
# similar, but some of the instructions are different:
#
#   - set X Y sets register X to the value of Y.
#   - sub X Y decreases register X by the value of Y.
#   - mul X Y sets register X to the result of multiplying the value
#     contained in register X by the value of Y.
#   - jnz X Y jumps with an offset of the value of Y, but only if the
#     value of X is not zero.  (An offset of 2 skips the next
#     instruction, an offset of -1 jumps to the previous instruction,
#     and so on.)
#
# Only the instructions listed above are used.  The eight registers
# here, named a through h, all start at 0.
#
# The coprocessor is currently set to some kind of debug mode, which
# allows for testing, but prevents it from doing any meaningful work.
#
# If you run the program (your puzzle input), how many times is the
# mul instruction invoked?
#
# --------------------
#
# The following code is mostly repurposed from day 18.

Code = IO.readlines("23.in").map do |l|
  op, x, y = l.split
  x = x.to_i if x !~ /^[a-z]$/
  y = y.to_i if y !~ /^[a-z]$/
  [op, x, y]
end

class Program

  attr_reader :muls

  def initialize
    @reg = Hash.new(0)
    @pc = 0
    @muls = 0
  end

  def get(x)
    if x.class == String then @reg[x] else x end
  end

  def run
    while 0 <= @pc and @pc < Code.length
      op, x, y = Code[@pc]
      case op
      when "set"
        @reg[x] = get(y)
      when "sub"
        @reg[x] = get(x) - get(y)
      when "mul"
        @reg[x] = get(x) * get(y)
        @muls += 1
      when "jnz"
        @pc += get(y) - 1 if get(x) != 0
      end
      @pc += 1
    end
  end

end

p = Program.new
p.run
puts p.muls

# --- Part Two ---
#
# Now, it's time to fix the problem.
#
# The debug mode switch is wired directly to register a.  You flip the
# switch, which makes register a now start at 1 when the program is
# executed.
#
# Immediately, the coprocessor begins to overheat.  Whoever wrote this
# program obviously didn't choose a very efficient implementation.
# You'll need to optimize the program if it has any hope of completing
# before Santa needs that printer working.
#
# The coprocessor's ultimate goal is to determine the final value left
# in register h once the program completes.  Technically, if it had
# that... it wouldn't even need to run the program.
#
# After setting register a to 1, if the program were to run to
# completion, what value would be left in register h?
#
# --------------------
#
# This part of the problem is of a substantially different nature.  We
# need to reverse engineer the assembly code and figure out what it's
# doing in order to (significantly) optimize it.
#
# Pass 1.  Here's a fairly direct rewrite into Ruby:
#
# b = 65
# c = b
# if a != 0
#   b *= 100
#   b -= -100000
#   c = b
#   c -= -17000
# end
# while true
#   f = 1
#   d = 2
#   while true
#     e = 2
#     while true
#       g = d
#       g *= e
#       g -= b
#       if g == 0
#         f = 0
#       end
#       e -= -1
#       g = e
#       g -= b
#       break if g == 0
#     end
#     d -= -1
#     g = d
#     g -= b
#     break if g == 0
#   end
#   if f == 0
#     h -= -1
#   end
#   g = b
#   g -= c
#   break if g == 0
#   b -= -17
# end
#
# Pass 2.  It's interesting to observe how much code comprehension is
# improved by just some modest simplifications.  Notice that register
# g is used only in formulating conditional tests, and hence can be
# eliminated entirely.
#
# b = c = 65
# if a != 0
#   b = b*100 + 100000
#   c = b + 17000
# end
# while b <= c
#   f = 1
#   d = 2
#   while d < b
#     e = 2
#     while e < b
#       f = 0 if d*e == b
#       e += 1
#     end
#     d += 1
#   end
#   h += 1 if f == 0
#   b += 17
# end
#
# Pass 3.  The code is clearly testing for primality, in about the
# most inefficient way possible, and counting the number of composite
# integers in a range.  There are many ways to do this more
# efficiently, but in Ruby it's a one-liner:

require "prime"

puts (106500..123500).step(17).count {|n| not n.prime? }
