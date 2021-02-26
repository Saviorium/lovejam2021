local UIobject = require "game.ui.uiobject"

local SpeedButton = Class {
    __includes = UIobject,
    init = function(self, parameters, world)
        self.bg = AssetManager:getAnimation('station_button_bg')
        self.bg:setTag('up')
        self.icons = {}
        for i, multiplier in pairs(config.game.speedMultipliers) do
            self.icons[i] = AssetManager:getAnimation('speed_button')
            self.icons[i]:setTag('up')
        end

        self.speedOption = 1
        self.world = world

        UIobject.init(
            self,
            parameters.x,
            parameters.y,
            74,
            74,
            "SpeedButton",
            'fixed'
        )

        self.startClickInteraction =
            function()
                self:setTag('down')
            end
        self.stopClickInteraction =
            function()
                self:setTag('up')
                self:increaseSpeed()
            end
        self.bgTag = 'up'
    end,
    iconPadding = Vector(20, 18),
    iconOffset = Vector(6, 0)
}

function SpeedButton:increaseSpeed()
    self.speedOption = self.speedOption + 1
    if self.speedOption > #config.game.speedMultipliers then
        self.speedOption = 1
    end
    self.world.speed = config.game.speedMultipliers[self.speedOption]
end

function SpeedButton:update(dt)
    self.bg:update(dt)
    for _, icon in pairs(self.icons) do
        icon:update(dt)
    end
    local mouseX, mouseY = love.mouse.getPosition()
    local localX, localY = love.graphics.transformPoint( mouseX, mouseY )
    local isHovered = self:getCollision(localX, localY)
    if isHovered and self.bgTag == 'up' then
        self:setTag('hover')
    elseif not isHovered and self.bgTag == 'hover' then
        self:setTag('up')
    end
    self:checkIfSpeedWasChangedAndSync()
end

function SpeedButton:checkIfSpeedWasChangedAndSync()
    if self.world.speed ~= config.game.speedMultipliers[self.speedOption] then
        for index, multiplier in pairs(config.game.speedMultipliers) do
            if multiplier == self.world.speed then
                self.speedOption = index
            end
        end
    end
end

function SpeedButton:render()
    local pos = Vector(self.x, self.y)
    self.bg:draw(pos.x, pos.y)
    pos = pos + self.iconPadding - self.iconOffset * self.speedOption/2
    local iconNumber = 0
    for _, icon in pairs(self.icons) do
        if iconNumber < self.speedOption then
            icon:draw(pos.x, pos.y)
            pos = pos + self.iconOffset
        end
        iconNumber = iconNumber + 1
    end
end

function SpeedButton:setTag(name)
    self.bgTag = name
    self.bg:setTag(name)
    for _, icon in pairs(self.icons) do
        icon:setTag(name)
    end
end

return SpeedButton