lines = readlines("input.txt")

function create_matrix(lines)
    rows = size(lines)[1]
    columns = size(split(lines[1], ""))[1]
    matrix = zeros(Int16, rows, columns)
    
    for i in 1:rows
        matrix[i,:] = parse.(Int16, split(lines[i], ""))
    end
    
    return matrix
end

function add_padding(matrix, value=9)
    v = ones(Int16, 1, size(matrix)[2]) * value
    h = ones(Int16, size(matrix)[1] + 2, 1) * value

    return hcat(h, vcat(v, matrix, v), h)
end

function find_index_lowest_points(matrix)
    matrix = add_padding(matrix)
    index_lowest_points = Array{Int16}[]
    for i in 2:size(matrix)[1] - 1
        for j in 2:size(matrix)[2] - 1
            if matrix[i, j] < min(matrix[i - 1, j], matrix[i + 1, j], matrix[i, j - 1], matrix[i, j + 1])
                push!(index_lowest_points, [i - 1, j - 1])
            end
        end
    end

    return index_lowest_points
end

function total_heigth_of_lowest_points(lowest_points)
    v = ones(Int16, size(lowest_points)[1])

    return sum(lowest_points + v)
end

function find_largest_basins(matrix, index_lowest_points)
    basins = []
    for index_lowest_point in index_lowest_points 
        push!(basins, find_basin_size(matrix, index_lowest_point))
    end

    return sort(basins, rev=true)[1:3]
end

function get_neighbors_points(matrix, index)
    adjacent_transormation = [[1, 0], [0, 1], [-1, 0], [0, -1]]
    neighbors = [index + transformation for transformation in adjacent_transormation]

    return neighbors
end

function find_basin_size(matrix, index_lowest_point)
    padding_matrix = add_padding(matrix)
    next_indexes = get_neighbors_points(padding_matrix, index_lowest_point + [1, 1])
    valid_indexes = [index_lowest_point + [1, 1]]
    total_size = 1
    while !(isempty(next_indexes))
        index = pop!(next_indexes)
        if padding_matrix[index...] != 9
            total_size += 1
            push!(valid_indexes, index)
            neighbors = get_neighbors_points(padding_matrix, index)
            for neighbor in neighbors
                if !(neighbor in next_indexes) && !(neighbor in valid_indexes) && padding_matrix[neighbor...] != 9
                    push!(next_indexes, neighbor)
                end
            end
        end
    end

    return total_size
end

matrix = create_matrix(lines)
index_lowest_points = find_index_lowest_points(matrix)
println("Solution part 1: ", total_heigth_of_lowest_points([matrix[x[1],x[2]] for x in index_lowest_points]))

println("Solution part 2: ", prod(find_largest_basins(matrix, index_lowest_points)))