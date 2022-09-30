local component = require("component")
local sides = require("sides")

ADDRESS_TRANSPOSER_MACHINE = "f9c462a0"
ADDRESS_TRANSPOSER_SWITCH = "e05115f8"

SIDE_FLUID_STORAGE = sides.northw

trans_machine = component.proxy(component.get(ADDRESS_TRANSPOSER_MACHINE))
trans_switch = component.proxy(component.get(ADDRESS_TRANSPOSER_SWITCH))

SWITCH_SIDES = {0, 3, 4, 5}

function update()
    print("Updating stock / recipes.")

    os.execute("wget -f http://27.33.54.13/recipes.lua")
    os.execute("wget -f http://27.33.54.13/stock.lua")

    stock_targets = dofile("stock.lua")
    recipes = dofile("recipes.lua")

    print("Updated stock / recipes.")
end

update()

orient = {}

function reorient()
    for _, side in pairs(SWITCH_SIDES) do
        fluids = trans_switch.getFluidInTank(side)
        count = fluids["n"]
        for i=1,count,1 do
            if tank.amount > 0 then
                orient[tank.label] = {side = side, i = i}
            end
        end
    end
end

function get_stock() 
    stock = {}

    fluids = trans_machine.getFluidInTank(SIDE_FLUID_STORAGE)
    count = fluids["n"]
    for i=1,count,1 do
        tank = fluids[i]
        if tank.amount > 0 then
            if stock[tank.label] == nil then
                stock[tank.label] = 0
            end

            stock[tank.label] = stock[tank.label] + tank.amount
        end
    end

    return stock
end

function process() 
    reorient()
    stock = get_stock()
end

process()