lines = readlines("input.txt")

function create_matrix(lines)
    matrix = zeros(Int16, size(lines)[1], length(lines[1]))
    for i in 1:size(lines)[1]
        for j in 1:length(lines[1])
            matrix[i,j] = parse(Bool, lines[i][j])
        end
    end

    return matrix
end

# Part 1
function calculate_power_consumption(matrix)
    gamma_rate = ""
    epsilon_rate = ""
    for i in 1:size(matrix)[2]
        column = matrix[:, i]
        gamma_rate_bit = count(i -> (i == 1), column) > size(matrix)[1] / 2 ? true : false
        epsilon_rate_bit = !gamma_rate_bit
        gamma_rate = string(gamma_rate, gamma_rate_bit == true ? "1" : "0")
        epsilon_rate = string(epsilon_rate, epsilon_rate_bit == true ? "1" : "0")
    end

    gamma_rate = parse(Int, gamma_rate; base=2)
    epsilon_rate = parse(Int, epsilon_rate; base=2)
    
    return gamma_rate * epsilon_rate
end

function calculate_oxygen_generator_rating(matrix, control_index = 1)
    if size(matrix)[1] == 1
        return parse(Int, join(matrix); base=2)
    end

    column = matrix[:, control_index]
    most_common_bit = count(i -> (i == 1), column) >= size(matrix)[1] / 2 ? true : false
    tmp_matrix = zeros(Int16, count(i -> (i == most_common_bit), column), size(matrix)[2])

    tmp_matrix_idx = 1
    for i in 1:size(matrix)[1]
        if matrix[i, control_index] == most_common_bit
            tmp_matrix[tmp_matrix_idx,:] = matrix[i,:]
            tmp_matrix_idx += 1
        end
    end
    
    return calculate_oxygen_generator_rating(tmp_matrix, control_index + 1)
end

function calculate_co2_scrubber_rating(matrix, control_index = 1)
    if size(matrix)[1] == 1
        return parse(Int, join(matrix); base=2)
    end

    column = matrix[:, control_index]
    less_common_bit = count(i -> (i == 1), column) < size(matrix)[1] / 2 ? true : false
    tmp_matrix = zeros(Int16, count(i -> (i == less_common_bit), column), size(matrix)[2])

    tmp_matrix_idx = 1
    for i in 1:size(matrix)[1]
        if matrix[i, control_index] == less_common_bit
            tmp_matrix[tmp_matrix_idx,:] = matrix[i,:]
            tmp_matrix_idx += 1
        end
    end
    
    return calculate_co2_scrubber_rating(tmp_matrix, control_index + 1)
end

# Part 2
function calculate_life_support_rating(matrix)
    oxygen_generator_rating = calculate_oxygen_generator_rating(matrix, 1)
    co2_scrubber_rating = calculate_co2_scrubber_rating(matrix, 1)

    return oxygen_generator_rating * co2_scrubber_rating
end

matrix = create_matrix(lines)
println("Solution part 1: ", calculate_power_consumption(matrix))
println("Solution part 2: ", calculate_life_support_rating(matrix))