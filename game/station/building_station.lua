local log = require 'engine.logger' ("stationsInnerDebug")
local Station      = require "game.station.station"
local Storage      = require "game.storage.storage"

-- Абстрактная станция с ресурсом
local BuildingStation = Class {
    __includes = Station,
    init = function(self, position, targetStation, world, index)

        self.targetStation = targetStation(world.resourcesGrid:clampToGrid(position.x, position.y))
        Station.init(self,
                     world.resourcesGrid:clampToGrid(position.x, position.y),
                     0,
                     0,
                     {iron = { required = 100, consume = 100, storage = Storage(1000, 0, 'iron', 100, 1)} },
                     {},
                     self.targetStation.image,
                     self.targetStation.imageFocused)
        self.world = world
        self.index = index
    end
}

function BuildingStation:onTick()
    local ready = true
    for _, resource in pairs(self.inResources) do
        if resource.required > 0 then
            local notEnought = resource.storage:addAndGetExcess(-resource.consume)
            resource.required = resource.required - (resource.consume + notEnought)
            ready = false
        end
    end
    for _, resource in pairs(self.inResources) do
        resource.storage:addAndGetExcess(resource.consume)
    end
    for _, resource in pairs(self.inResources) do
       resource.storage:onTick()
    end
    if ready then
        self.world.stations[self.index] = self.targetStation
    end
end

function BuildingStation:draw()
    love.graphics.draw(self.image, self.x, self.y)
    if Debug.stationsDrawDebug then
        local ind = 0
        for _, res in pairs(self:getConsumingResources()) do
            love.graphics.print(res, self.x - self.width, self.y + ind * 16 - 16)
            love.graphics.print(self.inResources[res].storage.value, self.x - self.width - 48, self.y + ind * 16 - 16)
            love.graphics.print('Required', self.x - self.width, self.y + ind * 16)
            love.graphics.print(self.inResources[res].required, self.x - self.width - 48, self.y + ind * 16)
            if self.inResources[res].storage.port.dockedShip then
                love.graphics.print('ship', self.x + self.width, self.y + ind * 16 + 16)
                love.graphics.print(self.inResources[res].storage.port.dockedShip.storage.value, self.x + self.width + 48, self.y + ind * 16)
            end
            ind = ind + 1
        end
    end
end

return BuildingStation

