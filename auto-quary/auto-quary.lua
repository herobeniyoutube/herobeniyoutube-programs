local quary = assert(loadfile("/home/quary-scripts/run.lua"))()
local robot = require("robot")
local logger = require("herobeni-logger")

local name = robot.name()
local minerId = tonumber(name:match("%d+"))

local args = { ... }
local x = args[1]
local z = args[2]
local y = args[3]
local side = args[4]

if not x or not z then
    error("auto-quage usage: auto quary 0(x) 0(z) nil[boolean](built) nil[boolean](loaded)")
end

local built = args[5] or false
local loaded = args[6] or false

quary.setId(minerId)
quary.setStepsToTheNextArea(80)
quary.setCoordinates(x, z, y, side)

local ok, err = xpcall(function()
    quary.run(built, loaded)
end, debug.traceback)

if not ok then
    logger.error("auto-quary failed: " .. tostring(err))
    error(err)
end

