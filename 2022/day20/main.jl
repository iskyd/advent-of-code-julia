mutable struct Node
    value::Int
    next::Union{Node,Nothing}
    prev::Union{Node,Nothing}
end

function get_linked_list(n::Int=1)::Tuple{Vector{Node},Node}
    input = parse.(Int, readlines("input.txt"))
    root = Node(input[1] * n, nothing, nothing)
    current = root
    for i in 2:length(input)
        current.next = Node(input[i] * n, nothing, current)
        current = current.next
    end
    root.prev = current
    current.next = root
    current = current.next

    nodes = Vector{Node}()
    for _ in 1:length(input)
        push!(nodes, current)
        current = current.next
    end

    return nodes, root
end

function mix(nodes::Vector{Node}, root::Node, k::Int=1)::Node
    n = length(nodes)
    m = n - 1
    starting::Union{Node,Nothing} = nothing

    for _ in 1:k
        for current in nodes
            if current.value == 0
                starting = current
                continue
            end

            target = current
            steps = current.value > 0 ? mod(current.value, m) : mod(n + current.value - 1, m)
            for _ in 1:steps
                target = target.next
            end

            if current == target
                continue
            end

            # Remove current
            current.prev.next = current.next
            current.next.prev = current.prev

            # Move current next to target
            current.next = target.next
            current.prev = target
            target.next.prev = current
            target.next = current
        end
    end

    return starting
end

function get_sum(starting::Node)::Int
    total = 0
    for _ in 1:3
        for _ in 1:1000
            starting = starting.next
        end
        total += starting.value
    end

    return total
end

function solution_part1(nodes::Vector{Node}, root::Node)::Int
    starting = mix(nodes, root)
    return get_sum(starting)
end

function solution_part2(nodes::Vector{Node}, root::Node)::Int
    starting = mix(nodes, root, 10)
    return get_sum(starting)
end

nodes, root = get_linked_list()
println("Solution part 1: ", solution_part1(nodes, root))
nodes, root = get_linked_list(811589153)
println("Solution part 2: ", solution_part2(nodes, root))