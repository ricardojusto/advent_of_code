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
    @intcode = Intcode.new.parse
  end

  # Opcode 1 adds together numbers read from two positions and stores the result in a third position.
  # The three integers immediately after the opcode tell you these three positions
  # the first two indicate the positions from which you should read the input values
  # the third indicates the position at which the output should be stored
  # Opcode 2 works exactly like opcode 1, except it multiplies the two inputs instead of adding them
  # Once you're done processing an opcode, move to the next one by stepping forward 4 positions.

  def run_intcode
    restore_gravity
    dup = @intcode
    dup.each_slice(4) do |opcode, noun, verb, target|
      break if opcode == 99
      evaluate(opcode, noun, verb, target)
    end
    dup[0]
  end

  # restore the gravity assist program (your puzzle input) to the
  # "1202 program alarm" state it had just before the last computer caught fire.
  # To do this, before running the program, replace position 1 with the value 12
  # and replace position 2 with the value 2.
  # What value is left at position 0 after the program halts?
  def restore_gravity
    @intcode[1] = 12
    @intcode[2] = 2
  end

  def moon_gravity
    target_output = 19690720
    inputs        = Array(0..99)
    memory        = @intcode
    noun          = nil
    verb          = nil

    while memory[0] != target_output do
      inputs.each do |n1|
        noun = n1
        inputs.each do |n2|
          verb = n2
          puts "noun #{noun} - verb #{verb}"
          memory.each_slice(4) do |opcode, _, _, target|
            evaluate(opcode, noun, verb, target)
            break if memory[0] == target_output
            memory = @intcode
          end
          break if memory[0] == target_output
        end
        break if memory[0] == target_output
      end
      break if memory[0] == target_output
    end
    memory[0] * noun + verb
  end

  private

  def evaluate(opcode, noun, verb, target)
    case opcode
    when 1
      @intcode[target] = @intcode[noun] + @intcode[verb]
    when 2
      @intcode[target] = @intcode[noun] * @intcode[verb]
    else
      return
    end
  end

  def wrong?(opcode)
    ![1,2,99].include?(opcode)
  end
end

puts "1st part: The value at position 0 is #{ShipComputer.new.run_intcode}."
puts "2nd part: The value at position 0 is #{ShipComputer.new.moon_gravity}."
