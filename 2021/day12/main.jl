lines = readlines("/home/mattia/dev/advent-of-code-julia/2021/day12/input.txt")

function build_nodes(lines)
    nodes = Dict()

    for line in lines
        (node1, node2) = split(line, "-")
        if !(haskey(nodes, node1)) nodes[node1] = Dict("multiple_visits_allowed" => lowercase(node1) == node1 ? false : true, "connections" => []) end
        if !(haskey(nodes, node2)) nodes[node2] = Dict("multiple_visits_allowed" => lowercase(node2) == node2 ? false : true, "connections" => []) end

        push!(nodes[node1]["connections"], node2)
        push!(nodes[node2]["connections"], node1)
    end

    return nodes
end

function get_paths(nodes)
    incomplete = [["start"]]
    complete = []

    while length(incomplete) > 0
        previous = pop!(incomplete)
        for node in nodes[last(previous)]["connections"]
            if nodes[node]["multiple_visits_allowed"] === true || !(node in previous)
                tmp = copy(previous)
                if node == "end"
                    push!(complete, push!(tmp, "end"))
                else
                    push!(incomplete, push!(tmp, node))
                end
            end
        end
    end

    return complete
end

nodes = build_nodes(lines)
paths = get_paths(nodes)
println("Solution part 1: ", length(paths))