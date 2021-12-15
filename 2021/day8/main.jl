lines = readlines("input.txt")

UNIQUE_DIGITS_LENGTH = Dict(
    2 => 1,
    4 => 4,
    3 => 7,
    7 => 8
)

function get_output_values(lines)
    return [split(strip(split(line, "|")[2]), " ") for line in lines]
end

function solution_part_1(output_values)
    total = 0
    for output_value in output_values
        for digit in output_value
            if haskey(UNIQUE_DIGITS_LENGTH, length(digit))
                total += 1
            end
        end
    end

    return total
end

println("Solution part 1: ", solution_part_1(get_output_values(lines)))