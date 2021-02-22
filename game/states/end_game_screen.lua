local EndGame = {}

function EndGame:enter(prev_state, world)
    print(prev_state, world)
    self.font = fonts.smolPixelated
    --self.font:setFilter("nearest", "nearest")
    self.gameWorld = world
    local colonists = 0
    for _, station in pairs(self.gameWorld.stations) do
        colonists = colonists + station.population
    end
    self.lastWords = 'Your colonists has dies without enough chocolate in their pockets'..'\n'..
                     'Colonists was born: '..self.gameWorld.stations["HubStation"].outResources.dude.storage.value

end

function EndGame:keypressed(key)
end

function EndGame:draw()
    self.gameWorld:draw()
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(self.font)
    love.graphics.printf(self.lastWords, love.graphics.getWidth()/2 - 500, love.graphics.getHeight()/2 - 120, 1000, 'center')
    love.graphics.setFont(love.graphics.newFont(12))
end

function EndGame:update(dt)
end

return EndGame