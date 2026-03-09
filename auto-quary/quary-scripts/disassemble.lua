local robot = require("robot")
local component = require("component")
local inv = component.inventory_controller
local movement = require("movement")
local destroying = require("destroying")
local inventory = require("inventory")
local using = require("using")

local function spearDisassembly()
    for i = 1, 3 do
        destroying.digUp(1, true)
        for j = 1, 4 do
            robot.swing()
            robot.turnRight()
        end
    end

    destroying.digUp(3)
end

inventory.inventoryInit()

inventory.selectItem(inventory.aliases.pickaxe)

inventory.switchToolWrapper(function()
    movement.stepsUp(1)
    robot.swing()
    robot.turnLeft()
    robot.swing()
    movement.stepsForward(1)
    robot.turnRight()
    robot.swing()
    destroying.digDown(1, true)

    destroying.digForward(4)
    robot.turnRight()

    destroying.digForward(1)

    destroying.digUp(3, true, function ()
        robot.swing()
    end)

    movement.stepsUp(1)

    inventory.switchToolWrapper(function ()
        inventory.selectItem(inventory.aliases.computer_wrench)
        inventory.switchToolWrapper(function ()
                using.useForward(1, true)
        end)
        inventory.selectItem(inventory.aliases.pickaxe)
    end)

    destroying.digDown(4, true, function()
        robot.swing()
    end)

    destroying.digForward(2)
    robot.turnRight()
    destroying.digForward(2)
    robot.swing()
end)

robot.turnRight()
destroying.digForward(3, {
    function ()
        robot.turnRight()
        robot.swing()
        robot.turnAround()
        robot.swing()
        robot.turnRight()
    end
})

robot.turnAround()
movement.stepsForward(1)
spearDisassembly()

movement.moveRight(2)
robot.turnLeft()
movement.stepsDown(5)

inventory.inventoryInit(true)
