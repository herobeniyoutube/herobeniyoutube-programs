local robot = require("robot")
local movement = require("movement")
local inventory = require("inventory")
local logger = require("logger")

local using = {}

local direction = {
    front = 0,
    up = 1,
    down = 2,
}

local function use(side, shift, dir)
        dir = dir or 0
    local actions = {
        [0] = robot.use,
        [1] = robot.useUp,
        [2] = robot.useDown,
    }

    local ok, why = actions[dir](side, shift)
    if not ok then
        logger.error("use: couldn't use because: " .. tostring(why))
        --error("use: couldn't use because: " .. tostring(why))
    else 
        logger.info("use: " .. tostring(why))
    end
end

function using.useItem(side, name, shift)
    inventory.selectItem(name)
    inventory.switchToolWrapper(function ()
        use(side, shift)
    end)
end

function using.use(side, shift)
    use(side, shift)
end

function using.useForward(n, shift)
    local sneaky = shift or false
    for i = 1, n do
        use(nil, sneaky)
        movement.stepsForward(1)
    end
end

function using.useUp(n, shift, moveLast, action)
    local sneaky = shift or false
    local move = moveLast or false

    for i = 1, n do
        use(nil, sneaky, direction.up)

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

        use(nil, sneaky, direction.down)

        if i < n or move then
            movement.stepsDown(1)
        end
    end
end

return using
