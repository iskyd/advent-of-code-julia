lines = readlines("input.txt")

function get_coordinates(lines)
    coordinates = Array{Int16}[]
    max_x = 0
    max_y = 0
    for line in lines
        x1, y1 = split(strip(split(line, "->")[1]), ",")
        x2, y2 = split(strip(split(line, "->")[2]), ",")

        x1, y1, x2, y2 = parse.(Int16, [x1, y1, x2, y2])

        max_x = max(max_x, x1, x2)
        max_y = max(max_y, y1, y2)
        
        push!(coordinates, [x1, y1, x2, y2])
    end

    return coordinates, max_x, max_y
end

function get_matrix_of_segments(coordinates, max_x, max_y, diagonal=false)
    matrix = zeros(Int16, max_x + 1, max_y + 1)
    for segment in coordinates
        x1, y1, x2, y2 = segment
        if y1 == y2
            if x1 > x2 x1, x2 = x2, x1 end
            for x in x1:x2
                matrix[y1 + 1, x + 1] += 1
            end
        elseif x1 == x2
            if y1 > y2 y1, y2 = y2, y1 end
            for y in y1:y2
                matrix[y + 1, x1 + 1] += 1
            end
        elseif (y2 - y1) / (x2 - x1) in [1, -1] && diagonal
            slope = trunc(Int, (y2 - y1) / (x2 - x1))
            if slope < 0 && x1 > x2
                x1, x2, y1, y2 = x2, x1, y2, y1
            elseif slope > 0 && x1 < x2
                x1, x2, y1, y2 = x2, x1, y2, y1
            end

            for i in 0:abs(x2-x1)
                matrix[y1 - i + 1, x1 + (i * slope * -1) + 1] += 1
            end
        end
    end

    return matrix
end

function count_overlaps(matrix)
    count = 0
    for row in matrix
        for element in row
            if element > 1
                count += 1
            end
        end
    end

    return count
end

coordinates, max_x, max_y = get_coordinates(lines)
matrix = get_matrix_of_segments(coordinates, max_x, max_y, false)
println("Solution part 1: ", count_overlaps(matrix))
matrix = get_matrix_of_segments(coordinates, max_x, max_y, true)
println("Solution part 2: ", count_overlaps(matrix))