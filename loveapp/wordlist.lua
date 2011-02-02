-- 
--  wordlist.lua
--  ExperimentalGameplayProject-Feb-2011
--  
--  Created by Jay Roberts on 2011-02-02.
--  Copyright 2011 GloryFish.org. All rights reserved.
-- 

require 'middleclass'

Wordlist = class('Wordlist')

function Wordlist:initialize(filename)
  self.words = {}
  self.count = 0
  
  local file = assert(io.open(filename, 'r'), 'Word list file not found')
  
  for line in file:lines() do 
    self.words[line] = line
    self.count = self.count + 1
  end
end


function Wordlist:contains(word)
  for k,w in pairs(self.words) do
    if w == word then
      return true
    end
  end
  
  return false
end


function Wordlist:random(length)
  if length == nil then
    assert(false, 'Not implemented')
  end
  
  assert(false, 'Not implemented')
  
end