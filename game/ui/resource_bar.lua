local UIobject = require "game.ui.uiobject"

local ResourceBar =
    Class {
    __includes = UIobject,
    init = function(self, rightX, rightY, scale, resourceSources, world, iconSize, textWidth, textHeight, margin)
        self.iconSize    = nvl(iconSize, 16)
        self.iconBackgroudSize    = 26
        self.textWidth   = nvl(textWidth, 16)
        self.textHeight  = nvl(textHeight, 8)
        self.margin      = nvl(margin, 12)

        self.scale = scale
        self.cellWidth = ((self.iconSize > self.textWidth and self.iconSize or self.textWidth) + self.margin) * self.scale
        self.cellHeight = ((self.iconSize > self.textWidth and self.iconSize or self.textWidth) + self.textHeight + self.margin) * self.scale
        self.width = #resourceSources * self.cellWidth
        self.height = self.cellHeight

        self.iconBgImage = AssetManager:getImage('icon_bg')

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

    local font = love.graphics.newFont(fonts.smolPixelated.file, fonts.smolPixelated.size*self.scale)
    font:setFilter("nearest", "nearest")

    love.graphics.setFont(font)
    love.graphics.setColor(config.colors.uiBackground)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, 4, 4)
    for ind, res in pairs(self.resources) do
        local iconX, iconY = self.x + self.cellWidth * (ind - 1), self.y
        local textX, textY = iconX, self.y + self.cellWidth
        local icon = Resources[res.resource].icon
        local color = Resources[res.resource].color
        love.graphics.setColor(color)
        love.graphics.draw(
            self.iconBgImage,
            iconX + (self.cellWidth  - (icon:getWidth() + self.iconBackgroudSize/2) * self.scale)/2,
            iconY + (self.cellHeight - (icon:getHeight() + self.textHeight + self.iconBackgroudSize/2) * self.scale)/2,
            0,
            self.scale,
            self.scale
        )
        love.graphics.setColor(1, 1, 1)

        love.graphics.draw(
            Resources[res.resource].icon,
            iconX + (self.cellWidth  - icon:getWidth() * self.scale)/2 + ((res.resource == 'life' and self.world.disapointment) and love.math.random(-2, 2) or 0),
            iconY + (self.cellHeight - (icon:getHeight() + self.textHeight) * self.scale)/2,
            0,
            self.scale,
            self.scale
        )

        love.graphics.setColor(config.colors.infoTextColor)

        if res.resourceSource then
            local value, max = res.resourceSource.storage.value, res.resourceSource.storage.max
            if res.resource == 'dude' then
                value = 0
                max = res.resourceSource.storage.value
                for _, station in pairs(self.world.stations) do
                    value = value + station.population
                end
            end
            if res.resourceSource.consume then
                love.graphics.printf(
                    '-'..res.resourceSource.consume,
                    textX,
                    textY-12,
                    self.cellWidth,
                    'center'
                )
            elseif res.resourceSource.produce and res.resource ~= 'dude'then
                love.graphics.printf(
                    '+'..res.resourceSource.produce,
                    textX,
                    textY-12,
                    self.cellWidth,
                    'center'
                )
            end
            love.graphics.printf(
                math.clamp(0, math.floor(value), 9999) .. " / " .. max,
                textX,
                textY,
                self.cellWidth,
                'center'
            )
        elseif res.resource == 'life' then
            love.graphics.printf(
                math.clamp(0, math.floor(self.world.lifes), 99999)  .. " / " .. (config.game.godMode and 99999 or 10),
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
                math.clamp(0, math.floor(overallValue), 9999) .. " / " .. overallMax,
                textX,
                textY,
                self.cellWidth,
                'center'
            )
        end
        love.graphics.setColor(1,1,1)
    end
end

return ResourceBar
