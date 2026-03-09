local robot = require("robot")
local movement = require("movement")
local inventory = require("inventory")

local using = {}

function using.useItem(side, name, shift)
    inventory.selectItem(name)
    inventory.switchToolWrapper(function ()
        using.use(side, shift)
    end)
end

function using.use(side, shift)
    return robot.use(side, shift)
end

--obsolete
function using.useShiftForward()
    using.use(nil, true)
    robot.forward()
end

function using.useShiftDown()
    robot.useDown(nil, true)
    robot.down()
end

function using.useForward(n, shift)
    local sneaky = shift or false
    for i = 1, n do
        using.use(nil, sneaky)
        movement.stepsForward(1)
    end
end

function using.useUp(n, shift, moveLast, action)
    local sneaky = shift or false
    local move = moveLast or false

    for i = 1, n do
        robot.useUp(nil, sneaky)

        if i < n or move then
            movement.stepsUp(1)
        end

        if action then
            action()
        end
    end
end

function using.useDown(n, shift, moveLast,  action)
    local sneaky = shift or false
    local move = moveLast or false

    for i = 1, n do
        if action then
            action()
        end

        robot.useDown(nil, sneaky)

        if i < n or move then
            movement.stepsDown(1)
        end
    end
end

return using