local log  = require 'engine.logger' ("taskInnerDebug")

TaskList = Class {
    init = function(self, onEmpty)
        self:clear()
        self.onEmpty = onEmpty
    end
}

function TaskList:addTask(task)
    table.insert(self.tasks, task)
end

function TaskList:clear()
    self.tasks = {}
    self.currentTask = nil
end

function TaskList:isEmpty()
    return table.getn(self.tasks) < 1 and not self.currentTask
end

function TaskList:runTask(dt)
    if self:isEmpty() then
        if self.onEmpty then
            self:onEmpty()
        end
        return
    end
    if not self.currentTask then
        self.currentTask = table.remove(self.tasks)
    end
    if self.currentTask.run then

        self.currentTask.run(dt)
        log(1, "Doing task"..self.currentTask.name)

        if self.currentTask:isDone() then
            self.currentTask:onDone()
            log(1, "task is done: "..self.currentTask.name)
            self.currentTask = nil
        end

    end
end

return TaskList
