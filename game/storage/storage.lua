
local log = require 'engine.logger' ("storagesInnerDebug")

-- Абстрактный склад с ресурсом
local Storage = Class {
    init = function(self, max, initial, resource, loadSpeed, direction)
        self.max = max
        self.value = nvl(initial, 0)
        self.resource = resource
        self.shipsQueue = {}

        self.port = nil

        self.loadSpeed = nvl(loadSpeed, 0)
        self.direction = direction -- in = 1, out = -1
    end
}

function Storage:onTick()
    self:getShipToPort()

    if self.port then
        if self.port.storage:addAndGetExcess( -self.direction * self.loadSpeed ) == 0
       and self:addAndGetExcess(self.direction * self.loadSpeed ) == 0
      then
            self.port = nil
            self:getShipToPort()
        end
    end
end

function Storage:addAndGetExcess(units)
    local newValue = self.value + units
    if newValue > self.max then
        self.value = self.max
        return newValue - self.max
    end
    if newValue < 0 then
        self.value = 0
        return newValue
    end
    self.value = newValue
    return 0
end

function Storage:canGet(units)
    local newValue = self.value - units
    return not (newValue < 0)
end

function Storage:canPut(units)
    local newValue = self.value + units
    return not (newValue > self.max)
end

function Storage:addShipToQueue(ship)
    log(2, "Storage added ship " .. ship .. " in queue")
    table.insert(self.shipsQueue, ship)
end

function Storage:getShipToPort()
    if not self.port then
        log(2, "Storage ported ship " .. ship)
        self.port = table.remove(self.tasks)
    end
end

return Storage
