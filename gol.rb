#!/usr/bin/env ruby
class GameOfLife
    def File_background
        background = File.open("background.txt") { |line| line.read.split("\n")}
        puts background
    end

end

a = GameOfLife.new
a.File_background

