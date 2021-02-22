local ResourceBar = require "game.ui.resource_bar"
local InformationBoard = require "game.ui.information_boards.information_board"
local Resources   = require "data.resources"

local StationInformationBoard =
    Class {
    __includes = InformationBoard,
    init = function(self, targetObject, description)
        self.font = fonts.smolPixelated
        --self.font:setFilter("nearest", "nearest")
        InformationBoard.init(self, targetObject, description)
    end
}


function StationInformationBoard:getFullText(description)
    local inResources, outResources = '',''
    for _, res in pairs(self.targetObject:getConsumingResources()) do
        inResources = inResources..Resources[res].name..', '
    end
    for _, res in pairs(self.targetObject:getProductingResources()) do
        outResources = outResources..Resources[res].name..', '
    end
    local fullText = 'Station '..self.targetObject:tostring()..'\n'..
                     (description or "").. '\n' ..
                     'Resources:'.. '\n' ..
                     'In: ' ..inResources.. '\n' ..
                     'Out: ' ..outResources
    return fullText
end

function StationInformationBoard:initResourceBar()
    local resources = {}
    for name, resource in pairs(self.targetObject.inResources) do
        table.insert(resources, {resource = name, resourceSource = resource})
    end
    for name, resource in pairs(self.targetObject.outResources) do
        if name ~= 'dude' then
            table.insert(resources, {resource = name, resourceSource = resource})
        end
    end
    self.resourceBar = ResourceBar( self.targetObject.x + self.targetObject.width,
                                    self.targetObject.y + self.targetObject.height,
                                    1,
                                    resources,
                                    self,
                                    36,
                                    48,
                                    self.font:getHeight()*2,
                                    16
                                  )
end

function StationInformationBoard:render()
    love.graphics.translate( 0, 0 )
    love.graphics.setFont(self.font)
    love.graphics.setColor(config.colors.uiBackground)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(1,1,1)
    love.graphics.printf(self.fullText, self.font, love.math.newTransform(self.x, self.y), self.width, 'left')
    self.resourceBar:draw()
end

return StationInformationBoard
