local log = require "engine.logger"("taskInnerDebug")
local Task = require "game.task.task"

local Tasks = {}
Tasks["goTo"] = function(ship, destination, destinationStorage)
    log(1, "Adding goto " .. destination:getCenter():__tostring() .. " to ship " .. ship.name)
    return Task(
        "go to",
        function(dt)
            log(3, ship.name .. ": going to destination")
            ship:moveTo(dt, destination)
        end,
        function()
            log(3, ship.name .. ": checking if near destination")
            return ship:isNear(destination) or ship.newRoute
        end,
        function()
            if ship.newRoute then
                ship.storage.value = 0
                ship.route = ship.newRoute
                ship.newRoute = nil
                local target = ship.route.startStation
                ship.tasks:addTask(Tasks.goTo(ship, target, target.outResources[ship.route.resourceTaking].storage))
            else
                log(1, ship.name .. ": ship trying to get in queue")
                destinationStorage.port:addShipToQueue(ship)
                ship.tasks:addTask(Tasks.waitUntilPortRelease(ship, destination, destinationStorage))
            end
        end
    )
end
Tasks["waitUntilPortRelease"] = function(ship, target, storage)
    log(3, ship.name .. ": Waiting until port will be released")
    return Task(
        "wait until port will be released",
        function(dt)
            ship:moveAroundStation(dt, target)
        end,
        function()
            return not ship.route or storage.port:findShipInPort(ship) or ship.newRoute
        end,
        function()
            if ship.route then
                if ship.newRoute then
                    ship.storage.value = 0
                    ship.route = ship.newRoute
                    ship.newRoute = nil
                    local targetStation = ship.route.startStation
                    ship.tasks:addTask(
                        Tasks.goTo(ship, targetStation, targetStation.outResources[ship.route.resourceTaking].storage)
                    )
                else
                    ship:setVisible(false)
                    if storage.port.direction == -1 then
                        ship.tasks:addTask(Tasks.waitUntilFullLoad(ship, storage))
                    elseif storage.port.direction == 1 then
                        ship.tasks:addTask(Tasks.waitUntilFullUnLoad(ship, storage))
                    end
                end
            end
        end
    )
end
Tasks["waitAroundStation"] = function(ship, target)
    log(3, ship.name .. ": Waiting around station" .. target:tostring())
    return Task(
        "wait around station",
        function(dt)
            ship:moveAroundStation(dt, target)
        end,
        function()
            return ship.route
        end,
        function()
            ship.storage.value = 0
            local targetStation = ship.route.startStation
            ship.tasks:addTask(
                Tasks.goTo(ship, targetStation, targetStation.outResources[ship.route.resourceTaking].storage)
            )
        end
    )
end
Tasks["waitUntilFullLoad"] = function(ship, storage)
    log(3, ship.name .. ": Waiting until full load")
    ship:setResourceBar()
    return Task(
        "wait until full load",
        function(dt)
        end,
        function()
            return ship.storage.value == ship.storage.max or ship.newRoute or ship:isLeaving() or not ship.route
        end,
        function()
            storage.port:undockShip(ship)
            if ship.route then
                local target
                if ship.newRoute then
                    ship.storage.value = 0
                    ship.route = ship.newRoute
                    ship.newRoute = nil
                    target = ship.route.startStation
                else
                    target = ship.route.endStation
                end
                ship.tasks:addTask(Tasks.goTo(ship, target, target.inResources[ship.route.resourceTaking].storage))
            end
            ship:setVisible(true)
        end
    )
end
Tasks["waitUntilFullUnLoad"] = function(ship, storage)
    log(1, ship.name .. ": Waiting until full unload")
    ship:setResourceBar()
    return Task(
        "wait until full unload",
        function(dt)
        end,
        function()
            return ship.storage.value == 0 or ship:isLeaving() or not ship.route
        end,
        function()
            storage.port:undockShip(ship)
            if ship.route then
                if ship.newRoute then
                    ship.route = ship.newRoute
                    ship.newRoute = nil
                end
                local target = ship.route.startStation
                ship.tasks:addTask(Tasks.goTo(ship, target, target.outResources[ship.route.resourceTaking].storage))
            end
            ship:setVisible(true)
        end
    )
end

return Tasks
