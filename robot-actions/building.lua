local robot = require("robot")
local component = require("component")
local inv = component.inventory_controller

local movement = require("movement")
local inventory = require("inventory")
local logger = require("herobeni-logger")

local building = {}

local function place(name)
    if not name then
        logger.error("place: block name can't be nil")
        error("place: block name can't be nil")
    end

    local ok, why = robot.place()
    if not ok then
        logger.error("couldn't place block: " .. tostring(name) .. " because: " .. tostring(why))
        error("couldn't place block: " .. tostring(name) .. " because: " .. tostring(why))
    else
        logger.info("place: " .. tostring(name))
    end
end

function building.place(name, actions)
    inventory.selectItem(name)
    place(name)

    if actions then
        for i, action in ipairs(actions) do
            if type(action) ~= "function" then
                logger.error("place: actions[" .. i .. "] is not a function")
                error("place: actions[" .. i .. "] is not a function")
            end
            action()
        end
    end
end

function building.placeDown(name)
    inventory.selectItem(name)
    return robot.placeDown()
end

function building.drop(name, count)
    local c = count or 1
    inventory.selectItem(name)
    robot.drop(c)
end

function building.forwardThenPlaceLeft(block, actions)
    movement.stepsForward(1)
    robot.turnLeft()
    building.place(block, actions)
    robot.turnRight()
end

function building.buildSpear(height, block)
    for i = 1, height do
        robot.up()
        building.placeDown(block)
    end
end

return building
