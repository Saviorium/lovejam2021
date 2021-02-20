local log = require 'engine.logger' ("stationsInnerDebug")
local serpent = require "lib.debug.serpent"

-- Абстрактная станция с ресурсом
local Station = Class {
    init = function(self, x, y, width, height, inResources, outResources, image, focusedImage)
        self.x = nvl(x, 0)
        self.y = nvl(y, 0)
        self.width = nvl(width, image:getWidth())
        self.height = nvl(height, image:getHeight())

        self.inResources = inResources
        self.outResources = outResources

        self.image = image
        self.focusedImage = focusedImage
        print('Done')
    end
}

-- function Station:loadParameters(x, y, params)
--     return self(x,
--                 y,
--                 params.width,
--                 params.height,
--                 params.inResources,
--                 params.outResources,
--                 params.image,
--                 params.focusedImage)
-- end

function Station:onTick()

    local canProduce = true
    for name, resource in pairs(self.inResources) do
        local canGet = resource.storage:canGet(resource.consume)
        log(3, "Station storege of" .. name .. " check of get is " .. canGet)
        canProduce = canGet and canProduce or false
    end
    if canProduce then
        for name, resource in pairs(self.inResources) do
           local result = resource.storage:addAndGetExcess(-resource.consume)
           log(3, "Station storage of" .. name .. " consumed " .. resource.consume .. ":" .. result .. " and become " .. resource.storage.value)
        end
        for name, resource in pairs(self.outResources) do
            local result = resource.storage:addAndGetExcess(resource.produce)
            log(3, "Station storage of" .. name .. " produced " .. resource.produce .. ":" .. result .. " and become " .. resource.storage.value)
        end
    end

end

function Station:draw()
    love.graphics.draw(self.image, self.x, self.y)
    if self.isFocused then
        love.graphics.draw(self.focusedImage, self.x, self.y)
    end
    if Debug.stationsDrawDebug then
        love.graphics.circle('fill', self.x, self.y, self.width)
    end
end

function Station:getProductingResources()
    local result = {}
    for _, resource in pairs(self.outResources) do
        table.insert(result, resource.storage.resource)
    end
    return result
end

function Station:getConsumingResources()
    local result = {}
    for _, resource in pairs(self.inResources) do
        table.insert(result, resource.storage.resource)
    end
    return result
end

return Station

