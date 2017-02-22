crumb = {}
crumbs_controller = {}
crumbs_controller.crumbs = {}
crumbs_controller.crumb = love.graphics.newImage("images/crumb1.png")

function crumbs_controller:spawnCrumb(x, y)
  crumb = {}
  crumb.x = x
  crumb.y = y
  crumb.visible = false
  crumb.width = self.crumb:getWidth()
  crumb.heigth = self.crumb:getHeight()
  table.insert(self.crumbs, crumb)

end
