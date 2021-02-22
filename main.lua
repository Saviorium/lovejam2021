require "utils"
require "engine.debug"

Class = require "lib.hump.class"
Entity = require "game.components.entity"
StateManager = require "lib.hump.gamestate"
AssetManager = require "engine.asset_manager"
Vector = require "lib.hump.vector"
Timer = require "lib.hump.timer"

function love.load()
    AssetManager:load("assets")
    states = {
        game = require "game.states.game",
        end_game = require "game.states.end_game_screen",
        start_game = require "game.states.start_game_screen"
    }
    StateManager.switch(states.game)
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    StateManager.draw()
end

function love.keypressed(t)
    StateManager.keypressed(t)
    if t == "escape" then
        StateManager.switch(states.game)
    end
end

function love.mousepressed(x, y, button)
    StateManager.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    StateManager.mousereleased(x, y, button)
end

function love.wheelmoved(x, y)
    StateManager.wheelmoved(x, y)
end

function love.update(dt)
    StateManager.update(dt)
end
