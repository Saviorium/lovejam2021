local serpent = require "lib.debug.serpent"
Debug = {
    showFps = 0,
    mousePos = 0,
    showStatesLoadSave = 0,
    resourceGrid = 0,
    stationsInnerDebug = 1,
    stationsDrawDebug = false,
    storagesInnerDebug = 0,
    storagesDrawDebug = false,
    shipInnerDebug = 2,
    shipDrawDebug = false,
    taskInnerDebug = 0,
    routeBuilder = 0,
    shipAssigner = 1,
    portInnerDebug = 2,
    resourceDisplay = false
}

-- usage: vardump(x1, test, myVar) or vardump({ship = self, dt = dt})
vardump = function(...)
    local args = {...}
    print("================VARDUMP=====================")
    if #args == 1 then
        print(serpent.block(args))
    else
        for key, value in pairs(args) do
            if key then
                print(key .. ":")
            end
            print(serpent.block(value))
        end
    end
    print("============================================")
end

return Debug
