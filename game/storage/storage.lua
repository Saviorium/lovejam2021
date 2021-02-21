local Port = require "game.storage.port"

-- Абстрактный склад с ресурсом
local Storage = Class {
    init = function(self, max, initial, resource, loadSpeed, direction)
        self.max = max
        self.value = nvl(initial, 0)
        self.resource = resource

        self.port = Port(self, loadSpeed, direction)
    end
}

function Storage:onTick()
    self.port:onTick()
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

return Storage
