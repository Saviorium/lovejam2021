local UIobject = require "game.ui.uiobject"

-- resourceSources = { -- example
--     resource = "chocolate",
--     resourceStorage = -- optional if resourceSource is set
--         self.stations["HubStation"]:getStorage("chocolate")
--     textSource = -- callback to get value, optional if resourceStorage is set
--         function() return self.stations["HubStation"]:getResourceValue("chocolate") end,
--     criticalCheck = -- if true - text will be red, optional
--         function (value, max) return value == 0 end
-- }
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
        -- background box
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

        -- icon
        love.graphics.draw(
            Resources[res.resource].icon,
            iconX + (self.cellWidth  - icon:getWidth() * self.scale)/2 + ((res.resource == 'life' and self.world.disapointment) and love.math.random(-2, 2) or 0),
            iconY + (self.cellHeight - (icon:getHeight() + self.textHeight) * self.scale)/2,
            0,
            self.scale,
            self.scale
        )

        -- text
        local value, max, delta
        if res.resourceStorage then
            value, max = res.resourceStorage.value, res.resourceStorage.max
        end
        if res.resourceSource then
            value = res.resourceSource()
        end
        if res.maxResourceSource then
            max = res.maxResourceSource()
        end
        if res.deltaResourceSource then
            delta = res.deltaResourceSource()
        end
        local text = value
        if type(value) == "number" then
            text = math.clamp(0, math.floor(value), 9999)
        elseif type(value) == "string" then
            text = value
        else
            text = ""
        end
        if max then text = text .. "/" .. math.clamp(0, math.floor(max), 9999) end
        if delta and type(delta) == "number" then text = (delta > 0 and "+" or "") .. delta .. "\n" .. text end
        if res.criticalCheck and res.criticalCheck(value, max) then
            love.graphics.setColor(config.colors.critical)
        else
            love.graphics.setColor(config.colors.infoTextColor)
        end
        love.graphics.printf(
            text,
            textX,
            textY,
            self.cellWidth,
            'center'
        )
        love.graphics.setColor(1,1,1)
    end
end

return ResourceBar
