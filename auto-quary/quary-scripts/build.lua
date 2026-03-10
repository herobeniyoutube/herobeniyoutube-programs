local sides = require("sides")

local movement = require("movement")
local building = require("building")
local using = require("using")
local inventory = require("inventory")

local function buildRingEdge()
    building.forwardThenPlaceLeft(inventory.aliases.smart_cable, {
        function()
            movement.stepsUp(1)
        end,
        function()
            for i = 1, 3 do
                building.place(inventory.aliases.ring)
                if i < 3 then
                    movement.stepsUp(1)
                end
            end
        end,
        function() movement.stepsDown(3) end
    })
end

inventory.inventoryInit()

movement.stepsForward(2)
building.place(inventory.aliases.casing)
movement.stepsBack(1)
building.place(inventory.aliases.casing)
movement.stepsBack(1)
building.place(inventory.aliases.ore_drilling_plant)

movement.move(movement.to.turnRight)
movement.stepsForward(2)
movement.move(movement.to.turnLeft)
building.forwardThenPlaceLeft(inventory.aliases.energy_hatch)
building.forwardThenPlaceLeft(inventory.aliases.input_hatch)
building.forwardThenPlaceLeft(inventory.aliases.output_hatch)

movement.stepsForward(1)
movement.move(movement.to.turnLeft)
movement.stepsForward(4)
movement.move(movement.to.turnLeft)
building.forwardThenPlaceLeft(inventory.aliases.lv_input_bus)
building.forwardThenPlaceLeft(inventory.aliases.output_bus)
building.forwardThenPlaceLeft(inventory.aliases.maintenance_hatch)

movement.stepsForward(1)
movement.move(movement.to.turnLeft)
movement.stepsForward(1)
movement.move(movement.to.turnLeft)
using.use(sides.front, true)

movement.stepsUp(1)
movement.stepsForward(2)
movement.move(movement.to.turnRight)
movement.stepsForward(1)

for i = 1, 3 do
    for j = 1, 4 do
        building.place(inventory.aliases.frame_box)
        movement.move(movement.to.turnLeft)
    end

    movement.stepsUp(1)
    building.placeDown(inventory.aliases.casing)
end

building.buildSpear(3, inventory.aliases.frame_box)

movement.stepsForward(3)
movement.move(movement.to.turnRight)
movement.stepsForward(2)
movement.turnAround()
movement.stepsDown(7)

building.forwardThenPlaceLeft(inventory.aliases.p2p_tunnel, {
    function() using.useItem(sides.front, inventory.aliases.energy_tunnel) end, -- линк туннеля
    function() building.place(inventory.aliases.smart_cable) end
})

building.forwardThenPlaceLeft(inventory.aliases.p2p_tunnel, {
    function() using.useItem(sides.front, inventory.aliases.fluid_tunnel) end, -- линк туннеля
    function() building.place(inventory.aliases.smart_cable) end
})

building.forwardThenPlaceLeft(inventory.aliases.fluid_import_bus, {
    function() building.place(inventory.aliases.smart_cable) end
})

movement.stepsForward(2)
movement.move(movement.to.turnLeft)
building.forwardThenPlaceLeft(inventory.aliases.smart_cable)

buildRingEdge()

building.forwardThenPlaceLeft(inventory.aliases.dense_cable, {
    function()
        movement.stepsUp(1)
    end,
    function()
        building.place(inventory.aliases.ring)
        movement.stepsUp(1)
    end,
    function()
        building.place(inventory.aliases.ring_center, {
            function()
                building.drop(inventory.aliases.singularity)
            end
        })
        movement.stepsUp(1)
    end,
    function()
        building.place(inventory.aliases.ring)
        movement.stepsUp(1)
    end,
    function()
        building.place(inventory.aliases.dense_energy_cell)
    end,
    function()
        movement.stepsDown(4)
    end
})

buildRingEdge()

movement.stepsForward(2)
movement.move(movement.to.turnLeft)

building.forwardThenPlaceLeft(inventory.aliases.smart_cable)
building.forwardThenPlaceLeft(inventory.aliases.p2p_tunnel, {
    function()
        using.useItem(sides.front, inventory.aliases.pipes_tunnel)
        building.place(inventory.aliases.smart_cable)
    end
})
building.forwardThenPlaceLeft(inventory.aliases.import_bus, {
    function()
        using.useItem(sides.front, inventory.aliases.acceleration_card, true)
        building.place(inventory.aliases.smart_cable)
    end
})
building.forwardThenPlaceLeft(inventory.aliases.smart_cable, {
    function()
        movement.stepsUp(1)
        movement.stepsForward(1)
        building.place(inventory.aliases.chest)
        movement.stepsBack(1)
        building.place(inventory.aliases.import_bus)
        building.place(inventory.aliases.smart_cable)
        movement.stepsDown(1)
    end
})
building.forwardThenPlaceLeft(inventory.aliases.charger, {
    function()
        movement.stepsUp(1)
        building.place(inventory.aliases.smart_cable)
        movement.stepsDown(1)
    end
})

movement.stepsForward(1)
movement.move(movement.to.turnLeft)
movement.stepsForward(2)
movement.move(movement.to.turnLeft)
movement.stepsForward(1)
movement.move(movement.to.turnLeft)

inventory.selectItem(inventory.aliases.computer_wrench)
inventory.switchToolWrapper(function()
    using.use(sides.front)
end)

movement.stepsUp(1)
building.place(inventory.aliases.p2p_tunnel, {
    function() using.useItem(sides.front, inventory.aliases.supply_tunnel) end, -- линк туннеля
})

movement.stepsDown(1)
movement.move(movement.to.turnRight)
