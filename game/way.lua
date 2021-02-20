Way = Class {
    init = function(self, startStation, endStation)
        self.startStation   = startStation
        self.endStation     = endStation
        for ind, name1 in pairs(self.endStation:getConsumingResources()) do
            for ind, name2 in pairs(self.startStation:getProductingResources()) do
                if name1 == name2 then
                    self.resourceTaking = name1
                end
            end
        end
    end
}

return Way
