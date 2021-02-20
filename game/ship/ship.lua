local log      = require 'engine.logger' ("shipInnerDebug")
local Storage  = require "game.storage.storage"
local TaskList = require "game.task.task_list"
local Tasks    = require "game.task.shiptasks"

-- Абстрактный корабль с ресурсом
local Ship = Class {
    init = function(self, x, y, name)
        self.position = Vector(x, y)
        self.storage = Storage(1000, 0, 'any', 100, 0)
        self.speed   = 30

        self.name = name or "Ship #"..love.math.random( 1000 )

        self.tasks = TaskList()

        self.image        = AssetManager:getImage('ship')
        self.focusedImage = AssetManager:getImage('ship')
        self.width = self.image:getWidth()
        self.height = self.image:getHeight()
    end
}

function Ship:setRoute(route)
    self.route = route
    local target = self.route.startStation
    self.tasks.onEmpty = function ()
        self.tasks:addTask(Tasks.goTo(self, target, target.outResources[self.route.resourceTaking].storage))
    end
    return self
end

function Ship:update(dt)
    self.tasks:runTask(dt)
end

function Ship:draw()
    if self.tasks.currentTask and self.tasks.currentTask.name == 'goto' then
        love.graphics.draw(self.image, self.position.x, self.position.y)
    end
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


return Ship

