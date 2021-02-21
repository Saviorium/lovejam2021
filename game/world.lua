local Vector = require("lib.hump.vector")

local MapGrid          = require("game.map_grid")
local ResourcesData    = require("data.resources_grid_data")
local Stations         = require("game.station.stations")
local Ship             = require("game.ship.ship")
local Route            = require("game.route")
local WindowManager    = require("game.ui.window_manager")
local NewStationButton = require("game.ui.new_station_button")
local ResourceBar      = require("game.ui.resource_bar")
local BuildingStation  = require("game.station.station")
local Clock            = require("game.clock")

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
            position = Vector(0, 0),
            zoom = 1
        }
        self.stationBuilder = StationBuilder(self)
        self.shipAssigner = ShipAssigner(self)
        self.uiManager = WindowManager()
        self:initUI()

        self.lifes = 10
    end
}

function World:populateOnInit()
    table.insert(self.stations, Stations.oreDrill(self.resourcesGrid:clampToGrid(534, 234)))
    table.insert(self.stations, Stations.ironAnvil(self.resourcesGrid:clampToGrid(100, 200)))
    table.insert(self.stations, Stations.milkStation(self.resourcesGrid:clampToGrid(100, 300)))
    table.insert(self.stations, Stations.cocoaFarm(self.resourcesGrid:clampToGrid(100, 400)))
    table.insert(self.stations, Stations.chocolateFabric(self.resourcesGrid:clampToGrid(457, 500)))

    self.stations['HubStation'] = Stations.hubStation(self.resourcesGrid:clampToGrid(800, 800), self)

    table.insert(self.ships, Ship(150, 300):setRoute(self:addRoute(self.stations[1], self.stations[2])))
    table.insert(self.ships, Ship(150, 350):setRoute(self:addRoute(self.stations[3], self.stations[5])))
    table.insert(self.ships, Ship(150, 500):setRoute(self:addRoute(self.stations[3], self.stations[5])))
end

function World:addRoute(from, to)
    if not from or not to then
        return
    end
    self.routes[from] = self.routes[from] or {}
    self.routes[from][to] = self.routes[from][to] or Route(from, to)
    return self.routes[from][to]
end

function World:initUI()
    local index = 1
    for stationName, station in pairs(Stations) do
        if stationName ~= "hubStation" then
            self.uiManager:registerObject(
                "New" .. stationName .. "Button",
                NewStationButton(
                    {
                        position = Vector(0, love.graphics.getHeight() - 64 * index),
                        tag = "New" .. stationName .. "Button",
                        targetStation = station,
                        startCallback = function() self.stationBuilder:startBuild(stationName) end,
                        endCallback = function() return self.stationBuilder:placeStation( stationName, self ) end
                    }
                )
            )
            index = index + 1
        end
    end
    
    local resources = {}
    table.insert(resources, {resource = 'iron', resourceSource = self.stations['HubStation'].inResources.iron})
    table.insert(resources, {resource = 'dude', resourceSource = self.stations['HubStation'].outResources.dude})
    table.insert(resources, {resource = 'ship', resourceSource = nil})
    table.insert(resources, {resource = 'life', resourceSource = nil})
    self.uiManager:registerObject('Global resource bar', ResourceBar(love.graphics.getWidth(), 0, 3, resources, self))
end

function World:update(dt)
    self.clock:update(dt)
    if self.clock.dayChanged then
        for _, station in pairs(self.stations) do
            station:onTick()
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
    end
    for _, ship in pairs(self.ships) do
        ship:setHover(false)
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

    local mouseCoords = self:getMouseCoords()
    love.graphics.pop()
    self.uiManager:draw()
    self.stationBuilder:draw()
    self.shipAssigner:draw()
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

function World:wheelmoved(x, y)
    self:zoom(Vector(love.mouse.getPosition()), y)
end

function World:mousepressed(x, y)
    if not self.uiManager:mousepressed(x, y) then
        local ship = self:selectShipAt(self:getFromScreenCoord(Vector(x, y)))
        if ship and not self.shipAssigner:isActive() and ship:canBeAssigned() then
            self.shipAssigner:setShip(ship)
            return
        end
        local station = self:selectStationAt(self:getFromScreenCoord(Vector(x, y)))
        if station and not self.builders.route:isBuilding() and station:canBuildRouteFrom() then
            self.builders.route:startBuilding(station)
            return
        end
    end
end

function World:mousereleased(x, y)
    if not self.uiManager:mousereleased(x, y) then
        local station = self:selectStationAt(self:getMouseCoords())
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
    if self.lifes then
        self.gameOver = true
    end
end

function World:isThereLeftAnyDudes()
    return (self.stations.HubStation.outResources.dude.storage.value - #self.stations) > 0
end

return World
