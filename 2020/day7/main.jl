lines::Array{String} = readlines("input.txt")

function parse_lines(lines::Array{String})::Dict
    return Dict(
        line[1] => split(line[2], ", ") for line in
        [split(line, " bags contain ") for line in lines]
    )
end

function solution_part_1(rules::Dict)::Int
    function get_parents(bag::String)::Array{String}
        parsed_rules = Dict(
            parent => [typeof(match(r"\d (\w+\s\w+) bag", child)) != Nothing ? match(r"\d (\w+\s\w+) bag", child)[1] : false for child in children] for (parent, children) in rules
        )

        return [
            parent for (parent, children) in parsed_rules if
            bag in children
        ]
    end

    function get_all_parents(bag::String)::Array{String}
        parents = get_parents(bag)
        for parent in parents
            parents = unique([parents; get_all_parents(parent)])
        end

        return parents
    end

    return length(get_all_parents("shiny gold"))
end

println("Solution part 1: ", solution_part_1(parse_lines(lines)))