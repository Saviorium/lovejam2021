local TimeBar = Class {
    init = function(self, clock)
        self.width = love.graphics.getWidth() * 0.8
        self.height = 25
        self.x = love.graphics.getWidth() * 0.1
        self.y = love.graphics.getHeight() - self.height
        self.innerLineWidth = 4
        self.delimeterLineWidth = 1
        self.clock = clock
    end
}
function TimeBar:onTick()

end

function TimeBar:draw()    
    local daysInMonth = self.clock.daysInMonth-1
    local maxWidth, height, y = self.width - self.innerLineWidth*2, self.height-self.innerLineWidth, self.y + self.innerLineWidth
    local cellWidth = ((maxWidth-self.delimeterLineWidth*daysInMonth)/daysInMonth)
    love.graphics.setColor(config.colors.uiBackground)
    love.graphics.rectangle('fill', 
        self.x, 
        self.y, 
        self.width, 
        self.height*2, 
        8, 
        8)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', 
        self.x + self.innerLineWidth, 
        self.y + self.innerLineWidth, 
        self.width  - self.innerLineWidth*2, 
        self.height - self.innerLineWidth, 
        8, 
        8)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle('fill', 
        self.x + self.innerLineWidth, 
        self.y + self.innerLineWidth, 
        (self.clock.day % self.clock.daysInMonth)*cellWidth, 
        height)
    love.graphics.setColor(config.colors.uiBackground)
    for i = 1, daysInMonth, 1 do
        local x = self.x + cellWidth*i
        love.graphics.rectangle('fill', 
            x, 
            y, 
            self.innerLineWidth, 
            height)
    end
    love.graphics.setColor(1, 1, 1)

end

return TimeBar