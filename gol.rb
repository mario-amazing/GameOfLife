#!/usr/bin/env ruby

class Game_of_life
  def initialize
    # @background = File.open("background.txt").map { |line| line.delete("\n").each_char.to_a }
    @tmp = Array.new(100){Array.new(100)}
    @background = Array.new(100){Array.new(100)}
    @row = @background.length - 1
    @col = @background.first.length - 1
    randomize
  end

  def next_generation
    @background.each_with_index do |line,i|
      line.each_index { |j| analise_of_life(i, j) }
    end
    puts 
    @background = @tmp
  end

  def randomize
    @background.map do |line|
      line.map! {|elem| elem = rand(0..1)}
    end
  end

  def analise_of_life(i, j)
    live_neighbors = 0
    neighbors = 0
    neighbors = [ [i-1, j-1], [i-1, j], [i-1, j+1],
                  [i, j-1],             [i, j+1],
                  [i+1, j-1], [i+1, j], [i+1, j+1]]
    neighbors.each { |indexes| live_neighbors += get_live_neighbors(indexes) }
    alive_cell(i, j, live_neighbors)
  end

  def get_live_neighbors(indexes)
    i, j = indexes.first, indexes.last
    i = @row if i < 0 
    i = 0 if i > @row
    j = @col if j < 0
    j = 0 if j > @col
    @background[i][j].to_i
  end

  def alive_cell(i, j, live_neighbors)
    if @background[i][j].to_i == 1
      if live_neighbors.between?(2,3)
        @tmp[i][j] = 1
      else
        @tmp[i][j] = 0
      end
    else
      if live_neighbors == 3
        @tmp[i][j] = 1
      else
        @tmp[i][j] = 0
      end
    end
  end

  def display
    system 'clear'
    @background.each do |line|
      puts line.map(&:to_s).join.gsub(/[01]/ ,'0' => ' ','1' => '*')
    end
  end
end

a = Game_of_life.new
loop do
  a.display
  sleep(0.05)
  a.next_generation
end
