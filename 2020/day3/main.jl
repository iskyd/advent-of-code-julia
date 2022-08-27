lines::Array{String} = readlines("/Users/iskyd/dev/advent-of-code-julia/2020/day3/input.txt")
map = Matrix{Char}(undef, length(lines), length(lines[1]))

for i in eachindex(lines)
    map[i, :] = only.(split(lines[i], ""))
end

function count_trees(map::Matrix{Char}, right::Int, down::Int)::Int
    total_trees::Int = 0
    r_pos = 1

    for i in 1:down:size(map)[1]
        row = i
        col = r_pos

        if map[row, col] == '#'
            total_trees += 1
        end

        r_pos = r_pos + right > size(map)[2] ? r_pos + right - size(map)[2] : r_pos + right
    end

    return total_trees
end

function solution_part_2(map::Matrix{Char})::Int
    steps::Vector{Tuple{Int,Int}} = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
    trees::Vector{Int} = [count_trees(map, right, down) for (right, down) in steps]

    return prod(trees)
end

println("Solution part 1: ", count_trees(map, 3, 1))
println("Solution part 2: ", solution_part_2(map))