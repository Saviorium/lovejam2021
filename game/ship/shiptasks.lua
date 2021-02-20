local Tasks = {
    goto = function(ship, destination)
        if not destination then
            print("Destination is nil")
            return 
        end
        return Task(
            "goto",
            function(self, dt)
                ship:moveTo(dt, destination)
            end,
            function()
                return ship:isNear(destination)
            end
        )
    end,
    stayStill = function(ship)
        return Task(
            "stay_still",
            function(dt)
            end,
            function()
                return false
            end
        )
    end,
    buyFromStation = function(ship, station, resource, amount)
        if not station then
            print("Station is nil")
            return 
        end
        return Task(
            "buy_from_station",
            function(dt)
                ship:buyFromStation(station, resource, amount)
            end,
            function()
                return true
            end
        )
    end,
    sellToStation = function(ship, station, resource, amount)
        if not station then
            print("Station is nil")
            return 
        end
        return Task(
            "sell_to_station",
            function(dt)
                ship:sellToStation(station, resource, amount)
            end,
            function()
                return true
            end
        )
    end
}

return Tasks
