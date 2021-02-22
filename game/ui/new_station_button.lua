local UIobject = require "game.ui.uiobject"

local NewStationButton = Class {
    __includes = UIobject,
    init = function(self, parameters)
        self.targetStation = parameters.targetStation(parameters.position)
        self.image = self.targetStation.image
        UIobject.init(  self,
                        parameters.position.x,
                        parameters.position.y,
                        nvl(parameters.width, self.image:getWidth()*2),
                        nvl(parameters.height, self.image:getHeight()*2),
                        parameters.tag,
                        'fixed')
        self.startClickInteraction = nvl(parameters.startCallback, self.defaultCallback)
        self.misClickInteraction   = parameters.misCallback
        self.stopClickInteraction  = parameters.endCallback
    end
}

function NewStationButton:render()
    local scaleX = self.width / self.image:getWidth()
    local scaleY = self.height / self.image:getHeight()
    love.graphics.setColor(config.colors.uiBackgroundDarker)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(1,1,1)
	love.graphics.draw(self.image, self.x, self.y, 0, scaleX, scaleY)
	love.graphics.print(self.tag, self.x, self.y)
end

function NewStationButton.defaultCallback(self)
end

return NewStationButton