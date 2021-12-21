lines = readlines("input.txt")

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

function solution_part_1(nodes)
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

    return length(complete)
end

function solution_part_2(nodes)
    incomplete = [["start"]]
    complete = []

    while length(incomplete) > 0
        previous = pop!(incomplete)
        d = Dict([(i, count(x -> x == i, previous)) for i in unique(previous)])
        multiple_visits_occurred = false
        for (key, value) in d
            if nodes[key]["multiple_visits_allowed"] === false && value > 1
                multiple_visits_occurred = true
                break
            end
        end

        for node in nodes[last(previous)]["connections"]
            if nodes[node]["multiple_visits_allowed"] === false && multiple_visits_occurred === true && node in previous continue end
            if node == "start" continue end
            
            tmp = copy(previous)
            if node == "end"
                push!(complete, push!(tmp, "end"))
            else
                push!(incomplete, push!(tmp, node))
            end
        end
    end

    return length(complete)
end

nodes = build_nodes(lines)
println("Solution part 1: ", solution_part_1(nodes))
println("Solution part 2: ", solution_part_2(nodes))