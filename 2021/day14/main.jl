using DataStructures

lines = readlines("/home/mattia/dev/advent-of-code-julia/2021/day14/input.txt")

function get_template_rules(lines)
    template = lines[1]

    rules = Dict()
    lines = lines[3:end]
    for line in lines
        rule = split(line, " -> ")
        rules[rule[1]] = rule[2]
    end

    return template, rules
end

# First attempt. Not the most efficient. Obviously is better to use the second method also for the first part. I will leave this one here for reference of my first approach.
function solution_part_1(template, rules, steps = 10)
    result = ""
    for i in 1:steps
        for j in 1:length(template)-1
            result *= string(template[j])
            if haskey(rules, template[j:j+1])
                result *= string(rules[template[j:j+1]])
            end
        end

        result *= string(template[end])

        template = result
        result = ""
    end

    c = counter(split(template, ""))

    return maximum(values(c)) - minimum(values(c))
end

function solution_part_2(template, rules, steps = 40)
    c = Dict()
    for i in 1:length(template)-1
        pair = template[i] * template[i+1]
        if !(haskey(c, pair)) c[pair] = 0 end
        c[pair] += 1
    end

    for i in 1:steps
        new_c = copy(c)
        for (key, value) in rules
            if haskey(c, key)
                new1 = key[1] * value
                new2 = value * key[2]

                if !(haskey(new_c, new1)) new_c[new1] = 0 end
                if !(haskey(new_c, new2)) new_c[new2] = 0 end

                occurrences = c[key]
                new_c[new1] += occurrences
                new_c[new2] += occurrences
                new_c[key] -= occurrences
            end
        end

        c = new_c
    end
    
    counter = Dict()
    for (key, value) in c
        if !(haskey(counter, key[1])) counter[key[1]] = 0 end
        if !(haskey(counter, key[2])) counter[key[2]] = 0 end

        counter[key[1]] += value
        counter[key[2]] += value
    end

    counter[template[1]] += 1
    counter[template[end]] += 1

    for (key, value) in counter
        counter[key] = trunc(Int, value / 2)
    end

    return maximum(values(counter)) - minimum(values(counter))
end

(template, rules) = get_template_rules(lines)
println("Solution part 1: ", solution_part_1(template, rules, 10))
println("Solution part 2: ", solution_part_2(template, rules, 40))