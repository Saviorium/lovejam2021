local Resources = require "data.resources"
local UIobject = require "game.ui.uiobject"

local ResourceBar =
    Class {
    __includes = UIobject,
    init = function(self, rightX, rightY, scale, resourceSources, world, iconSize, textWidth, textHeight, margin)
        self.iconSize    = nvl(iconSize, 16)
        self.textWidth   = nvl(textWidth, 16)
        self.textHeight  = nvl(textHeight, 8)
        self.margin      = nvl(margin, 12)

        self.scale = scale
        self.cellWidth = ((self.iconSize > self.textWidth and self.iconSize or self.textWidth) + self.margin) * self.scale
        self.cellHeight = ((self.iconSize > self.textWidth and self.iconSize or self.textWidth) + self.textHeight + self.margin) * self.scale
        self.width = #resourceSources * self.cellWidth
        self.height = self.cellHeight

        self.x = rightX - self.width
        self.y = rightY

        UIobject.init(  self,
                        self.x,
                        self.y,
                        self.width,
                        self.height,
                        'Progress Bar',
                        'fixed')

        self.resources = resourceSources
        self.world = world
    end
}

function ResourceBar:render()

    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1)

    for ind, res in pairs(self.resources) do
        local iconX, iconY = self.x + self.cellWidth * (ind - 1), self.y
        local textX, textY = iconX, self.y + self.cellWidth
        local icon = Resources[res.resource].icon
        love.graphics.draw(
                           Resources[res.resource].icon,
                           iconX + (self.cellWidth  - icon:getWidth() * self.scale)/2,
                           iconY + (self.cellHeight - (icon:getHeight() + self.textHeight) * self.scale)/2,
                           0,
                           self.scale,
                           self.scale
                          )

        if res.resourceSource then
            local value, max = res.resourceSource.storage.value, res.resourceSource.storage.max
            if res.resource == 'dude' then
                value = 0
                max = res.resourceSource.storage.value
                for _, station in pairs(self.world.stations) do
                    value = value + station.population
                end
            end
            love.graphics.printf(
                value .. " / " .. max,
                textX,
                textY,
                self.cellWidth,
                'center'
            )
        elseif res.resource == 'life' then
            love.graphics.printf(
                self.world.lifes .. " / " .. 10,
                textX,
                textY,
                self.cellWidth,
                'center'
            )
        else
            local overallValue, overallMax = 0, 0
            for _, station in pairs(self.world.stations) do
                if count( station:getProductingResources(), function(obj) return obj == res.resource end) > 0 then
                    overallValue = overallValue + station.outResources[res.resource].storage.value
                    overallMax   = overallMax + station.outResources[res.resource].storage.max
                end
            end
            love.graphics.printf(
                overallValue .. " / " .. overallMax,
                textX,
                textY,
                self.cellWidth,
                'center'
            )
        end
    end
end

return ResourceBar
