
mutable struct Node
    children::Vector{Node}
    parent::Union{Node, Nothing}
    weigth::Int
    name::String
end

function create_tree(filename)::Node
    root = Node([], nothing, 0, "root")
    current_node = root

    for line in readlines(filename)
        if line[1] == '$'
            if line[3:4] == "cd"
                dir = line[6:end]
                if dir == "/"
                    current_node = root
                elseif dir == ".."
                    current_node = current_node.parent
                else
                    node = Node([], current_node, 0, dir)
                    push!(current_node.children, node)
                    current_node = node
                end
            end
        else
            if line[1:3] == "dir"
                continue
            else
                filesize = parse(Int, split(line, " ")[1])
                current_node.weigth += filesize
            end
        end
    end

    return root
end

function get_total_size(root::Node)
    if length(root.children) == 0
        return root.weigth
    end

    weight = root.weigth
    for child in root.children
        weight += get_total_size(child)
    end

    return weight
end

function solution_part1(root::Node)::Int
    stack = [root]
    total_size = 0
    while !isempty(stack)
        node = pop!(stack)
        node_size = get_total_size(node)
        if node_size <= 100000
            total_size += node_size
        end

        for child in node.children
            push!(stack, child)
        end
    end

    return total_size
end

function solution_part2(root::Node)::Int
    directories_size = Vector{Int}()
    total_disk_size = 70000000
    update_size = 30000000

    stack = [root]
    while !isempty(stack)
        node = pop!(stack)
        node_size = get_total_size(node)
        push!(directories_size, node_size)

        for child in node.children
            push!(stack, child)
        end
    end

    used_size = maximum(directories_size)
    needed = update_size - (total_disk_size - used_size)

    return minimum([d for d in directories_size if d > needed])
end


root = create_tree("input.txt")
println("Solution part 1: ", solution_part1(root))
println("Solution part 1: ", solution_part2(root))