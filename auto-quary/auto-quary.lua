local quary = assert(loadfile("/home/quary-scripts/run.lua"))()
local robot = require("robot")

local name = robot.name()
local minerId = tonumber(name:match("%d+"))

local args = { ... }
local built = args[1] or false
local loaded = args[2] or false

quary.setId(minerId)
quary.setStepsToTheNextArea(80)
quary.run(built, loaded)

