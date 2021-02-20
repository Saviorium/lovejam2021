config = {
    camera = {
        zoomRate = 0.2, -- more - faster
        zoomMin = 0.5,
        zoomMax = 5
    }
}

function love.conf(t)
    t.window.title = "lovejam2021"
    t.window.width = 1366
    t.window.height = 768
    t.identity = "lovejam2021"
end