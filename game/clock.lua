local Clock = Class {
    init = function(self, secsInDay, daysInMonth)

        self.secsInDay = secsInDay
        self.daysInMonth = daysInMonth

        self.day = 1
        self.month = 1

        self.timer = 0
    end
}

function Clock:tostring()
    return os.date(self.dateFormat, self.time)
end

function Clock:update(dt)
    self.dayChanged, self.monthChanged = false, false
    self.timer = self.timer + dt
    if self.timer >= self.secsInDay then
        self.day = self.day + 1
        self.timer = 0
        self.dayChanged = true
        if self.day % self.daysInMonth == 0 then
            self.month = self.month + 1
            self.monthChanged = true
        end
    end
end


return Clock