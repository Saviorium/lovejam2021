local World = require("game.world")

local StartGame = {}

function StartGame:enter()
    self.font = love.graphics.newFont(fonts.bigPixelated.file, fonts.bigPixelated.size)
    self.font:setFilter("nearest", "nearest")
    self.gameWorld = World()
end

function StartGame:mousepressed(x, y, button)
    self.gameWorld:mousepressed(x, y, button)
end

function StartGame:mousereleased(x, y, button)
    self.gameWorld:mousereleased(x, y, button)
end

function StartGame:wheelmoved(x, y)
end

function StartGame:keypressed(key)
    if key == "return" then
        StateManager.switch(states.game, self.gameWorld)
    end
end

function StartGame:draw()
    self.gameWorld:draw()
    love.graphics.setFont(self.font)
    for ind, ui in pairs(self.gameWorld.uiManager.objects) do
        if ind == "Global resource bar" then
            local x, y = love.graphics.transformPoint(ui.x, ui.y + ui.height)
            love.graphics.printf("The most important global resources", x, y, ui.width, "left")
        end
    end
    love.graphics.printf("In this game you need to make and deliver chocolate to the HUB", 150, 0, 1000, "center")
    love.graphics.printf(
        "Buttons to build stations",
        0,
        220,
        1000,
        "left"
    )
    love.graphics.printf(
        "This is a complete ship production line. Iron ore is processed into iron bars from which ships are built",
        150,
        135,
        1000,
        "center"
    )
    love.graphics.printf(
        "This is a complete chocolate making line\n" ..
        "Cows and cocoa beans need ice, cows also need cocoa beans\n" ..
        "The chocolate itself is made from milk and cocoa beans\n" ..
        "After all this, chocolate must be sent to the hub",
        150,
        340,
        1000,
        "center"
    )
    love.graphics.printf(
        "You can build paths by clicking on the station and pulling in the direction of the desired other station"..'\n'..
        "Then you need to drag a ship on a route."..'\n'..
        "The game is paused now, press ENTER to start!",
        150,
        670,
        1000,
        "center"
    )

    love.graphics.printf(
        "Press Enter to start",
        love.graphics.getWidth()/2-200,
        love.graphics.getHeight()/2-150,
        300,
        "center"
    )

    love.graphics.printf(
        "Hub is right there",
        love.graphics.getWidth()-300,
        love.graphics.getHeight()-50,
        1000,
        "left"
    )
end

function StartGame:update(dt)
end

return StartGame
