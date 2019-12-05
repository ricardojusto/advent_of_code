#!/usr/bin/env ruby

require 'pry'

class Intcode
  def initialize
    @file = File.open('intcode.txt', 'r')
  end

  def parse
    result = []
    @file.each_line do |line|
      result.push(line.scan(/\d+/).map(&:to_i))
    end
    result.flatten
  end
end

class ShipComputer
  def initialize
    @intcode = Intcode.new.parse.freeze
  end

  # Opcode 1 adds together numbers read from two positions and stores the result in a third position.
  # The three integers immediately after the opcode tell you these three positions
  # the first two indicate the positions from which you should read the input values
  # the third indicates the position at which the output should be stored
  # Opcode 2 works exactly like opcode 1, except it multiplies the two inputs instead of adding them
  # Once you're done processing an opcode, move to the next one by stepping forward 4 positions.

  def run_intcode(x, y)
    dup = @intcode.dup
    dup = restore_gravity(dup, x, y)
    dup.each_slice(4) do |opcode, noun, verb, target|
      break if opcode == 99

      dup = evaluate(dup, opcode, noun, verb, target)
    end
    dup[0]
  end

  # restore the gravity assist program (your puzzle input) to the
  # "1202 program alarm" state it had just before the last computer caught fire.
  # To do this, before running the program, replace position 1 with the value 12
  # and replace position 2 with the value 2.
  # What value is left at position 0 after the program halts?
  def restore_gravity(dup, x, y)
    dup[1] = x
    dup[2] = y
    dup
  end

  def moon_gravity
    target_output = 19690720
    inputs        = Array(0..99)

    inputs.each do |noun|
      inputs.each do |verb|
        out = run_intcode(noun, verb)
        return 100 * noun + verb if out == target_output
      end
    end

    return "No luck" if out != target_output
  end

  private

  def evaluate(dup, opcode, noun, verb, target)
    if opcode == 1
      dup[target] = dup[noun] + dup[verb]
    elsif opcode == 2
      dup[target] = dup[noun] * dup[verb]
    elsif opcode == 99
      return dup
    end
    dup
  end

  def wrong?(opcode)
    ![1,2,99].include?(opcode)
  end
end

puts "1st part: The value at position 0 is #{ShipComputer.new.run_intcode(12, 2)}."
puts "2nd part: The value at position 0 is #{ShipComputer.new.moon_gravity}."
