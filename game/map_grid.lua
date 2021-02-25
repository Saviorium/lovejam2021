local log = require "engine.logger"("resourceGrid")

local MapGrid = Class {
    init = function(self, width, height, parameters, seed)
        self.size = { width = width, height = height }
        self.gridSize = parameters.gridSize or 1
        self.resources = parameters.resources or {}
        self.seed = seed or love.timer.getTime()
        self.random = love.math.newRandomGenerator( self.seed )
        self.grid = {}
        self:initResources()
    end
}

function MapGrid:initResources()
    local stats = {}
    for i=1,1 do
        for resourceName, resource in pairs(self.resources) do
            self.grid[resourceName] = {
                noiseStart = {
                    x = self.random:random(999999),
                    y = self.random:random(999999)
                },
                cells = {},
                total = 0,
                filledCells = 0
            }
            local grid = self.grid[resourceName]
            for x = 1, self.size.width do
                for y = 1, self.size.height do
                    self.grid[resourceName].cells[x] = self.grid[resourceName].cells[x] or {}
                    self.grid[resourceName].cells[x][y] =
                        math.max(0, love.math.noise(
                            grid.noiseStart.x + x * resource.frequency,
                            grid.noiseStart.y + y * resource.frequency )
                        - resource.threshold ) / (1 - resource.threshold) * resource.multiplier
                        self.grid[resourceName].total = self.grid[resourceName].total + self.grid[resourceName].cells[x][y]
                        self.grid[resourceName].filledCells = self.grid[resourceName].filledCells + (self.grid[resourceName].cells[x][y] >1 and 1 or 0)
                end
            end
        if not stats[resourceName] then stats[resourceName] = {total = 0, filledCells = 0} end
        stats[resourceName].total = stats[resourceName].total + self.grid[resourceName].total
        stats[resourceName].filledCells = stats[resourceName].filledCells + self.grid[resourceName].filledCells
        log(1, "Generated " .. self.grid[resourceName].total .. " units of " .. resourceName)
        end
    end
    vardump (stats)
end

function MapGrid:getResourceTypes()
    return self.resources
end

function MapGrid:getResourcesAtCoords(point, resourceName)
    local cell = self:getGridCellAtCoords(point)
    if not self.grid[resourceName].cells[cell.x] or not self.grid[resourceName].cells[cell.x][cell.y] then
        return 0
    end
    return self.grid[resourceName].cells[cell.x][cell.y]
end

function MapGrid:clampToGrid(x, y)
    local point
    if type(x) == 'table' and type(x.x) == 'number' and type(x.y) == 'number' then
        point = x
    else
        point = Vector(x, y)
    end
    return self:getGridCellAtCoords(point)*self.gridSize
end

function MapGrid:getGridCellAtCoords(point)
    return Vector(math.floor(point.x/self.gridSize), math.floor(point.y/self.gridSize))
end

function MapGrid:draw()
    for resourceName, _ in pairs(self.resources) do
        for x = 1, self.size.width do
            for y = 1, self.size.height do
                self:drawResource(x, y, resourceName)
            end
        end
    end
    love.graphics.setColor( 1, 1, 1, 1 )
end

function MapGrid:drawResource(x, y, resourceName)
    local resource = self.resources[resourceName]
    local resourceCell = self.grid[resourceName].cells[x][y]
    if config.map.style == 'circle' then
        local fadedColor = resource.color
        fadedColor[4] = 0.8
        love.graphics.setColor(fadedColor)
        fadedColor[4] = 1 -- i'm sorry
        love.graphics.circle('fill',
            x * self.gridSize + self.gridSize / 2,
            y * self.gridSize + self.gridSize / 2,
            self.gridSize * (resourceCell / resource.multiplier) / 2
        )
    elseif config.map.style == 'grid' then
        local fadedColor = resource.color
        fadedColor[4] = resourceCell/1000
        love.graphics.setColor(fadedColor)
        fadedColor[4] = 1 -- i'm sorry

        love.graphics.rectangle('fill',
            x * self.gridSize,
            y * self.gridSize,
            self.gridSize,
            self.gridSize
        )
    elseif config.map.style == 'image' then
    
    end
end

function MapGrid:setResources(x, y, units, resource)
    self.grid[resource].cells[x][y] = units
end

return MapGrid