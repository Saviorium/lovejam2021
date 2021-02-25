local UIobject = require "game.ui.uiobject"

local SpeedButton = Class {
    __includes = UIobject,
    init = function(self, parameters, world)
        self.image = AssetManager:getAnimation('speed_button')
        self.image:setTag('Speed1')
        UIobject.init(  self,
                        parameters.x,
                        parameters.y,
                        self.image:getWidth(),
                        self.image:getHeight(),
                        parameters.tag,
                        'fixed')

        self.startClickInteraction =
            function()
                if self.bgTag == 'Speed1' then
                    self.image:setTag('Speed2')
                    self.bgTag = 'Speed2'
                    world.speed = config.game.speed2
                elseif self.bgTag == 'Speed2' then 
                    self.image:setTag('Speed3')
                    self.bgTag = 'Speed3'
                    world.speed = config.game.speed3
                elseif self.bgTag == 'Speed3' then
                    self.image:setTag('Speed1')
                    self.bgTag = 'Speed1'
                    world.speed = config.game.speed1
                end
            end
        self.bgTag = 'Speed1'
    end
}
function SpeedButton:update(dt)
    self.image:update(dt)
end

function SpeedButton:render()
    self.image:draw(self.x, self.y)
end

return SpeedButton