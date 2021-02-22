local UIobject    = require "game.ui.uiobject"
local ResourceBar = require "game.ui.resource_bar"

local InformationBoard =
    Class {
    __includes = UIobject,
    init = function(self, targetObject, description)
        self.font = love.graphics.newFont(12)
        self.font:setFilter("nearest", "nearest")

        self.targetObject = targetObject
        self.description = self:createDescription(description)
        self:initResourceBar()

        self.width = self.resourceBar.width > 128 and self.resourceBar.width or 128

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
        self.isVisible = false
        self.showTimer = Timer.new()
    end
}


function InformationBoard:createDescription(description)
    return description
end

function InformationBoard:initResourceBar()
    self.resourceBar = ResourceBar( self.targetObject.x + self.targetObject.width,
                                    self.targetObject.y + self.targetObject.height,
                                    1,
                                    {},
                                    self
                                  )
end

function InformationBoard:update(dt)
    self.showTimer:update(dt)
end

function InformationBoard:render()
end

function InformationBoard:draw()
    if self.isVisible then
        self:render()
    end
end

return InformationBoard
