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

part1, part2 = solution()
println("Solution part 1: ", part1)
println("Solution part 2: ", part2)
