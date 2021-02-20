local UIobject = require "game.ui.uiobject"

NewStationButton = Class {
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
        self.misClickInteraction = nvl(parameters.missCallback, self.defaultCallback)
    end
}

function NewStationButton:render()
    love.graphics.setColor(0.7,0.7,0.7)
    love.graphics.rectangle('fill', self.x, self.y, 64, 64)
    love.graphics.setColor(1,1,1)
	love.graphics.draw(self.image, self.x, self.y, 0, 2, 2)
	love.graphics.print(self.tag, self.x, self.y)
end

function NewStationButton.defaultCallback(self)
     print(self.tag,'Clicked')
end

return NewStationButton