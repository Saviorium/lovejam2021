local Storage = require "game.storage.storage"

local StationsData = {
    oreDrill = {
        image        = AssetManager:getImage('oredrill_station'),
        selectedImage   = AssetManager:getImage('drill_station_focused'),
        conditionToBuild =
        function (world)
            local mouseCoords = world:getFromScreenCoord(Vector(love.mouse.getPosition()))
            return world.resourcesGrid:getResourcesAtCoords(mouseCoords, "ironOre") ~= 0 and world:isThereLeftAnyDudes()
        end,
        description = 'A huge drill that mines ore for iron, piercing and ravaging the cosmos'
    },
    iceDrill = {
        image            = AssetManager:getImage('icedrill_station'),
        selectedImage    = AssetManager:getImage('drill_station_focused'),
        conditionToBuild =
        function (world)
            local mouseCoords = world:getFromScreenCoord(Vector(love.mouse.getPosition()))
            return world.resourcesGrid:getResourcesAtCoords(mouseCoords, "ice") ~= 0 and world:isThereLeftAnyDudes()
        end,
        description = 'Hot stuff, it is not afraid of the cold of space and even more so not afraid of these rocks full of ice'
    },
    ironAnvil = {
        image        = AssetManager:getImage('ironanvil_station'),
        selectedImage   = AssetManager:getImage('focused_ore_drill'),
        conditionToBuild =
        function (world)
            return world:isThereLeftAnyDudes()
        end,
        description = 'A place where iron is forged for your ships and your victory'
    },
    milkStation = {
        image        = AssetManager:getImage('milk_station'),
        selectedImage   = AssetManager:getImage('milk_station_focused'),
        conditionToBuild =
        function (world)
            return world:isThereLeftAnyDudes()
        end,
        description = 'For excellent milk, you only need this farm, a little water and cocoa beans, as well as space cows of course'
    },
    cocoaFarm = {
        image        = AssetManager:getImage('cocoa_station'),
        selectedImage   = AssetManager:getImage('cocoa_station_focused'),
        conditionToBuild =
        function (world)
            return world:isThereLeftAnyDudes()
        end,
        description = 'There are endless plantations of precious cocoa that need only water obtained from ice'
    },
    chocolateFabric = {
        image        = AssetManager:getImage('chocolate_station'),
        selectedImage   = AssetManager:getImage('chocolate_station_focused'),
        conditionToBuild =
        function (world)
            return world:isThereLeftAnyDudes()
        end,
        description = 'The most important resource of the galaxy and the survival of the people in the HUB is made here from milk and cocoa'
    },
    hubStation = {
        image        = AssetManager:getImage('hub_station'),
        selectedImage   = AssetManager:getImage('hub_station_focused'),
        conditionToBuild =
        function (world)
            return world:isThereLeftAnyDudes()
        end,
        description = 'A haven for all people in space who want chocolate, for the population to grow, it is necessary to meet its needs for this product'
    },
    buildShipsStation = {
        image        = AssetManager:getImage('ship_station'),
        selectedImage   = AssetManager:getImage('ship_station_focused'),
        conditionToBuild =
        function (world)
            return world:isThereLeftAnyDudes()
        end,
        description = 'An incredible shipyard where new iron ships are made'
    }
}

return StationsData