local Storage      = require "game.storage.storage"
local Station      = require("game.station.station")

local Stations = {
    oreDrill = function (x, y)
                    return Station(
                                    x,
                                    y,
                                    nil,
                                    nil,
                                    {},
                                    {ironOre = { produce = 100, storage = Storage(1000, 0, 'ironOre', 100, -1)} },
                                    AssetManager:getImage('ship'),
                                    AssetManager:getImage('ship')
                                  )
               end
    ,
    -- ironAnvil = {
    --     inResources  = {ironOre = { consume = 100, Storage(4000, 0, 'ironOre', 100, 1)} },
    --     outResources = {iron = { product = 25, Storage(1000, 0, 'iron'   , 100, -1)} },
    --     image = AssetManager:getImage('iron_anvil'),
    --     focusedImage = AssetManager:getImage('focused_iron_anvil'),
    -- },
    -- milkStation = {
    --     inResources  = {},
    --     outResources = {milk = { product = 100, Storage(1000, 0, 'milk', 100, -1)} },
    --     image = AssetManager:getImage('milk_station'),
    --     focusedImage = AssetManager:getImage('focused_milk_station'),
    -- },
    -- cocoaFarm = {
    --     inResources  = {},
    --     outResources = {cocoa = { product = 100, Storage(1000, 0, 'cocoa', 100, -1)} },
    --     image = AssetManager:getImage('cocoa_farm'),
    --     focusedImage = AssetManager:getImage('focused_cocoa_farm'),
    -- },
    -- chocolateFabric = {
    --     inResources  = {
    --                     cocoa = { consume = 100, Storage(4000, 0, 'cocoa', 100, 1)},
    --                     milk  = { consume = 100, Storage(4000, 0, 'milk', 100, 1)}
    --                    },
    --     outResources = {chocolate = { product = 100, Storage(1000, 0, 'chocolate', 100, -1)} },
    --     image = AssetManager:getImage('chocolate_fabric'),
    --     focusedImage = AssetManager:getImage('focused_chocolate_fabric'),
    -- },
    -- cityStation = {
    --     inResources  = {
    --                     chocolate = { consume = 100, Storage(10000, 0, 'chocolate', 100, 1)},
    --                     iron      = { consume = 100, Storage(10000, 0, 'chocolate', 100, 1)}
    --                    },
    --     outResources = {},
    --     image = AssetManager:getImage('city_station'),
    --     focusedImage = AssetManager:getImage('focused_city_station'),
    -- },
}

return Stations