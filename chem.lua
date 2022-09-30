local component = require("component")

ADDRESS_TRANSPOSER_MACHINE = "f9c462a0"
ADDRESS_TRANSPOSER_SWITCH = "e05115f8"

SIDE_FLUID_STORAGE = 2

trans_machine = component.proxy(component.get(ADDRESS_TRANSPOSER_MACHINE))
trans_switch = component.proxy(component.get(ADDRESS_TRANSPOSER_SWITCH))

function check_update() 
end

function update()
    print("Updating stock / recipes.")

    os.execute("wget https://github.com/PeterKlimk/NORDAR/blob/main/recipes.lua")
    os.execute("wget https://github.com/PeterKlimk/NORDAR/blob/main/stock.lua")

    stock_targets = dofile("stock.lua")
    recipes = dofile("recipes.lua")

    print("Updated stock / recipes.")
end

update()

function get_stock() 
    stock = {}

    fluids = transposer_machine.getFluidInTank(SIDE_FLUID_STORAGE)
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

print(check_stock())