# --- Day 8: I Heard You Like Registers ---
#
# You receive a signal directly from the CPU.  Because of your recent
# assistance with jump instructions, it would like you to compute the
# result of a series of unusual register instructions.
#
# Each instruction consists of several parts: the register to modify,
# whether to increase or decrease that register's value, the amount by
# which to increase or decrease it, and a condition.  If the condition
# fails, skip the instruction without modifying the register.  The
# registers all start at 0.  The instructions look like this:
#
# b inc 5 if a > 1
# a inc 1 if b < 5
# c dec -10 if a >= 1
# c inc -20 if c == 10
#
# You might also encounter <= (less than or equal to) or != (not equal
# to).  However, the CPU doesn't have the bandwidth to tell you what
# all the registers are named, and leaves that to you to determine.
#
# What is the largest value in any register after completing the
# instructions in your puzzle input?
#
# --------------------
#
# The problem statement is ambiguous on one point.  If every assigned
# register holds a negative value at the end, and if there is a
# register that is referenced in a condition but never assigned, is
# zero the largest value?

def run(reg)
  mf = { "inc" => 1, "dec" => -1 }
  max = 0
  IO.foreach("08.in") do |l|
    m = /^([a-z]+) (inc|dec) (-?[0-9]+) if ([a-z]+) (.*)$/.match(l)
    if eval("reg.fetch('#{m[4]}', 0) #{m[5]}")
      reg[m[1]] = reg.fetch(m[1], 0) + m[3].to_i*mf[m[2]]
      max = [max, reg[m[1]]].max
    end
  end
  max
end

reg = {}
run(reg)
puts reg.values.max

# --- Part Two ---
#
# To be safe, the CPU also needs to know the highest value held in any
# register during this process so that it can decide how much memory
# to allocate to these operations.  For example, in the above
# instructions, the highest value ever held was 10 (in register c
# after the third instruction was evaluated).

puts run({})
