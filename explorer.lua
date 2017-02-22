explorer = {}
explorers_controller = {}
explorers_controller.explorers = {}
explorers_controller.rob = love.graphics.newImage("images/ROB1.png")


function explorers_controller:spawnExplorer(x, y, n)
  explorer = {}
  explorer.x = x
  explorer.y = y
  explorer.capacity = 4
  explorer.recolected = 0
  explorer.number = n
  explorer.time = love.timer.getTime()
  explorer.timeRunning = 0
  explorer.battery = 10000
  explorer.Charging = 0
  explorer.alarm = false
  explorer.movementX = 0.2
  explorer.movementY = 0.2
  explorer.width = self.rob:getWidth()
  explorer.heigth = self.rob:getHeight()
  table.insert(self.explorers, explorer)
end
