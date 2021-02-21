local serpent = require "lib.debug.serpent"
Debug = {
    showFps = 1,
    showStatesLoadSave = 0,
    stationsInnerDebug = 0,
    stationsDrawDebug = true,
    storagesInnerDebug = 0,
    storagesDrawDebug = false,
    shipInnerDebug = 0,
    shipDrawDebug = false,
    taskInnerDebug = 1,
    routeBuilder = 1,
    shipAssigner = 1
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
