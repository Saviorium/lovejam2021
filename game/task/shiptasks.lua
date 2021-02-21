local log  = require 'engine.logger' ("taskInnerDebug")
local Task = require "game.task.task"

local Tasks = {}
Tasks['goTo'] =
    function(ship, destination, destinationStorage)
        log(1, "Adding goto " .. destination:getCenter():__tostring() .." to ship " .. ship.name )
        return Task(
            "goto",
            function(dt)
                log(3, ship.name .. ": going to destination")
                ship:moveTo(dt, destination)
            end,
            function()
                log(3, ship.name .. ": checking if near destination")
                return ship:isNear(destination)
            end,
            function()
                log(1, ship.name .. ": ship trying to get in queue")
                destinationStorage.port:addShipToQueue(ship)
                ship.tasks:addTask(Tasks.waitUntilPortRelease(ship, destination, destinationStorage))
            end
        )
    end
Tasks['waitUntilPortRelease'] =
    function(ship, target, storage)
        log(3, ship.name .. ": Waiting until port will be released")
        return Task(
            "wait_until_port_will_be_released",
            function(dt)
                ship:moveAroundStation(dt, target)
            end,
            function()
                return storage.port.dockedShip == ship
            end,
            function()
                if storage.port.direction == -1 then
                    ship.tasks:addTask(Tasks.waitUntilFullLoad(ship, storage))
                elseif storage.port.direction == 1 then
                    ship.tasks:addTask(Tasks.waitUntilFullUnLoad(ship, storage))
                end
            end
        )
    end
Tasks['waitAroundStation'] =
        function(ship, target, storage)
            log(3, ship.name .. ": Waiting until port will be released")
            return Task(
                "wait_until_port_will_be_released",
                function(dt)
                    ship:moveAroundStation(dt, target)
                end,
                function()
                    return ship.route
                end,
                function()
                    local target = ship.route.startStation
                    ship.tasks:addTask(Tasks.goTo(ship, target, target.outResources[ship.route.resourceTaking].storage))
                end
            )
        end
Tasks['waitUntilFullLoad'] =
    function(ship, storage)
        log(3, ship.name .. ": Waiting until full load")
        return Task(
            "wait_until_full_load",
            function(dt)
            end,
            function()
                return ship.storage.value == ship.storage.max
            end,
            function()
                storage.port.dockedShip = nil
                local target = ship.route.endStation
                ship.tasks:addTask(Tasks.goTo(ship, target, target.inResources[ship.route.resourceTaking].storage))
            end
        )
    end
Tasks['waitUntilFullUnLoad'] =
    function(ship, storage)
        log(1, ship.name .. ": Waiting until full unload")
        return Task(
            "wait_until_full_unload",
            function(dt)
            end,
            function()
                return ship.storage.value == 0
            end,
            function()
                storage.port.dockedShip = nil
                if ship.newRoute then
                    ship.route    = ship.newRoute
                    ship.newRoute = nil
                end
                local target = ship.route.startStation
                ship.tasks:addTask(Tasks.goTo(ship, target, target.outResources[ship.route.resourceTaking].storage))
            end
        )
    end


return Tasks
