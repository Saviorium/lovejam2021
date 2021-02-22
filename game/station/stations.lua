local Station = require "game.station.station"
local Storage = require "game.storage.storage"
local StationsData = require "data.stations_data"

local Stations = {
    oreDrill = function(position)
        local newStorage
        local inResources  = {}
        local outResources = {}
        newStorage = Storage(4000, 0, 'ironOre', 100, -1)
        outResources['ironOre'] = { takingFromGrid = 5, produce = 200 , storage = newStorage}
        StationsData.oreDrill.inResources = inResources
        StationsData.oreDrill.outResources = outResources
        return Station(position, StationsData.oreDrill)
    end,
    iceDrill = function(position)
        local newStorage
        local inResources  = {}
        local outResources = {}
        newStorage = Storage(4000, 0, 'ice', 100, -1)
        outResources['ice'] = { takingFromGrid = 5, produce = 200 , storage = newStorage}
        StationsData.iceDrill.inResources = inResources
        StationsData.iceDrill.outResources = outResources
        return Station(position, StationsData.iceDrill)
    end,
    ironAnvil = function(position)
        local newStorage
        local inResources  = {}
        local outResources = {}
        newStorage = Storage(1000, 0, 'ironOre', 100, 1)
        inResources['ironOre'] = { consume = 100 , storage = newStorage}
        newStorage = Storage(1000, 0, 'iron', 100, -1)
        outResources['iron'] = { produce = 25 , storage = newStorage}
        StationsData.ironAnvil.inResources = inResources
        StationsData.ironAnvil.outResources = outResources
        return Station(position, StationsData.ironAnvil)
    end,
    milkStation = function(position)
        local newStorage
        local inResources  = {}
        local outResources = {}
        newStorage = Storage(1000, 0, 'ice', 100, 1)
        inResources['ice'] = { consume = 100 , storage = newStorage}
        newStorage = Storage(1000, 0, 'cocoa', 100, 1)
        inResources['cocoa'] = { consume = 50 , storage = newStorage}
        newStorage = Storage(1000, 0, 'milk', 100, -1)
        outResources['milk'] = { produce = 50 , storage = newStorage}
        StationsData.milkStation.inResources = inResources
        StationsData.milkStation.outResources = outResources
        return Station(position, StationsData.milkStation)
    end,
    cocoaFarm = function(position)
        local newStorage
        local inResources  = {}
        local outResources = {}
        newStorage = Storage(1000, 0, 'ice', 100, 1)
        inResources['ice'] = { consume = 100 , storage = newStorage}
        newStorage = Storage(1000, 0, 'cocoa', 100, -1)
        outResources['cocoa'] = { produce = 75 , storage = newStorage}
        StationsData.cocoaFarm.inResources = inResources
        StationsData.cocoaFarm.outResources = outResources
        return Station(position, StationsData.cocoaFarm)
    end,
    chocolateFabric = function(position)
        local newStorage
        local inResources  = {}
        local outResources = {}
        newStorage = Storage(1000, 1000, 'cocoa', 100, 1)
        inResources['cocoa'] = { consume = 100 , storage = newStorage}
        newStorage = Storage(1000, 1000, 'milk', 100, 1)
        inResources['milk'] = { consume = 100 , storage = newStorage}
        newStorage = Storage(1000, 0, 'chocolate', 100, -1)
        outResources['chocolate'] = { produce = 50 , storage = newStorage}
        StationsData.chocolateFabric.inResources = inResources
        StationsData.chocolateFabric.outResources = outResources
        return Station(position, StationsData.chocolateFabric)
    end,
    hubStation = function(position, world)
        local newStorage
        local inResources  = {}
        local outResources = {}
        newStorage = Storage(10000, 0, 'iron', 100, 1)
        inResources['iron'] = { consume = 0 , storage = newStorage}
        newStorage = Storage(10000, 0, 'chocolate', 100, 1)
        inResources['chocolate'] = { dudeConsuming = 100, consume = 0 , storage = newStorage}
        newStorage = Storage(10000, 10, 'dude', 100, -1)
        outResources['dude'] = { inMonthProducing = 1, produce = 0 , storage = newStorage}
        StationsData.hubStation.inResources = inResources
        StationsData.hubStation.outResources = outResources

        local resultStation = Station(position, StationsData.hubStation)
        resultStation.world = world
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
        local newStorage
        local inResources  = {}
        local outResources = {}
        newStorage = Storage(5000, 1000, 'iron', 100, 1)
        inResources['iron'] = { consume = 50 , storage = newStorage}
        newStorage = Storage(5, 1, 'ship', 1, -1)
        outResources['ship'] = { produce = 0.05 , storage = newStorage}
        StationsData.buildShipsStation.inResources = inResources
        StationsData.buildShipsStation.outResources = outResources
        return Station(position, StationsData.buildShipsStation)
    end
}

return Stations
