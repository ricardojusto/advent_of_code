require 'pry'

class Modules
  def initialize
    @file = File.open('modules.txt', 'r')
  end

  def parse
    modules = []
    @file.each_line do |line|
      modules.push(line.delete('\n').to_i)
    end
    modules
  end
end

class FuelManager
  def initialize(modules)
    @modules = modules
  end

  def calculate(value)
    (value / 3).floor - 2
  end

  def fuel_requirements
    @modules.map { |mass| calculate(mass) }.sum
  end

  def total_fuel_requirements
    @modules.map do |fuel|
      fuel_modules = []
      while fuel > 0 do
        fuel = calculate(fuel)
        fuel_modules.push(fuel) if fuel >= 0
      end
      fuel_modules.sum
    end.sum
  end
end

fuel_manager = FuelManager.new(Modules.new.parse)

fuel_1 = fuel_manager.fuel_requirements
puts "\n1st part: Fuel needed is #{fuel_1}."

fuel_2 = fuel_manager.total_fuel_requirements
puts "\n2nd part: Fuel needed is #{fuel_2}."
