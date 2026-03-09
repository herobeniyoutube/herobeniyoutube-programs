local quary = require("quary-scripts.quaryRun")
local robot = require("robot")

local name = robot.name()
local minerId = tonumber(name:match("%d+"))

local args = { ... }
local built = args[1] or false
local loaded = args[2] or false

quary.setId(minerId)
quary.setIdetStepsToTh2eNextArea(80)
quary.run(built, loaded)

