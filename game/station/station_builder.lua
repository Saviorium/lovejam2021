local BuildingStation      = require "game.station.building_station"

-- Абстрактная станция с ресурсом
local StationBuilder = Class {
    init = function(self)
        self.buildingStation = nil
    end
}

function StationBuilder:startBuild( typeOfStation )
    self.buildingStation = typeOfStation
    print('Ready to build')
end

function StationBuilder:placeStation( mouseCoords, typeOfStation, world, index )
    if self.buildingStation then
        print('Building', mouseCoords)
        self.buildingStation = nil
        return BuildingStation( mouseCoords, typeOfStation, world, index)
    end
end

return StationBuilder

