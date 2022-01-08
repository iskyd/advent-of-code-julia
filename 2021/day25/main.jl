lines = readlines("input.txt")

function get_matrix(lines)
    matrix = Matrix{Char}(undef, length(lines), length(lines[1]))
    for i in 1:size(lines)[1]
        matrix[i,:] = only.(split(lines[i], ""))
    end

    return matrix
end

function move(matrix)
    total_movements = 0
    # East
    movements = []
    for i in 1:size(matrix)[1]
        for j in 1:size(matrix)[2]
            if matrix[i,j] == '>'
                if j < size(matrix)[2] && matrix[i, j+1] == '.'
                    push!(movements, [i, j, i, j+1])
                elseif j == size(matrix)[2] && matrix[i, 1] == '.'
                    push!(movements, [i, j, i, 1])
                end
            end
        end
    end

    total_movements += length(movements)
    for movement in movements
        matrix[movement[1], movement[2]] = '.'
        matrix[movement[3], movement[4]] = '>'
    end

    # Suth
    movements = []
    for i in 1:size(matrix)[1]
        for j in 1:size(matrix)[2]
            if matrix[i,j] == 'v'
                if i < size(matrix)[1] && matrix[i+1, j] == '.'
                    push!(movements, [i, j, i + 1, j])
                elseif i == size(matrix)[1] && matrix[1, j] == '.'
                    push!(movements, [i, j, 1, j])
                end
            end
        end
    end

    total_movements += length(movements)
    for movement in movements
        matrix[movement[1], movement[2]] = '.'
        matrix[movement[3], movement[4]] = 'v'
    end

    return matrix, total_movements
end

function solution_part_1(matrix)
    total_movements = 1
    steps = 0
    while total_movements != 0
        matrix, total_movements = move(matrix)
        steps += 1
    end

    return steps
end

matrix = get_matrix(lines)
println("Solution part 1: ", solution_part_1(matrix))