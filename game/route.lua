local Arrow = require "game.ui.arrow"

local Route =
    Class {
    init = function(self, startStation, endStation)
        self.startStation = startStation
        self.endStation = endStation
        for _, resourceTo in pairs(self.endStation:getConsumingResources()) do
            for _, resourceFrom in pairs(self.startStation:getProductingResources()) do
                if resourceTo == resourceFrom then
                    self.resourceTaking = resourceTo
                end
            end
        end

        self.arrow = Arrow():setFrom(self.startStation:getCenter()):setTo(self.endStation:getCenter())
    end
}

function Route:draw()
    self.arrow:draw()
end

return Route
