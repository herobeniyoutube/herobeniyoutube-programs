local robot = require("robot")
local component = require("component")
local inv = component.inventory_controller

local movement = require("movement")
local inventory = require("inventory")

local building = {}

local function place(name, actions)
    inventory.selectItem(name)
    robot.place()

    if actions then
        for i, action in ipairs(actions) do
            if type(action) ~= "function" then
                error("place: actions[" .. i .. "] is not a function")
            end
            action()
        end
    end
end
building.place = place

local function placeDown(name)
    inventory.selectItem(name)
    return robot.placeDown()
end
building.placeDown = placeDown

local function drop(name, count)
    local c = count or 1
    inventory.selectItem(name)
    robot.drop(c)
end
building.drop = drop

local function forwardThenPlaceLeft(block, actions)
    movement.stepsForward(1)
    robot.turnLeft()
    building.place(block, actions)
    robot.turnRight()
end
building.forwardThenPlaceLeft = forwardThenPlaceLeft

local function buildSpear(height, block)
    for i = 1, height do 
        robot.up()
        building.placeDown(block)
    end
end
building.buildSpear = buildSpear

return building
