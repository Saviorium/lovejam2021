local World = require("game.world")

local Game = {}

function Game:enter(prev_state, world)
    self.gameWorld = nvl(world, World())
end

function Game:mousepressed(x, y, button)
    self.gameWorld:mousepressed(x, y, button)
end

function Game:mousereleased(x, y, button)
    self.gameWorld:mousereleased(x, y, button)
end

function Game:wheelmoved(x, y)
    self.gameWorld:wheelmoved(x, y)
end

function Game:keypressed(key)
end

function Game:draw()
    self.gameWorld:draw()
    -- draw ui
end

function Game:update(dt)
    self.gameWorld:update(dt)
end

return Game