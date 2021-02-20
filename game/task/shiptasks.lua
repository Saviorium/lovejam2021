local log  = require 'engine.logger' ("taskInnerDebug")
local Task = require "game.task.task"

local Tasks = {
    goTo = function(ship, destination, destinationStorage)
        log(1, "Adding goto to ship")
        log(4, "Adding goto to ship",ship )
        return Task(
            "goto",
            function(dt)
                log(1, "Going to destignation in")
                ship:moveTo(dt, destination)
            end,
            function()
                log(1, "Checking if near destignation")
                return ship:isNear(destination)
            end,
            function()
                log(1, "Ship trying to get in queue ", destinationStorage)
                destinationStorage:addShipToQueue(ship)
                ship.tasks:addTask(Tasks.waitUntilPortRelease(ship, destinationStorage))
            end
        )
    end,
    waitUntilPortRelease = function(ship, storage)
        return Task(
            "wait_until_port_will_be_released",
            function(dt)
            end,
            function()
                return station.port == ship
            end,
            function()
                if storage.direction == 1 then
                    ship.tasks:addTask(Tasks.waitUntilFullLoad(ship))
                elseif storage.direction == -1 then
                    ship.tasks:addTask(Tasks.waitUntilFullUnLoad(ship))
                end
            end
        )
    end,
    waitUntilFullLoad = function(ship)
        return Task(
            "wait_until_full_load",
            function(dt)
            end,
            function()
                return ship.storage.value == max
            end,
            function()
                local target = ship.way.endStation
                ship.tasks:addTask(Tasks.goTo(ship, target, target.inResources[ship.way.resourceTaking]))
            end
        )
    end,
    waitUntilFullUnLoad = function(ship)
        return Task(
            "wait_until_full_unload",
            function(dt)
            end,
            function()
                return ship.storage.value == 0
            end,
            function() 
                local target = ship.way.startStation
                ship.tasks:addTask(Tasks.goTo(ship, target, target.outResources[ship.way.resourceTaking]))
            end
        )
    end,
}

return Tasks
