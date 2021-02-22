local log = require "engine.logger"("shipInnerDebug")
local Storage = require "game.storage.storage"
local TaskList = require "game.task.task_list"
local Tasks = require "game.task.shiptasks"

-- Абстрактный корабль с ресурсом
local Ship =
    Class {
    __includes = Entity,
    init = function(self, x, y, name)
        Entity.init(self)
        self.position = Vector(x, y)
        self.storage = Storage(1000, 0, "any", 100, 0)
        self.speed = 30
        self.direction = Vector()

        self.name = name or "Ship #" .. love.math.random(1000)

        self.tasks = TaskList()

        self.image = AssetManager:getImage("ship")
        self.focusedImage = AssetManager:getImage("ship")
        self.width = self.image:getWidth()
        self.height = self.image:getHeight()
        self.visible = true

        self:addComponent("selectable")

        self.newRoute = nil
        self.driftAngle = 0
    end
}

function Ship:setRoute(route)
    if not self.route then
        self.route = route
        local target = self.route.startStation
        self.tasks.onEmpty = function()
            self.tasks:addTask(Tasks.goTo(self, target, target.outResources[self.route.resourceTaking].storage))
        end
    else
        self.newRoute = route
    end
    return self
end

function Ship:flyAroundStation(station)
    self.tasks:clear()
    self.route = nil
    self.tasks:addTask(Tasks.waitAroundStation(self, station))
    return self
end

function Ship:canBeAssigned()
    if not self.visible then
        return false
    end
    return true
end

function Ship:update(dt)
    self.tasks:runTask(dt)
    self.driftAngle = math.clamp(-0.1, self.driftAngle + love.math.random(0.1) - 0.05, 0.1)
end

function Ship:draw()
    if self.visible then
        Entity.draw(self)
        love.graphics.draw(
            self.image,
            self.position.x,
            self.position.y,
            self.angle,
            1,
            1,
            self.width / 2,
            self.height / 2
        )
        love.graphics.circle(
            'fill',
            self.position.x,
            self.position.y,
            1
        )
    end
end

function Ship:drawSelected()
    local scale =
        Vector(
        (self.width + config.selection.border * 2) / self.width,
        (self.height + config.selection.border * 2) / self.height
    )
    love.graphics.setBlendMode("add", "alphamultiply")
    love.graphics.setColor(config.colors.selected)
    love.graphics.draw(
        self.image,
        self.position.x,
        self.position.y,
        self.angle,
        scale.x,
        scale.y,
        self.width / 2,
        self.height / 2
    )
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(1, 1, 1)
end

function Ship:setVisible(boolean)
    self.visible = boolean
    return self
end

function Ship:drawHovered()
    local scale =
        Vector(
        (self.width + config.selection.border * 2) / self.width,
        (self.height + config.selection.border * 2) / self.height
    )
    love.graphics.setBlendMode("add", "alphamultiply")
    love.graphics.setColor(config.colors.hover)
    love.graphics.draw(
        self.image,
        self.position.x,
        self.position.y,
        self.angle,
        scale.x,
        scale.y,
        self.width / 2,
        self.height / 2
    )
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(1, 1, 1)
end

function Ship:isNear(target)
    local result = (target:getCenter() - self.position):len()
    log(1, "Ship checking distance to target", result)
    return result <= target.width
end

function Ship:moveTo(dt, target)
    self.direction = (target:getCenter() - self.position):normalized()
    self.angle = -nvl(self.direction, Vector(1, 1)):toPolar().x - math.pi
    self.direction = self.direction:rotateInplace(self.driftAngle)
    log(1, "Ship moving in direction ", self.direction)
    self.position = self.position + self.direction * self.speed * dt
end

function Ship:moveAroundStation(dt, target)
    if not self:isNear(target) then
        self:moveTo(dt, target)
        return
    end
    self.direction = (target:getCenter() - self.position):normalized():rotateInplace(math.pi / 2)
    self.angle = -nvl(self.direction, Vector(1, 1)):toPolar().x - math.pi
    log(1, "Ship moving around station", self.direction)
    self.position = self.position + self.direction * self.speed * dt
end

function Ship:getCenter()
    return Vector(self.position.x + self.width / 2, self.position.y + self.height / 2)
end

function Ship:tostring()
    return self.name
end

return Ship
