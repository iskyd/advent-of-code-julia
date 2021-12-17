using Combinatorics

lines = readlines("input.txt")

function get_output_values(lines)
    return [split(strip(split(line, "|")[2]), " ") for line in lines]
end

function get_unique_signal_patterns(lines) 
    return [split(strip(split(line, "|")[1]), " ") for line in lines]
end

function solution_part_1(output_values)
    total = 0
    for output_value in output_values
        total += length([digit for digit in output_value if length(digit) in [2, 3, 4, 7]])
    end

    return total
end

function solution_part_2(lines)
    total = 0
    for line in lines
        signals, output_values = split(line, " | ")
        signals = [join(sort(collect(x))) for x in split(strip(signals), " ")]
        output_values = [join(sort(collect(x))) for x in split(strip(output_values), " ")]
        
        results = Dict()

        results[1] = [x for x in signals if length(x) == 2]
        results[4] = [x for x in signals if length(x) == 4]
        results[7] = [x for x in signals if length(x) == 3]
        results[8] = [x for x in signals if length(x) == 7]

        # len6 could be either 0 or 6 or 9
        len6 = [x for x in signals if length(x) == 6]
        results[6] = [x for x in len6 if length(intersect(collect(results[1][1]), collect(x))) == 1]
        results[9] = [x for x in len6 if length(intersect(collect(results[4][1]), collect(x))) == 4]
        results[0] = setdiff(len6, results[6], results[9])

        # len5 could be either 2 or 3 or 5
        len5 = [x for x in signals if length(x) == 5]
        results[5] = [x for x in len5 if length(intersect(collect(results[6][1]), collect(x))) == 5]
        results[3] = [x for x in len5 if length(intersect(collect(results[1][1]), collect(x))) == 2]
        results[2] = setdiff(len5, results[3], results[5])

        reverted = Dict()
        for (key, value) in results
            reverted[value[1]] = key
        end
        
        digit_value = ""
        for output_value in output_values
            digit_value *= string(reverted[output_value])
        end
        
        digit_value = parse(Int16, digit_value)
        
        total += digit_value
    end

    return total
end

println("Solution part 1: ", solution_part_1(get_output_values(lines)))
println("Solution part 2: ", solution_part_2(lines))