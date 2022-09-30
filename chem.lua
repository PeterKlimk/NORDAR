local component = require("component")
local stock = 

ADDRESS_TRANSPOSER_MACHINE = "f9c462a0"
ADDRESS_TRANSPOSER_SWITCH = "e05115f8"

SIDE_FLUID_STORAGE = 2

trans_machine = component.proxy(component.get(ADDRESS_TRANSPOSER_MACHINE))
trans_switch = component.proxy(component.get(ADDRESS_TRANSPOSER_SWITCH))

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

            stock[tank.label] += tank.amount
        end
    end

    return stock
end

print(check_stock())