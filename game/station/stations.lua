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
    hubStation = function(position, world)
        local resultStation = Station(position, StationsData.hubStation)
        resultStation.world = world
        resultStation.dudeConsuming = dudeConsuming
        resultStation.onMonthTick =
            function( station )
                local peoplesConsuming = station.outResources['dude'].storage.value * station.inResources['chocolate'].dudeConsuming
                local result = station.inResources['chocolate'].storage:addAndGetExcess(-peoplesConsuming)
                local willLive = result == 0
                if willLive then
                    station.outResources['dude'].storage:addAndGetExcess(station.outResources['dude'].inMonthProducing)
                else
                    station.world:descreaseLives()
                end
            end
        return resultStation
    end,
    buildShipsStation = function(position)
        return Station(position, StationsData.buildShipsStation)
    end
}

return Stations
