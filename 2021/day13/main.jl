lines = readlines("input.txt")

function get_coordinates_folding(lines)
    index = findall(x->x=="", lines)[1]

    coordinates = []
    foldings = []

    for line in lines[1:index-1]
        push!(coordinates, parse.(Int16, split(line, ",")))
    end

    for line in lines[index+1:end]
        push!(foldings, line)
    end

    return coordinates, foldings
end

function get_cartesian_matrix(coordinates)
    max_x = 0
    max_y = 0
    for (x, y) in coordinates
        if x > max_x max_x = x end
        if y > max_y max_y = y end
    end

    matrix = zeros(Bool, max_y+1, max_x+1)

    for (x, y) in coordinates
        matrix[y + 1, x + 1] = true
    end

    return matrix
end

function fold_matrix(matrix, folding)
    axes, fold_value = split(replace(folding, "fold along " => ""), "=")
    fold_value = parse(Int16, fold_value)
    
    if axes == "x"
        matrix1 = matrix[:, 1:fold_value]
        matrix2 = matrix[:, fold_value + 2:end]
        
        output = matrix1 .| reverse(matrix2, dims=2)
    else
        matrix1 = matrix[1:fold_value, :]
        matrix2 = matrix[fold_value + 2:end, :]

        output = matrix1 .| reverse(matrix2, dims=1)
    end

    return output
end

function solution_part_1(matrix, foldings)
    for folding in foldings
        matrix = fold_matrix(matrix, folding)
    end

    return count(x -> x == 1, matrix)
end

coordinates, foldings = get_coordinates_folding(lines)
matrix = get_cartesian_matrix(coordinates)
println("Solution part 1: ", solution_part_1(matrix, [foldings[1]]))