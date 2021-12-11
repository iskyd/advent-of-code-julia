lines = readlines("input.txt")


function solution_part_1(lines)
    depth = 0
    horizontal = 0
    for line in lines
        action, value = split(line, " ")
        value = parse(Int16, value)
        if action == "up"
            depth -= value
        elseif action == "down"
            depth += value
        elseif action == "forward"
            horizontal += value
        end
    end

    return horizontal * depth
end

function solution_part_2(lines)
    depth = 0
    horizontal = 0
    aim = 0
    for line in lines
        action, value = split(line, " ")
        value = parse(Int16, value)
        if action == "up"
            aim -= value
        elseif action == "down"
            aim += value
        elseif action == "forward"
            horizontal += value
            depth += aim * value
        end
    end

    return horizontal * depth
end

println("Solution part 1: ", solution_part_1(lines))
println("Solution part 2: ", solution_part_2(lines))