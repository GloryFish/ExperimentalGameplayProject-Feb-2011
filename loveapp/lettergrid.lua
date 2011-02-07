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

  self.selector = {
    visible = false,
    currentpos = vector(0, 0),
    startpos = vector(0, 0),
    endpos = vector(0, 0)
  }

  self.scale = 1
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

-- Returns a random letter
function Lettergrid:screenToGrid(point)
  local grid = vector(math.floor(point.x / (Lettergrid.GRIDSIZE * self.scale)),
                      math.floor(point.y / (Lettergrid.GRIDSIZE * self.scale)))

  return grid

end


function Lettergrid:beginSelect(pos)
  self.selector.visible = true
  self.selector.startpos = self:screenToGrid(pos)
  self.selector.currentpos = vector(x, y)
end

function Lettergrid:moveSelect(pos)
  self.selector.currentpos = self:screenToGrid(pos)
end

function Lettergrid:endSelect(pos)
  self.selector.visible = true
  self.selector.currentpos = self:screenToGrid(pos)
  self.selector.endpos = self:screenToGrid(pos)
end

function Lettergrid:draw()
  love.graphics.setFont(self.font)
  
  for x = 1, self.width do
    for y = 1, self.height do
      if (x == self.selector.currentpos.x and y == self.selector.currentpos.y) then
        love.graphics.setColor(255, 0, 0, 255)
        love.graphics.print('O',
                            (Lettergrid.GRIDSIZE * x + self.position.x) - Lettergrid.GRIDSIZE,
                            (Lettergrid.GRIDSIZE * y + self.position.y) - Lettergrid.GRIDSIZE,
                            0,
                            1,
                            1)
      end

      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.print(self.letters[x][y], 
                          (Lettergrid.GRIDSIZE * x + self.position.x) - Lettergrid.GRIDSIZE,
                          (Lettergrid.GRIDSIZE * y + self.position.y) - Lettergrid.GRIDSIZE,
                          0, 
                          1,
                          1)
    end
  end
end