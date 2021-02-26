local Task = require "game.task.task"

local Tasks = {}
Tasks["goTo"] = function(ship, destination, destinationStorage)
    ship.log(3, "Adding goto " .. destination:getCenter():__tostring() .. " to ship " .. ship.name)
    return Task(
        "go to",
        function(dt)
            ship:moveTo(dt, destination)
        end,
        function()
            return ship:isNear(destination) or ship.newRoute
        end,
        function()
            if ship.newRoute then
                ship.log(2, ship.name .. " ship get new route "..ship.newRoute.name)
                ship.storage.value = 0
                ship.route = ship.newRoute
                ship.newRoute = nil
                local target = ship.route.startStation
                ship.tasks:addTask(Tasks.goTo(ship, target, target.outResources[ship.route.resourceTaking].storage))
            else
                ship.log(2, ship.name .. ": ship trying to get in queue on port "..destinationStorage.port.name)
                destinationStorage.port:addShipToQueue(ship)
                ship.tasks:addTask(Tasks.waitUntilPortRelease(ship, destination, destinationStorage))
            end
        end
    )
end
Tasks["waitUntilPortRelease"] = function(ship, target, storage)
    ship.log(3, ship.name .. ": Waiting until port "..target:tostring().. " will be released ")
    return Task(
        "wait until port will be released",
        function(dt)
            ship:moveAroundStation(dt, target)
        end,
        function()
            return storage.port:findShipInPort(ship) or ship.newRoute
        end,
        function()
            if ship.route then
                if ship.newRoute then
                    ship.log(2, ship.name .. " ship get new route "..ship.newRoute.name)
                    storage.port:leavePort(ship)
                    storage.port:undockShip(ship)
                    ship.storage.value = 0
                    ship.route = ship.newRoute
                    ship.newRoute = nil
                    local targetStation = ship.route.startStation
                    ship.tasks:addTask(
                        Tasks.goTo(ship, targetStation, targetStation.outResources[ship.route.resourceTaking].storage)
                    )
                else
                    ship.log(2, ship.name .. " docked to "..storage.port.name)
                    ship:setVisible(false)
                    if storage.port.direction == -1 then
                        ship.tasks:addTask(Tasks.waitUntilFullLoad(ship, storage))
                    elseif storage.port.direction == 1 then
                        ship.tasks:addTask(Tasks.waitUntilFullUnLoad(ship, storage))
                    end
                end
            else
                storage.port:leavePort(ship)
                storage.port:undockShip(ship)
            end
        end
    )
end
Tasks["waitAroundStation"] = function(ship, target)
    ship.log(3, ship.name .. ": Waiting around station" .. target:tostring())
    return Task(
        "wait around station",
        function(dt)
            ship:moveAroundStation(dt, target)
        end,
        function()
            return ship.route or ship.newRoute
        end,
        function()
            ship.log(2, ship.name .. " got new route and going to " .. target:tostring())
            ship.storage.value = 0
            ship.route = nvl(ship.newRoute, ship.route)
            ship.newRoute = nil 
            local targetStation = ship.route.startStation
            ship.tasks:addTask(
                Tasks.goTo(ship, targetStation, targetStation.outResources[ship.route.resourceTaking].storage)
            )
        end
    )
end
Tasks["waitUntilFullLoad"] = function(ship, storage)
    ship.log(3, ship.name .. ": Waiting until full load on storage "..storage.port.name)
    ship:setResourceBar()
    return Task(
        "wait until full load",
        function(dt)
        end,
        function()
            return ship.storage.value == ship.storage.max or ship.newRoute or ship:isLeaving()
        end,
        function()            
            storage.port:undockShip(ship)
            if ship.route then
                local target
                if ship.newRoute then
                    ship.storage.value = 0
                    ship.route = ship.newRoute
                    target = ship.route.startStation
                    ship.log(2, ship.name .. " got new route " .. ship.newRoute.name.." and going to "..target:tostring())
                    ship.newRoute = nil
                else
                    target = ship.route.endStation
                    ship.log(2, ship.name .. " ship now undocking and going to "..target:tostring())
                end
                ship.tasks:addTask(Tasks.goTo(ship, target, target.inResources[ship.route.resourceTaking].storage))
            end
            ship:setVisible(true)
        end
    )
end
Tasks["waitUntilFullUnLoad"] = function(ship, storage)
    ship.log(3, ship.name .. ": Waiting until full unload on storage "..storage.port.name)
    ship:setResourceBar()
    return Task(
        "wait until full unload",
        function(dt)
        end,
        function()
            return ship.storage.value == 0 or ship:isLeaving()
        end,
        function()
            storage.port:undockShip(ship)
            if ship.route then
                if ship.newRoute then
                    ship.route = ship.newRoute
                    ship.newRoute = nil
                end
                local target = ship.route.startStation
                ship.log(2, ship.name .. " ship now undocking and going to "..target:tostring())
                ship.tasks:addTask(Tasks.goTo(ship, target, target.outResources[ship.route.resourceTaking].storage))
            end
            ship:setVisible(true)
        end
    )
end

return Tasks
