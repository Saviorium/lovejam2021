config = {
    camera = {
        zoomRate = 0.2, -- more - faster
        zoomMin = 0.5,
        zoomMax = 5
    },
    selection = {
        colorSelected = {0.5, 0.9, 0.2, 1},
        colorHover = {0.6, 1, 0.4, 1},
        colorDelete = {0.8, 0.2, 0.2},
        border = 4,
        stationSize = 50,
        shipSize = 10,
        routeDistance = 400 -- squared
    }
}

function love.conf(t)
    t.window.title = "lovejam2021"
    t.window.width = 1366
    t.window.height = 768
    t.identity = "lovejam2021"
end