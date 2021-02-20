local Task = Class {
    init = function(self, name, updateCallback, isDoneCallback, onDoneCallback)
        self.name = name
        self.run = updateCallback
        self.isDone = isDoneCallback
        self.onDone = onDoneCallback
    end
}

return Task
