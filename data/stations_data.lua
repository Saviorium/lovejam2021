local Storage = require "game.storage.storage"

local StationsData = {
    oreDrill = {
        image        = AssetManager:getImage('ore_drill'),
        selectedImage   = AssetManager:getImage('focused_ore_drill'),
        conditionToBuild =
        function (world)
            local mouseCoords = world:getFromScreenCoord(Vector(love.mouse.getPosition()))
            return world.resourcesGrid:getResourcesAtCoords(mouseCoords, "ironOre") ~= 0 and world:isThereLeftAnyDudes()
        end,
        description = 'Text to test stations description'
    },
    iceDrill = {
        image            = AssetManager:getImage('ore_drill'),
        selectedImage    = AssetManager:getImage('focused_ore_drill'),
        conditionToBuild =
        function (world)
            local mouseCoords = world:getFromScreenCoord(Vector(love.mouse.getPosition()))
            return world.resourcesGrid:getResourcesAtCoords(mouseCoords, "ice") ~= 0 and world:isThereLeftAnyDudes()
        end,
        description = 'Text to test stations description'
    },
    ironAnvil = {
        image        = AssetManager:getImage('ore_drill'),
        selectedImage   = AssetManager:getImage('focused_ore_drill'),
        conditionToBuild =
        function (world)
            return world:isThereLeftAnyDudes()
        end,
        description = 'Text to test stations description'
    },
    milkStation = {
        image        = AssetManager:getImage('ore_drill'),
        selectedImage   = AssetManager:getImage('focused_ore_drill'),
        conditionToBuild =
        function (world)
            return world:isThereLeftAnyDudes()
        end,
        description = 'Text to test stations description'
    },
    cocoaFarm = {
        image        = AssetManager:getImage('ore_drill'),
        selectedImage   = AssetManager:getImage('focused_ore_drill'),
        conditionToBuild =
        function (world)
            return world:isThereLeftAnyDudes()
        end,
        description = 'Text to test stations description'
    },
    chocolateFabric = {
        image        = AssetManager:getImage('ore_drill'),
        selectedImage   = AssetManager:getImage('focused_ore_drill'),
        conditionToBuild =
        function (world)
            return world:isThereLeftAnyDudes()
        end,
        description = 'Text to test stations description'
    },
    hubStation = {
        image        = AssetManager:getImage('ore_drill'),
        selectedImage   = AssetManager:getImage('focused_ore_drill'),
        conditionToBuild =
        function (world)
            return world:isThereLeftAnyDudes()
        end,
        description = 'Text to test stations description'
    },
    buildShipsStation = {
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