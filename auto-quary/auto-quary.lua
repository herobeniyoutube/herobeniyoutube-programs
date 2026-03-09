local quary = assert(loadfile("/home/quary-scripts/run.lua"))()
local robot = require("robot")
local logger = require("herobeni-logger")

local name = robot.name()
local minerId = tonumber(name:match("%d+"))

local args = { ... }
local built = args[1] or false
local loaded = args[2] or false

quary.setId(minerId)
quary.setStepsToTheNextArea(80)
local ok, err = xpcall(function()
    quary.run(built, loaded)
end, debug.traceback)

if not ok then
    logger.error("auto-quary failed: " .. tostring(err))
    error(err)
end

