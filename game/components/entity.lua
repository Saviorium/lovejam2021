local Components = {
    selectable = require "game.components.selectable"
}

local Entity = Class {
    init = function(self)
        self.components = {}
    end
}

function Entity:addComponent(componentName)
    self.components[componentName] = Components[componentName](self)
end

function Entity:draw()
    for _, component in pairs(self.components) do
        if component.draw then
            component:draw()
        end
    end
end

return Entity