require("explorer")
require("mineral")
require("obstacle")
require("spacecraft")
require("crumb")

local xMovement = 0.2
local yMovement = 0.2

local xMovement2 = 0.2
local yMovement2 = 0.2

local xMovement3 = 0.2
local yMovement3 = 0.2


local limit = 2
local batteryLimit = 50
local capacity = 4
local batteryFull = 10000
local ubicationx = 5
local ubicationy = 5
local activeCooperativeMod = false


local pruebax = {}
local pruebay = {}

local saved = 0


function love.load()
  love.window.setMode(1000, 900, {resizable=true, vsync=false, minwidth=400, minheight=300})
  love.graphics.setBackgroundColor(231, 125, 17)
  love.window.setTitle("Mars Explorers")

  --crumbs locations
  for i = 50, 1, -1 do
    crumbs_controller:spawnCrumb(100, 100)
  end

--minerals up right
  for i = 10, 1, -1 do
    ranUX = love.math.random(10, 15)
    ranUY = love.math.random(10, 15)
    minerals_controller:spawnMineral(790 + ubicationx, 150 + ubicationy)

    ubicationx = ubicationx + ranUX
    ubicationy = ubicationy + ranUY
  end

 --Down right
  minerals_controller:spawnMineral(800, 640)
  minerals_controller:spawnMineral(790, 660)
  minerals_controller:spawnMineral(820, 670)
  minerals_controller:spawnMineral(835, 675)
  minerals_controller:spawnMineral(830, 695)
  minerals_controller:spawnMineral(810, 695)
  minerals_controller:spawnMineral(830, 720)
  minerals_controller:spawnMineral(835, 660)

 --middle right
  minerals_controller:spawnMineral(815, 450)
  minerals_controller:spawnMineral(790, 480)
  minerals_controller:spawnMineral(790, 450)
  minerals_controller:spawnMineral(830, 470)
  minerals_controller:spawnMineral(830, 490)

  --middle left
  minerals_controller:spawnMineral(70, 400)
  minerals_controller:spawnMineral(105, 405)
  minerals_controller:spawnMineral(135, 407)
  minerals_controller:spawnMineral(159, 417)


  ---down left
  minerals_controller:spawnMineral(90, 620)
  minerals_controller:spawnMineral(105, 639)
  minerals_controller:spawnMineral(135, 700)
  minerals_controller:spawnMineral(140, 650)


  --obstacles locations
  obstacles_controller:spawnObstacle(300, 500)
  obstacles_controller:spawnObstacle(720, 0)
  obstacles_controller:spawnObstacle(500, 600)
  obstacles_controller:spawnObstacle(400, 800)
  obstacles_controller:spawnObstacle(20, 350)
  obstacles_controller:spawnObstacle(700, 700)
  obstacles_controller:spawnObstacle(700, 300)

  --explorers locations
  explorers_controller:spawnExplorer(20, 20, 1)
  explorers_controller:spawnExplorer(30, 40, 2)
  explorers_controller:spawnExplorer(30, 40, 3)
  --spacecraft location
  spacecrafts_controller:spawnspacecraft(0,0)




end


function love.update(dt) --delta time


 --activate cooperative Mode
  if love.keyboard.isDown("e") then
    activeCooperativeMod = true
    print("Enabled Cooperative Mode")

  elseif love.keyboard.isDown("d") then
    activeCooperativeMod = false
    print("Disabled Cooperative Mode")
  elseif love.keyboard.isDown("q") then
    love.event.quit(0)
    print("PROGRAM ABORTED")
  end

  if saved == 0 then
    for i, m in ipairs(minerals_controller.minerals) do
    pruebax[i] = m.x + 5
    pruebay[i] = m.y + 3
    end
    saved = 1
  end


  --collisions for minerals
    for i, m in ipairs(minerals_controller.minerals) do
      for _, e in pairs(explorers_controller.explorers) do
        if CheckCollision(m.x, m.y, m.width, m.heigth, e.x, e.y, e.width, e.heigth) == true and e.capacity ~= 0 then
          printf("Agent %d found a mineral\n", e.number)

          table.remove(minerals_controller.minerals, i)
          e.capacity = e.capacity - 1
          e.recolected = e.recolected + 1
          printf("Minerals recolected by Agent %d : %d\n", e.number, e.recolected)
          printf("Minerals missing for maximum capacity: %d\n", e.capacity)
          if activeCooperativeMod == 1 then
            printf("Agent %d is leaving a crumb.\n",e.number)
          end
        elseif e.capacity == 0 then
          printf("Agent %d is at its maximum capacity, returning to the spacecraft\n", e.number)
        end
      end
    end

    --collisions for crumbs
    if activeCooperativeMod then
    for i, m in ipairs(crumbs_controller.crumbs) do
      for _, e in pairs(explorers_controller.explorers) do
          if CheckCollision(m.x, m.y, m.width, m.heigth, e.x, e.y, e.width, e.heigth) == true then
              e.y = e.y + e.movementY
                if CheckCollision(m.x, m.y, m.width, m.heigth, e.x, e.y, e.width, e.heigth) == false then
                  e.y = e.y - e.movementY
                  if CheckCollision(m.x, m.y, m.width, m.heigth, e.x, e.y, e.width, e.heigth) == false then
                    e.x = e.x + e.movementX
                    if CheckCollision(m.x, m.y, m.width, m.heigth, e.x, e.y, e.width, e.heigth) == false then
                      e.x = e.x - e.movementX
                    end
                  end
                end
          end
      end
    end
  end

    for i, e in ipairs(explorers_controller.explorers) do
      for _, b in pairs(obstacles_controller.obstacles) do
        if CheckCollision(e.x, e.y, e.width, e.heigth, b.x, b.y, b.width, b.heigth) == true then
          printf("Agent %d hit an obstacle\n", e.number)
          movementAgent(e.number)
        end
      end
    end

    --collisions for walls
    for _, e in pairs(explorers_controller.explorers) do
      if e.x > love.graphics.getWidth() - e.width then
        e.x = love.graphics.getWidth() - e.width
        printf("Agent %d reached the area limit, resetting searching\n", e.number)
        movementAgent(e.number)
      elseif e.x < 0 then
        e.x = 0
        printf("Agent %d reached the area limit, resetting searching\n", e.number)
        movementAgent(e.number)
      elseif e.y < 0 then
        e.y = 0
        printf("Agent %d reached the area limit, resetting searching\n", e.number)
        movementAgent(e.number)
      elseif e.y > love.graphics.getHeight() - e.heigth then
        e.y = love.graphics.getHeight() - e.heigth
        printf("Agent %d reached the area limit, resetting searching\n", e.number)
        movementAgent(e.number)
      elseif e.capacity ~= 0 then
      --  printf("Agent %d Exploring the area\n", e.number)
      end
    end

    --battery usage
    timeEx = love.timer.getTime()


    for _, e in pairs(explorers_controller.explorers) do
      e.timeRunning =  timeEx- e.time
      if math.floor(e.timeRunning)  % limit == 0 and math.floor(e.timeRunning) ~= 0 and e.charging ~= 1 then
        if e.battery > 0 then
          e.battery = e.battery - 1
          printf("Agent %d battery %d porcent\n",e.number, e.battery/100)
        end
      end

      if e.battery/100 <= batteryLimit then
        if activeCooperativeMod then
          e.alarm = true
        end
        printf("Agent %d has low battery, returning to the spacecraft \n", e.number)
      end

      if e.battery == 0 then
        printf("Agent %d ran out of battery\n", e.number)
      end

    end

    --battery management
    CheckCollisionsForSpacecraft(explorers_controller.explorers, spacecrafts_controller.spacecrafts)

end


function love.draw()


 -- explorers draw
 local porcentaje

 for _, e in pairs(explorers_controller.explorers) do
    love.graphics.draw(explorers_controller.rob, e.x, e.y, 0)
    walk = love.math.random(100)
      if e.number == 1 then
        porcentaje = 20
      elseif e.number == 2 then
        porcentaje = 40
      elseif e.number == 3 then
        porcentaje = 30
      end

      if walk > porcentaje  and e.charging ~= 1 and e.battery > 0 and e.alarm == false then
        e.x = e.x + e.movementX
      elseif walk <= porcentaje and e.charging ~= 1 and e.battery > 0 and e.alarm == false then
        e.y = e.y + e.movementY
      elseif e.alarm == true  and e.battery > 0 and e.charging ~= 1 then
          if e.x > 0   then
            e.x = e.x - e.movementX

          elseif e.y > 0  then
            e.y = e.y - e.movementY
          end
      end
  end

  --crumbs draw
  for i, c in pairs(crumbs_controller.crumbs) do
    if activeCooperativeMod then
      love.graphics.draw(crumbs_controller.crumb, pruebax[i], pruebay[i], 0)
    end
  end

 -- minerals draw
 for _, e in pairs(explorers_controller.explorers) do
   for _, m in pairs(minerals_controller.minerals) do
     love.graphics.draw(minerals_controller.gem, m.x, m.y, 0)
   end
 end


  --obstacles draw
  for _, e in pairs(obstacles_controller.obstacles) do
    love.graphics.draw(obstacles_controller.obstacle, e.x, e.y, 0)
  end

  --spacecraft draw
  love.graphics.draw(spacecrafts_controller.spacecraft,0)

  love.graphics.setColor(231, 125, 17)
  love.graphics.rectangle("fill",0,0,27,19)
  love.graphics.setColor(255,255,255)
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)

  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function CheckCollisions(list1, list2, nameOfObject)
    for i, e in ipairs(list1) do
      for _, b in pairs(list2) do
        if CheckCollision(e.x, e.y, e.width, e.heigth, b.x, b.y, b.width, b.heigth) == true  then
          printf("Agent %d %s\n", e.number, nameOfObject)
          movementAgent(e.number)

        end
      end
    end
end


function CheckCollisionsForSpacecraft(list1, list2)
    for i, e in ipairs(list1) do
      for _, b in pairs(list2) do
        if CheckCollision(e.x, e.y, e.width, e.heigth, b.x, b.y, b.width, b.heigth) == true and e.battery/100 < batteryLimit  then
          e.charging = 1
          printf("Agent %d is charging\n", e.number)
          e.battery = batteryFull
        elseif CheckCollision(e.x, e.y, e.width, e.heigth, b.x, b.y, b.width, b.heigth) == true and e.battery >= batteryFull then
          e.charging = 0
          e.alarm = false
        elseif CheckCollision(e.x, e.y, e.width, e.heigth, b.x, b.y, b.width, b.heigth) == true and e.capacity == 0 then
          e.capacity = capacity
          e.recolected = 0
          printf("Agent %d left the minerals in the spacecraft\n", e.number)
        end
      end
    end
end




function movementAgent(x)
  randomElection = love.math.random(100)
  randomElection2 = love.math.random(100)


    if randomElection > 50 then
      for _, e in pairs(explorers_controller.explorers) do
          if x == e.number then
            e.movementX = -e.movementX
          end
      end
    else
      for _, e in pairs(explorers_controller.explorers) do
          if x == e.number then
            e.movementY = -e.movementY
          end
      end
    end
end

printf = function(s,...)
           return io.write(s:format(...))
         end -- function
