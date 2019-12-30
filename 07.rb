# --- Day 7: Recursive Circus ---
#
# Wandering further through the circuits of the computer, you come
# upon a tower of programs that have gotten themselves into a bit of
# trouble.  A recursive algorithm has gotten out of hand, and now
# they're balanced precariously in a large tower.
#
# One program at the bottom supports the entire tower.  It's holding a
# large disc, and on the disc are balanced several more sub-towers.
# At the bottom of these sub-towers, standing on the bottom disc, are
# other programs, each holding their own disc, and so on.  At the very
# tops of these sub-sub-sub-...-towers, many programs stand simply
# keeping the disc below them balanced but with no disc of their own.
#
# You offer to help, but first you need to understand the structure of
# these towers.  You ask each program to yell out their name, their
# weight, and (if they're holding a disc) the names of the programs
# immediately above them balancing on that disc.  You write this
# information down (your puzzle input).  Unfortunately, in their
# panic, they don't do this in an orderly fashion; by the time you're
# done, you're not sure which program gave which information.
#
# Before you're ready to help them, you need to make sure your
# information is correct.  What is the name of the bottom program?

class Node

  attr_reader :name, :weight, :children

  @@all = {} # name => Node
  def Node.all; @@all; end
  def Node.lookup(name)
    @@all.fetch(name) { new(name) }
  end

  def initialize(name)
    @name = name
    @@all[name] = self
  end

  def link!(weight, children_names)
    @weight = weight
    @children = children_names.map {|n| Node.lookup(n) }
  end

end

IO.foreach("07.in") do |l|
  m = /^([a-z]+) \(([0-9]+)\)(?: -> ((?:[a-z]+, )*[a-z]+))?$/.match(l)
  n = Node.lookup m[1]
  n.link!(m[2].to_i, m[3]? m[3].split(", ") : [])
end

root = (Node.all.values - Node.all.values.map{|n|n.children}.flatten)[0]
puts root.name

# --- Part Two ---
#
# The programs explain the situation: they can't get down.  Rather,
# they could get down, if they weren't expending all of their energy
# trying to keep the tower balanced.  Apparently, one program has the
# wrong weight, and until it's fixed, they're stuck here.
#
# For any program holding a disc, each program standing on that disc
# forms a sub-tower.  Each of those sub-towers are supposed to be the
# same weight, or the disc itself isn't balanced.  The weight of a
# tower is the sum of the weights of the programs in that tower.
#
# Given that exactly one program is the wrong weight, what would its
# weight need to be to balance the entire tower?

def balance(node)
  if node.children.length == 0
    node.weight
  else
    weights = node.children.map {|c| balance(c) }
    min, max = weights.minmax
    if min != max
      i = weights.count(min) == 1? weights.index(min) : weights.index(max)
      puts node.children[i].weight + min-max
    end
    node.weight + min-max + weights.reduce(:+)
  end
end

balance(root)
