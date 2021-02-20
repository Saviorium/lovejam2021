local BuildingStation      = require "game.station.building_station"

-- Абстрактная станция с ресурсом
local StationBuilder = Class {
    init = function(self)
        self.buildingStation = nil
    end
}

function StationBuilder:startBuild( stationName )
    self.buildingStation = stationName
end

function StationBuilder:placeStation( stationName, typeOfStation, world )
    if self.buildingStation == stationName then
        local mouseCoords = world:getFromScreenCoord(Vector(love.mouse.getPosition()))
        if (self.buildingStation == "oreDrill" and world.resourcesGrid:getResourcesAtCoords(mouseCoords, "iron") == 0)
        or (self.buildingStation == "cocoaFarm" and world.resourcesGrid:getResourcesAtCoords(mouseCoords, "ice") == 0)
         then
            self.buildingStation = nil
        else
            print('Builed')
            local stationIndex = #world.stations + 1
            self.buildingStation = nil
            world.stations[stationIndex] = BuildingStation( mouseCoords, typeOfStation, world, stationIndex)
            return true
        end
    end
    return false
end

return StationBuilder

