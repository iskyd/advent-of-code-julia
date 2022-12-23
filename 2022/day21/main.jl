function parse_input()::Dict{String, String}
    monkeys = Dict{String, String}()
    for line in readlines("input.txt")
        id = line[1:4]
        operation = line[7:end]

        monkeys[id] = operation
    end

    return monkeys
end

function yell(monkeys::Dict{String, String}, monkey_id::String)::Int
    if tryparse(Int, monkeys[monkey_id]) !== nothing
        return parse(Int, monkeys[monkey_id])
    end

    left = monkeys[monkey_id][1:4]
    right = monkeys[monkey_id][8:11]
    operation = monkeys[monkey_id][6]
    
    if operation == '+'
        return yell(monkeys, left) + yell(monkeys, right)
    elseif operation == '*'
        return yell(monkeys, left) * yell(monkeys, right)
    elseif operation == '/'
        return yell(monkeys, left) / yell(monkeys, right)
    elseif operation == '-'
        return yell(monkeys, left) - yell(monkeys, right)
    else
        error("Unknown operation: ", operation)
    end
end

function solution_part1(monkeys::Dict{String, String})::Int
    val = yell(monkeys, "root")

    return val
end

input = parse_input()
println("Solution part 1: ", solution_part1(input))