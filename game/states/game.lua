
local Game = {}

function Game:enter()
    self.ship = AssetManager:getImage("ship")
end

function Game:mousepressed(x, y)
end

function Game:mousereleased(x, y)
end

function Game:keypressed(key)
end

function Game:draw()
    love.graphics.draw(self.ship, 10, 10)
end

function Game:update(dt)
end

return Game