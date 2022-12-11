using ResumableFunctions
using Memoize

CYCLES = (20, 60, 100, 140, 180, 220)

@resumable function get_instructions()::Tuple{String, Union{Int, Nothing}}
    for line in readlines("input.txt")
        splitted = split(line, " ")
        instruction = splitted[1]
        value = length(splitted) == 2 ? parse(Int, splitted[2]) : nothing

        @yield instruction, value
    end
end

@memoize function get_registry_values()::Vector{Int}
    cycle = 1
    x_registry = 1
    registry_values = Vector{Int}()
    for (instruction, value) in get_instructions()
        if instruction == "noop"
            push!(registry_values, x_registry)
            cycle += 1
        else
            push!(registry_values, x_registry)
            push!(registry_values, x_registry)
            cycle += 2
            x_registry += value
        end
    end

    return registry_values
end

function solution_part1()::Int
    registry_values = get_registry_values()
    
    return sum([registry_values[i] * i for i in CYCLES])
end

function solution_part2()
    registry_values = get_registry_values()

    cycle = 0
    for i in eachindex(registry_values)
        if registry_values[i] == cycle || registry_values[i] == cycle + 1 || registry_values[i] == cycle - 1
            print("█")
        else
            print(" ")
        end

        cycle += 1

        if cycle == 40
            println()
            cycle = 0
        end
    end
end

println("Solution part 1: ", solution_part1())
solution_part2()