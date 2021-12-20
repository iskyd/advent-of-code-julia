lines = readlines("input.txt")

function get_matrix(lines)
    matrix = zeros(Int16, 10, 10)

    for i in 1:10
        matrix[i,:] = parse.(Int16, split(lines[i], ""))
    end

    return matrix
end

function add_padding(matrix, value=9)
    v = ones(Int16, 1, size(matrix)[2]) * value
    h = ones(Int16, size(matrix)[1] + 2, 1) * value

    return hcat(h, vcat(v, matrix, v), h)
end

function remove_padding(matrix)
    return matrix[2:size(matrix)[1] - 1, 2:size(matrix)[2] - 1]
end

function increment_neighbors(matrix, i, j)
    matrix = add_padding(matrix)
    i += 1
    j += 1

    neighbors = [[i - 1, j - 1], [i - 1, j], [i - 1, j + 1], [i, j - 1], [i, j + 1], [i + 1, j - 1], [i + 1, j], [i + 1, j + 1]]
    for neighbor in neighbors
        if matrix[neighbor[1], neighbor[2]] != 0
            matrix[neighbor[1], neighbor[2]] = matrix[neighbor[1], neighbor[2]] + 1
        end
    end

    return remove_padding(matrix)
end

function get_total_flashes(matrix, steps)
    v = ones(Int16, size(matrix)[1], size(matrix)[2])
    total_flashes = 0
    for i in 1:steps
        matrix = matrix + v
        while count(i->(i > 9), (vec(matrix))) > 0
            for i in 1:size(matrix)[1]
                for j in 1:size(matrix)[2]
                    if matrix[i, j] > 9
                        total_flashes += 1
                        matrix[i, j] = 0
                        # Update neighbors
                        matrix = increment_neighbors(matrix, i, j)
                    end
                end
            end
        end
    end

    return total_flashes
end

function get_first_step_simultaneosly_flashes(matrix)
    v = ones(Int16, size(matrix)[1], size(matrix)[2])
    i = 1
    while true
        matrix = matrix + v
        while count(i->(i > 9), (vec(matrix))) > 0
            for i in 1:size(matrix)[1]
                for j in 1:size(matrix)[2]
                    if matrix[i, j] > 9
                        matrix[i, j] = 0
                        # Update neighbors
                        matrix = increment_neighbors(matrix, i, j)
                    end
                end
            end
        end

        if count(i->(i == 0), (vec(matrix))) == size(matrix)[1] * size(matrix)[2]
            return i
        end

        i += 1
    end
end

matrix = get_matrix(lines)
println("Solution part 1: ", get_total_flashes(matrix, 100))
println("Solution part 2: ", get_first_step_simultaneosly_flashes(matrix))
