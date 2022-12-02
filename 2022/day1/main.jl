using ResumableFunctions

@resumable function get_calories()
    calory = 0
    for line in readlines("input.txt")
        if line == ""
            @yield calory
            calory = 0
        else
            calory += parse(Int, line)
        end
    end
end

function solution()::Tuple{Int, Int}
    elvesCalories = Vector{Int}()

    for calory in get_calories()
        push!(elvesCalories, calory)
        elvesCalories = sort(elvesCalories, rev=true)
        if length(elvesCalories) > 3
            elvesCalories = elvesCalories[1:3]
        end
    end

    return elvesCalories[1], sum(elvesCalories)
end

function optimized_part_2()::Int
    total_calories, max, min = 0, 0, 0
    for calory in get_calories()
        if calory > min
            total_calories = total_calories - min + calory
            if calory >= max
                min = total_calories - calory - max
                max = calory
            else
                min = calory < total_calories - calory - max ? calory : (min === 0 ? calory : min)
            end
        end
    end

    return total_calories
end

part1, part2 = solution()
println("Solution part 1: ", part1)
println("Solution part 2: ", part2)
println("Optimized part 2: ", optimized_part_2())
