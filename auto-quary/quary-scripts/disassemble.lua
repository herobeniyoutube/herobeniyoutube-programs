local movement = require("movement")
local destroying = require("destroying")
local inventory = require("inventory")
local using = require("using")

local function spearDisassembly()
    for i = 1, 3 do
        destroying.digUp(1, true)
        for j = 1, 4 do
            destroying.swing()
            movement.move(movement.to.turnRight)
        end
    end

    destroying.digUp(3)
end

inventory.inventoryInit()

inventory.selectItem(inventory.aliases.pickaxe)

inventory.switchToolWrapper(function()
    movement.stepsUp(1)
    destroying.swing()
    movement.move(movement.to.turnLeft)
    destroying.swing()
    movement.stepsForward(1)
    movement.move(movement.to.turnRight)
    destroying.swing()
    destroying.digDown(1, true)

    destroying.digForward(4)
    movement.move(movement.to.turnRight)

    destroying.digForward(1)

    destroying.digUp(3, true, function ()
        destroying.swing()
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
        destroying.swing()
    end)

    destroying.digForward(2)
    movement.move(movement.to.turnRight)
    destroying.digForward(2)
    destroying.swing()
end)

movement.move(movement.to.turnRight)
destroying.digForward(3, {
    function ()
        movement.move(movement.to.turnRight)
        destroying.swing()
        movement.move(movement.to.around)
        destroying.swing()
        movement.move(movement.to.turnRight)
    end
})

movement.move(movement.to.around)

movement.stepsForward(1)
spearDisassembly()

movement.moveRight(2)
movement.move(movement.to.turnLeft)
movement.stepsDown(5)

inventory.inventoryInit(true)
