# --- Day 1: Inverse Captcha ---
#
# The night before Christmas, one of Santa's Elves calls you in a
# panic.  "The printer's broken!  We can't print the Naughty or Nice
# List!"  By the time you make it to sub-basement 17, there are only a
# few minutes until midnight.  "We have a big problem," she says;
# "there must be almost fifty bugs in this system, but nothing else
# can print The List.  Stand in this square, quick!  There's no time
# to explain; if you can convince them to pay you in stars, you'll be
# able to---"  She pulls a lever and the world goes blurry.
#
# When your eyes can focus again, everything seems a lot more
# pixelated than before.  She must have sent you inside the computer!
# You check the system clock: 25 milliseconds until midnight.  With
# that much time, you should be able to collect all fifty stars by
# December 25th.
#
# Collect stars by solving puzzles.  Two puzzles will be made
# available on each day (er, millisecond) in the advent calendar; the
# second puzzle is unlocked when you complete the first.  Each puzzle
# grants one star.  Good luck!
#
# You're standing in a room with "digitization quarantine" written in
# LEDs along one wall.  The only door is locked, but it includes a
# small interface.  "Restricted Area - Strictly No Digitized Users
# Allowed."
#
# It goes on to explain that you may only leave by solving a captcha
# to prove you're not a human.  Apparently, you only get one
# millisecond to solve the captcha: too fast for a normal human, but
# it feels like hours to you.
#
# The captcha requires you to review a sequence of digits (your puzzle
# input) and find the sum of all digits that match the next digit in
# the list.  The list is circular, so the digit after the last digit
# is the first digit in the list.
#
# What is the solution to your captcha?

$input = IO.read("01.in")
L = $input.length

def captcha(skip)
  (0...L)
    .select {|i| $input[i] == $input[(i+skip)%L] }
    .map {|i| $input[i].to_i }
    .reduce(:+)
end

puts captcha(1)

# --- Part Two ---
#
# You notice a progress bar that jumps to 50% completion.  Apparently,
# the door isn't yet satisfied, but it did emit a star as
# encouragement.  The instructions change:
#
# Now, instead of considering the next digit, it wants you to consider
# the digit halfway around the circular list.  That is, if your list
# contains 10 items, only include a digit in your sum if the digit
# 10/2 = 5 steps forward matches it.  Fortunately, your list has an
# even number of elements.
#
# What is the solution to your new captcha?

puts captcha(L/2)
