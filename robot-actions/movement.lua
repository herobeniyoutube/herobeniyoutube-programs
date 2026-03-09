local robot = require("robot")
local logger = require("logger")

local movement = {}

local to = {
    turnLeft = 0,
    turnRight = 1,
    forward = 2,
    back = 3,
    up = 4,
    down = 5,
    around = 6,
}

local function move(moveType)
    if not moveType then
        error("move function should have move type")
    end

    local moves = {
        [0] = robot.turnLeft,
        [1] = robot.turnRight,
        [2] = robot.forward,
        [3] = robot.back,
        [4] = robot.up,
        [5] = robot.down,
        [6] = robot.turnAround,
    }

    local ok, why = moves[moveType]()
    if not ok then
        logger.error("couldn't move: " .. tostring(why))
        error("couldn't move: " .. tostring(why))
    else
        logger.info("move: " .. tostring(moveType))
    end
end

function movement.stepsForward(n)
    for i = 1, n do
        move(to.forward)
    end
end

function movement.stepsBack(n)
    for i = 1, n do
        move(to.back)
    end
end

function movement.turnAround()
    move(to.around)
end

function movement.stepsDown(count)
    for i = 1, count do
        move(to.down)
    end
end

function movement.stepsUp(count)
    for i = 1, count do
        move(to.up)
    end
end

function movement.moveLeft(count)
    move(to.turnLeft)
    movement.stepsForward(count)
    move(to.turnRight)
end

function movement.moveRight(count)
    move(to.turnRight)
    movement.stepsForward(count)
    move(to.turnLeft)
end

return movement
