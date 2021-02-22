config = {
    camera = {
        zoomRate = 0.2, -- more - faster
        zoomMin = 0.3,
        zoomMax = 5
    },
    colors = {
        uiBackground = {0.8, 0.8, 0.8},
        uiBackgroundDarker = {0.7, 0.7, 0.7},
        selected = {0.5, 0.9, 0.2, 1},
        hover = {0.6, 1, 0.4, 0.5},
        delete = {0.8, 0.2, 0.2},
        noResource = {0.1, 0.1, 0.1},
        infoTextColor = {0.1, 0.1, 0.1}
    },
    selection = {
        border = 4,
        stationSize = 80,
        shipSize = 30,
        routeDistance = 900 -- squared
    },
    game = {
        speed = 3,
        infobarsTimeToAppear = 0.5,
        infobarsTimeToDisapear = 1,
        godMode = false
    },
    map = {
        style = 'grid', -- circle grid image,
        starsCount = 1000
    }
}

function love.conf(t)
    t.window.title = "lovejam2021"
    t.window.width = 1366
    t.window.height = 768
    t.identity = "lovejam2021"
end