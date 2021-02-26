local log = require "engine.logger"("stationsInnerDebug")
local ProgressBar = require "game.ui.progress_bar"
local StationInformationBoard = require "game.ui.information_boards.station_information_board"

-- Абстрактная станция с ресурсом
local Station =
    Class {
    init = function(self, position, parameters)
        self.x = position.x
        self.y = position.y
        self.width = nvl(parameters.width, parameters.image:getWidth())
        self.height = nvl(parameters.height, parameters.image:getHeight())
        self.inResources = parameters.inResources

        self.shipPorts = {}
        self.inProgressBars = {}
        local index = 1
        for _, res in pairs(parameters.inResources) do
            table.insert(self.inProgressBars, ProgressBar(self.x - 6 * index, self.y, self.height, res.storage))
            table.insert(self.shipPorts, res.storage.port)
            index = index + 1
        end

        self.outResources = parameters.outResources
        self.outProgressBars = {}
        index = 1
        for _, res in pairs(parameters.outResources) do
            table.insert(
                self.outProgressBars,
                ProgressBar(self.x + self.width + 6 * index, self.y, self.height, res.storage)
            )
            table.insert(self.shipPorts, res.storage.port)
            index = index + 1
        end

        self.name = "station #" .. love.math.random(100)
        for name, _ in pairs(self.outResources) do
            self.name = name .. " " .. self.name
        end

        self.image = parameters.image

        self.selectedImage = parameters.selectedImage
        self.isSelected = false
        self.isHovered = false

        self.population = 1

        self.informationBoard = StationInformationBoard(self, parameters.description)
        log( 1, self.name .." initialized on position ["..self.x..":"..self.y.."]")
    end
}
function Station:update(dt)
    self.informationBoard:update(dt)
end

function Station:onTick(world)
    local productivity = self:calculateProductivity()
    local canProduce = true
    for name, resource in pairs(self.inResources) do
        local canGive = resource.storage:canGive(resource.consume * productivity) == resource.consume * productivity
        log(3, "Station storage of " .. name .. " check of can get is " .. (canGive and 1 or 0))
        canProduce = canGive and canProduce or false
    end
    for name, resource in pairs(self.outResources) do
        if resource.takingFromGrid then
            canProduce =
                world:canGetResourceInRange(
                Vector(self.x, self.y),
                name,
                1,
                resource.takingFromGrid
            )
            if not canProduce and resource.storage.value == 0 then
                world:deleteStationAt(Vector(self.x, self.y))
            end
        end
        local canPut = resource.storage:canPut(resource.produce * productivity) == resource.produce * productivity
        log(3, "Station storage of " .. name .. " check of can put is " .. (canPut and 1 or 0))
        canProduce = canPut and canProduce or false
    end
    if canProduce then
        for name, resource in pairs(self.inResources) do
            local result = resource.storage:addAndGetExcess(-resource.consume * productivity)
            log(
                3,
                "Station storage of " ..
                    name ..
                        " consumed " ..
                            resource.consume * productivity .. ":" .. result .. " and become " .. resource.storage.value
            )
            resource.storage:onTick()
        end
        for name, resource in pairs(self.outResources) do
            if resource.takingFromGrid then
                world:getResourceInRange(
                    Vector(self.x, self.y),
                    name,
                    1,
                    resource.takingFromGrid
                )
            end
            local result = resource.storage:addAndGetExcess(resource.produce * productivity)
            log(
                3,
                "Station storage of " ..
                    name ..
                        " produced " ..
                            resource.produce * productivity .. ":" .. result .. " and become " .. resource.storage.value
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
    if self.isSelected then
        self:drawSelected()
        self.informationBoard.showTimer:clear()
        self.informationBoard.isVisible = false
    else
        if self.isHovered then
            self.informationBoard.showTimer:after(config.game.infobarsTimeToAppear, function() self.informationBoard.isVisible = true end)
            self:drawHovered()
        else
            self.informationBoard.showTimer:clear()
            self.informationBoard.isVisible = false
        end
    end
    love.graphics.draw(self.image, self.x, self.y)
    for _, progressBar in pairs(self.inProgressBars) do
        progressBar:draw()
    end
    for _, progressBar in pairs(self.outProgressBars) do
        progressBar:draw()
    end
    local index = 1
    for _, port in pairs(self.shipPorts) do
        for _, ship in pairs(port:getAllDockedShips()) do
            if ship.progressBar then
                love.graphics.draw(ship.image, self.x + self.width + ship.width, self.y - 4 + self.height + index*(ship.progressBar.width + 2), math.pi/2)

                local transform = love.math.newTransform( self.x + self.width, self.y + self.height + index*(ship.progressBar.width + 2), math.pi/2)
                love.graphics.applyTransform( transform )
                ship.progressBar:draw()
                local inverse = transform:inverse( )
                love.graphics.applyTransform( inverse )
                index = index + 1
            end
        end
    end
    if Debug.stationsDrawDebug then
        local ind = 0
        for i, res in pairs(self:getProductingResources()) do
            love.graphics.print(
                math.clamp(0, math.floor(self.outResources[i].storage.value), 9999),
                self.x - self.width - 48,
                self.y + ind * 8
            )
            love.graphics.print(Resources[res].name, self.x - self.width, self.y + ind * 8)
            for shipIndex, ship in pairs(self.outResources[i].storage.port:getAllDockedShips()) do
                love.graphics.print("ship", self.x + self.width*shipIndex + 48*(shipIndex-1), self.y + ind * 8)
                love.graphics.print(
                    ship.storage.value,
                    self.x + (self.width + 48)*shipIndex,
                    self.y + ind * 8
                )
            end
            ind = ind + 1
        end
        for i, res in pairs(self:getConsumingResources()) do
            love.graphics.print(
                math.clamp(0, math.floor(self.inResources[i].storage.value), 9999),
                self.x - self.width - 48,
                self.y + ind * 8 + 16
            )
            love.graphics.print(Resources[res].name, self.x - self.width, self.y + ind * 8 + 16)
            for shipIndex, ship in pairs(self.inResources[i].storage.port:getAllDockedShips()) do
                love.graphics.print("ship", self.x + self.width*shipIndex + 48*(shipIndex-1), self.y + ind * 8 + 16)
                love.graphics.print(
                    ship.storage.value,
                    self.x + (self.width + 48)*shipIndex,
                    self.y + ind * 8 + 16
                )
            end
            ind = ind + 1
        end
    end
end

function Station:drawSelected()
    love.graphics.setColor(config.colors.selected)
    love.graphics.draw(
        self.selectedImage,
        self.x,
        self.y
    )
    love.graphics.setColor(1, 1, 1)
end

function Station:drawHovered()
    love.graphics.setColor(config.colors.hover)
    love.graphics.draw(
        self.selectedImage,
        self.x,
        self.y
    )
    love.graphics.setColor(1, 1, 1)
end

function Station:canBuildRouteFrom()
    if self:isProducing("ship") then
        return false
    end
    return true
end

function Station:getProduct(resourceName)
    local resource = Resources[resourceName]
    local storage = self:getStorage(resourceName)
    if not self:isProducing(resourceName) or not resource or not resource.productConstructor or storage.value < 1 then
        return false
    end
    storage.value = storage.value - 1
    return resource.productConstructor(self)
end

function Station:isProducing(resourceName)
    for ind, _ in pairs(self.outResources) do
        if ind == resourceName then
            return true
        end
    end
    return false
end

function Station:getResourceValue(resourceName)
    local storage = self:getStorage(resourceName)
    return storage and storage.value or 0
end

function Station:getStorage(resourceName)
    for ind, storage in pairs(self.outResources) do
        if ind == resourceName then
            return storage.storage
        end
    end
    for ind, storage in pairs(self.inResources) do
        if ind == resourceName then
            return storage.storage
        end
    end
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

function Station:calculateProductivity()
    return math.sqrt(self.population)
end

return Station
