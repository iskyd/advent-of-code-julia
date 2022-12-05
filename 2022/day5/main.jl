using DataStructures

function reverse_stack(stack::Stack)
    new_stack = Stack{Char}()
    while !isempty(stack)
        push!(new_stack, pop!(stack))
    end

    return new_stack
end

function get_stacks(filename::String, total_stacks::Int)
    stacks = [Stack{Char}() for _ in 1:total_stacks]
    for line in readlines(filename)
        if !(contains(line, r"(\[[A-Z]\])")) break end

        for i in 1:total_stacks
            element = line[(i-1)*4+2]
            if element !== ' '
                push!(stacks[i], element)
            end
        end
    end

    for i in 1:total_stacks
        stacks[i] = reverse_stack(stacks[i])
    end

    return stacks
end

function get_rules(filename::String)
    regex = r"move (\d*) from (\d)* to (\d)*"
    rules = Tuple{Int, Int, Int}[]
    for line in readlines(filename)
        if !(contains(line, "move")) continue end

        res = match(regex, line)
        move, from, to = res[1], res[2], res[3] 
        push!(rules, (parse(Int, move), parse(Int, from), parse(Int, to)))
    end
    
    return rules
end

function solution_part1(stacks, rules)::Vector{Char}
    for (move, from, to) in rules
        for i in 1:move
            crate = pop!(stacks[from])
            push!(stacks[to], crate)
        end
    end

    res = []
    for stack in stacks
        push!(res, first(stack))
    end

    return res
end

function solution_part2(stacks, rules)::Vector{Char}
    for (move, from, to) in rules
        crates = []
        for i in 1:move
            crate = pop!(stacks[from])
            push!(crates, crate)
        end

        for crate in Iterators.reverse(crates)
            push!(stacks[to], crate)
        end
    end

    res = []
    for stack in stacks
        push!(res, first(stack))
    end

    return res
end

stacks = get_stacks("input.txt", 9)
rules = get_rules("input.txt")
println("Solution part 1 ", join(solution_part1(deepcopy(stacks), deepcopy(rules))))
println("Solution part 2 ", join(solution_part2(deepcopy(stacks), deepcopy(rules))))