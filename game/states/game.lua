local MapGrid           = require("game.map_grid")
local ResourcesData     = require("data.resources_grid_data")
local Stations          = require("game.station.stations")

local Game = {
    map = MapGrid(100, 100, ResourcesData)
}

function Game:enter()
    self.ship = AssetManager:getImage("ship")
    self.station = Stations.oreDrill(100, 100)
end

function Game:mousepressed(x, y)
end

function Game:mousereleased(x, y)
end

function Game:keypressed(key)
end

function Game:draw()
    love.graphics.draw(self.ship, 10, 10)
    self.map:draw()
    self.station:draw()
end

function Game:update(dt)

end

return Game