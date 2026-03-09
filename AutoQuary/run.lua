local robot = require("robot")
local component = require("component")
local sides = require("sides")
local event = require("event")
local building = require("building")
local inv = component.inventory_controller
local wireless = component.gt_wireless
local inventory = require("inventory")
local movement = require("movement")

local buildQuaryScript, errBuilder = loadfile("/home/build_quary.lua")
if not buildQuaryScript then
    error(errBuilder)
end

local disassembleScript, errDisassembler = loadfile("/home/disassemble_quary.lua")
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

local pickaxeFreq = 10
local tapeFreq = 11
local wrenchFreq = 12
local enableMinerFreq = 75
local supplyPipesFreq = 76
local pipesFullFreq = 228
local quaryFinished = 229
local quaryNeedMaintenanceFreq = 300
local stepsToNextArea = 80

local function loadPipes()
    wireless.write(supplyPipesFreq, 15)

    while wireless.read(pipesFullFreq) < 15 do
        local signal = wireless.read(pipesFullFreq)
        print("Mining pipes capacity signal: " .. tostring(signal))
        event.pull(5)
    end

    wireless.write(supplyPipesFreq, 0)
end

local function enableMiner()
    wireless.write(enableMinerFreq, 15)
    print("miner on")
end

local function offMiner()
    wireless.write(enableMinerFreq, 0)
    print("miner off")
end

local function restoreDuctTape(slot)
    movement.stepsUp(1)
    robot.turnLeft()

    wireless.write(tapeFreq, 15)

    while inventory.getSlotInfoSize() <= 10 do
        event.pull(10)
    end
    wireless.write(tapeFreq, 0)
    event.pull(10)

    print("duct tape supply off")

    movement.stepsDown(1)
    robot.turnRight()
end

local function tryRepair()
    while wireless.read(quaryNeedMaintenanceFreq) >= 15 do
        print("Repairing")

        local tapeSlot = inventory.selectItem("duct tape")

        local slot = inv.getStackInInternalSlot(tapeSlot)

        if slot.size < 10 then
            restoreDuctTape(slot)
        end

        inventory.switchToolWrapper(function()
            if wireless.read(quaryNeedMaintenanceFreq) >= 15 then
                for i = 0, 2 do
                    robot.use(sides.front)
                    event.pull(10)
                    if wireless.read(quaryNeedMaintenanceFreq) < 15 then
                        break
                    end
                end
            end
        end)

        if wireless.read(quaryNeedMaintenanceFreq) >= 15 then
            robot.swing()
            inventory.inventoryInit()
            building.place("maintenance hatch")
        end
    end
end

local function minerMaintenance()
    while wireless.read(quaryFinished) < 15 do
        tryRepair()

        local signal = wireless.read(quaryFinished)
        print("Working... signal=" .. tostring(signal))
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

    local wrenchSlot = inventory.selectItem("computer wrench")

    inventory.switchToolWrapper(function()
        --drop old wrench
        movement.stepsUp(1)
        local ok, result = robot.drop()
        robot.turnLeft()

        if result ~= nil then
            print(result)
        end

        --get new wrench
        wireless.write(frequency, 15)
        while inv.getStackInInternalSlot(wrenchSlot) == nil do
            event.pull(2)
        end
        wireless.write(frequency, 0)
        print("tool supply off")

        --return to maintenance
        movement.stepsDown(1)
        robot.turnRight()
    end)
end

local function disassembleQuary()
    if not durabilityOk() then
        changeTool(wrenchFreq)
    end

    local pickaxeSlot = inventory.selectItem("pickaxe")
    if not durabilityOk() then
        inventory.switchToolWrapper(function()
            changeTool(pickaxeFreq)
            robot.select(pickaxeSlot)
        end)
    end

    disassembleScript()
end

local args = { ... }
local built = args[1] or false
local loaded = args[2] or false

while true do
    offMiner()

    if not built then
        buildQuaryScript()
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

    --идет на другую точку и встает там
    movement.stepsForward(stepsToNextArea)
end
