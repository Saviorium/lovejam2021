local log      = require 'engine.logger' ("shipInnerDebug")
local Storage  = require "game.storage.storage"
local TaskList = require "game.task.task_list"
local Tasks    = require "game.task.shiptasks"

-- Абстрактный корабль с ресурсом
local Ship = Class {
    __includes = Entity,
    init = function(self, x, y, name)
        Entity.init(self)
        self.position = Vector(x, y)
        self.storage = Storage(1000, 0, 'any', 100, 0)
        self.speed   = 30

        self.name = name or "Ship #"..love.math.random( 1000 )

        self.tasks = TaskList()

        self.image        = AssetManager:getImage('ship')
        self.focusedImage = AssetManager:getImage('ship')
        self.width = self.image:getWidth()
        self.height = self.image:getHeight()

        self:addComponent("selectable")
    end
}

function Ship:setRoute(route)
    self.route = route
    log(1, "Set ship "..self:tostring().." to route "..route:tostring())
    local target = self.route.startStation
    self.tasks.onEmpty = function ()
        self.tasks:addTask(Tasks.goTo(self, target, target.outResources[self.route.resourceTaking].storage))
    end
    return self
end

function Ship:canBeAssigned()
    return true
end

function Ship:update(dt)
    self.tasks:runTask(dt)
end

function Ship:draw()
    Entity.draw(self)
    if self.tasks.currentTask and self.tasks.currentTask.name == 'goto' then
        love.graphics.draw(self.image, self.position.x, self.position.y)
    end
end

function Ship:drawSelected()
    local scale = Vector(
        (self.width + config.selection.border*2) / self.width,
        (self.height + config.selection.border*2) / self.height
    )
    love.graphics.setBlendMode("add", "alphamultiply")
    love.graphics.setColor(config.selection.colorSelected)
    love.graphics.draw(self.image, self.position.x-config.selection.border, self.position.y-config.selection.border, 0, scale.x, scale.y)
    love.graphics.draw(self.image, self.position.x-config.selection.border, self.position.y-config.selection.border, 0, scale.x, scale.y)
    love.graphics.draw(self.image, self.position.x-config.selection.border, self.position.y-config.selection.border, 0, scale.x, scale.y)
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(1, 1, 1)
end

function Ship:drawHovered()
    local scale = Vector(
        (self.width + config.selection.border*2) / self.width,
        (self.height + config.selection.border*2) / self.height
    )
    love.graphics.setBlendMode("add", "alphamultiply")
    love.graphics.setColor(config.selection.colorHover)
    love.graphics.draw(self.image, self.position.x-config.selection.border, self.position.y-config.selection.border, 0, scale.x, scale.y)
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(1, 1, 1)
end

function Ship:isNear( target )
    local result = (target:getCenter() - self.position):len()
    log(1, "Ship checking distance to target", result)
    return result <= target.width
end

function Ship:moveTo( dt, target )
    local direction = (target:getCenter()-self.position):normalized()
    log(1, "Ship moving in direction ", direction)
    self.position = self.position + direction * self.speed * dt
end

function Ship:getCenter()
    return Vector(self.position.x + self.width / 2, self.position.y + self.height / 2)
end

function Ship:tostring()
    return self.name
end

return Ship

