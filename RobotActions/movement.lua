local robot = require("robot")

local movement = {}

function movement.stepsForward(n)
    for i = 1, n do
        robot.forward()
    end
end

function movement.stepsBack(n)
    for i = 1, n do
        robot.back()
    end
end

function movement.turnAround()
    robot.turnLeft()
    robot.turnLeft()
end

function movement.stepsDown(count)
    for i = 1, count do
        robot.down()
    end
end

function movement.stepsUp(count)
    for i = 1, count do
        robot.up()
    end
end

function movement.moveLeft(count)
    robot.turnLeft()
    movement.stepsForward(count)
    robot.turnRight()
end

function movement.moveRight(count)
    robot.turnRight()
    movement.stepsForward(count)
    robot.turnLeft()
end

return movement