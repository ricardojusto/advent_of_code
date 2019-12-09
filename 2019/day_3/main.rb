#!/usr/bin/env ruby

require 'pry'

class Wires
  def initialize
    @file = File.open('wires.txt', 'r')
  end

  def parse
    result = []
    @file.each_line do |line|
      result.push(line.gsub("\n",'').split(','))
    end
    result
  end
end

class FuelManagement
  def initialize
    @wires = Wires.new.parse.freeze
    @wire1 = nil
    @wire2 = nil
  end

  def run
    @wire1 = create_circuit_board(@wires.first)
    @wire2 = create_circuit_board(@wires.last)
    manhattan_distance
  end

  private

  def create_circuit_board(wire)
    x = 0
    y = 0
    path = []

    wire.each do |step|
      direction = step[0].upcase
      distance  = step[1..].to_i

      while distance > 0 do
        case direction
        when 'R' then x += 1
        when 'U' then y += 1
        when 'L' then x -= 1
        when 'D' then y -= 1
        else
          raise StandardError('¯\_(ツ)_/¯')
        end

        path.push([x,y])
        distance -= 1
      end
    end
    path
  end

  def manhattan_distance
    (@wire1 & @wire2).map do |intersection|
      intersection.reduce(0) { |acc, n| acc + n.abs }
    end.min
  end
end

puts "Part A: The manhattan distance is: #{FuelManagement.new.run}"
