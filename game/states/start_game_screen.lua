local World = require("game.world")

local StartGame = {}

function StartGame:enter()
    self.gameWorld = World()
end

function StartGame:mousepressed(x, y, button)
    self.gameWorld:mousepressed(x, y, button)
end

function StartGame:mousereleased(x, y, button)
    self.gameWorld:mousereleased(x, y, button)
end

function StartGame:wheelmoved(x, y)
    self.gameWorld:wheelmoved(x, y)
end

function StartGame:keypressed(key)
end

function StartGame:draw()
    self.gameWorld:draw()
    -- draw ui
    if Debug and Debug.showFps == 1 then
        love.graphics.print(""..tostring(love.timer.getFPS( )), 2, 2)
    end
end

function StartGame:update(dt)
    self.gameWorld:update(dt)
end

return StartGame