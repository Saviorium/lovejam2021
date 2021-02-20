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
    for resourceName, resource in pairs(self.resources) do
        self.grid[resourceName] = {
            noiseStart = {
                x = self.random:random(999999),
                y = self.random:random(999999)
            },
            cells = {}
        }
        local grid = self.grid[resourceName]
        for x = 1, self.size.width do
            for y = 1, self.size.height do
                self.grid[resourceName].cells[x] = self.grid[resourceName].cells[x] or {}
                self.grid[resourceName].cells[x][y] =
                    math.max(0, love.math.noise(
                        grid.noiseStart.x + x * resource.frequency,
                        grid.noiseStart.y + y * resource.frequency )
                    - resource.threshold ) * resource.multiplier
            end
        end
    end
end

function MapGrid:draw()
    for resourceName, resource in pairs(self.resources) do
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
    love.graphics.setColor(resource.color)
    love.graphics.circle('fill',
        x * self.gridSize + self.gridSize / 2,
        y * self.gridSize + self.gridSize / 2,
        self.gridSize * (resourceCell / resource.multiplier)
    )
end

return MapGrid