spacecraft = {}
spacecrafts_controller = {}
spacecrafts_controller.spacecrafts = {}
spacecrafts_controller.spacecraft = love.graphics.newImage("images/milleniumFalcon50.png")

function spacecrafts_controller:spawnspacecraft(x, y)
  spacecraft = {}
  spacecraft.x = x
  spacecraft.y = y
  spacecraft.width = self.spacecraft:getWidth()
  spacecraft.heigth = self.spacecraft:getHeight()
  table.insert(self.spacecrafts, spacecraft)

end
