local robot = require("robot")
local sides = require("sides")

local movement = require("movement")
local building = require("building")
local using = require("using")
local inventory = require("inventory")

local function buildRingEdge()
    building.forwardThenPlaceLeft("smart cable", {
        function()
            movement.stepsUp(1)
        end,
        function()
            for i = 1, 3 do
                building.place("ring")
                if i < 3 then
                    movement.stepsUp(1)
                end
            end
        end,
        function() movement.stepsDown(3) end
    })
end

inventory.inventoryInit()

movement.stepsForward(2)
building.place("casing")
movement.stepsBack(1)
building.place("casing")
movement.stepsBack(1)
building.place("ore drilling plant")

robot.turnRight()
movement.stepsForward(2)
robot.turnLeft()
building.forwardThenPlaceLeft("energy hatch")
building.forwardThenPlaceLeft("input hatch")
building.forwardThenPlaceLeft("output hatch")

movement.stepsForward(1)
robot.turnLeft()
movement.stepsForward(4)
robot.turnLeft()
building.forwardThenPlaceLeft("lv input bus")
building.forwardThenPlaceLeft("output bus")
building.forwardThenPlaceLeft("maintenance hatch")

movement.stepsForward(1)
robot.turnLeft()
movement.stepsForward(1)
robot.turnLeft()
robot.use(sides.front, true)

movement.stepsUp(1)
movement.stepsForward(2)
robot.turnRight()
movement.stepsForward(1)

for i = 1, 3 do
    for j = 1, 4 do
        building.place("frame box")
        robot.turnLeft()
    end

    movement.stepsUp(1)
    building.placeDown("casing")
end

building.buildSpear(3, "frame box")

movement.stepsForward(3)
robot.turnRight()
movement.stepsForward(2)
movement.turnAround()
movement.stepsDown(7)

building.forwardThenPlaceLeft("p2p tunnel", {
    function() using.useItem(sides.front, "energy tunnel") end, -- линк туннеля
    function() building.place("smart cable") end
})

building.forwardThenPlaceLeft("p2p tunnel", {
    function() using.useItem(sides.front, "fluid tunnel") end, -- линк туннеля
    function() building.place("smart cable") end
})

building.forwardThenPlaceLeft("fluid import bus", {
    function() building.place("smart cable") end
})

movement.stepsForward(2)
robot.turnLeft()
building.forwardThenPlaceLeft("smart cable")

buildRingEdge()

building.forwardThenPlaceLeft("dense cable", {
    function()
        movement.stepsUp(1)
    end,
    function()
        building.place("ring")
        movement.stepsUp(1)
    end,
    function()
        building.place("ring center", {
            function()
                building.drop("singularity")
            end
        })
        movement.stepsUp(1)
    end,
    function()
        building.place("ring")
        movement.stepsUp(1)
    end,
    function()
        building.place("dense energy cell")
    end,
    function()
        movement.stepsDown(4)
    end
})

buildRingEdge()

movement.stepsForward(2)
robot.turnLeft()

building.forwardThenPlaceLeft("smart cable")
building.forwardThenPlaceLeft("p2p tunnel", {
    function()
        using.useItem(sides.front, "pipes tunnel")
        building.place("smart cable")
    end
})
building.forwardThenPlaceLeft("import bus", {
    function()
        using.useItem(sides.front, "acceleration card", true)
        building.place("smart cable")
    end
})
building.forwardThenPlaceLeft("smart cable", {
    function()
        movement.stepsUp(1)
        movement.stepsForward(1)
        building.place("chest")
        movement.stepsBack(1)
        building.place("import bus", {
            function() building.place("smart cable") end
        })
        building.place("smart cable")
        movement.stepsDown(1)
    end
})
building.forwardThenPlaceLeft("charger", {
    function()
        movement.stepsUp(1)
        building.place("smart cable")
        movement.stepsDown(1)
    end
})

movement.stepsForward(1)
robot.turnLeft()
movement.stepsForward(2)
robot.turnLeft()
movement.stepsForward(1)
robot.turnLeft()

inventory.selectItem("computer wrench")
inventory.switchToolWrapper(function()
    using.use(sides.front)
end)

movement.stepsUp(1)
building.place("p2p tunnel", {
    function() using.useItem(sides.front, "supply tunnel") end, -- линк туннеля
})

movement.stepsDown(1)
robot.turnRight()
