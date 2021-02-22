local ResourceBar = require "game.ui.resource_bar"
local InformationBoard = require "game.ui.information_boards.information_board"

local StationInformationBoard =
    Class {
    __includes = InformationBoard,
    init = function(self, targetObject, description)
        self.font = love.graphics.newFont(fonts.smolPixelated.file, fonts.smolPixelated.size)
        self.font:setFilter("nearest", "nearest")
        InformationBoard.init(self, targetObject, description)
    end
}


function StationInformationBoard:getFullText(description)
    local currentTask = self.targetObject.tasks.currentTask and self.targetObject.tasks.currentTask.name or ""
    local endStation = self.targetObject.route and self.targetObject.route.endStation.name or ""
    local resourceTransporting = self.targetObject.route and self.targetObject.route.resourceTaking or ""
    local fullText = 'Ship '..self.targetObject:tostring()..'\n'..
                     (description or "").. '\n' ..
                     'Resource transporting: '.. resourceTransporting .. '\n' ..
                     'To station: ' ..endStation.. '\n' ..
                     'Now doing: ' ..currentTask
    return fullText
end

function StationInformationBoard:initResourceBar()
    local resources = {}
    if self.targetObject.route then
        table.insert(resources, {resource = self.targetObject.route.resourceTaking, resourceSource = self.targetObject})
    end
    self.resourceBar = ResourceBar( self.targetObject.position.x + self.targetObject.width,
                                    self.targetObject.position.y + self.targetObject.height,
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
    self:updateInformation()
    love.graphics.translate( 0, 0 )
    love.graphics.setFont(self.font)
    love.graphics.setColor(config.colors.uiBackground)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(config.colors.infoTextColor)
    love.graphics.printf(self.fullText, self.font, love.math.newTransform(self.x, self.y), self.width, 'left')
    love.graphics.setColor(1,1,1)
    self.resourceBar:draw()
end

return StationInformationBoard
