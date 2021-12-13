using Statistics

lines = readlines("input.txt")

submarines = sort(parse.(Int16, split(lines[1], ",")))

function solution_part_1(submarines)
    best_point = trunc(Int16, median(submarines)) 

    v = ones(Int16, size(submarines)[1]) * best_point
    fuel_consumption_v = [abs(x) for x in submarines - v]
    fuel_consumption = sum(fuel_consumption_v)

    return fuel_consumption
end

function solution_part_2(submarines)
    best_points = [floor(Int16, mean(submarines)), ceil(Int16, mean(submarines))]

    best_fuel_consuption = nothing
    for best_point in best_points
        v = ones(Int16, size(submarines)[1]) * best_point
        fuel_consumption_v = [abs(x) for x in submarines - v]
        fuel_consumption = sum([sum(collect(1:x)) for x in fuel_consumption_v])
        if best_fuel_consuption === nothing || fuel_consumption < best_fuel_consuption
            best_fuel_consuption = fuel_consumption
        end
    end
    
    return best_fuel_consuption
end


println("Solution part 1: ", solution_part_1(submarines))
println("Solution part 2: ", solution_part_2(submarines))