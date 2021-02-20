local log = require 'engine.logger' ("stationsInnerDebug")

-- Абстрактная станция с ресурсом
local Station = Class {
    init = function(self, position, width, height, inResources, outResources, image, focusedImage)
        self.x = position.x
        self.y = position.y
        self.width = nvl(width, image:getWidth())
        self.height = nvl(height, image:getHeight())

        self.inResources = inResources
        self.outResources = outResources

        self.image = image
        self.focusedImage = focusedImage

        self.isBuilding = false
    end
}

function Station:onTick()

    local canProduce = true
    for name, resource in pairs(self.inResources) do
        local canGet = resource.storage:canGet(resource.consume)
        log(3, "Station storage of " .. name .. " check of can get is " .. (canGet and 1 or 0))
        canProduce = canGet and canProduce or false
    end
    for name, resource in pairs(self.outResources) do
        local canPut = resource.storage:canPut(resource.produce)
        log(3, "Station storage of " .. name .. " check of can put is " .. (canGet and 1 or 0))
        canProduce = canPut and canProduce or false
    end
    if canProduce then
        for name, resource in pairs(self.inResources) do
           local result = resource.storage:addAndGetExcess(-resource.consume)
           log(3, "Station storage of " .. name .. " consumed " .. resource.consume .. ":" .. result .. " and become " .. resource.storage.value)
           resource.storage:onTick()
        end
        for name, resource in pairs(self.outResources) do
            local result = resource.storage:addAndGetExcess(resource.produce)
            log(3, "Station storage of " .. name .. " produced " .. resource.produce .. ":" .. result .. " and become " .. resource.storage.value)
        end
    end

    for _, resource in pairs(self.inResources) do
       resource.storage:onTick()
    end
    for _, resource in pairs(self.outResources) do
        resource.storage:onTick()
    end

end

function Station:draw()
    love.graphics.draw(self.image, self.x, self.y)
    if self.isFocused then
        love.graphics.draw(self.focusedImage, self.x, self.y)
    end
    if Debug.stationsDrawDebug then
        local ind = 0
        for _, res in pairs(self:getProductingResources()) do
            love.graphics.print(self.outResources[res].storage.value, self.x - self.width - 48, self.y + ind * 8)
            love.graphics.print(res, self.x - self.width, self.y + ind * 8)
            if self.outResources[res].storage.port.dockedShip then
                love.graphics.print('ship', self.x + self.width, self.y + ind * 8)
                love.graphics.print(self.outResources[res].storage.port.dockedShip.storage.value, self.x + self.width + 48, self.y + ind * 8)
            end
            ind = ind + 1
        end
        for _, res in pairs(self:getConsumingResources()) do
            love.graphics.print(self.inResources[res].storage.value, self.x - self.width - 48, self.y + ind * 8 + 16)
            love.graphics.print(res, self.x - self.width, self.y + ind * 8 + 16)
            if self.inResources[res].storage.port.dockedShip then
                love.graphics.print('ship', self.x + self.width, self.y + ind * 8 + 16)
                love.graphics.print(self.inResources[res].storage.port.dockedShip.storage.value, self.x + self.width + 48, self.y + ind * 8 + 16)
            end
            ind = ind + 1
        end
    end
end

function Station:getProductingResources()
    local result = {}
    for name, _ in pairs(self.outResources) do
        table.insert(result, name)
    end
    return result
end

function Station:getConsumingResources()
    local result = {}
    for name, _ in pairs(self.inResources) do
        table.insert(result, name)
    end
    return result
end

function Station:getCenter()
    return Vector(self.x + self.width/2, self.y + self.height/2)
end

return Station

