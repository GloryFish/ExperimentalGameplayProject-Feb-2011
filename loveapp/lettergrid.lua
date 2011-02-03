-- 
--  lettergrid.lua
--  ExperimentalGameplayProject-Feb-2011
--  
--  Created by Jay Roberts on 2011-02-02.
--  Copyright 2011 GloryFish.org. All rights reserved.
-- 

require 'middleclass'
require 'vector'

Lettergrid = class('Lettergrid')

Lettergrid.LETTERS = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
Lettergrid.GRIDSIZE = 28

function Lettergrid:initialize(width, height, font)
  self.width = width
  self.height = height
  
  if font == nil then
    self.font = love.graphics.newFont('resources/fonts/droid.ttf', 24)
  else
    self.font = font
  end
  
  self.letters = {}
  
  for x = 1, self.width do
    self.letters[x] = {}
    for y = 1, self.height do
      self.letters[x][y] = 'A'
    end
  end
  
  self.position = vector(0, 0)
end

function Lettergrid:randomize()
  for x = 1, self.width do
    for y = 1, self.height do
      self.letters[x][y] = self:randomLetter()
    end
  end
end

-- Returns a random letter
function Lettergrid:randomLetter()
  return Lettergrid.LETTERS[math.random(1, #Lettergrid.LETTERS)]
end

function Lettergrid:draw()
  love.graphics.setFont(self.font)
  
  for x = 1, self.width do
    for y = 1, self.height do
      love.graphics.print(self.letters[x][y], Lettergrid.GRIDSIZE * x + self.position.x, Lettergrid.GRIDSIZE * y + self.position.y, 0, 1, 1)
    end
  end
end