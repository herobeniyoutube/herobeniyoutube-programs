local robot = require("robot")
local logger = require("herobeni-logger")

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
movement.to = to

local coordinates = {
    x = 0,
    z = 0,
    y = 0
}

local currentDirection

movement.directions = {
    south = 0,
    east = 1,
    north = 2,
    west = 3
}

local function turnLeft()
    if currentDirection == movement.directions.south then
        currentDirection = movement.directions.west
    else
        currentDirection = currentDirection - 1
    end

    robot.turnLeft()
end

local function turnRight()
if currentDirection == movement.directions.west then
        currentDirection = movement.directions.south
    else
        currentDirection = currentDirection + 1
    end

    robot.turnRight()
end

local function turnAround()
    if currentDirection > 1 then
        currentDirection = currentDirection - 2
    else
        currentDirection = currentDirection + 2
    end

    robot.turnAround()
end

local function move(moveType)
    if not currentDirection then
        error("direction state should not be nil. Set it with setupCoordination(x, y, z, side)")
    end

    if not moveType then
        error("move function should have move type")
    end

    local moves = {
        [0] = turnLeft,
        [1] = turnRight,
        [2] = robot.forward,
        [3] = robot.back,
        [4] = robot.up,
        [5] = robot.down,
        [6] = turnAround,
    }

    local ok, why = moves[moveType]()
    if not ok then
        logger.error("couldn't move: " .. tostring(why))
        error("couldn't move: " .. tostring(why))
    else
        logger.info("move: " .. tostring(moveType))
    end
end

function movement.setupCoordination(x, y, z, side)
    currentDirection = side
    coordinates.x = x
    coordinates.y = y
    coordinates.z = z
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
