local Resources = require "data.resources"

local ProgressBar =
    Class {
    init = function(self, x, y, height, parentStorage)
        self.x = x
        self.y = y

        self.width = 4
        self.height = height

        self.color = Resources[parentStorage.resource].color
        self.bgColor = Resources[parentStorage.resource].bgColor
        self.parent = parentStorage
    end
}

function ProgressBar:draw()
    local leftSpaceInPercents = 1 - (self.parent.value / self.parent.max)
    local resultheight = self.height * leftSpaceInPercents
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(self.bgColor)
    love.graphics.rectangle("fill", self.x + 1, self.y + 1, self.width - 2, resultheight > 0 and resultheight - 2 or 0)
    love.graphics.setColor(1, 1, 1)
end

return ProgressBar
