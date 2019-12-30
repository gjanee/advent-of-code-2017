# --- Day 24: Electromagnetic Moat ---
#
# The CPU itself is a large, black building surrounded by a bottomless
# pit.  Enormous metal tubes extend outward from the side of the
# building at regular intervals and descend down into the void.
# There's no way to cross, but you need to get inside.
#
# No way, of course, other than building a bridge out of the magnetic
# components strewn about nearby.
#
# Each component has two ports, one on each end.  The ports come in
# all different types, and only matching types can be connected.  You
# take an inventory of the components by their port types (your puzzle
# input).  Each port is identified by the number of pins it uses; more
# pins mean a stronger connection for your bridge.  A 3/7 component,
# for example, has a type-3 port on one side, and a type-7 port on the
# other.
#
# Your side of the pit is metallic; a perfect surface to connect a
# magnetic, zero-pin port.  Because of this, the first port you use
# must be of type 0.  It doesn't matter what type of port you end
# with; your goal is just to make the bridge as strong as possible.
#
# The strength of a bridge is the sum of the port types in each
# component.  For example, if your bridge is made of components 0/3,
# 3/7, and 7/4, your bridge has a strength of 0+3 + 3+7 + 7+4 = 24.
#
# (Note that order of ports within a component doesn't matter.
# However, you may only use each port on a component once.)
#
# What is the strength of the strongest bridge you can make with the
# components you have available?

class Component

  attr_accessor :in_use

  def initialize(id, p1, p2)
    @id = id
    @p1 = p1
    @p2 = p2
    @in_use = false
  end

  def strength
    @p1 + @p2
  end

  def other_port(p)
    if p == @p1 then @p2 else @p1 end
  end

end

$supply = {}
IO.foreach("24.in").each_with_index do |l,id|
  p1, p2 = l.split("/").map{|p|p.to_i}
  c = Component.new(id, p1, p2)
  [p1, p2].uniq.each do |p|
    l = $supply.fetch(p, [])
    l.push(c)
    $supply[p] = l
  end
end

def extend(port, length, strength, store)
  $supply[port].reject{|c|c.in_use}.each do |c|
    c.in_use = true
    store.(length+1, strength+c.strength)
    extend(c.other_port(port), length+1, strength+c.strength, store)
    c.in_use = false
  end
end

ms = 0
extend(0, 0, 0, lambda {|l,s| ms = [ms, s].max })
puts ms

# --- Part Two ---
#
# The bridge you've built isn't long enough; you can't jump the rest
# of the way.
#
# What is the strength of the longest bridge you can make?  If you can
# make multiple bridges of the longest length, pick the strongest one.

ls = ll = 0
extend(0, 0, 0, lambda {|l,s|
  if l > ll
    ls = s
    ll = l
  elsif l == ll
    ls = [ls, s].max
  end
})
puts ls
