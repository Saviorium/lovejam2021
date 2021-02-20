config = {
    camera = {
        zoomRate = 0.2, -- more - faster
        zoomMin = 0.5,
        zoomMax = 5
    },
    selection = {
        colorSelected = {0.5, 0.9, 0.2, 1},
        colorHover = {0.4, 0.6, 0.1, 1},
        border = 4,
        stationSize = 50
    }
}

function love.conf(t)
    t.window.title = "lovejam2021"
    t.window.width = 1366
    t.window.height = 768
    t.identity = "lovejam2021"
end