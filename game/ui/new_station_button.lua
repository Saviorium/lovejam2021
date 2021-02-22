local UIobject = require "game.ui.uiobject"
local Peachy = require "lib.peachy.peachy"

local NewStationButton = Class {
    __includes = UIobject,
    init = function(self, parameters)
        self.targetStation = parameters.targetStation(parameters.position)
        self.image = self.targetStation.image
        self.buttonImage = AssetManager:getAnimation('station_button_bg')
        self.buttonImage:setTag('up')
        UIobject.init(  self,
                        parameters.position.x,
                        parameters.position.y,
                        nvl(parameters.width, self.image:getWidth()*2),
                        nvl(parameters.height, self.image:getHeight()*2),
                        parameters.tag,
                        'fixed')

        self.startClickInteraction =
            function()
                self.bgTag = 'down'
                self.buttonImage:setTag(self.bgTag)
                return parameters.startCallback()
            end
        self.stopClickInteraction =
            function()
                self.bgTag = 'up'
                self.buttonImage:setTag(self.bgTag)
                return parameters.endCallback()
            end
        self.bgTag = 'up'
    end
}
function NewStationButton:update(dt)
    self.buttonImage:update(dt)
    local x, y = love.mouse.getPosition()
    local localX, localY = love.graphics.transformPoint( x, y )
    if self:getCollision(localX, localY) and self.bgTag == 'up' then
        self.bgTag = 'hover'
        self.buttonImage:setTag('hover')
    elseif not self:getCollision(localX, localY) and self.bgTag == 'hover' then
        self.bgTag = 'up'
        self.buttonImage:setTag('up')
    else
        self.buttonImage:setTag(self.bgTag)
    end
end

function NewStationButton:render()
    local margin = (self.buttonImage:getWidth() - self.image:getWidth())/2
    self.buttonImage:draw(self.x, self.y)
    love.graphics.setColor(1,1,1)
	love.graphics.draw(self.image, self.x + margin, self.y + margin)
	love.graphics.print(self.tag, self.x, self.y)
end

function NewStationButton.defaultCallback(self)
end

return NewStationButton