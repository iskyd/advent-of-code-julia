using DataStructures

lines = readlines("input.txt")

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

function solution_part_1(template, rules, steps = 10)
    result = ""
    for i in 1:steps
        for j in 1:length(template)-1
            if haskey(rules, template[j:j+1])
                result *= string(template[j]) * string(rules[template[j:j+1]])
            else
                result *= string(template[j])
            end
        end

        result *= string(template[end])

        template = result
        result = ""
    end

    c = counter(split(template, ""))

    return maximum(values(c)) - minimum(values(c))
end

(template, rules) = get_template_rules(lines)
println("Solution part 1: ", solution_part_1(template, rules))