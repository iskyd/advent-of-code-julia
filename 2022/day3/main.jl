using ResumableFunctions

@resumable function get_groups(file)
    i = 0
    group = Vector{String}()
    for line in readlines(file)
        if i == 3
            @yield group
            group = Vector{String}()
            push!(group, line)
            i = 1
        else
            push!(group, line)
            i += 1
        end
    end

    @yield group
end

function get_priority(c::Char)
    return lowercase(c) == c ? Int(c) - 96 : Int(c) - 38
end

function solution_part1()::Int
    sum_priorities::Int = 0
    for line in readlines("input.txt")
        first_compartment, second_compartment = line[1:div(length(line), 2)], line[div(length(line), 2) + 1:end]
        priorities_first_compartment = map(c -> get_priority(only(c)), split(first_compartment, ""))
        priorities_second_compartment = map(c -> get_priority(only(c)), split(second_compartment, ""))

        intersection = intersect(priorities_first_compartment, priorities_second_compartment)
        sum_priorities += intersection[1]
    end

    return sum_priorities
end


function solution_part2()::Int
    total = 0
    for group in get_groups("input.txt")
        converted_group = [map(c -> get_priority(only(c)), split(element, "")) for element in group]
        intersection = intersect(converted_group[1], converted_group[2], converted_group[3])

        total += intersection[1]
    end

    return total
end


println("Solution part 1: ", solution_part1())
println("Solution part 2: ", solution_part2())