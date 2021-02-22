local Star = Class {
    init = function(self, mapGrid)
        self.x = love.math.random(mapGrid.size.width * mapGrid.gridSize)
        self.y = love.math.random(mapGrid.size.height * mapGrid.gridSize)
        self.distance = love.math.random(1)
        self.image = AssetManager:getImage('star_'..math.random(1,6))
    end
}

function Star:draw()
    love.graphics.draw(self.image,
                       self.x,
                       self.y)
end

function Star:move(changePos)
    self.x = self.x + changePos.x * self.distance
    self.y = self.y + changePos.y * self.distance
end

return Star