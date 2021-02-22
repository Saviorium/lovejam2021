local Vector = require("lib.hump.vector")

local MapGrid = require("game.map_grid")
local ResourcesData = require("data.resources_grid_data")
local Stations = require("game.station.stations")
local Ship = require("game.ship.ship")
local Route = require("game.route")
local WindowManager = require("game.ui.window_manager")
local NewStationButton = require("game.ui.new_station_button")
local ResourceBar = require("game.ui.resource_bar")
local BuildingStation = require("game.station.station")
local Clock = require("game.clock")

local StationBuilder = require("game.station.station_builder")
local RouteBuilder = require "game.route_builder"
local ShipAssigner = require "game.ship.ship_assigner"

-- local StationParameters = require("game.station.stations_parameters")

local World =
    Class {
    init = function(self)
        self.clock = Clock(1, 15)
        self.resourcesGrid = MapGrid(100, 100, ResourcesData)
        self.stations = {}
        self.routes = {}
        self.ships = {}
        self:populateOnInit()
        self.builders = {
            route = RouteBuilder(self)
        }
        self.camera = {
            position = Vector(-150, 800),
            zoom = 0.38
        }
        self.stationBuilder = StationBuilder(self)
        self.shipAssigner = ShipAssigner(self)
        self.uiManager = WindowManager()
        self:initUI()

        self.lifes = config.game.godMode and 99999 or 10
        self.disapointmentTimer = Timer.new()
    end
}

function World:populateOnInit()
    self:addResourceInRange(self.resourcesGrid:getGridCellAtCoords(Vector(500, 1000)), "ironOre", 1)
    table.insert(self.stations, Stations.oreDrill(self.resourcesGrid:clampToGrid(500, 1000)))
    table.insert(self.stations, Stations.ironAnvil(self.resourcesGrid:clampToGrid(1500, 1000)))
    table.insert(self.stations, Stations.buildShipsStation(self.resourcesGrid:clampToGrid(2500, 1000)))

    self:addResourceInRange(self.resourcesGrid:getGridCellAtCoords(Vector(500, 2200)), "ice", 1)
    table.insert(self.stations, Stations.iceDrill(self.resourcesGrid:clampToGrid(500, 2200)))
    table.insert(self.stations, Stations.milkStation(self.resourcesGrid:clampToGrid(1500, 2000)))
    table.insert(self.stations, Stations.cocoaFarm(self.resourcesGrid:clampToGrid(1500, 2500)))
    table.insert(self.stations, Stations.chocolateFabric(self.resourcesGrid:clampToGrid(2500, 2200)))

    self.stations["HubStation"] = Stations.hubStation(self.resourcesGrid:clampToGrid(4000, 4000), self)

    table.insert(self.ships, Ship(550, 1000):setRoute(self:addRoute(self.stations[1], self.stations[2])))
    table.insert(self.ships, Ship(1550, 1000):setRoute(self:addRoute(self.stations[2], self.stations[3])))

    table.insert(self.ships, Ship(550, 2250):setRoute(self:addRoute(self.stations[4], self.stations[5])))
    table.insert(self.ships, Ship(550, 2150):setRoute(self:addRoute(self.stations[4], self.stations[6])))

    table.insert(self.ships, Ship(1550, 2000):setRoute(self:addRoute(self.stations[5], self.stations[7])))

    table.insert(self.ships, Ship(1550, 2550):setRoute(self:addRoute(self.stations[6], self.stations[7])))
    table.insert(self.ships, Ship(1550, 2450):setRoute(self:addRoute(self.stations[6], self.stations[5])))

    table.insert(self.ships, Ship(2550, 2200):setRoute(self:addRoute(self.stations[7], self.stations["HubStation"])))
end

function World:addRoute(from, to)
    if not from or not to then
        return
    end
    self.routes[from] = self.routes[from] or {}
    self.routes[from][to] = self.routes[from][to] or Route(from, to)
    return self.routes[from][to]
end

function World:deleteRoute(routeToDel)
    for routeFrom, routesFrom in pairs(self.routes) do
        for routeTo, route in pairs(routesFrom) do
            if routeToDel == route then
                self.routes[routeFrom][routeTo] = nil
            end
        end
    end
    for _, ship in pairs(self.ships) do
        if ship.route == routeToDel then
            ship:flyAroundStation(routeToDel.endStation)
        end
    end
end

function World:initUI()
    local index = 1
    for stationName, station in pairs(Stations) do
        if stationName ~= "hubStation" then
            self.uiManager:registerObject(
                "New" .. stationName .. "Button",
                NewStationButton(
                    {
                        position = Vector(0, love.graphics.getHeight() - 74 * index),
                        tag = "New" .. stationName .. "Button",
                        targetStation = station,
                        startCallback = function()
                            self.stationBuilder:startBuild(stationName)
                        end,
                        endCallback = function()
                            return self.stationBuilder:placeStation(stationName, self)
                        end,
                        stationName = stationName

                    }
                )
            )
            index = index + 1
        end
    end

    local resources = {}
    -- table.insert(resources, {resource = "iron", resourceSource = self.stations["HubStation"].inResources.iron})
    table.insert(resources, {resource = "dude", resourceSource = self.stations["HubStation"].outResources.dude})
    table.insert(resources, {resource = "ship", resourceSource = nil})
    table.insert(resources, {resource = "life", resourceSource = nil})
    self.uiManager:registerObject("Global resource bar", ResourceBar(love.graphics.getWidth(), 0, 3, resources, self, nil, nil, 16, 16))
end

function World:update(dt)
    self.clock:update(dt)
    self.disapointmentTimer:update(dt)
    if self.clock.dayChanged then
        for _, station in pairs(self.stations) do
            station:onTick(self)
        end
    end
    if self.clock.monthChanged then
        for _, station in pairs(self.stations) do
            if station.onMonthTick then
                station:onMonthTick()
            end
        end
    end

    self:handleInputMove()

    for _, station in pairs(self.stations) do
        station:setHover(false)
        station:update(dt)
    end
    for _, ship in pairs(self.ships) do
        ship:setHover(false)
    end
    for _, routesFrom in pairs(self.routes) do
        for _, route in pairs(routesFrom) do
            route:setSelectedToDelete(false)
        end
    end
    local stationSelected = self:selectStationAt(self:getMouseCoords())
    local routeSelected = self:selectRouteAt(self:getMouseCoords())
    local shipSelected = self:selectShipAt(self:getMouseCoords())

    if shipSelected then
        shipSelected:setHover(true)
    else
        if stationSelected and not self.shipAssigner:isActive() then
            stationSelected:setHover(true)
        end
    end
    if routeSelected and love.mouse.isDown(2) then
        routeSelected:setSelectedToDelete(true)
    end
    if self.builders.route:isBuilding() then
        self.builders.route:setDestination(stationSelected)
    end

    if self.shipAssigner:isActive() then
        self.shipAssigner:setRoute(routeSelected)
    end

    for _, ship in pairs(self.ships) do
        ship:update(dt)
    end
    self.uiManager:update(dt)
end

function World:draw()
    love.graphics.push()
    self:attachCamera()
    -- draw background
    self.resourcesGrid:draw()
    self.builders.route:draw()
    for _, routesFrom in pairs(self.routes) do
        for routeTo, route in pairs(routesFrom) do
            route:draw()
        end
    end
    for _, station in pairs(self.stations) do
        station:draw()
    end
    for _, ship in pairs(self.ships) do
        ship:draw()
    end
    self.stationBuilder:draw()

    for _, station in pairs(self.stations) do
        station.informationBoard:draw()
    end
    for _, ship in pairs(self.ships) do
        ship.informationBoard:draw()
    end
    local mouseCoords = self:getMouseCoords()
    if self.disapointment then
        love.graphics.draw(self.disapointmentIcon, self.stations.HubStation.x, self.stations.HubStation.y)
    end

    love.graphics.pop()
    self.uiManager:draw()
    self.shipAssigner:draw()
    if Debug.resourceDisplay then
        love.graphics.print(
            string.format("Resource iron: %d", self.resourcesGrid:getResourcesAtCoords(mouseCoords, "ironOre")),
            2,
            16
        )
        love.graphics.print(
            string.format("Resource ice: %d", self.resourcesGrid:getResourcesAtCoords(mouseCoords, "ice")),
            2,
            32
        )
    end
end

function World:wheelmoved(x, y)
    self:zoom(Vector(love.mouse.getPosition()), y)
end

function World:mousepressed(x, y, button)
    if not self.uiManager:mousepressed(x, y) and button == 1 then
        local ship = self:selectShipAt(self:getFromScreenCoord(Vector(x, y)))
        if ship and not self.shipAssigner:isActive() and ship:canBeAssigned() then
            self.shipAssigner:setShip(ship)
            return
        end
        local station = self:selectStationAt(self:getFromScreenCoord(Vector(x, y)))
        if station and not self.builders.route:isBuilding() then
            if station:canBuildRouteFrom() then
                self.builders.route:startBuilding(station)
            else
                if station:isProducing("ship") then
                    local newShip = station:getProduct("ship")
                    if newShip then
                        table.insert(self.ships, newShip)
                        self.shipAssigner:setShip(newShip)
                    end
                end
            end
            return
        end
    end
end

function World:mousereleased(x, y, button)

    local mouseCoords = self:getFromScreenCoord(Vector(x, y))
    local stationSelected = self:selectStationAt(mouseCoords)
    if stationSelected and stationSelected.index and button == 2 then
        self:deleteStation(stationSelected.index, stationSelected)
    end

    if not self.uiManager:mousereleased(x, y) then
        local station = self:selectStationAt(mouseCoords)
        if self.builders.route:isBuilding() then
            local from, to = self.builders.route:finishBuilding()
            self:addRoute(from, to)
        end
        if self.shipAssigner:canAssign() then
            local ship, route = self.shipAssigner:assign()
            if ship and route then
                ship:setRoute(route)
            end
        end
        local route = self:selectRouteAt(mouseCoords)
        if button == 2 and route then
            self:deleteRoute(route)
        end
    end
    self.shipAssigner:reset()
    self.builders.route:stopBuilding()
end

function World:getMouseCoords()
    return self:getFromScreenCoord(Vector(love.mouse.getPosition()))
end

function World:zoom(screenPoint, zoomSize)
    if zoomSize > 0 and self.camera.zoom > config.camera.zoomMax then -- zoom in
        return
    end
    if zoomSize < 0 and self.camera.zoom < config.camera.zoomMin then -- zoom out
        return
    end
    local zoomUnit = -config.camera.zoomRate
    local pointInWorldCoordinates = self:getFromScreenCoord(screenPoint)
    self.camera.position = self.camera.position - (pointInWorldCoordinates - self.camera.position) * zoomUnit * zoomSize
    self.camera.zoom = self.camera.zoom / (1 + zoomSize * zoomUnit)
end

function World:handleInputMove()
    local inputPosition = Vector(love.mouse.getPosition())
    if love.keyboard.isDown("space") or love.mouse.isDown(3) then
        self:move(inputPosition - self.lastInputPosition)
    end
    self.lastInputPosition = inputPosition
end

function World:move(dPos)
    self.camera.position = self.camera.position - dPos / self.camera.zoom
end

function World:selectStationAt(point)
    for _, station in pairs(self.stations) do
        if (station:getCenter() - point):len() < config.selection.stationSize then
            return station
        end
    end
end

function World:deleteStationAt(point)
    for ind, station in pairs(self.stations) do
        if (station:getCenter() - point):len() < config.selection.stationSize then
            self:deleteStation(ind, station)
        end
    end
end

function World:deleteStation(ind, station)
    table.remove(self.stations, ind)
    if self.routes[station] then
        for _, route in pairs(self.routes[station]) do
            self:deleteRoute(route)
        end
    end
    for routeFrom, routesFrom in pairs(self.routes) do
        for routeTo, route in pairs(routesFrom) do
            if routeTo == station then
                self:deleteRoute(route)
            end
        end
    end
end

function World:selectShipAt(point)
    for _, ship in pairs(self.ships) do
        if (ship:getCenter() - point):len() < config.selection.shipSize then
            return ship
        end
    end
end

function World:selectRouteAt(point)
    for _, routesFrom in pairs(self.routes) do
        for routeTo, route in pairs(routesFrom) do
            if route:getDistanceTo(point) < config.selection.routeDistance then
                return route
            end
        end
    end
end

function World:getFromScreenCoord(screenPoint)
    local unitsPerPixel = 1 / self.camera.zoom
    return self.camera.position + (screenPoint * unitsPerPixel)
end

function World:attachCamera()
    local transform = love.math.newTransform()
    transform:scale(self.camera.zoom):translate((-self.camera.position):unpack())
    love.graphics.applyTransform(transform)
end

function World:descreaseLives()
    self.lifes = self.lifes - 1
    self:showDisapointment()
    if self.lifes == 0 then
        StateManager.switch(states.end_game, self)
    end
end

function World:showDisapointment()
    self.disapointment = true
    self.disapointmentIcon = AssetManager:getImage('disapointment_icon')
    self.disapointmentTimer:after(3,function() self.disapointment = false end)
end

function World:isThereLeftAnyDudes()
    return (self.stations.HubStation.outResources.dude.storage.value - #self.stations) > 0
end

function World:addResourceInRange(position, resource, range)
    for i = -range, range, 1 do
        for j = -range, range, 1 do
            self.resourcesGrid:setResources(position.x + i, position.y + j, 1000, resource)
        end
    end
end

function World:canGetResourceInRange(position, resource, range, unitsToGet)
    local result = false
    for i = -range, range, 1 do
        for j = -range, range, 1 do
            local pos = Vector(position.x + i * self.resourcesGrid.gridSize, position.y + j * self.resourcesGrid.gridSize)
            local resourcesLeft = self.resourcesGrid:getResourcesAtCoords(pos, resource)
            if resourcesLeft > unitsToGet then
                result = true
            end
        end
    end
    return result
end

function World:getResourceInRange(position, resource, range, unitsToGet)
    for i = -range, range, 1 do
        for j = -range, range, 1 do
            local pos = Vector(position.x + i * self.resourcesGrid.gridSize, position.y + j * self.resourcesGrid.gridSize)
            local resourcesLeft = self.resourcesGrid:getResourcesAtCoords( pos, resource )
            if resourcesLeft > unitsToGet then
                local cellCoords = self.resourcesGrid:getGridCellAtCoords(pos)
                self.resourcesGrid:setResources(cellCoords.x, cellCoords.y, resourcesLeft - unitsToGet, resource)
                return true
            end
        end
    end
end

function World:findStationsInRange(position, range)
    for _, station in pairs(self.stations) do
        local stationCellCoords = self.resourcesGrid:getGridCellAtCoords(Vector(station.x, station.y))
        if stationCellCoords.x >= position.x - range and stationCellCoords.x <= position.x + range and
           stationCellCoords.y >= position.y - range and stationCellCoords.y <= position.y + range
         then
            return station
        end
    end
    return nil
end

return World
