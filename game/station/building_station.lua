local Station = require "game.station.station"
local StationsData = require "data.stations_data"
local Storage = require "game.storage.storage"

local BuildingStation =
    Class {
    __includes = Station,
    init = function(self, position, targetStation, world, index)
        self.targetStation = StationsData[targetStation]
        Station.init(
            self,
            world.resourcesGrid:clampToGrid(position.x, position.y),
            {
                inResources  = {iron = {required = 1000, consume = 100, storage = Storage(1000, 0, "iron", 100, 1)}},
                outResources = {},
                image        = self.targetStation.image,
                selectedImage = self.targetStation.selectedImage,
                description  = self.targetStation.description
            }
        )
        self.world = world
        self.index = index

        self.fadeLevel = 0.8
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
        self.world.stations[self.index] = Station( Vector(self.x, self.y), self.targetStation)
    end
end

function BuildingStation:draw()
    love.graphics.setColor(1, 1, 1, self.fadeLevel)
    love.graphics.draw(self.image, self.x, self.y)
    love.graphics.setColor(1, 1, 1, 1)

    if Debug.stationsDrawDebug then
        local ind = 0
        for _, res in pairs(self:getConsumingResources()) do
            love.graphics.print(res, self.x - self.width, self.y + ind * 16 - 16)
            love.graphics.print(self.inResources[res].storage.value, self.x - self.width - 48, self.y + ind * 16 - 16)
            love.graphics.print("Required", self.x - self.width, self.y + ind * 16)
            love.graphics.print(self.inResources[res].required, self.x - self.width - 48, self.y + ind * 16)
            if self.inResources[res].storage.port.dockedShip then
                love.graphics.print("ship", self.x + self.width, self.y + ind * 16 + 16)
                love.graphics.print(
                    self.inResources[res].storage.port.dockedShip.storage.value,
                    self.x + self.width + 48,
                    self.y + ind * 16
                )
            end
            ind = ind + 1
        end
    end
end

return BuildingStation
