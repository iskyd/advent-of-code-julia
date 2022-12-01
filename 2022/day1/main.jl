function solutionPart1()::Int
    maxElvesCalories = 0
    currentElvesCalories = 0

    for line in readlines("input.txt")
        if line == ""
            if currentElvesCalories > maxElvesCalories
                maxElvesCalories = currentElvesCalories
            end
            currentElvesCalories = 0
        else
            currentElvesCalories += parse(Int, line)
        end
    end

    return maxElvesCalories
end

function solutionPart2()::Int
    elvesCalories = Vector{Int}()
    currentElvesCalories = 0
    for line in readlines("input.txt")
        if line == ""
            push!(elvesCalories, currentElvesCalories)
            elvesCalories = sort(elvesCalories, rev=true)
            if length(elvesCalories) > 3
                elvesCalories = elvesCalories[1:3]
            end
            currentElvesCalories = 0
        else
            currentElvesCalories += parse(Int, line)
        end
    end

    return sum(elvesCalories)
end

println("Solution part 1: ", solutionPart1())
println("Solution part 2: ", solutionPart2())
