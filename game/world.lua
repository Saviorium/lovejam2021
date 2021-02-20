local Vector = require("lib.hump.vector")

local MapGrid       = require("game.map_grid")
local ResourcesData = require("data.resources_grid_data")
local Stations      = require("game.station.stations")
local Ship          = require("game.ship.ship")
local Way           = require("game.way")

-- local StationParameters = require("game.station.stations_parameters")

local World = Class {
    init = function(self)
        self.resourcesGrid = MapGrid(100, 100, ResourcesData)
        self.stations = {}
        self.ships = {}
        self:populateOnInit()
        self.camera = {
            position = Vector(0, 0),
            zoom = 1
        }
    end
}

function World:populateOnInit()
    table.insert( self.stations, Stations.oreDrill(self.resourcesGrid:clampToGrid(100, 100)))
    table.insert( self.stations, Stations.ironAnvil(self.resourcesGrid:clampToGrid(100, 200)))
    table.insert( self.stations, Stations.milkStation(self.resourcesGrid:clampToGrid(100, 300)))
    table.insert( self.stations, Stations.cocoaFarm(self.resourcesGrid:clampToGrid(100, 400)))
    table.insert( self.stations, Stations.chocolateFabric(self.resourcesGrid:clampToGrid(100, 500)))

    table.insert( self.ships, Ship(150, 300, Way(self.stations[1], self.stations[2])) )
    table.insert( self.ships, Ship(150, 350, Way(self.stations[3], self.stations[5])) )
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
end

function World:draw()
    love.graphics.push()
    self:attachCamera()
    -- draw background
    self.resourcesGrid:draw()
    for _, station in pairs(self.stations) do
        station:draw()
    end
    for _, ship in pairs(self.ships) do
        ship:draw()
    end

    local mouseCoords = self:getFromScreenCoord(Vector(love.mouse.getPosition()))
    love.graphics.pop()

    love.graphics.print(string.format("Resource iron: %d", self.resourcesGrid:getResourcesAtCoords(mouseCoords, "iron")), 2, 16)
end

function World:wheelmoved(x, y)
    self:zoom(Vector(love.mouse.getPosition()), y)
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