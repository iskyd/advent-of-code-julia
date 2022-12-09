function is_visible(map::Matrix{Int}, i::Int, j::Int)
    left = map[i, j+1:end]
    right = map[i, 1:j-1]
    up = map[1:i-1, j]
    bottom = map[i+1:end, j]

    return any([all([val < map[i, j] for val in left]), all([val < map[i, j] for val in right]), all([val < map[i, j] for val in up]), all([val < map[i, j] for val in bottom])])
end

function score(slice::Vector{Int}, h::Int)
    return something(findfirst(h .<= slice), size(slice, 1))
end

function get_scenic_score(map::Matrix{Int}, i::Int, j::Int)
    h = map[i, j]
    return score(map[i, j+1:end], h) * score(reverse(map[i, 1:j-1]), h) * score(reverse(map[1:i-1, j]), h) * score(map[i+1:end, j], h)
end

function solution_part1(map::Matrix{Int})::Int
    total_visibles = size(map)[1] * 2 + size(map)[2] * 2 - 4
    for i in 2:size(map)[1]-1
        for j in 2:size(map)[2]-1
            if is_visible(map, i, j)
                total_visibles += 1
            end
        end
    end

    return total_visibles
end

function solution_part2(map::Matrix{Int})::Int
    return maximum([get_scenic_score(map, i, j) for i = axes(map, 1) for j = axes(map, 2)])
end

map::Matrix{Int} = parse.(Int, reduce(hcat, collect.(readlines("input.txt"))))
println("Solution part 1: ", solution_part1(map))
println("Solution part 2: ", solution_part2(map))