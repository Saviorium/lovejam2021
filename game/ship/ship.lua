local log      = require 'engine.logger' ("shipInnerDebug")
local serpent  = require "lib.debug.serpent"
local Storage  = require "game.storage.storage"
local TaskList = require "game.task.task_list"
local Tasks    = require "game.task.shiptasks"

-- Абстрактная станция с ресурсом
local Ship = Class {
    init = function(self, x, y, way)
        self.x = nvl(x, 0)
        self.y = nvl(y, 0)
        self.storage = Storage(1000, 0, 'any', 100, 0)
        self.speed   = 1
        self.tasks = TaskList()

        self.way = way
        local target = self.way.endStation
        self.tasks:addTask(Tasks.goto(self, target, target.inResources[self.way.resourceTaking]))

        self.image        = AssetManager:getImage('ship')
        self.focusedImage = AssetManager:getImage('ship')
        self.width = self.image:getWidth()
        self.height = self.image:getHeight()
    end
}

function Ship:update(dt)
    self.tasks:runTask(dt)
end

function Ship:draw()
    if self.tasks.currentTask and self.tasks.currentTask.name == 'goto' then
        love.graphics.draw(self.image, self.x, self.y)
    end
end
function Ship:isNear( target )
    local result = Vector(target.x - self.x, target.y - self.y):len()
    log(1, "Ship checking distance to target", result)
    return result <= 1
end

function Ship:moveTo( dt, target )
    local direction = Vector(target.x - self.x, target.y - self.y):normalized()
    log(1, "Ship moving in direction ", direction)
    self.x = self.x + self.speed*dt*direction.x
    self.y = self.y + self.speed*dt*direction.y
end


return Ship

