local UIobject    = require "game.ui.uiobject"
local ResourceBar = require("game.ui.resource_bar")

local InformationBoard =
    Class {
    __includes = UIobject,
    init = function(self, station, description)
        self.station = station
        self.description = description

        local resources = {}
        for name, resource in pairs(self.station.inResources) do
            table.insert(resources, {resource = name, resourceSource = resource})
        end
        for name, resource in pairs(self.station.outResources) do
            if name ~= 'dude' then
                table.insert(resources, {resource = name, resourceSource = resource})
            end
        end
        self.font = love.graphics.newFont(12)
        self.font:setFilter("nearest", "nearest")
        self.resourceBar = ResourceBar( self.station.x + self.station.width,
                                        self.station.y + self.station.height,
                                        1,
                                        resources,
                                        self,
                                        36,
                                        self.font:getHeight(),
                                        12
                                      )

        self.width = self.resourceBar.width > 48 and self.resourceBar.width or 128

        self.textWidth, self.wrappedtext = self.font:getWrap( self.description, self.width )
        self.textHeight = self.font:getHeight() * #self.wrappedtext

        self.x = self.resourceBar.x
        self.y = self.resourceBar.y

        self.resourceBar.y = self.resourceBar.y + self.textHeight
        self.height = self.textHeight + self.resourceBar.height

        UIobject.init(  self,
                        self.x,
                        self.y,
                        self.width,
                        self.height,
                        'Information board',
                        'fixed')
    end
}

function InformationBoard:render()
    love.graphics.setFont(self.font)
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height + 10)
    love.graphics.setColor(1,1,1)
    love.graphics.printf(self.description, self.font, love.math.newTransform(self.x, self.y), self.width, 'left')
    self.resourceBar:draw()
end

return InformationBoard
