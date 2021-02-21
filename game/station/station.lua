local log = require "engine.logger"("stationsInnerDebug")
local ProgressBar = require "game.ui.progress_bar"
local Resources = require "data.resources"

-- Абстрактная станция с ресурсом
local Station = Class {
    init = function(self, position, parameters)
        self.x = position.x
        self.y = position.y
        self.width = nvl(parameters.width, parameters.image:getWidth())
        self.height = nvl(parameters.height, parameters.image:getHeight())

        self.inResources = parameters.inResources
        self.inProgressBars = {}
        local index = 1
        for _, res in pairs(parameters.inResources) do
            table.insert(self.inProgressBars, ProgressBar(self.x - 5 * index, self.y, self.height, res.storage))
            index = index + 1
        end

        self.outResources = parameters.outResources
        self.outProgressBars = {}
        index = 1
        for _, res in pairs(parameters.outResources) do
            table.insert(
                self.outProgressBars,
                ProgressBar(self.x + self.width + 4 * index, self.y, self.height, res.storage)
            )
            index = index + 1
        end

        self.name = "station #" .. love.math.random( 100 )
        for name, _ in pairs(self.outResources) do
            self.name = name .. " " .. self.name
        end

        self.image = parameters.image

        self.selectedImage = parameters.selectedImage
        self.isSelected = false
        self.isHovered = false
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
        log(3, "Station storage of " .. name .. " check of can put is " .. (canPut and 1 or 0))
        canProduce = canPut and canProduce or false
    end
    if canProduce then
        for name, resource in pairs(self.inResources) do
            local result = resource.storage:addAndGetExcess(-resource.consume)
            log(
                3,
                "Station storage of " ..
                    name ..
                        " consumed " .. resource.consume .. ":" .. result .. " and become " .. resource.storage.value
            )
            resource.storage:onTick()
        end
        for name, resource in pairs(self.outResources) do
            local result = resource.storage:addAndGetExcess(resource.produce)
            log(
                3,
                "Station storage of " ..
                    name ..
                        " produced " .. resource.produce .. ":" .. result .. " and become " .. resource.storage.value
            )
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
    for _, progressBar in pairs(self.inProgressBars) do
        progressBar:draw()
    end
    for _, progressBar in pairs(self.outProgressBars) do
        progressBar:draw()
    end
    if self.isSelected then
        self:drawSelected()
    else
        if self.isHovered then
            self:drawHovered()
        end
    end
    love.graphics.draw(self.image, self.x, self.y)
    if Debug.stationsDrawDebug then
        local ind = 0
        for i, res in pairs(self:getProductingResources()) do
            love.graphics.print(self.outResources[i].storage.value, self.x - self.width - 48, self.y + ind * 8)
            love.graphics.print(Resources[res].name, self.x - self.width, self.y + ind * 8)
            if self.outResources[i].storage.port.dockedShip then
                love.graphics.print("ship", self.x + self.width, self.y + ind * 8)
                love.graphics.print(
                    self.outResources[i].storage.port.dockedShip.storage.value,
                    self.x + self.width + 48,
                    self.y + ind * 8
                )
            end
            ind = ind + 1
        end
        for i, res in pairs(self:getConsumingResources()) do
            love.graphics.print(self.inResources[i].storage.value, self.x - self.width - 48, self.y + ind * 8 + 16)
            love.graphics.print(Resources[res].name, self.x - self.width, self.y + ind * 8 + 16)
            if self.inResources[i].storage.port.dockedShip then
                love.graphics.print("ship", self.x + self.width, self.y + ind * 8 + 16)
                love.graphics.print(
                    self.inResources[i].storage.port.dockedShip.storage.value,
                    self.x + self.width + 48,
                    self.y + ind * 8 + 16
                )
            end
            ind = ind + 1
        end
    end
end

function Station:drawSelected()
    local scale = Vector(
        (self.width + config.selection.border*2) / self.width,
        (self.height + config.selection.border*2) / self.height
    )
    love.graphics.setBlendMode("add", "alphamultiply")
    love.graphics.setColor(config.selection.colorSelected)
    love.graphics.draw(self.image, self.x-config.selection.border, self.y-config.selection.border, 0, scale.x, scale.y)
    love.graphics.draw(self.image, self.x-config.selection.border, self.y-config.selection.border, 0, scale.x, scale.y)
    love.graphics.draw(self.image, self.x-config.selection.border, self.y-config.selection.border, 0, scale.x, scale.y)
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(1, 1, 1)
end

function Station:drawHovered()
    local scale = Vector(
        (self.width + config.selection.border*2) / self.width,
        (self.height + config.selection.border*2) / self.height
    )
    love.graphics.setBlendMode("add", "alphamultiply")
    love.graphics.setColor(config.selection.colorHover)
    love.graphics.draw(self.image, self.x-config.selection.border, self.y-config.selection.border, 0, scale.x, scale.y)
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(1, 1, 1)
end

function Station:canBuildRouteFrom()
    if self.outResources == 'ship' then
        return false
    end
    return true
end

function Station:getProductingResources()
    local result = {}
    for ind, storage in pairs(self.outResources) do
        result[ind] = storage.storage.resource
    end
    return result
end

function Station:getConsumingResources()
    local result = {}
    for ind, storage in pairs(self.inResources) do
        result[ind] = storage.storage.resource
    end
    return result
end

function Station:setSelected(bool)
    self.isSelected = bool
end

function Station:setHover(bool)
    self.isHovered = bool
end

function Station:getCenter()
    return Vector(self.x + self.width / 2, self.y + self.height / 2)
end

function Station:tostring()
    return self.name
end

return Station
