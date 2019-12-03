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

  def run_intcode
    dup = @intcode.dup
    restore_gravity(dup)

    dup.each_slice(4) do |opcode, noun, verb, target|
      break if opcode == 99
      raise "Something went wrong..." if wrong?(opcode)
      dup = evaluate(dup, opcode, noun, verb, target)
    end
    dup[0]
  end

  # restore the gravity assist program (your puzzle input) to the
  # "1202 program alarm" state it had just before the last computer caught fire.
  # To do this, before running the program, replace position 1 with the value 12
  # and replace position 2 with the value 2.
  # What value is left at position 0 after the program halts?
  def restore_gravity(dup)
    dup[1] = 12
    dup[2] = 2
  end

  def moon_gravity
    target_output = 19690720
    inputs        = Array(0..99)
    dup           = nil
    noun          = nil
    verb          = nil


    inputs.each do |noun|
      inputs.each do |verb|
        dup = @intcode.dup

        dup.each_slice(4) do |opcode, _, _, target|
          break if opcode == 99

          raise "Something went wrong... opcode is #{opcode}" if wrong?(opcode)
          evaluate(dup, opcode, noun, verb, target)
        end
        print "\nTrying => noun: #{noun} | verb: #{verb} = dup output was #{dup[0]}"

        break if dup[0] == target_output

      end

      break if dup[0] == target_output

    end

    return "No luck" if dup[0] != target_output

    100 * noun + verb
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

puts "\n1st part: The value at position 0 is #{ShipComputer.new.run_intcode}."
puts "\n2nd part: The value at position 0 is #{ShipComputer.new.moon_gravity}."
