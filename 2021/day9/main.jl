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

matrix = create_matrix(lines)
index_lowest_points = find_index_lowest_points(matrix)
println("Solution part 1: ", total_heigth_of_lowest_points([matrix[x[1],x[2]] for x in index_lowest_points]))