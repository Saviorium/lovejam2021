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
    end
}

function Station:loadParameters(x, y, params)
    print(params.image)
    return self(x,
                y,
                params.width,
                params.height,
                params.inResources,
                params.outResources,
                params.image,
                params.focusedImage)
end

function Station:onTick()

    local canProduce = true
    for _, resource in pairs(self.inResources) do
        canProduce = resource.storage:canGet(resource.consume) and canProduce or false
    end
    if canProduce then
        for _, resource in pairs(self.inResources) do
           resource.storage:addAndGetExcess(-resource.consume)
        end
        for _, resource in pairs(self.outResources) do
           resource.storage:addAndGetExcess(resource.produce)
        end
    end

end

function Station:draw()
    love.graphics.draw(self.image, self.x, self.y)
    if self.isFocused then
        love.graphics.draw(self.focusedImage, self.x, self.y)
    end
    if Debug.stationsInnerDebug then

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

return function(x, y, params) return Station:loadParameters(x, y, params) end

