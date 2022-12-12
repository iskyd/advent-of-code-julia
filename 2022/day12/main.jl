using DataStructures

heightmap::Matrix{Int} = map(c -> Int(c), reduce(hcat, collect.(readlines("input.txt"))))
start_point = findfirst(x -> x == 83, heightmap::Matrix)
end_point = findfirst(x -> x == 69, heightmap::Matrix)

heightmap[start_point] = Int('a')
heightmap[end_point] = Int('z')

function solution_part1(heightmap::Matrix{Int}, start_point::CartesianIndex, end_point::CartesianIndex)::Int
    visited = Set{CartesianIndex}()
    queue = Queue{Tuple{Int, CartesianIndex}}()
    enqueue!(queue, (0, end_point))

    deltas = [CartesianIndex(-1, 0), CartesianIndex(1, 0), CartesianIndex(0, -1), CartesianIndex(0, 1)]

    while !isempty(queue)
        steps, current_point = dequeue!(queue)
        if current_point == start_point
            return steps
        end

        for delta in deltas
            new_point = current_point + delta
            if new_point in visited
                continue
            end

            if new_point in CartesianIndices(heightmap) && heightmap[current_point] - heightmap[new_point] <= 1
                enqueue!(queue, (steps + 1, new_point))
                push!(visited, new_point)
            end
        end
    end

    return -1
end

println("Solution part 1: ", solution_part1(heightmap, start_point, end_point))