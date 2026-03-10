local filesystem = require("filesystem")

local logger = {}

local levels = {
    debug = 1,
    info = 2,
    warn = 3,
    error = 4,
}

local currentLevel = levels.info
local logFile = "/home/logs/robot.log"
local toConsole = true
local cleared = false

local function ensureDir(path)
    local dir = filesystem.path(path)
    if dir and not filesystem.exists(dir) then
        filesystem.makeDirectory(dir)
    end
end

local function write(level, message)
    local now = os.date("%Y-%m-%d %H:%M:%S")
    local line = string.format("[%s] %-5s %s", now, level, tostring(message))

    if toConsole then
        io.write(line .. "\n")
    end

    ensureDir(logFile)
    if not cleared then
        local fresh = io.open(logFile, "w")
        if fresh then
            fresh:close()
        end
        cleared = true
    end
    local file = io.open(logFile, "a")
    if file then
        file:write(line .. "\n")
        file:close()
    end
end

function logger.setLevel(level)
    if levels[level] then
        currentLevel = levels[level]
    else
        write("WARN", "unknown log level: " .. tostring(level))
    end
end

function logger.setLogFile(path)
    if path and path ~= "" then
        logFile = path
        cleared = false
    else
        write("WARN", "log file path is empty")
    end
end

function logger.setConsole(enabled)
    toConsole = not not enabled
end

function logger.clear()
    ensureDir(logFile)
    local fresh = io.open(logFile, "w")
    if fresh then
        fresh:close()
    end
    cleared = true
end

function logger.debug(message)
    if currentLevel <= levels.debug then
        write("DEBUG", message)
    end
end

function logger.info(message)
    if currentLevel <= levels.info then
        write("INFO", message)
    end
end

function logger.warn(message)
    if currentLevel <= levels.warn then
        write("WARN", message)
    end
end

function logger.error(message)
    if currentLevel <= levels.error then
        write("ERROR", message)
    end
end

return logger
