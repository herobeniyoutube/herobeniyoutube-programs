--local robot = require("robot")
local component = require("component")
local sides = require("sides")
local event = require("event")
local building = require("building")
local using    = require("using")
local destroying = require("destroying")
local inv = component.inventory_controller
local wireless = component.gt_wireless
local inventory = require("inventory")
local movement = require("movement")
local logger = require("herobeni-logger")

local quary = {}
local stepsToNextArea = 80
local minerId
local frequencies

local baseDir = "/home/quary-scripts"
local buildScript, errBuilder = loadfile(baseDir .. "/build.lua")
if not buildScript then
    error(errBuilder)
end

local disassembleScript, errDisassembler = loadfile(baseDir .. "/disassemble.lua")
if not disassembleScript then
    error(errDisassembler)
end

-- x - версия карьера

-- 10 запросить кирку (подать 15)
-- 11 запросить изоленту (подать 15)
-- 12 сигнал техобслуживания (подать 15 если нужен новый ключ)
-- 75 майнер вкл (после всех подготовок включается майнер) (0 чтобы выкл)
--76 подача труб (разблокируется подача труб из подсети) (0 чтобы выкл)
--228 наполнение труб (при 100% наполнение инпута карьера трубами идем дальше)
--229 сигнал разборки карьера (значит что в подсети заполнено хранилище труб - майнер разобрал свои трубы)
--300 поломка

local function loadPipes()
    wireless.write(frequencies.supplyPipesFreq, 15)

    while wireless.read(frequencies.pipesFullFreq) < 15 do
        local signal = wireless.read(frequencies.pipesFullFreq)
        logger.info("Mining pipes capacity signal: " .. tostring(signal))
        event.pull(5)
    end

    wireless.write(frequencies.supplyPipesFreq, 0)
end

local function enableMiner()
    wireless.write(frequencies.enableMinerFreq, 15)
    logger.info("miner on")
end

local function offMiner()
    wireless.write(frequencies.enableMinerFreq, 0)
    logger.info("miner off")
end

local function restoreDuctTape(slot)
    movement.stepsUp(1)
    movement.turn(movement.to.turnLeft)

    wireless.write(frequencies.tapeFreq, 15)

    while inventory.getSlotInfoSize() <= 10 do
        event.pull(10)
    end
    wireless.write(frequencies.tapeFreq, 0)
    event.pull(10)

    logger.info("duct tape supply off")

    movement.stepsDown(1)
    movement.turn(movement.to.turnRight)
end

local function tryRepair()
    while wireless.read(frequencies.quaryNeedMaintenanceFreq) >= 15 do
        logger.info("Repairing")

        local tapeSlot = inventory.selectItem(inventory.aliases.duct_tape)

        local slot = inv.getStackInInternalSlot(tapeSlot)

        if slot.size < 10 then
            restoreDuctTape(slot)
        end

        inventory.switchToolWrapper(function()
            if wireless.read(frequencies.quaryNeedMaintenanceFreq) >= 15 then
                for i = 0, 2 do
                    using.use(sides.front)
                    event.pull(10)
                    if wireless.read(frequencies.quaryNeedMaintenanceFreq) < 15 then
                        break
                    end
                end
            end
        end)

        if wireless.read(frequencies.quaryNeedMaintenanceFreq) >= 15 then
            destroying.swing()
            inventory.inventoryInit()
            building.place(inventory.aliases.maintenance_hatch)
        end
    end
end

local function minerMaintenance()
    logger.info("Working... signal=")
    while wireless.read(frequencies.quaryFinished) < 15 do
        tryRepair()

        local signal = wireless.read(frequencies.enableMinerFreq)
        if not signal or signal < 15 then
            enableMiner()
        end
        event.pull(5)
    end
end

local function durabilityOk()
    -- проверка инструмента на износ
    return true
end

local function changeTool(frequency)
    if not frequency then
        error("changeTool: frequency can't be nil")
    end

    local wrenchSlot = inventory.selectItem(inventory.aliases.computer_wrench)

    inventory.switchToolWrapper(function()
        --drop old wrench
        movement.stepsUp(1)
        local ok, result = building.drop()
        movement.turn(movement.to.turnRight)
        if result ~= nil then
            logger.warn(result)
        end

        --get new wrench
        wireless.write(frequency, 15)
        while inv.getStackInInternalSlot(wrenchSlot) == nil do
            event.pull(2)
        end
        wireless.write(frequency, 0)
        logger.info("tool supply off")

        --return to maintenance
        movement.stepsDown(1)
        movement.turn(movement.to.turnRight)
    end)
end

local function disassembleQuary()
    if not durabilityOk() then
        changeTool(frequencies.wrenchFreq)
    end

    local pickaxeSlot = inventory.selectItem(inventory.aliases.pickaxe)
    if not durabilityOk() then
        inventory.switchToolWrapper(function()
            changeTool(frequencies.pickaxeFreq)
            inventory.select(pickaxeSlot)
        end)
    end

    disassembleScript()
end

local function setFrequencies()
    frequencies = {
        pickaxeFreq = minerId * 100 + 1,
        tapeFreq = minerId * 100 + 2,
        wrenchFreq = minerId * 100 + 3,
        enableMinerFreq = minerId * 100 + 4,
        supplyPipesFreq = minerId * 100 + 5,
        pipesFullFreq = minerId * 100 + 6,
        quaryFinished = minerId * 100 + 7,
        quaryNeedMaintenanceFreq = minerId * 100 + 8,
        stepsToNextArea = stepsToNextArea,
    }
end

function quary.setCoordinates(x, z, y, direction)
    movement.setupCoordination(x, z, y, direction)
end

function quary.setId(id)
    minerId = id
end

function quary.setStepsToTheNextArea(steps)
    stepsToNextArea = steps
end

function quary.run(built, loaded)
    if not minerId then
        error("miner id can't be nil")
    end

    if built or loaded then
        inventory.inventoryInit()
    end

    setFrequencies()

    while true do
        offMiner()

        if not built then
            buildScript()
        end

        -- запускает заполнение mining pipes и ждет их заполнения
        if not loaded then
            loadPipes()
        end

        enableMiner()

        -- проверки на поломки, которые прерываются сигналом разборки
        minerMaintenance()

        offMiner()

        -- разборка карьера
        disassembleQuary()
        built = false
        loaded = false

        --идет на другую точку и встает там
        logger.info("moving" .. stepsToNextArea)
        movement.stepsForward(stepsToNextArea)
    end
end

return quary
