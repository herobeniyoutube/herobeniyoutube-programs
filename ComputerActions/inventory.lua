local robot = require("robot")
local component = require("component")

local inv = component.inventory_controller

local inventory = {}

local function normalizeLabel(label)
    label = string.lower(label)

    if label:match("^ore drilling plant") then
        return "ore drilling plant"
    end

    if label:match("^me smart") then
        return "smart cable"
    end

    if label:match("^me dense") then
        return "dense cable"
    end

    if label:match("^me fluid") then
        return "fluid import bus"
    end

    if label:match("^me import") then
        return "import bus"
    end

    if label:match("^me quantum link") then
        return "ring center"
    end

    if label:match("^me quantum ring") then
        return "ring"
    end

    if label:match("^braintech") then
        return "duct tape"
    end

    if label:match("^p2p tunnel") then
        return "p2p tunnel"
    end

    if label:match("^fluid tunnel") then
        return "fluid tunnel"
    end

    if label:match("^supply tunnel") then
        return "supply tunnel"
    end

    if label:match("^pipes tunnel") then
        return "pipes tunnel"
    end

    if label:match("^energy tunnel") then
        return "energy tunnel"
    end

    if label:match("casing$") then
        return "casing"
    end

    if label:match("frame box$") then
        return "frame box"
    end

    if label:match("output bus$") then
        return "output bus"
    end

    if label:match("output hatch$") then
        return "output hatch"
    end

    if label:match("input hatch$") then
        return "input hatch"
    end

    if label:match("energy hatch$") then
        return "energy hatch"
    end

    if label:match("singularity$") then
        return "singularity"
    end

    if label:match("chest$") then
        return "chest"
    end

    return label
end

function inventory.inventoryInit(silent)
    for slot = 1, robot.inventorySize() do
        local stack = inv.getStackInInternalSlot(slot)

        if stack then
            local key = normalizeLabel(stack.label)
            inventory[key] = slot
            if not silent then
                print(slot .. ": " .. stack.label .. " -> " .. key)
            end
        end
    end
end

function inventory.selectItem(name)
    local slot = inventory[name]
    if not slot then
        error("item not found in inventory: " .. tostring(name))
    end

    robot.select(slot)

    return slot
end

function inventory.switchToolWrapper(action)
    inv.equip()
    action()
    inv.equip()
end

function inventory.printInventory()
    for key, value in ipairs(inventory) do
        print(key + "" + value)
    end
end

function inventory.getSlotInfoSize(slot)
    local slot = inv.getStackInInternalSlot(slot)

    if slot then
        return tonumber(slot.size)
    end

    return 0
end

inventory.inventoryInit(true)

return inventory
