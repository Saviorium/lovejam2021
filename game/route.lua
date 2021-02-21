local Arrow = require "game.ui.arrow"

local Resources = require "data.resources"

local Route =
    Class {
    init = function(self, startStation, endStation)
        self.startStation = startStation
        self.endStation = endStation
        for _, resourceTo in pairs(self.endStation:getConsumingResources()) do
            for _, resourceFrom in pairs(self.startStation:getProductingResources()) do
                if resourceTo == resourceFrom then
                    self.resourceTaking = resourceTo
                end
            end
        end

        if self.resourceTaking then
            self.resourceColor = Resources[self.resourceTaking].color
        else
            self.resourceColor = config.colors.noResource
        end

        self.arrow = Arrow():setFrom(self.startStation:getCenter()):setTo(self.endStation:getCenter())
        self.isHovered = false
        self.isSelectedToDelete = false
        self.isSelected = false

        self.name = "Route from ["..self.startStation:tostring().."] to ["..self.endStation:tostring().."]"
    end
}

local function distFromPointToLineSegment(point, lineStart, lineEnd)
    local length2 = lineStart:dist2(lineEnd)
    if (length2 <= 0) then return point:dist2(lineStart) end -- lineStart == lineEnd case
    local lineVector = lineEnd - lineStart
    local pointToStartVector = (point - lineStart)
    local prjScalar = (pointToStartVector.x * lineVector.x + pointToStartVector.y * lineVector.y) / (lineVector.x * lineVector.x + lineVector.y * lineVector.y)
    prjScalar = math.clamp(0, prjScalar, 1)
    local projectionOnSegment = lineVector * prjScalar
    return (lineStart + projectionOnSegment):dist2(point)
end

function Route:canAssign(ship)
    if self.resourceTaking then
        return true
    end
    return false
end

function Route:getDistanceTo(point)
    return distFromPointToLineSegment(point, self.startStation:getCenter(), self.endStation:getCenter())
end

function Route:setSelected(bool)
    self.isSelected = bool
end

function Route:setSelectedToDelete(bool)
    self.isSelectedToDelete = bool
end

function Route:setHover(bool)
    self.isHovered = bool
end

function Route:draw()
    self.arrow:setColor(self.resourceColor)
    if self.isHovered then self.arrow:setColor(config.colors.hover) end
    if self.isSelected then self.arrow:setColor(config.colors.hover) end
    if self.isSelectedToDelete then self.arrow:setColor(config.colors.delete) end
    self.arrow:draw()
end

function Route:tostring()
    return self.name
end

return Route
