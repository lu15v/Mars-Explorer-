mineral = {}
minerals_controller = {}
minerals_controller.minerals = {}
minerals_controller.gem = love.graphics.newImage("images/gem.png")

function minerals_controller:spawnMineral(x, y)
  mineral = {}
  mineral.x = x
  mineral.y = y
  mineral.width = self.gem:getWidth()
  mineral.heigth = self.gem:getHeight()
  table.insert(self.minerals, mineral)

end
