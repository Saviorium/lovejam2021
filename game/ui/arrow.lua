local defaultParams = {
    lineWidth = 8,
    color = config.colors.selected,
    endAngle = 15,
    endLength = 50
}

local Arrow = Class {
    init = function(self, params)
        self.params = merge(defaultParams, params or {})
    end
}

function Arrow:setFrom( point )
    self.from = point
    return self
end

function Arrow:setTo( point )
    self.to = point
    return self
end

function Arrow:setColor( color )
    self.params.color = color
end

function Arrow:draw()
    if not self.from or not self.to then
        return
    end
    local vector = self.to - self.from
    local leftEnd = self.to - vector:rotated(self.params.endAngle*math.pi/180):normalized()*self.params.endLength
    local rightEnd = self.to - vector:rotated(self.params.endAngle*(-math.pi)/180):normalized()*self.params.endLength
    love.graphics.setLineWidth( self.params.lineWidth )
    love.graphics.setColor(self.params.color)
    love.graphics.line(self.from.x, self.from.y, self.to.x, self.to.y)
    love.graphics.line(self.to.x, self.to.y, leftEnd.x, leftEnd.y)
    love.graphics.line(self.to.x, self.to.y, rightEnd.x, rightEnd.y)
    love.graphics.circle("fill", leftEnd.x, leftEnd.y, self.params.lineWidth/2)
    love.graphics.circle("fill", rightEnd.x, rightEnd.y, self.params.lineWidth/2)
    love.graphics.circle("fill", self.to.x, self.to.y, self.params.lineWidth/2)
    love.graphics.setColor({1,1,1})
end

return Arrow