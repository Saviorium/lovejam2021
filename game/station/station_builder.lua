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
        local stationCoords = self.world.resourcesGrid:getGridCellAtCoords(Vector(mouseCoords.x, mouseCoords.y))
        if not (StationsData[self.buildingStation].conditionToBuild(self.world) and not self.world:findStationsInRange(stationCoords, 1)) then
            love.graphics.setColor(1, 0, 0, 0.8)
        end
        love.graphics.draw(self.stationImage, position.x, position.y )
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function StationBuilder:startBuild( stationName )
    self.buildingStation = stationName
    self.stationImage = StationsData[self.buildingStation].image
end

function StationBuilder:placeStation( stationName, world )
    local collision = false
    for ind, ui in pairs(world.uiManager.objects) do
        if ui:getCollision(love.graphics.transformPoint(love.mouse.getPosition())) then
            collision = true
        end
    end
    if self.buildingStation == stationName then
        local mouseCoords = world:getFromScreenCoord(Vector(love.mouse.getPosition()))
        local stationCoords = world.resourcesGrid:getGridCellAtCoords(Vector(mouseCoords.x, mouseCoords.y))
        self.buildingStation = nil
        if StationsData[stationName].conditionToBuild(world) and not world:findStationsInRange(stationCoords, 2) and not collision then
            SoundManager:play("build_start")
            local stationIndex = #world.stations + 1
            world.stations[stationIndex] = BuildingStation( mouseCoords, stationName, world, stationIndex)
            return true
        end
    end
    return false
end

return StationBuilder

