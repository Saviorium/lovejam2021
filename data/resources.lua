local Ship = require("game.ship.ship")

Resources = {
    iron = {
        name = 'Iron bars',
        icon = AssetManager:getImage('iron_icon'),
        color = {0.3, 0.3, 0.3},
        bgColor = {1, 1, 1}
    },
    ironOre = {
        name = 'Iron ore',
        icon = AssetManager:getImage('ironore_icon'),
        color = { 1, 0.6, 0.45 },
        bgColor = {1, 1, 1}
    },
    ice = {
        name = 'Ice',
        icon = AssetManager:getImage('ice_icon'),
        color = { 0.3, 0.6, 1 },
        bgColor = {1, 1, 1}
    },
    chocolate = {
        name = 'Chocolate bars',
        icon = AssetManager:getImage('chocolate_icon'),
        color = {0.7, 0.5, 0.1}, -- owerwtitten in World:update FYI
        bgColor = {1, 1, 1}
    },
    cocoa = {
        name = 'Cocoa beans',
        icon = AssetManager:getImage('cocoa_icon'),
        color = {0.9, 0.8, 0.2},
        bgColor = {1, 1, 1}
    },
    milk = {
        name = 'Milk',
        icon = AssetManager:getImage('milk_icon'),
        color = {1, 1, 1},
        bgColor = {0, 0, 0}
    },
    ship = {
        name = 'Ship',
        icon = AssetManager:getImage('ship_icon'),
        color = {0.2, 0.2, 0.2},
        bgColor = {1, 1, 1},
        productConstructor = function(station)
            local initPoint = station:getCenter()+Vector(station.width, 0):rotateInplace(love.math.random(2*math.pi))
            return Ship(initPoint.x, initPoint.y):flyAroundStation(station)
        end
    },
    dude = {
        name = 'Peoples',
        icon = AssetManager:getImage('dudes_icon'),
        color = {0.1, 0.7, 0.1},
        bgColor = {1, 1, 1}
    },
    life = {
        name = 'Life',
        icon = AssetManager:getImage('lifes_icon'),
        color = {1, 0, 0}, -- owerwtitten in World:update FYI
        bgColor = {1, 1, 1}
    },
}

return Resources