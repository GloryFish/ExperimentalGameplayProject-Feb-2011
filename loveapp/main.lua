-- 
--  main.lua
--  xenofarm
--  
--  Created by Jay Roberts on 2011-01-20.
--  Copyright 2011 GloryFish.org. All rights reserved.
-- 

require('middleclass')
require('middleclass-extras')

require 'lettergrid'

print 'Test'

function love.load()
  
  -- Seed random
  local seed = os.time()
  math.randomseed(seed);
  math.random(); math.random(); math.random()
  
  
  lg = Lettergrid(32, 24)
  lg.position = vector(40, 30)
  lg:randomize()
  
  dur = 0
end

function love.mousepressed(x, y, button)
  lg:beginSelect(vector(x, y))
end

function love.mousereleased(x, y, button)
  lg:endSelect(vector(x, y))
end


function love.update(dt)
  lg:moveSelect(vector(love.mouse.getX(), love.mouse.getY()))
  
  dur = dur + dt
  if dur > 0.1 then
    lg:randomize()
    dur = 0
  end
end

function love.draw()
  lg:draw()
end