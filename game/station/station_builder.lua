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
        local mouseCoords = self.world:getMouseCoords()
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
        local stationCoords = world.resourcesGrid:getGridCellAtCoords(Vector(love.mouse.getPosition()))
        self.buildingStation = nil
        if StationsData[stationName].conditionToBuild(world) and not world:findStationsInRange(stationCoords, 1) then
            local stationIndex = #world.stations + 1
            world.stations[stationIndex] = BuildingStation( mouseCoords, stationName, world, stationIndex)
            return true
        end
    end
    return false
end

return StationBuilder

