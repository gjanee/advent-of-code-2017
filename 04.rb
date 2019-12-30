# --- Day 4: High-Entropy Passphrases ---
#
# A new system policy has been put in place that requires all accounts
# to use a passphrase instead of simply a password.  A passphrase
# consists of a series of words (lowercase letters) separated by
# spaces.
#
# To ensure security, a valid passphrase must contain no duplicate
# words.
#
# The system's full passphrase list is available as your puzzle input.
# How many passphrases are valid?

File.open("04.in") do |f|
  puts f.select {|l| p = l.split; p.uniq.length == p.length }.count
end

# --- Part Two ---
#
# For added security, yet another system policy has been put in place.
# Now, a valid passphrase must contain no two words that are anagrams
# of each other - that is, a passphrase is invalid if any word's
# letters can be rearranged to form any other word in the passphrase.
#
# Under this new system policy, how many passphrases are valid?

File.open("04.in") do |f|
  puts f.select {|l| p = l.split
    p.map{|w|w.chars.sort.join}.uniq.length == p.length }.count
end
