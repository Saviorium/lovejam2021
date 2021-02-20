local Vector = require("lib.hump.vector")

local MapGrid          = require("game.map_grid")
local ResourcesData    = require("data.resources_grid_data")
local Stations         = require("game.station.stations")
local Ship             = require("game.ship.ship")
local Route            = require("game.route")
local WindowManager    = require("game.ui.window_manager")
local NewStationButton = require("game.ui.new_station_button")
local BuildingStation  = require("game.station.station")
local StationBuilder   = require("game.station.station_builder")

-- local StationParameters = require("game.station.stations_parameters")

local World = Class {
    init = function(self)
        self.resourcesGrid = MapGrid(100, 100, ResourcesData)
        self.stations = {}
        self.routes = {}
        self.ships = {}
        self:populateOnInit()
        self.camera = {
            position = Vector(0, 0),
            zoom = 1
        }
        self.stationBuilder = StationBuilder()
        self.uiManager = WindowManager()
        local index = 1
        for stationName, station in pairs(Stations) do
            if stationName ~= 'cityStation' and stationName ~= 'buildShipsStation' then
                self.uiManager:registerObject(
                'New' .. stationName .. 'Button',
                NewStationButton(
                                    {
                                    position = Vector(0, love.graphics.getHeight() - 64*index),
                                    tag = 'New' .. stationName .. 'Button',
                                    targetStation = station,
                                    startCallback =
                                        function ()
                                            print('Im here')
                                            self.stationBuilder:startBuild( stationName )
                                        end,
                                    missCallback  =
                                        function ()
                                            print('Now im not')
                                            local mouseCoords = self:getFromScreenCoord(Vector(love.mouse.getPosition()))
                                            if self.stationBuilder.buildingStation == stationName then
                                                if (self.stationBuilder.buildingStation == 'oreDrill' and self.resourcesGrid:getResourcesAtCoords(mouseCoords, "iron") == 0) 
                                                or (self.stationBuilder.buildingStation == 'cocoaFarm' and self.resourcesGrid:getResourcesAtCoords(mouseCoords, "ice") == 0) then
                                                    self.stationBuilder.buildingStation = nil
                                                else
                                                    local stationIndex = #self.stations + 1
                                                    self.stations[stationIndex] = self.stationBuilder:placeStation(mouseCoords, station, self, stationIndex)
                                                end
                                            end
                                        end,
                                    }
                                )
                )
                index = index + 1
            end
        end
    end
}

function World:populateOnInit()
    table.insert( self.stations, Stations.oreDrill(self.resourcesGrid:clampToGrid(534, 234)))
    table.insert( self.stations, Stations.ironAnvil(self.resourcesGrid:clampToGrid(100, 200)))
    table.insert( self.stations, Stations.milkStation(self.resourcesGrid:clampToGrid(100, 300)))
    table.insert( self.stations, Stations.cocoaFarm(self.resourcesGrid:clampToGrid(100, 400)))
    table.insert( self.stations, Stations.chocolateFabric(self.resourcesGrid:clampToGrid(457, 500)))

    table.insert( self.ships, Ship(150, 300, Route(self.stations[1], self.stations[2])) )
    table.insert( self.ships, Ship(150, 350, Route(self.stations[3], self.stations[5])) )
    table.insert( self.ships, Ship(150, 350, Route(self.stations[3], self.stations[5])) )
end

function World:update(dt)
    if Clock.dayChanged then
        for _, station in pairs(self.stations) do
            station:onTick()
        end
    end
    self:handleInputMove()
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

    local mouseCoords = self:getFromScreenCoord(Vector(love.mouse.getPosition()))
    love.graphics.pop()
    self.uiManager:draw()
    love.graphics.print(string.format("Resource iron: %d", self.resourcesGrid:getResourcesAtCoords(mouseCoords, "iron")), 2, 16)
    love.graphics.print(string.format("Resource ice: %d", self.resourcesGrid:getResourcesAtCoords(mouseCoords, "ice")), 2, 32)
end

function World:wheelmoved(x, y)
    self:zoom(Vector(love.mouse.getPosition()), y)
end

function World:mousepressed(x, y)
    self.uiManager:mousepressed(x, y)
end

function World:mousereleased(x, y)
    self.uiManager:mousereleased(x, y)
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
    self.camera.zoom = self.camera.zoom / (1 + zoomSize * zoomUnit);
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

function World:getFromScreenCoord(screenPoint)
    local unitsPerPixel = 1/self.camera.zoom
    return self.camera.position + (screenPoint * unitsPerPixel)
end

function World:attachCamera()
    local transform = love.math.newTransform()
    transform
        :scale( self.camera.zoom )
        :translate( (-self.camera.position):unpack() )
    love.graphics.applyTransform(transform)
end

return World