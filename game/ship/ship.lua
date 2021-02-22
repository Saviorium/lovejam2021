local log = require "engine.logger"("shipInnerDebug")
local Storage = require "game.storage.storage"
local TaskList = require "game.task.task_list"
local Tasks = require "game.task.shiptasks"
local ProgressBar = require "game.ui.progress_bar"
local ShipInformationBoard = require "game.ui.information_boards.ship_information_board"

-- Абстрактный корабль с ресурсом
local Ship =
    Class {
    __includes = Entity,
    init = function(self, x, y, name)
        Entity.init(self)
        self.position = Vector(x, y)
        self.storage = Storage(1000, 0, "any", 100, 0)
        self.speed = 60
        self.direction = Vector()

        self.name = name or "Ship #" .. love.math.random(1000)

        self.tasks = TaskList()

        self.image = AssetManager:getImage("ship")
        self.selectedImage = AssetManager:getImage("ship_focused")
        self.width = self.image:getWidth()
        self.height = self.image:getHeight()
        self.visible = true

        self:addComponent("selectable")

        self.newRoute = nil
        self.driftAngle = 0

        self.informationBoard = ShipInformationBoard(self, 'Little poor ship transpoting resources from one place to another')
        self.loadTimer = Timer.new()
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

function Ship:setResourceBar()
    if self.tasks.currentTask then
        self.progressBar = ProgressBar(0, 0, 64, self.storage, self.route.resourceTaking)
    end
end


function Ship:flyAroundStation(station)
    self.route = nil
    self.newRoute = nil
    if self.tasks.currentTask and not (self.tasks.currentTask.name == "go to") then
        self.tasks.currentTask:onDone()
    end
    self.tasks:clear()
    self.tasks.onEmpty = nil
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
    self.informationBoard:update(dt)
    self.loadTimer:update(dt)
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
        self.informationBoard:draw()
    end
end

function Ship:drawSelected()
    love.graphics.setColor(config.colors.selected)
    love.graphics.draw(
        self.selectedImage,
        self.position.x,
        self.position.y,
        self.angle,
        1,
        1,
        self.width / 2,
        self.height / 2
    )
    love.graphics.setColor(1, 1, 1)
end

function Ship:setVisible(boolean)
    self.visible = boolean
    return self
end

function Ship:drawHovered()
    love.graphics.setColor(config.colors.hover)
    love.graphics.draw(
        self.selectedImage,
        self.position.x,
        self.position.y,
        self.angle,
        1,
        1,
        self.width / 2,
        self.height / 2
    )
    love.graphics.setColor(1, 1, 1)

    self.informationBoard.isVisible = true
    self.informationBoard.showTimer:clear()
    self.informationBoard.showTimer:after(config.game.infobarsTimeToDisapear, function() self.informationBoard.isVisible = false end)
end


function Ship:isNear(target)
    local result = (target:getCenter() - self.position):len()
    log(1, "Ship checking distance to target", result)
    return result <= target.width
end

function Ship:moveTo(dt, target)
    self.direction = (target:getCenter() - self.position):normalized()
    self.angle = -self.direction:toPolar().x - math.pi
    self.direction = self.direction:rotateInplace(self.driftAngle)
    log(1, "Ship moving in direction ", self.direction)
    self.position = self.position + self.direction * self.speed * dt
end

function Ship:moveAroundStation(dt, target)
    if not self:isNear(target) then
        self:moveTo(dt, target)
    end
    local direction = self.direction
    self.direction = (target:getCenter() - self.position):normalized():rotateInplace(math.pi / 2)
    self.angle = -(direction + self.direction):toPolar().x - math.pi
    log(1, "Ship moving around station", self.direction)
    self.position = self.position + self.direction * self.speed * dt
end

function Ship:getCenter()
    return Vector(self.position.x + self.width / 2, self.position.y + self.height / 2)
end

function Ship:tostring()
    return self.name
end

function Ship:isLeaving()
    return (self.canLeave and self.storage.value > 0 and self.storage.value < self.storage.max)
end
return Ship
