lines::Array{String} = readlines("/Users/iskyd/dev/advent-of-code-julia/2020/day8/input.txt")

struct Instruction
    op::String
    arg::Int
end

function parse_instructions(lines::Array{String})::Array{Instruction}
    return [Instruction(line[1:3], parse(Int, line[4:end])) for line in lines]
end

function solution_part_1(instructions::Array{Instruction})::Int
    i = 1
    acc = 0
    executed = Set{Int}()
    while true
        instruction = instructions[i]
        if instruction.op == "acc"
            acc += instruction.arg
        end

        push!(executed, i)

        i = i + (instruction.op == "jmp" ? instruction.arg : 1)

        if i in executed
            return acc
        end
    end
end

instructions = parse_instructions(lines)
println("Solution part 1: ", solution_part_1(instructions))