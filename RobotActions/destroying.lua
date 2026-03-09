local robot = require("robot")
local inventory = require("inventory")
local component = require("component")
local movement = require("movement")
local inv = component.inventory_controller

local destroying = {}
local inventory = nil

function destroying.digForward(n, actions)
    for i = 1, n do
        robot.swing()
        movement.stepsForward(1)

        if actions then
            for j, action in ipairs(actions) do
                if type(action) ~= "function" then
                    error("place: actions[" .. j .. "] is not a function")
                end
                action()
            end
        end
    end
end

function destroying.digUp(n, moveUp, action)
    for i = 1, n do
        robot.swingUp()

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
        robot.swingDown()

        if i < n or moveDown then
            movement.stepsDown(1)
        end

        if action then
            action()
        end
    end
end

return destroying
