local Star = Class {
    init = function(self, mapGrid, camera)
        self.x = love.math.random(mapGrid.size.width * mapGrid.gridSize)
        self.y = love.math.random(mapGrid.size.height * mapGrid.gridSize)
        self.distance = love.math.random()
        self.image = AssetManager:getImage('star_'..math.random(1,6))
        self.camera = camera
        self.mapGrid = mapGrid
    end
}

function Star:draw()
    love.graphics.draw(self.image,
                       self.x + self.camera.position.x *  self.distance / self.camera.zoom,
                       self.y + self.camera.position.y * self.distance / self.camera.zoom)
end

-- function Star:move(changePos)
--     -- star:draw(self.x+self.camera.x)
--     self.x = self.x - changePos.x * self.distance / self.camera.zoom
--     self.y = self.y - changePos.y * self.distance / self.camera.zoom
-- end

return Star