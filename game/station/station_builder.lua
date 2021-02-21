local BuildingStation  = require "game.station.building_station"
local StationsData     = require "data.stations_data"

-- Абстрактная станция с ресурсом
local StationBuilder = Class {
    init = function(self, world)
        self.buildingStation = nil
        self.world = world
    end
}

function StationBuilder:draw()
    if self.buildingStation then
        local mouseCoords = Vector(love.mouse.getPosition()) --self.world:getFromScreenCoord(Vector(love.mouse.getPosition()))
        local position = self.world.resourcesGrid:clampToGrid(mouseCoords.x, mouseCoords.y)
        love.graphics.draw(self.stationImage, position.x, position.y )
    end
end

function StationBuilder:startBuild( stationName )
    self.buildingStation = stationName
    self.stationImage = StationsData[self.buildingStation].image
end

function StationBuilder:placeStation( stationName, world )
    if self.buildingStation == stationName then
        local mouseCoords = world:getFromScreenCoord(Vector(love.mouse.getPosition()))
        if (self.buildingStation == "oreDrill" and world.resourcesGrid:getResourcesAtCoords(mouseCoords, "ironOre") == 0)
        or (self.buildingStation == "cocoaFarm" and world.resourcesGrid:getResourcesAtCoords(mouseCoords, "ice") == 0)
         then
            self.buildingStation = nil
        else
            local stationIndex = #world.stations + 1
            self.buildingStation = nil
            world.stations[stationIndex] = BuildingStation( mouseCoords, stationName, world, stationIndex)
            return true
        end
    end
    return false
end

return StationBuilder

