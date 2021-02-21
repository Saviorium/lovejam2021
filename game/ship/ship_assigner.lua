local log = require 'engine.logger' ( "shipAssigner", function (msg) return "ShipAssigner: ["..msg.."]" end )

local ShipAssigner = Class {
    init = function(self, world)
        self.ship = nil
        self.route = nil
        self.world = world
    end
}

function ShipAssigner:isActive()
    return not (self.ship == nil)
end

function ShipAssigner:canAssign()
    return self.ship and self.route and self.route:canAssign(self.ship)
end

function ShipAssigner:setShip(ship)
    if not ship then
        log(1, "Cannot assign ship: no ship")
        return
    end
    self.ship = ship
    ship:setSelected(true)
    log(3, "Ship " .. ship:tostring() .. " is selected for assignment")
end

function ShipAssigner:setRoute(route)
    if not self:isActive() then
        log(1, "Cannot set route")
        log(4, self.ship, route)
        self:reset()
        return
    end
    log(3, "Destnation set to " .. (self.route and self.route:tostring() or "Nil") )
    if self.route then
        self.route:setSelected(false)
    end
    self.route = route
    if self.route then
        self.route:setSelected(true)
    end
end

function ShipAssigner:assign()
    if not self:canAssign() then
        log(3, "Abort ship assign")
        log(4, self.ship, self.route)
        self:reset()
        return
    end
    log(1, "Assigned " .. self.ship:tostring() .. " to " .. self.route:tostring())
    local from, to = self.ship, self.route
    self:reset()
    return from, to
end

function ShipAssigner:reset()
    if self.ship then
        self.ship:setSelected(false)
    end
    if self.route then
        self.route:setSelected(false)
    end
    self.ship = nil
    self.route = nil
end

function ShipAssigner:draw()
    if not self:isActive() or not self.ship then
        return
    end
    love.graphics.draw(self.ship.image, love.mouse.getPosition())
end

return ShipAssigner