local Arrow = require "game.ui.arrow"

local log = require 'engine.logger' ( "routeBuilder", function (msg) return "RouteBuilder: ["..msg.."]" end )

local RouteBuilder = Class {
    init = function(self, world)
        self.fromStation = nil
        self.toStation = nil
        self.world = world
        self.arrow = Arrow()
    end
}

function RouteBuilder:isBuilding()
    return not (self.fromStation == nil)
end

function RouteBuilder:canBuild()
    return self.fromStation and self.toStation and not (self.fromStation == self.toStation)
end

function RouteBuilder:startBuilding(fromStation)
    if not fromStation then
        log(1, "Cannot start build: no fromStation")
        return
    end
    self.fromStation = fromStation
    fromStation:setSelected(true)
    log(3, "Building route from station " .. fromStation:tostring())
    SoundManager:play("route_start")
end

function RouteBuilder:setDestination(toStation)
    if not self:isBuilding() then
        log(1, "Cannot set destination")
        log(4, self.fromStation, toStation)
        self:stopBuilding()
        return
    end
    log(3, "Destnation set to " .. (toStation and toStation:tostring() or "Nil") )
    if self.toStation then
        self.toStation:setSelected(false)
    end
    self.toStation = toStation
    if self.toStation then
        self.toStation:setSelected(true)
    end
    self.fromStation:setSelected(true)
end

function RouteBuilder:finishBuilding()
    if not self:canBuild() then
        log(3, "Abort build route")
        log(4, self.fromStation, self.toStation)
        self:stopBuilding()
        return
    end
    log(1, "Building route from " .. self.fromStation:tostring() .. " -> " .. self.toStation:tostring())
    local from, to = self.fromStation, self.toStation
    SoundManager:play("route_done")
    self:stopBuilding()
    return from, to
end

function RouteBuilder:stopBuilding()
    if self.fromStation then
        self.fromStation:setSelected(false)
    end
    if self.toStation then
        self.toStation:setSelected(false)
    end
    self.fromStation = nil
    self.toStation = nil
end

function RouteBuilder:draw()
    if not self:isBuilding() or not self.fromStation then
        return
    end
    self.arrow:setFrom(self.fromStation:getCenter())
    self.arrow:setTo(self.toStation and self.toStation:getCenter() or self.world:getMouseCoords())
    self.arrow:draw()
end

return RouteBuilder