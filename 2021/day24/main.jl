lines = readlines("input.txt")

function get_instructions(lines)
    instructions = []

    for line in lines
        instruction = split(line, " ")
        if instruction[1] == "inp" 
            push!(instructions, (instruction[1], instruction[2])) 
        else
            x = tryparse(Int, instruction[3])
            if x === nothing
                push!(instructions, (instruction[1], instruction[2], instruction[3]))
            else
                push!(instructions, (instruction[1], instruction[2], x))
            end
        end
    end

    return instructions
end

function solution(instructions)
    # The instructions repeat after 18 steps (on every "inp").
    programs = []
    for i in 1:18:length(instructions)
        push!(programs, instructions[i:i+17])
    end
    
    # We divide the programs in 2 types. Look at https://github.com/goggle/AdventOfCode2021.jl/blob/master/src/day24.jl for the idea.
    program_types = [!isempty(findall(x -> (x[1] == "div" && x[2] == "z" && x[3] == 1), program)) for program in programs]
    add_to_x = [program[findfirst(x -> (x[1] == "add" && x[2] == "x" && isa(x[3], Int)), program)][3] for program in programs]
    add_to_z = [program[findlast(x -> (x[1] == "add" && x[2] == "y" && isa(x[3], Int)), program)][3] for program in programs]

    inputs = Int[]
    solve!(inputs, programs, 1, 0, program_types, add_to_x, add_to_z, true)
    part1 = parse(Int, join(inputs))

    inputs = Int[]
    solve!(inputs, programs, 1, 0, program_types, add_to_x, add_to_z, false)
    part2 = parse(Int, join(inputs))

    return [part1, part2]
end

function solve!(inputs, programs, programnumber, z, program_types, add_to_x, add_to_z, p1)
    length(inputs) == length(programs) && return true
    if program_types[programnumber]
        range = (p1 == true ? (9:-1:1) : (1:9))
        for w ∈ range
            push!(inputs, w)
            result = solve!(inputs, programs, programnumber + 1, 26 * z + w + add_to_z[programnumber], program_types, add_to_x, add_to_z, p1)
            if !result
                pop!(inputs)
                continue
            end

            return result
        end

        return false
    else
        value = mod(z, 26) + add_to_x[programnumber]
        value ∉ 1:9 && return false

        push!(inputs, value)
        result = solve!(inputs, programs, programnumber + 1, z ÷ 26, program_types, add_to_x, add_to_z, p1)
        if !result
            pop!(inputs)
        end

        return result
    end
end

instructions = get_instructions(lines)
part1, part2 = solution(instructions)
println("Solution part 1: ", part1)
println("Solution part 2: ", part2)