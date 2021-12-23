lines = readlines("input.txt")

mutable struct Node
    connections
    weight
    f
    J
end

function get_matrix(lines)
    matrix = zeros(Int16, size(lines)[1], length(lines[1]))

    for i in 1:size(lines)[1]
        matrix[i,:] = parse.(Int16, split(lines[i], ""))
    end

    return matrix
end

function get_neighbours(matrix, i, j)
    neighbours = []
    if i > 1 push!(neighbours, [i-1, j]) end
    if i < size(matrix)[1] push!(neighbours, [i+1, j]) end
    if j > 1 push!(neighbours, [i, j-1]) end
    if j < size(matrix)[2] push!(neighbours, [i, j+1]) end

    return [((i - 1) * size(matrix)[2]) + j for (i, j) in neighbours]
end

function init_nodes(lines)
    matrix = get_matrix(lines)
    nodes = Dict()

    for i in 1:size(matrix)[1]
        for j in 1:size(matrix)[2]
            node_index = ((i - 1) * size(matrix)[2]) + j
            nodes[node_index] = Node(get_neighbours(matrix, i, j), matrix[i, j], Inf, undef)
            if node_index == 1 nodes[node_index].f = 0 end
            if node_index in nodes[1].connections 
                nodes[node_index].J = 1 
                nodes[node_index].f = nodes[node_index].weight
            end
        end
    end

    return nodes
end

function find_min(nodes)
    min_node = Inf
    min_index = undef

    for (key, node) in nodes
        if node.f < min_node
            min_node = node.f
            min_index = key
        end
    end

    return min_index, min_node
end

# dijkstra implementation
function solution_part_1(nodes, source, target)
    Q = copy(nodes)

    dist = Dict()
    previous = Dict()
    for (key, val) in Q
        dist[key] = Inf
        previous[key] = undef
    end

    dist[source] = 0


    while !(isempty(Q))
        u_idx = reduce((x, y) -> dist[x] ≤ dist[y] ? x : y, keys(Q))
        u = pop!(Q, u_idx)

        if dist[u_idx] == Inf break end

        for v in u.connections
            if !(haskey(Q, v)) continue end

            alt = dist[u_idx] + Q[v].weight
            if alt < dist[v]
                dist[v] = alt
                previous[v] = u_idx
            end
        end
    end

    return dist[target]
end

nodes = init_nodes(lines)
target = size(lines)[1] * length(lines[1])
println("Solution part 1: ", solution_part_1(nodes, 1, target))