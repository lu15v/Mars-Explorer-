obstacle = {}
obstacles_controller = {}
obstacles_controller.obstacles = {}
obstacles_controller.obstacle = love.graphics.newImage("images/obstacle.png")

function obstacles_controller:spawnObstacle(x, y)
  obstacle = {}
  obstacle.x = x
  obstacle.y = y
  obstacle.width = self.obstacle:getWidth()
  obstacle.heigth = self.obstacle:getHeight()
  table.insert(self.obstacles, obstacle)

end
