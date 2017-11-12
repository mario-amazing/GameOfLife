#!/usr/bin/env ruby

require 'colorize'

class GameOfLife
  def initialize
    @tmp = Array.new(100) { Array.new(100) }
    @background = Array.new(100) { Array.new(100) }
    @row = @background.length - 1
    @col = @background.first.length - 1
    randomize
  end

  def next_generation
    @background.each_with_index do |line, i|
      line.each_index { |j| analise_of_life(i, j) }
    end
    puts
    @background = @tmp
  end

  def randomize
    @background.map do |line|
      line.map! { |_| rand(0..1) }
    end
  end

  def analise_of_life(i, j)
    live_neighbors = 0
    neighbors = [
      [i-1, j-1], [i-1, j], [i-1, j+1],
      [i, j-1],             [i, j+1],
      [i+1, j-1], [i+1, j], [i+1, j+1]
    ]
    neighbors.each { |indexes| live_neighbors += get_live_neighbors(indexes) }
    alive_cell(i, j, live_neighbors)
  end

  def get_live_neighbors(indexes)
    i = indexes.first
    j = indexes.last
    i = @row if i < 0
    i = 0 if i > @row
    j = @col if j < 0
    j = 0 if j > @col
    @background[i][j].to_i
  end

  def alive_cell(i, j, live_neighbors)
    @tmp[i][j] = if @background[i][j].to_i == 1
                   live_neighbors.between?(2, 3) ? 1 : 0
                 else
                   live_neighbors == 3 ? 1 : 0
                 end
  end

  def display
    system 'clear'
    @background.each do |line|
      puts line.map(&:to_s).join.gsub(/[01]/, '0' => ' ', '1' => '*').blue
    end
  end
end

a = GameOfLife.new
loop do
  a.display
  sleep(0.05)
  a.next_generation
end
