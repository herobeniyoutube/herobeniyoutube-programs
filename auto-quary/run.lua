local scripts = require("quary-scripts.quaryRun")
local robot = require("robot")

local name = robot.name()
local minerId = tonumber(name:match("%d+"))