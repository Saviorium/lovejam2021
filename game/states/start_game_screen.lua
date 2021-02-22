local World = require("game.world")

local StartGame = {}

function StartGame:enter()
    self.font = love.graphics.newFont(16)
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
    if key ~= "space" then
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
        -- else
        --     local x, y = love.graphics.transformPoint(ui.x + ui.width, ui.y)
        --     love.graphics.printf(ui.description, x, y, 1000, "left")
        end
    end
    love.graphics.printf("In this game you need to make and deliver chocolate to the HUB", 150, 0, 1000, "center")
    love.graphics.printf(
        "This is a complete ship production line the ore is processed into iron from which ships are built",
        150,
        100,
        1000,
        "center"
    )

    love.graphics.printf(
        "This is a complete chocolate making line" ..
            "\n" ..
                "Cows and cocoa beans need ice, and cows also need cocoa beans" ..
                    "\n" ..
                        "The chocolate itself is made from milk and cocoa beans" ..
                            "\n" .. "After all this, the chocolate must be sent to the hub",
        150,
        400,
        1000,
        "center"
    )
end

function StartGame:update(dt)
end

return StartGame
