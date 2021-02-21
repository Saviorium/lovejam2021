local Selectable = Class {
    init = function(self, entity)
        self.entity = entity

        self.isHovered = false
        self.isSelected = false

        self.entity.setSelected = self.setSelected
        self.entity.setHover = self.setHover
    end
}

function Selectable:setSelected(bool)
    self.components.selectable.isSelected = bool
end

function Selectable:setHover(bool)
    self.components.selectable.isHovered = bool
end

function Selectable:draw()
    if self.isSelected and self.entity.drawSelected then
        self.entity:drawSelected()
    else
        if self.isHovered and self.entity.drawHovered then
            self.entity:drawHovered()
        end
    end
end

return Selectable