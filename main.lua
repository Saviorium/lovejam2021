require "utils"
require "engine.debug"

Class        = require "lib.hump.class"
Entity       = require "game.components.entity"
StateManager = require "lib.hump.gamestate"
AssetManager = require "engine.asset_manager"
Vector       = require "lib.hump.vector"
Timer        = require "lib.hump.timer"

SoundData    = require "data.sound_data"
SoundManager = require "engine.sound_manager" (SoundData)

fonts = {
    smolPixelated = { file = "assets/fonts/m3x6.ttf", size = 16},
    bigPixelated = { file = "assets/fonts/m3x6.ttf", size = 32},
}

function love.load()
    -- fonts.smolPixelated:setFilter("nearest", "nearest")
    -- fonts.bigPixelated:setFilter("nearest", "nearest")
    AssetManager:load("assets")
    Resources    = require "data.resources"
    states = {
        game = require "game.states.game",
        end_game = require "game.states.end_game_screen",
        start_game = require "game.states.start_game_screen"
    }
    love.keyboard.setKeyRepeat( true )
    StateManager.switch(states.start_game)
end

function love.draw()
    if Debug and Debug.showFps == 1 then
        love.graphics.print(""..tostring(love.timer.getFPS( )), 2, 2)
    end
    if Debug and Debug.mousePos == 1 then
        local x, y = love.mouse.getPosition()
        love.graphics.print(""..tostring(x)..","..tostring(y), 2, 16)
    end
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
    StateManager.update(dt * config.game.speed)
end
