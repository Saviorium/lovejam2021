local Storage      = require "game.storage.storage"
local Station      = require "game.station.station"

local Stations = {
    oreDrill = function (position)
        return Station(
            position,
            nil,
            nil,
            {},
            {ironOre = { produce = 100, storage = Storage(1000, 0, 'ironOre', 100, -1)} },
            AssetManager:getImage('ore_drill'),
            AssetManager:getImage('focused_ore_drill')
        )
    end
    ,
    ironAnvil = function (position)
        return Station(
            position,
            nil,
            nil,
            {ironOre = { consume = 100, storage = Storage(1000, 1000, 'ironOre', 100, 1) } },
            {iron    = { produce = 25 , storage = Storage(1000, 0, 'iron'   , 100, -1)} },
            AssetManager:getImage('ore_drill'),
            AssetManager:getImage('focused_ore_drill')
        )
    end
    ,
    milkStation = function (position)
        return Station(
            position,
            nil,
            nil,
            {},
            {milk    = { produce = 100 , storage = Storage(1000, 0, 'milk'   , 100, -1)} },
            AssetManager:getImage('ore_drill'),
            AssetManager:getImage('focused_ore_drill')
        )
    end
    ,
    cocoaFarm = function (position)
        return Station(
           position,
           nil,
           nil,
           {},
           {cocoa    = { produce = 100 , storage = Storage(1000, 0, 'cocoa'   , 100, -1)} },
           AssetManager:getImage('ore_drill'),
           AssetManager:getImage('focused_ore_drill')
        )
    end,
    chocolateFabric = function (position)
        return Station(
            position,
            nil,
            nil,
            {
                cocoa     = { consume = 100 , storage = Storage(1000, 1000, 'cocoa'   , 100, 1)},
                milk      = { consume = 100 , storage = Storage(1000, 1000, 'milk'    , 100, 1)},
            },
            {
                chocolate = { produce = 50  , storage = Storage(1000, 0, 'chocolate', 100, -1)}
            },
            AssetManager:getImage('ore_drill'),
            AssetManager:getImage('focused_ore_drill')
        )
    end,
    cityStation = function (position)
        return Station(
            position,
            nil,
            nil,
            {
                iron      = { consume = 0 , storage = Storage(10000, 0, 'iron'      , 100, 1)},
                chocolate = { consume = 0 , storage = Storage(10000, 0, 'chocolate' , 100, 1)},
            },
            {},
            AssetManager:getImage('ore_drill'),
            AssetManager:getImage('focused_ore_drill')
            )
    end,
    buildShipsStation = function (position)
        return Station(
            position,
            nil,
            nil,
            {
                iron      = { consume = 1000 , storage = Storage(5000, 0, 'iron'      , 100, 1)},
            },
            {
                ship      = { produce = 1    , storage = Storage(5, 0, 'ship'      , 1, -1)},
            },
            AssetManager:getImage('ore_drill'),
            AssetManager:getImage('focused_ore_drill')
            )
    end
    ,
}

return Stations