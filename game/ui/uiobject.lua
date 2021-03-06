
local UIobject = Class {
    init = function(self, x, y, width, height, tag, position)
        self.x = nvl(x, 0)
        self.y = nvl(y, 0)
        self.width = width and width or 0
        self.height = height and height or 0
        -- Название объекта
        self.tag = tag
        -- Параметры для выполнения действий с объектом, обозначены тут и есть у любого объекта, 
        -- возможно лучше объявить им базовые значения, а то что они есть что их нет, разницы по коду нет
        self.startHoldInteraction = nil
        self.endtHoldInteraction = nil
        self.clickInteraction = nil
        -- Позиционирование, неоходимо для отображения в WM, Если fixed значит как указаны X и Y так и будет по тем координатам на экране расположен объект
        -- если relative, то X и Y берутся как указания "как относительно другого объекта расположен этот"
        -- положительное значение - справа, ниже, отрицательные - слева, выше
        self.position = position and position or 'fixed'
        self.isPressed = false
    end
}
-- Всем объектам надо уметь понимать случилась ли коллизия, причем не важно с мышкой или чем-то ещё
function UIobject:getCollision(x, y)
    return 	self.x < x and
            (self.x + self.width) > x and
            self.y < y and
            (self.y + self.height) > y
end
-- Указан отдельный объект чтобы логика указанная в Draw была сквозной, а опциональная была в render
function UIobject:render()
end

function UIobject:drawObject(x, y, angle, width, height)
end

function UIobject:draw()
    self:render()
end

function UIobject:update(dt)
end

return UIobject