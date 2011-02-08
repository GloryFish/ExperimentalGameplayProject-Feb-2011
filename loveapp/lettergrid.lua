-- 
--  lettergrid.lua
--  ExperimentalGameplayProject-Feb-2011
--  
--  Created by Jay Roberts on 2011-02-02.
--  Copyright 2011 GloryFish.org. All rights reserved.
-- 

require 'middleclass'
require 'vector'
require 'tableextras'

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
    startpos = vector(1, 1),
    endpos = vector(1, 1),
    selectedPoints = {},
    selectedWord = ''
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
  self.selector.currentpos = self.selector.startpos
end

function Lettergrid:moveSelect(pos)
  local gridPos = self:screenToGrid(pos)
  self.selector.currentpos = gridPos
  
  self.selector.endpos = self:endpointSnappedToAngle(self.selector.startpos, gridPos)

  self.selector.selectedPoints = self:pointsBetween(self.selector.startpos, self.selector.endpos)
  
  -- Only update word if we are showing the selector
  if self.selector.visible then
    local letters = {}
    for i, point in ipairs(self.selector.selectedPoints) do
      table.insert(letters, self.letters[point.x][point.y])
    end
  
    self.selector.selectedWord = table.concat(letters)
  end
  
end

function Lettergrid:endSelect(pos)
  self.selector.selectedPoints = {}
  self.selector.visible = false
  self.selector.endpos = self:screenToGrid(pos)
end

local function round(num)
  local mult = 10^0
  return math.floor(num * mult + 0.5) / mult
end

function Lettergrid:endpointSnappedToAngle(startpos, endpos)
  local velocity = endpos - startpos
  local step = math.rad(45)

  local angle = -math.atan2(-velocity.y, velocity.x)
  angle = angle + math.rad(90)

  local dirnum = round(angle / step) % 8
  local snapped = dirnum * step

  local up = vector(0, -1) * round(velocity:len())
  local tmp = startpos + up:rotated(snapped)

  return vector(round(tmp.x), round(tmp.y))
end

function Lettergrid:selectedWord()
  return self.selector.selectedWord:lower()
end

function Lettergrid:draw()
  love.graphics.setFont(self.font)
  
  for x = 1, self.width do
    for y = 1, self.height do
      local pos = vector(x, y)

      -- Draw cursor
      if (pos == self.selector.currentpos) then
        love.graphics.setColor(255, 0, 0, 255)
        love.graphics.print('O',
                            (Lettergrid.GRIDSIZE * x + self.position.x) - Lettergrid.GRIDSIZE,
                            (Lettergrid.GRIDSIZE * y + self.position.y) - Lettergrid.GRIDSIZE,
                            0,
                            1,
                            1)
      end

      love.graphics.setColor(255, 255, 255, 255)
      
      if (self.selector.visible and table.contains(self.selector.selectedPoints, pos)) then
        love.graphics.setColor(0, 240, 20, 255)
      end

      love.graphics.print(self.letters[x][y], 
                          (Lettergrid.GRIDSIZE * x + self.position.x) - Lettergrid.GRIDSIZE,
                          (Lettergrid.GRIDSIZE * y + self.position.y) - Lettergrid.GRIDSIZE,
                          0, 
                          1,
                          1)
    end
    
  end
end

-- Returns a table of vectors representing all of the points between the two supplied points 
function Lettergrid:pointsBetween(first, second)
  -- http://en.wikipedia.org/wiki/Bresenham's_line_algorithm
  local x0 = first.x
  local y0 = first.y
  local x1 = second.x
  local y1 = second.y
  
  local points = {}
  
  local steep = false
  if math.abs(y1 - y0) > math.abs(x1 - x0) then steep = true end

  if steep then
    x0, y0 = y0, x0
    x1, y1 = y1, x1
  end             

  if x0 > x1 then
    x0, x1 = x1, x0
    y0, y1 = y1, y0
  end

  local deltax = x1 - x0
  local deltay = math.abs(y1 - y0)
  local err = deltax / 2
  local ystep = 0
  local y = y0

  if y0 < y1 then 
    ystep = 1 
  else 
    ystep = -1 
  end

  for x=x0,x1 do
    if steep then 
      local c = vector(y, x)
      table.insert(points, c)
    else 
      local c = vector(x, y)
      table.insert(points, c)
    end             

    err = err - deltay

    if err < 0 then
       y = y + ystep
       err = err + deltax
    end
  end
  
  return points
end