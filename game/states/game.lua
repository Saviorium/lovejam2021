local World = require("game.world")

local Game = {}

function Game:enter()
    self.gameWorld = World()
end

function Game:mousepressed(x, y)
    self.gameWorld:mousepressed(x, y)
end

function Game:mousereleased(x, y)
    self.gameWorld:mousereleased(x, y)
end

function Game:wheelmoved(x, y)
    self.gameWorld:wheelmoved(x, y)
end

function Game:keypressed(key)
end

function Game:draw()
    self.gameWorld:draw()
    -- draw ui
    if Debug and Debug.showFps == 1 then
        love.graphics.print(""..tostring(love.timer.getFPS( )), 2, 2)
    end
end

function Game:update(dt)
    self.gameWorld:update(dt)
end

return Game