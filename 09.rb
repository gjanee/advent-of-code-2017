# --- Day 9: Stream Processing ---
#
# A large stream blocks your path.  According to the locals, it's not
# safe to cross the stream at the moment because it's full of garbage.
# You look down at the stream; rather than water, you discover that
# it's a stream of characters.
#
# You sit for a while and record part of the stream (your puzzle
# input).  The characters represent groups - sequences that begin with
# { and end with }.  Within a group, there are zero or more other
# things, separated by commas: either another group or garbage.  Since
# groups can contain other groups, a } only closes the
# most-recently-opened unclosed group - that is, they are nestable.
# Your puzzle input represents a single, large group which itself
# contains many smaller ones.
#
# Sometimes, instead of a group, you will find garbage.  Garbage
# begins with < and ends with >.  Between those angle brackets, almost
# any character can appear, including { and }.  Within garbage, < has
# no special meaning.
#
# In a futile attempt to clean up the garbage, some program has
# canceled some of the characters within it using !: inside garbage,
# any character that comes after ! should be ignored, including <, >,
# and even another !.
#
# You don't see any characters that deviate from these rules.  Outside
# garbage, you only find well-formed groups, and garbage always
# terminates according to the rules above.
#
# Your goal is to find the total score for all groups in your input.
# Each group is assigned a score which is one more than the score of
# the group that immediately contains it.  (The outermost group gets a
# score of 1.)
#
# What is the total score for all groups in your input?

d = 0
s = 0
IO.read("09.in").gsub(/!./, "").gsub(/<.*?>/, "").each_char do |c|
  if c == "{"
    d += 1
  elsif c == "}"
    s += d
    d -= 1
  end
end
puts s

# --- Part Two ---
#
# Now, you're ready to remove the garbage.
#
# To prove you've removed it, you need to count all of the characters
# within the garbage.  The leading and trailing < and > don't count,
# nor do any canceled characters or the ! doing the canceling.
#
# How many non-canceled characters are within the garbage in your
# puzzle input?

puts IO.read("09.in")
  .gsub(/!./, "")
  .scan(/<.*?>/)
  .map {|m| m.length-2 }
  .reduce(:+)
