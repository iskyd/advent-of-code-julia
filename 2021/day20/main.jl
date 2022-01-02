lines = readlines("input.txt")

function get_roi(input::Matrix, char::Char='.')::Matrix
    first_row, last_row, first_col, last_col = size(input)[1], 1, size(input)[2], 1

    for i in 1:size(input)[1]
        for j in 1:size(input)[2]
            if input[i, j] == '#'
                if i < first_row first_row = i end
                if i > last_row last_row = i end
                if j < first_col first_col = j end
                if j > last_col last_col = j end
            end
        end
    end

    roi = input[first_row:last_row, first_col:last_col]

    roi = copy(input)

    v = Matrix{Char}(undef, 1, size(roi)[2])
    v .= char
    roi = vcat(v, roi, v)

    h = Matrix{Char}(undef, size(roi)[1], 1)
    h .= char
    roi = hcat(h, roi, h)
    
    return roi
end

function parse_input(lines)
    enhancement_algorithm = lines[1]
    
    input_image = Matrix{Char}(undef, length(lines[3:end]), length(lines[3]))
    input_lines = lines[3:end]

    for i in 1:size(input_image)[1]
        for j in 1:size(input_image)[2]
            input_image[i,j] = input_lines[i][j]
        end
    end
    
    return input_image, enhancement_algorithm
end

function get_neighbours(input_image::Matrix, i::Int, j::Int, default::Char='.')
    return [
        i > 1 && j > 1 ? input_image[i-1, j-1] : default,
        i > 1 ? input_image[i-1, j] : default,
        i > 1 && j < size(input_image)[2] ? input_image[i-1, j+1] : default,
        j > 1 ? input_image[i, j-1] : default,
        input_image[i, j],
        j < size(input_image)[2] ? input_image[i, j+1] : default,
        i < size(input_image)[1] && j > 1 ? input_image[i+1, j-1] : default,
        i < size(input_image)[1] ? input_image[i+1, j] : default,
        i < size(input_image)[1] && j < size(input_image)[2] ? input_image[i+1, j+1] : default
    ]
end

function enhance(roi, enhancement_algorithm)
    binary = join([x == '#' ? 1 : 0 for x in roi], "")
    decimal = parse(Int, binary, base=2)

    return enhancement_algorithm[decimal + 1]
end

function solution_part_1(input_image, enhancement_algorithm)
    input_image = get_roi(input_image)
    output_image = copy(input_image)

    for iteration in 1:2
        default_neighbours = '.'
        if enhancement_algorithm[1] == '#' && enhancement_algorithm[end] == '.' && iteration % 2 == 0 default_neighbours = '#' end
        
        for i in 1:size(input_image)[1]
            for j in 1:size(input_image)[2]
                roi = get_neighbours(input_image, i, j, default_neighbours)
                output_image[i, j] = enhance(roi, enhancement_algorithm)
            end
        end

        roi_fill = '.'
        if enhancement_algorithm[1] == '#' && enhancement_algorithm[end] == '.'
            roi_fill = default_neighbours == '#' ? '.' : '#'
        end

        output_image = get_roi(output_image, roi_fill)
        input_image = copy(output_image)
    end

    return count(i -> (i == '#'), output_image)
end

input_image, enhancement_algorithm = parse_input(lines)
println("Solution part 1: ", solution_part_1(input_image, enhancement_algorithm))