local log = require "engine.logger"("storagesInnerDebug")

local Port =
    Class {
    init = function(self, storage, loadSpeed, direction)
        self.shipsQueue = {}
        self.dockedShip = nil
        self.loadSpeed = nvl(loadSpeed, 100)
        self.direction = direction -- in = 1, out = -1
        self.storage = storage
    end
}

function Port:onTick()
    self:getShipToPort()

    log(1, "Port checking docked ship")
    if self.dockedShip then
        log(
            1,
            "Port started transport resources",
            self.direction == 1 and self.storage:canPut(self.loadSpeed) or self.storage:canGet(self.loadSpeed)
        )
        if
            (self.direction == 1 and self.storage:canPut(self.loadSpeed)) or
                (self.direction == -1 and self.storage:canGet(self.loadSpeed))
         then
            print(self.storage:canPut(self.loadSpeed), self.storage:canGet(self.loadSpeed))
            self.dockedShip.storage:addAndGetExcess(-self.direction * self.loadSpeed)
            self.storage:addAndGetExcess(self.direction * self.loadSpeed)
        end
    end
end

function Port:addShipToQueue(ship)
    log(2, "Port added ship in queue")
    table.insert(self.shipsQueue, ship)
end

function Port:getShipToPort()
    log(2, "Port trying to dock ship in port ")
    if not self.dockedShip then
        self.dockedShip = table.remove(self.shipsQueue, 1)
        if self.dockedShip then
            log(1, "Port docked ship ")
        end
    end
end

return Port
