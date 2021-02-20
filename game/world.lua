local Vector = require("lib.hump.vector")

local MapGrid = require("game.map_grid")
local ResourcesData = require("data.resources_grid_data")
local Stations = require("game.station.stations")

-- local StationParameters = require("game.station.stations_parameters")

local World = Class {
    init = function(self)
        self.resourcesGrid = MapGrid(1000, 1000, ResourcesData)
        self.stations = {}
        self.ships = {}
        self:populateOnInit()
        self.camera = {
            position = Vector(0, 0),
            zoom = 1
        }
    end
}

function World:populateOnInit()
    table.insert( self.stations, Stations.oreDrill(100, 100) )
end

function World:update(dt)
end

function World:draw()
    love.graphics.push()
    self:attachCamera()
    -- draw background
    self.resourcesGrid:draw()
    for _, station in pairs(self.stations) do
        station:draw()
    end
    for _, ship in pairs(self.ships) do
        ship:draw()
    end
    love.graphics.pop()
end

function World:attachCamera()
    local transform = love.math.newTransform()
    transform
        :translate( self.camera.position:unpack() )
        :scale( self.camera.zoom )
    love.graphics.applyTransform(transform)
end

return World