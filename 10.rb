# --- Day 10: Knot Hash ---
#
# You come across some programs that are trying to implement a
# software emulation of a hash based on knot-tying.  The hash these
# programs are implementing isn't very strong, but you decide to help
# them anyway.  You make a mental note to remind the Elves later not
# to invent their own cryptographic functions.
#
# This hash function simulates tying a knot in a circle of string with
# 256 marks on it.  Based on the input to be hashed, the function
# repeatedly selects a span of string, brings the ends together, and
# gives the span a half-twist to reverse the order of the marks within
# it.  After doing this many times, the order of the marks is used to
# build the resulting hash.
#
#   4--5   pinch   4  5           4   1
#  /    \  5,0,1  / \/ \  twist  / \ / \
# 3      0  -->  3      0  -->  3   X   0
#  \    /         \ /\ /         \ / \ /
#   2--1           2  1           2   5
#
# To achieve this, begin with a list of numbers from 0 to 255, a
# current position which begins at 0 (the first element in the list),
# a skip size (which starts at 0), and a sequence of lengths (your
# puzzle input).  Then, for each length:
#
#   - Reverse the order of that length of elements in the list,
#     starting with the element at the current position.
#   - Move the current position forward by that length plus the skip
#     size.
#   - Increase the skip size by one.
#
# The list is circular; if the current position and the length try to
# reverse elements beyond the end of the list, the operation reverses
# using as many extra elements as it needs from the front of the list.
# If the current position moves past the end of the list, it wraps
# around to the front.  Lengths larger than the size of the list are
# invalid.
#
# Once this process is complete, what is the result of multiplying the
# first two numbers in the list?
#
# --------------------
#
# To simplify reversals, we store the array rotated so that the
# current position is always at index 0.

Input = "102,255,99,252,200,24,219,57,103,2,226,254,1,0,69,216"
N = 256

def hash_round(lengths, a, p, s)
  lengths.each do |l|
    a[0,l] = a[0,l].reverse
    a.rotate!(l+s)
    p = (p+l+s)%N
    s += 1
  end
  [p, s]
end

a = (0...N).to_a
p = s = 0
p, s = hash_round(Input.split(",").map{|l|l.to_i}, a, p, s)
a.rotate!(-p)
puts a[0]*a[1]

# --- Part Two ---
#
# The logic you've constructed forms a single round of the Knot Hash
# algorithm; running the full thing requires many of these rounds.
# Some input and output processing is also required.
#
# First, from now on, your input should be taken not as a list of
# numbers, but as a string of bytes instead.  Unless otherwise
# specified, convert characters to bytes using their ASCII codes.
# This will allow you to handle arbitrary ASCII strings, and it also
# ensures that your input lengths are never larger than 255.  For
# example, if you are given 1,2,3, you should convert it to the ASCII
# codes for each character: 49,44,50,44,51.
#
# Once you have determined the sequence of lengths to use, add the
# following lengths to the end of the sequence: 17, 31, 73, 47, 23.
# For example, if you are given 1,2,3, your final sequence of lengths
# should be 49,44,50,44,51,17,31,73,47,23 (the ASCII codes from the
# input string combined with the standard length suffix values).
#
# Second, instead of merely running one round like you did above, run
# a total of 64 rounds, using the same length sequence in each round.
# The current position and skip size should be preserved between
# rounds.
#
# Once the rounds are complete, you will be left with the numbers from
# 0 to 255 in some order, called the sparse hash.  Your next task is
# to reduce these to a list of only 16 numbers called the dense hash.
# To do this, use numeric bitwise XOR to combine each consecutive
# block of 16 numbers in the sparse hash (there are 16 such blocks in
# a list of 256 numbers).  So, the first element in the dense hash is
# the first sixteen elements of the sparse hash XOR'd together, the
# second element in the dense hash is the second sixteen elements of
# the sparse hash XOR'd together, etc.
#
# Perform this operation on each of the sixteen blocks of sixteen
# numbers in your sparse hash to determine the sixteen numbers in your
# dense hash.
#
# Finally, the standard way to represent a Knot Hash is as a single
# hexadecimal string; the final output is the dense hash in
# hexadecimal notation.  Because each number in your dense hash will
# be between 0 and 255 (inclusive), always represent each number as
# two hexadecimal digits (including a leading zero as necessary).  So,
# if your first three numbers are 64, 7, 255, they correspond to the
# hexadecimal numbers 40, 07, ff, and so the first six characters of
# the hash would be 4007ff.  Because every Knot Hash is sixteen such
# numbers, the hexadecimal representation is always 32 hexadecimal
# digits (0-f) long.
#
# Treating your puzzle input as a string of ASCII characters, what is
# the Knot Hash of your puzzle input?  Ignore any leading or trailing
# whitespace you might encounter.

lengths = Input.chars.map{|c|c.ord} + [17, 31, 73, 47, 23]
a = (0...N).to_a
p = s = 0
64.times { p, s = hash_round(lengths, a, p, s) }
a.rotate!(-p)
puts a.each_slice(16)
  .map {|s| "%02x" % s.reduce(:^) }
  .join
