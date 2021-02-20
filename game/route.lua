local Route = Class {
    init = function(self, startStation, endStation)
        self.startStation   = startStation
        self.endStation     = endStation
        for _, resourceTo in pairs(self.endStation:getConsumingResources()) do
            for _, resourceFrom in pairs(self.startStation:getProductingResources()) do
                if resourceTo == resourceFrom then
                    self.resourceTaking = resourceTo
                end
            end
        end
    end
}

local arrow = {
    lineWidth = 10,
    color = {0.5, 0.9, 0.2},
    endAngle = 18,
    endLength = 50
}

function Route:draw()
    local from = self.startStation:getCenter()
    local to = self.endStation:getCenter()
    local vector = to - from
    local leftEnd = to - vector:rotated(arrow.endAngle*math.pi/180):normalized()*arrow.endLength
    local rightEnd = to - vector:rotated(arrow.endAngle*(-math.pi)/180):normalized()*arrow.endLength
    love.graphics.setLineWidth( arrow.lineWidth )
    love.graphics.setColor(arrow.color)
    love.graphics.line(from.x, from.y, to.x, to.y)
    love.graphics.line(to.x, to.y, leftEnd.x, leftEnd.y)
    love.graphics.line(to.x, to.y, rightEnd.x, rightEnd.y)
    love.graphics.circle("fill", leftEnd.x, leftEnd.y, arrow.lineWidth/2)
    love.graphics.circle("fill", rightEnd.x, rightEnd.y, arrow.lineWidth/2)
    love.graphics.setColor({1,1,1})
end

return Route
