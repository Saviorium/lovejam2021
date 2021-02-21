local Station = require "game.station.station"
local StationsData = require "data.stations_data"

local Stations = {
    oreDrill = function(position)
        return Station(position, StationsData.oreDrill)
    end,
    ironAnvil = function(position)
        return Station(position, StationsData.ironAnvil)
    end,
    milkStation = function(position)
        return Station(position, StationsData.milkStation)
    end,
    cocoaFarm = function(position)
        return Station(position, StationsData.cocoaFarm)
    end,
    chocolateFabric = function(position)
        return Station(position, StationsData.chocolateFabric)
    end,
    cityStation = function(position)
        return Station(position, StationsData.cityStation)
    end,
    buildShipsStation = function(position)
        return Station(position, StationsData.buildShipsStation)
    end
}

return Stations
