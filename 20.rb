# --- Day 20: Particle Swarm ---
#
# Suddenly, the GPU contacts you, asking for help.  Someone has asked
# it to simulate too many particles, and it won't be able to finish
# them all in time to render the next frame at this rate.
#
# It transmits to you a buffer (your puzzle input) listing each
# particle in order (starting with particle 0, then particle 1,
# particle 2, and so on).  For each particle, it provides the X, Y,
# and Z coordinates for the particle's position (p), velocity (v), and
# acceleration (a), each in the format <X,Y,Z>.
#
# Each tick, all particles are updated simultaneously.  A particle's
# properties are updated in the following order:
#
#   - Increase the X velocity by the X acceleration.
#   - Increase the Y velocity by the Y acceleration.
#   - Increase the Z velocity by the Z acceleration.
#   - Increase the X position by the X velocity.
#   - Increase the Y position by the Y velocity.
#   - Increase the Z position by the Z velocity.
#
# Because of seemingly tenuous rationale involving z-buffering, the
# GPU would like to know which particle will stay closest to position
# <0,0,0> in the long term.  Measure this using the Manhattan
# distance, which in this situation is simply the sum of the absolute
# values of a particle's X, Y, and Z position.
#
# Which particle will stay closest to position <0,0,0> in the long
# term?
#
# --------------------
#
# Given initial position p_0, initial velocity v_0, and acceleration
# a, a particle's position at time t is given by
#
# p(t) = p_0 + t*v_0 + (t(t+1)/2)*a
#      = (a/2)*t^2 + (a/2+v_0)*t + p_0
#
# This is quadratic in t, and thus particle behavior is to approach
# the origin, then reverse direction and retreat.
#
# For a given dimension, the inbound (outbound) phase is marked by the
# velocity and acceleration having opposite (the same) signs.  Once in
# the outbound phase, velocity and position grow monotically according
# to the acceleration's sign.
#
# Distance from the origin is primarily determined by the magnitude of
# the acceleration, of course.  But the case when two particles have
# the same acceleration in absolute value is tricky because the
# particles may also have the same velocity and/or position in
# absolute value, yet have different distances to the origin in the
# limit due to one particle being inbound while the other is already
# outbound (e.g., one particle may "lag" behind the other).  To handle
# this case we project a time at which both particles will be
# outbound, and compare distances then.

class Array
  def distance
    self.map {|c| c.abs }.reduce(:+)
  end
end

class Particle

  attr_reader :id, :acc

  def initialize(id, pos, vel, acc)
    @id = id
    @pos = pos
    @vel = vel
    @acc = acc
  end

  def pos(time=nil)
    if time.nil?
      @pos
    else
      (0..2).map {|i| @pos[i] + @vel[i]*time + @acc[i]*time*(time+1)/2 }
    end
  end

  def vel(time=nil)
    if time.nil?
      @vel
    else
      (0..2).map {|i| @vel[i] + @acc[i]*time }
    end
  end

  def outbound_time
    # returns a time at which the particle will be outbound in all dimensions
    (0..2).map {|i|
      if @acc[i] == 0
        0
      else
        [(-@vel[i]/@acc[i].to_f + 1).to_i, 0].max
      end
    }.max
  end

end

Input = {}
IO.foreach("20.in").each_with_index do |l,i|
  re = "<(-?\\d+),(-?\\d+),(-?\\d+)>"
  m = Regexp.new("^p=#{re}, v=#{re}, a=#{re}$")
    .match(l)
    .to_a
    .map {|v| v.to_i }
  Input[i] = Particle.new(i, m[1..3], m[4..6], m[7..9])
end

puts Input.values.sort {|p,q|
  if (c = p.acc.distance <=> q.acc.distance) != 0
    c
  else
    t = [p.outbound_time, q.outbound_time].max
    if (c = p.vel(t).distance <=> q.vel(t).distance) != 0
      c
    else
      p.pos(t).distance <=> q.pos(t).distance
    end
  end
}.first.id

# --- Part Two ---
#
# To simplify the problem further, the GPU would like to remove any
# particles that collide.  Particles collide if their positions ever
# exactly match.  Because particles are updated simultaneously, more
# than two particles can collide at the same time and place.  Once
# particles collide, they are removed and cannot collide with anything
# else after that tick.
#
# How many particles are left after all collisions are resolved?
#
# --------------------
#
# Given the closed form equation for particle position above, we could
# simply solve for pairwise collision times, but this would involve
# finding integer solutions to quadratics which is a little messy.
# Instead, we simulate the particles and collisions until we can prove
# that the remaining particles cannot possibly collide.

class Particle

  def step!
    (0..2).each do |i|
      @vel[i] += @acc[i]
      @pos[i] += @vel[i]
    end
  end

  def inbound?
    (0..2).any? {|i| @vel[i]*@acc[i] < 0 }
  end

  def collision_impossible?(other)
    # the following computation assumes both particles are outbound
    (0..2).any? {|i|
      [-1, 1].any? {|s|
        @pos[i]*s > other.pos[i]*s and @vel[i]*s >= other.vel[i]*s and
          @acc[i]*s >= other.acc[i]*s
      }
    }
  end

end

loop do
  positions = {}
  Input.each_value do |p|
    p.step!
    l = positions.fetch(p.pos, [])
    l.push(p)
    positions[p.pos] = l
  end
  positions.each_value.select {|l| l.length > 1 }.each do |l|
    l.each {|p| Input.delete(p.id) }
  end
  break if not Input.each_value.any? {|p| p.inbound? } and
    Input.each_value.to_a.combination(2).all? {|p,q|
      p.collision_impossible?(q)
    }
end
puts Input.length
