local log = require "engine.logger"("portInnerDebug", 
function(msg) 
    -- love.filesystem.append('ports_debug.txt', msg)
    love.filesystem.append('ships_and_ports_debug.txt', msg..'\n') 
    return msg
end)

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
        self.name = "#"..love.math.random( 1000 )
        log( 1, "Port ".. self.name .." transporting resource "..storage.resource.. ' in direction '..(self.direction == 1 and ' from ships ' or ' to ships'))
    end
}

function Port:onTick()
    log( 5, "Port ".. self.name .." started onTick() ")
    self:getShipToPort()
    for ind, port in pairs(self.dockedShips) do
        if port.ship then
            local result
            if self.direction == 1 then
                result = math.min(self.storage:canPut(self.loadSpeed), port.ship.storage:canGive(self.loadSpeed))
            elseif self.direction == -1 then
                result = math.min(self.storage:canGive(port.ship.storage.port.loadSpeed), port.ship.storage:canPut(port.ship.storage.port.loadSpeed))
            end
            if result ~= 0 then
                self.storage:addAndGetExcess(self.direction * result)
                port.ship.storage:addAndGetExcess(-self.direction * result)
                port.ship.canLeave = false
                port.ship.loadTimer:clear()
                port.ship.loadTimer:after(4, function() port.ship.canLeave = true end)
                log( 3, "Port ".. self.name .." successly traded with ship "..port.ship.name.." resources "..port.ship.route.resourceTaking.." in amount "..result)
            end
        end
    end
end

function Port:addShipToQueue(ship)
    log( 5, "Port ".. self.name .." added ship "..ship.name.." to queue")
    table.insert(self.shipsQueue, ship)
end

function Port:getShipToPort()
    log( 5, "Port ".. self.name .." docking ship to port")
    for ind, port in pairs(self.dockedShips) do
        if not port.ship then
            self.dockedShips[ind].ship = table.remove(self.shipsQueue, 1)
            if port.ship then
                log(2, "Port ".. self.name .." docked ship "..self.dockedShips[ind].ship.name .. ' at port number '..ind)
                return true
            end
        end
    end
    return false
end

function Port:isFree()
    log( 5, "Port ".. self.name .." checking for free port")
    for ind, port in pairs(self.dockedShips) do
        if not port.ship then
            log( 2, "Port ".. self.name .." found free port at "..ind)
            return true
        end
    end
    return false
end

function Port:leavePort(ship)
    log( 5, "Ship "..ship.name.." trying to leave queue in port ".. self.name)
    for ind, queueShip in pairs(self.shipsQueue) do
        if ship == queueShip then
            table.remove(self.shipsQueue, ind)
            log( 2, "Ship "..ship.name.." leaving port ".. self.name.." from queue ")
        end
    end
end

function Port:undockShip(ship)
    log( 5, "Ship "..ship.name.." trying to undock ship ".. self.name)
    for ind, port in pairs(self.dockedShips) do
        if port.ship and port.ship == ship then
            log(4, "Port ".. self.name .." found ship "..ship.name .. " at port number "..ind)
            port.ship.loadTimer:clear()
            port.ship = nil
            if not port.ship then
                log(2, "Port ".. self.name .." undocked ship "..ship.name .. ' from port number '..ind)
                return true
            end
        end
    end
    return false
end

function Port:findShipInPort(ship)
    log( 5, "Port "..self.name.." searching ship ".. ship.name)
    for ind, port in pairs(self.dockedShips) do
        if port.ship and port.ship == ship then
            log( 2, "Port "..self.name.." found ship ".. ship.name.. " at port "..ind)
            return true
        end
    end
    return false
end

function Port:getAllDockedShips()
    log( 5, "Port "..self.name.." getting all docked ships")
    local result = {}
    for ind, port in pairs(self.dockedShips) do
        if port.ship then
            table.insert(result, port.ship)
        end
    end
    return result
end

return Port
