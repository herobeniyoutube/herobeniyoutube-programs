local robot = require("robot")
local movement = require("movement")
local logger = require("herobeni-logger")

local direction = {
    front = 0,
    up = 1,
    down = 2,
}

local destroying = {}

local function swing(dir)
    dir = dir or 0
    local actions = {
        [0] = robot.swing,
        [1] = robot.swingUp,
        [2] = robot.swingDown,
    }

    local ok, why = actions[dir]()
    if not ok then
        logger.error("couldn't break block: because: " .. tostring(why))
    else
        logger.info("swing: " .. tostring(why))
    end
end

function destroying.digForward(n, actions)
    for i = 1, n do
        swing(direction.front) 
        movement.stepsForward(1)

        if actions then
            for j, action in ipairs(actions) do
                if type(action) ~= "function" then
                    logger.error("place: actions[" .. j .. "] is not a function")
                    error("place: actions[" .. j .. "] is not a function")
                end
                action()
            end
        end
    end
end

function destroying.digUp(n, moveUp, action)
    for i = 1, n do
        swing(direction.up)

        if i < n or moveUp then
            movement.stepsUp(1)
        end

        if action then
            action()
        end
    end
end

function destroying.digDown(n, moveDown, action)
    for i = 1, n do
        swing(direction.down)

        if i < n or moveDown then
            movement.stepsDown(1)
        end

        if action then
            action()
        end
    end
end

return destroying
