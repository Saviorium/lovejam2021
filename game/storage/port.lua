local log = require "engine.logger"("storagesInnerDebug")

local Port =
    Class {
    init = function(self, storage, loadSpeed, direction, maxDockedShips)
        self.shipsQueue = {}
        self.dockedShips = {}
        for i = 0, nvl(maxDockedShips,2), 1 do
            table.insert(self.dockedShips,{ship = nil})
        end
        self.loadSpeed = nvl(loadSpeed, 100)
        self.direction = direction -- in = 1, out = -1
        self.storage = storage
        self.name = "Port #"..love.math.random( 1000 )
        self.maxDockedShips = 2
    end
}

function Port:onTick()
    self:getShipToPort()
    for ind, port in pairs(self.dockedShips) do
        if port.ship then
            log( 1, "Port ".. self.name .." started transport resources to "..port.ship.name )
            local transferRealized = false
            if self.direction == 1 then
                local result = self.storage:addAndGetExcess(self.loadSpeed) - self.loadSpeed
                port.ship.storage:addAndGetExcess(result)
                transferRealized = result ~= 0
            elseif self.direction == -1 then
                local result = port.ship.storage.port.loadSpeed + self.storage:addAndGetExcess(-port.ship.storage.port.loadSpeed)
                port.ship.storage:addAndGetExcess(result)
                transferRealized = result ~= 0
            end
            if transferRealized then
                port.ship.canLeave = false
                port.ship.loadTimer:clear()
                port.ship.loadTimer:after(4, function() port.ship.canLeave = true end)
            end
        end
    end
end

function Port:addShipToQueue(ship)
    log(2, "Port ".. self.name .." added ship ".. ship.name .." in queue")
    table.insert(self.shipsQueue, ship)
end

function Port:getShipToPort()
    log(2, "Port ".. self.name .." docking ship in port ")
    for ind, port in pairs(self.dockedShips) do
        if not port.ship then
            self.dockedShips[ind].ship = table.remove(self.shipsQueue, 1)
            if self.dockedShip then
                log(1, "Port ".. self.name .." docked ship "..self.dockedShips[ind].ship.name .. ' At port number '..ind)
                return true
            end
        end
    end
    return false
end

function Port:isFree()
    log(2, "Port ".. self.name .." checking if there any free docks")
    for ind, port in pairs(self.dockedShips) do
        if not port.ship then
            return true
        end
    end
    return false
end

function Port:undockShip(ship)
    log(2, "Port ".. self.name .." undocking ship "..ship.name)
    for ind, port in pairs(self.dockedShips) do
        if port.ship == ship then
            port.ship.loadTimer:clear()
            port.ship = nil
            if not port.ship then
                log(2, "Port ".. self.name .." undocked ship "..ship.name .. ' At port number '..ind)
                return true
            end
        end
    end
    return false
end
function Port:getAllDockedShips()
    local result = {}
    for ind, port in pairs(self.dockedShips) do
        if port.ship then
            table.insert(result, port.ship)
        end
    end
    return result
end

return Port
