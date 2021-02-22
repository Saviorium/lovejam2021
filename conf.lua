config = {
    camera = {
        zoomRate = 0.2, -- more - faster
        zoomMin = 0.5,
        zoomMax = 5
    },
    colors = {
        uiBackground = {0.8, 0.8, 0.8},
        uiBackgroundDarker = {0.7, 0.7, 0.7},
        selected = {0.5, 0.9, 0.2, 1},
        hover = {0.6, 1, 0.4, 0.5},
        delete = {0.8, 0.2, 0.2},
        noResource = {0.1, 0.1, 0.1}
    },
    selection = {
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