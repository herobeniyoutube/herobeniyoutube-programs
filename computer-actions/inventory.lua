local robot = require("robot")
local component = require("component")
local inv = component.inventory_controller
local logger = require("herobeni-logger")

local aliases = {
    ore_drilling_plant = "ore drilling plant",
    smart_cable = "smart cable",
    dense_cable = "dense cable",
    fluid_import_bus = "fluid import bus",
    import_bus = "import bus",
    ring_center = "ring center",
    ring = "ring",
    duct_tape = "duct tape",
    p2p_tunnel = "p2p tunnel",
    fluid_tunnel = "fluid tunnel",
    supply_tunnel = "supply tunnel",
    pipes_tunnel = "pipes tunnel",
    energy_tunnel = "energy tunnel",
    casing = "casing",
    frame_box = "frame box",
    output_bus = "output bus",
    output_hatch = "output hatch",
    input_hatch = "input hatch",
    energy_hatch = "energy hatch",
    maintenance_hatch = "maintenance hatch",
    singularity = "singularity",
    chest = "chest",
    lv_input_bus = "lv input bus",
    dense_energy_cell = "dense energy cell",
    charger = "charger",
    acceleration_card = "acceleration card",
    computer_wrench = "computer wrench",
    pickaxe = "pickaxe",
}

local inventory = {}
inventory.aliases = aliases

local function normalizeLabel(label)
    label = string.lower(label)

    if label:match("^ore drilling plant") then
        return aliases.ore_drilling_plant
    end

    if label:match("^me smart") then
        return aliases.smart_cable
    end

    if label:match("^me dense") then
        return aliases.dense_cable
    end

    if label:match("^me fluid") then
        return aliases.fluid_import_bus
    end

    if label:match("^me import") then
        return aliases.import_bus
    end

    if label:match("^me quantum link") then
        return aliases.ring_center
    end

    if label:match("^me quantum ring") then
        return aliases.ring
    end

    if label:match("^braintech") then
        return aliases.duct_tape
    end

    if label:match("^p2p tunnel") then
        return aliases.p2p_tunnel
    end

    if label:match("^fluid tunnel") then
        return aliases.fluid_tunnel
    end

    if label:match("^supply tunnel") then
        return aliases.supply_tunnel
    end

    if label:match("^pipes tunnel") then
        return aliases.pipes_tunnel
    end

    if label:match("^energy tunnel") then
        return aliases.energy_tunnel
    end

    if label:match("casing$") then
        return aliases.casing
    end

    if label:match("frame box$") then
        return aliases.frame_box
    end

    if label:match("output bus$") then
        return aliases.output_bus
    end

    if label:match("output hatch$") then
        return aliases.output_hatch
    end

    if label:match("input hatch$") then
        return aliases.input_hatch
    end

    if label:match("energy hatch$") then
        return aliases.energy_hatch
    end

    if label:match("maintenance hatch$") then
        return aliases.maintenance_hatch
    end

    if label:match("singularity$") then
        return aliases.singularity
    end

    if label:match("chest$") then
        return aliases.chest
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
                logger.info(slot .. ": " .. stack.label .. " -> " .. key)
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
        logger.info(key .. "" .. value)
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
