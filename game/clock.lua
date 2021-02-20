Class = require "lib.hump.class"

Clock = Class {
    init = function(self, initDate, secPerRealSec)
        self.time = os.time(initDate)
        self.rate = secPerRealSec
        self.dateFormat = "%d.%m.%Y"

        self.timeInDay = 5
        self.daysInMonth = 15

        self.day = 1
        self.month = 1

        self.dayCounter = 0
        self.monthCounter = 0
    end
}

function Clock:tostring()
    return os.date(self.dateFormat, self.time)
end

function Clock:update(dt)
    local dayChanged, monthChanged = false, false
    self.dayCounter = self.dayCounter + dt
    if self.dayCounter >= self.timeInDay then
        self.day = self.day + 1
        self.dayCounter = 0
        dayChanged = true
    end
end


return Clock