local Storage = require "game.storage.storage"

local StationsData = {
    oreDrill = {
        inResources  = {},
        outResources = {ironOre = { produce = 100, storage = Storage(1000, 0, 'ironOre', 100, -1)} },
        image        = AssetManager:getImage('ore_drill'),
        selectedImage   = AssetManager:getImage('focused_ore_drill'),
        conditionToBuild =
        function (world)
            local mouseCoords = world:getFromScreenCoord(Vector(love.mouse.getPosition()))
            return world.resourcesGrid:getResourcesAtCoords(mouseCoords, "ironOre") ~= 0 and world:isThereLeftAnyDudes()
        end,
        description = 'Text to test stations description'
    },
    ironAnvil = {
        inResources  = {ironOre = { consume = 100, storage = Storage(1000, 1000, 'ironOre', 100, 1) } },
        outResources = {iron    = { produce = 25 , storage = Storage(1000, 0, 'iron' , 100, -1)} },
        image        = AssetManager:getImage('ore_drill'),
        selectedImage   = AssetManager:getImage('focused_ore_drill'),
        conditionToBuild =
        function (world)
            return world:isThereLeftAnyDudes()
        end,
        description = 'Text to test stations description'
    },
    milkStation = {
        inResources  = {},
        outResources = {milk    = { produce = 100 , storage = Storage(1000, 0, 'milk' , 100, -1)} },
        image        = AssetManager:getImage('ore_drill'),
        selectedImage   = AssetManager:getImage('focused_ore_drill'),
        conditionToBuild =
        function (world)
            return world:isThereLeftAnyDudes()
        end,
        description = 'Text to test stations description'
    },
    cocoaFarm = {
        inResources  = {},
        outResources = {cocoa    = { produce = 100 , storage = Storage(1000, 0, 'cocoa' , 100, -1)} },
        image        = AssetManager:getImage('ore_drill'),
        selectedImage   = AssetManager:getImage('focused_ore_drill'),
        conditionToBuild =
        function (world)
            local mouseCoords = world:getFromScreenCoord(Vector(love.mouse.getPosition()))
            return world.resourcesGrid:getResourcesAtCoords(mouseCoords, "ice") ~= 0 and world:isThereLeftAnyDudes()
        end,
        description = 'Text to test stations description'
    },
    chocolateFabric = {
        inResources  = {
                        cocoa     = { consume = 100 , storage = Storage(1000, 1000, 'cocoa'  , 100, 1)},
                        milk      = { consume = 100 , storage = Storage(1000, 1000, 'milk'   , 100, 1)},
                       },
        outResources = {chocolate = { produce = 50  , storage = Storage(1000, 0, 'chocolate' , 100, -1)}},
        image        = AssetManager:getImage('ore_drill'),
        selectedImage   = AssetManager:getImage('focused_ore_drill'),
        conditionToBuild =
        function (world)
            return world:isThereLeftAnyDudes()
        end,
        description = 'Text to test stations description'
    },
    hubStation = {
        inResources  = {
                        iron      = { consume = 0 , storage = Storage(10000, 0, 'iron' , 100, 1)},
                        chocolate = { dudeConsuming = 100, consume = 0 , storage = Storage(10000, 1000, 'chocolate' , 100, 1)},
                       },
        outResources = { dude = { inMonthProducing = 1, produce = 0 , storage = Storage(10000, 10, 'dude' , 100, 1)},},
        image        = AssetManager:getImage('ore_drill'),
        selectedImage   = AssetManager:getImage('focused_ore_drill'),
        conditionToBuild =
        function (world)
            return world:isThereLeftAnyDudes()
        end,
        description = 'Text to test stations description'
    },
    buildShipsStation = {
        inResources  = {iron = { consume = 50  , storage = Storage(5000, 1000, 'iron' , 100, 1)}},
        outResources = {ship = { produce = 0.05, storage = Storage(5,    1, 'ship' , 1,  -1)}},
        image        = AssetManager:getImage('ore_drill'),
        selectedImage   = AssetManager:getImage('focused_ore_drill'),
        conditionToBuild =
        function (world)
            return world:isThereLeftAnyDudes()
        end,
        description = 'Text to test stations description'
    }
}

return StationsData