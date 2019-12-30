# --- Day 18: Duet ---
#
# You discover a tablet containing some strange assembly code labeled
# simply "Duet".  Rather than bother the sound card with it, you
# decide to run the code yourself.  Unfortunately, you don't see any
# documentation, so you're left to figure out what the instructions
# mean on your own.
#
# It seems like the assembly is meant to operate on a set of registers
# that are each named with a single letter and that can each hold a
# single integer.  You suppose each register should start with a value
# of 0.
#
# There aren't that many instructions, so it shouldn't be hard to
# figure out what they do.  Here's what you determine:
#
#   - snd X plays a sound with a frequency equal to the value of X.
#   - set X Y sets register X to the value of Y.
#   - add X Y increases register X by the value of Y.
#   - mul X Y sets register X to the result of multiplying the value
#     contained in register X by the value of Y.
#   - mod X Y sets register X to the remainder of dividing the value
#     contained in register X by the value of Y (that is, it sets X to
#     the result of X modulo Y).
#   - rcv X recovers the frequency of the last sound played, but only
#     when the value of X is not zero.  (If it is zero, the command
#     does nothing.)
#   - jgz X Y jumps with an offset of the value of Y, but only if the
#     value of X is greater than zero.  (An offset of 2 skips the next
#     instruction, an offset of -1 jumps to the previous instruction,
#     and so on.)
#
# Many of the instructions can take either a register (a single
# letter) or a number.  The value of a register is the integer it
# contains; the value of a number is that number.
#
# After each jump instruction, the program continues with the
# instruction to which the jump jumped.  After any other instruction,
# the program continues with the next instruction.  Continuing (or
# jumping) off either end of the program terminates it.
#
# What is the value of the recovered frequency (the value of the most
# recently played sound) the first time a rcv instruction is executed
# with a non-zero value?

Code = IO.readlines("18.in").map do |l|
  op, x, y = l.split
  x = x.to_i if x !~ /^[a-z]$/
  y = y.to_i if y !~ /^[a-z]$/
  [op, x, y]
end

class Program

  attr_reader :last_snd

  def initialize
    @reg = Hash.new(0)
    @pc = 0
  end

  def get(x)
    if x.class == String then @reg[x] else x end
  end

  def snd(x)
    @last_snd = get(x)
  end

  def rcv(x)
    return get(x) == 0
  end

  def run
    while 0 <= @pc and @pc < Code.length
      op, x, y = Code[@pc]
      case op
      when "snd"
        snd(x)
      when "set"
        @reg[x] = get(y)
      when "add"
        @reg[x] = get(x) + get(y)
      when "mul"
        @reg[x] = get(x) * get(y)
      when "mod"
        @reg[x] = get(x) % get(y)
      when "rcv"
        continue = rcv(x)
        break if not continue
      when "jgz"
        @pc += get(y) - 1 if get(x) > 0
      end
      @pc += 1
    end
  end

end

p = Program.new
p.run
puts p.last_snd

# --- Part Two ---
#
# As you congratulate yourself for a job well done, you notice that
# the documentation has been on the back of the tablet this entire
# time.  While you actually got most of the instructions correct,
# there are a few key differences.  This assembly code isn't about
# sound at all - it's meant to be run twice at the same time.
#
# Each running copy of the program has its own set of registers and
# follows the code independently - in fact, the programs don't even
# necessarily run at the same speed.  To coordinate, they use the send
# (snd) and receive (rcv) instructions:
#
#   - snd X sends the value of X to the other program.  These values
#     wait in a queue until that program is ready to receive them.
#     Each program has its own message queue, so a program can never
#     receive a message it sent.
#   - rcv X receives the next value and stores it in register X.  If
#     no values are in the queue, the program waits for a value to be
#     sent to it.  Programs do not continue to the next instruction
#     until they have received a value.  Values are received in the
#     order they are sent.
#
# Each program also has its own program ID (one 0 and the other 1);
# the register p should begin with this value.
#
# Once both of your programs have terminated (regardless of what
# caused them to do so), how many times did program 1 send a value?
#
# --------------------
#
# We avoid using the concurrency control provided by the Queue class
# because we need the ability to detect and recover from a deadlock.

$mutex = Mutex.new
$cv = ConditionVariable.new

class Program2 < Program

  attr_reader :queue, :waiting, :sent

  def initialize(id)
    super()
    @id = id
    @reg["p"] = id
    @queue = Queue.new
    @waiting = false
    @sent = 0
  end

  def set_other(other)
    @other = other
  end

  def snd(x)
    $mutex.synchronize {
      @other.queue.push(get(x))
      @sent += 1
      $cv.signal
    }
  end

  def rcv(x)
    $mutex.synchronize {
      @waiting = true
      while @queue.length == 0 do
        if @other.queue.length == 0 and @other.waiting
          # deadlocked
          $cv.signal
          return false
        end
        $cv.wait($mutex)
      end
      @waiting = false
      @reg[x] = @queue.pop
    }
    true
  end

end

programs = [Program2.new(0), Program2.new(1)]
programs[0].set_other(programs[1])
programs[1].set_other(programs[0])
threads = programs.map {|p| Thread.new{p.run} }
threads.each {|t| t.join }
puts programs[1].sent
