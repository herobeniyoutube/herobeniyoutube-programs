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

local direction = {
    south = 0,
    east = 1,
    north = 2,
    west = 3
}
movement.directions = direction

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

local function turn(turnType)
    local moves = {
        [0] = turnLeft,
        [1] = turnRight,
        [6] = turnAround,
    }

    moves[turnType]()
end
movement.turn = turn

local directionVectors = {
    [direction.south] = { x = 0, z = 1 },
    [direction.east] = { x = 1, z = 0 },
    [direction.north] = { x = 0, z = -1 },
    [direction.west] = { x = -1, z = 0 },
}

local function applyMoveToCoordinates(moveType)
    local dx, dy, dz = 0, 0, 0

    if moveType == to.up then
        dy = 1
    elseif moveType == to.down then
        dy = -1
    else
        local vec = directionVectors[currentDirection]
        if not vec then
            error("unknown direction: " .. tostring(currentDirection))
        end

        if moveType == to.forward then
            dx = vec.x
            dz = vec.z
        elseif moveType == to.back then
            dx = -vec.x
            dz = -vec.z
        else
            error("unsupported move type: " .. tostring(moveType))
        end
    end

    coordinates.x = coordinates.x + dx
    coordinates.y = coordinates.y + dy
    coordinates.z = coordinates.z + dz
end

local function move(moveType)
    if not currentDirection then
        error("direction state should not be nil. Set it with setupCoordination(x, y, z, side)")
    end

    if not moveType then
        error("move function should have move type")
    end

    local moves = {
        [2] = robot.forward,
        [3] = robot.back,
        [4] = robot.up,
        [5] = robot.down,
    }

    local ok, why = moves[moveType]()
    if not ok then
        logger.error("couldn't move: " .. tostring(why))
        error("couldn't move: " .. tostring(why))
    else
        applyMoveToCoordinates(moveType)
        logger.info("move: " .. tostring(moveType) .. "to: x-" .. coordinates.x .. " z-" .. coordinates.z .. " y-" .. coordinates.y)
    end
end
movement.move = move

function movement.setupCoordination(x, z, y, side)
    if not x or not z or not y or not side then
        error("setupCoordination: invalid input")
    end

    if type(side) == "string" then
        local normalized = string.lower(side)
        if direction[normalized] == nil then
            error("setupCoordination: unknown direction '" .. tostring(side) .. "'")
        end
        currentDirection = direction[normalized]
    else
        currentDirection = side
    end
    coordinates.x = x
    coordinates.z = z
    coordinates.y = y
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
    turn(to.around)
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
    turn(to.turnLeft)
    movement.stepsForward(count)
    turn(to.turnRight)
end

function movement.moveRight(count)
    turn(to.turnRight)
    movement.stepsForward(count)
    turn(to.turnLeft)
end

return movement
