local UIobject    = require "game.ui.uiobject"
local ResourceBar = require "game.ui.resource_bar"

local InformationBoard =
    Class {
    __includes = UIobject,
    init = function(self, targetObject, description)
        self.targetObject = targetObject
        self.description = description
        self:updateInformation()

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


function InformationBoard:getFullText(description)
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

function InformationBoard:updateInformation()
    self.fullText = self:getFullText(self.description)
    self:initResourceBar()

    self.width = self.resourceBar.width > 128 and self.resourceBar.width or 128

    self.textWidth, self.wrappedtext = self.font:getWrap( self.fullText, self.width )
    self.textHeight = self.font:getHeight() * #self.wrappedtext

    self.x = self.resourceBar.x
    self.y = self.resourceBar.y

    self.resourceBar.y = self.resourceBar.y + self.textHeight
    self.height = self.textHeight + self.resourceBar.height
end

function InformationBoard:draw()
    if self.isVisible then
        self:render()
    end
end

return InformationBoard
