require "utils"
require "engine.debug"

StateManager = require "lib.hump.gamestate"
AssetManager = require "engine.asset_manager"

states = {
    game = require "game.states.game",
}

function love.load()
    AssetManager:load("assets")
    StateManager.switch(states.game)
end

function love.draw()
    love.graphics.setColor(1,1,1)
    StateManager.draw()
end

function love.keypressed(t)
    StateManager.keypressed(t)
    if t == "escape" then
        StateManager.switch(states.game)
    end
end

function love.mousepressed(x, y)
    StateManager.mousepressed(x, y)
end

function love.mousereleased(x, y)
    StateManager.mousereleased(x, y)
end

function love.wheelmoved(x, y)
    StateManager.wheelmoved(x, y)
end

function love.update(dt)
    StateManager.update(dt)
end
