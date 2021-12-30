import JSON

lines = [JSON.parse(line) for line in readlines("input.txt")]

function replace_char(str, start_index, stop_index, replacement)
    str = split(str, "")

    if start_index == stop_index
        str[start_index] = replacement
    else
        c = 1
        for i in start_index:stop_index
            str[i] = string(replacement[c])
            c += 1
        end
    end

    return join(str)
end

function explode(number)
    nested = 0
    for index in 1:length(number)
        char = number[index]
        if char == '[' nested += 1 end
        if char == ']' nested -= 1 end

        if nested > 4 && !(number[index + 1] in ['[', ']'])
            left_pair_idx_start = index + 1
    
            left_pair = parse(Int, match(r"(\d+)", number[left_pair_idx_start:end])[1])
            right_pair = parse(Int, match(r",(\d+)", number[left_pair_idx_start+length(string(left_pair)):end])[1])

            str_pair = "[" * string(left_pair) * "," * string(right_pair) * "]"

            first_right_number, first_left_number = nothing, nothing

            r = match(r"(\d+)", number[left_pair_idx_start+length(str_pair):end])
            if r !== nothing first_right_number = parse(Int, r[1]) end

            r = match(r"(\d+)", reverse(number[1:left_pair_idx_start-1]))
            if r !== nothing first_left_number = parse(Int, reverse(r[1])) end

            rigth_replacement = first_right_number !== nothing ? first_right_number + right_pair : 0
            left_replacement = first_left_number !== nothing ? first_left_number + left_pair : 0

            sub = number[index:end]
            sub = replace(sub, str_pair => "0", count=1)
            number = number[1:index-1] * sub

            sub = number[index+1:end]
            rigth_replace_index = findall(r"(\d+)", sub)
            if length(rigth_replace_index) > 0 sub = replace_char(sub, rigth_replace_index[1].start, rigth_replace_index[1].stop, string(rigth_replacement)) end
            number = number[1:index] * sub

            sub = reverse(number[1:index-1])
            left_replace_index = findall(r"(\d+)", sub)
            if length(left_replace_index) > 0 sub = replace_char(sub, left_replace_index[1].start, left_replace_index[1].stop, reverse(string(left_replacement))) end
            number = reverse(sub) * number[index:end]

            return number
        end
    end

    return number
end

function split_number(number)
    for index in 1:length(number)
        char = number[index]

        if char != '[' && char != ']' && char != ','
            complete_number = parse(Int, match(r"(\d+)", number[index:end])[1])
            if complete_number >= 10
                left_pair = trunc(Int, floor(complete_number / 2))
                right_pair = trunc(Int, ceil(Int, complete_number / 2))
        
                return number[1:index-1] * "[" * string(left_pair) * "," * string(right_pair) * "]" * number[index+1+length(complete_number):end]
            end
        end
    end

    return number
end

function reduce(number)
    exploded = explode(number)
    if number != exploded 
        return reduce(exploded)
    else
        splitted = split_number(number)
        if splitted != number return reduce(splitted) else return number end
    end
end

function magnitude(number)
    while count(i->(i==','), number) > 0
        for r in eachmatch(r"(\[\d+,\d+\])", number)
            arr = JSON.parse(r[1])
            val = arr[1] * 3 + arr[2] * 2
            number = replace(number, r[1] => string(val), count=1)
        end
    end
    
    return parse(Int, number)
end

function solution_part_1(lines)
    result = lines[1]
    for i in 2:length(lines)
        result = push!([], result, lines[i])
        result = JSON.parse(reduce(JSON.json(result)))
    end

    return magnitude(JSON.json(result))
end

function solution_part_2(lines)
    max_magnitude = 0
    for i in 1:length(lines)
        for j in 1:length(lines)
            if i == j continue end

            result = push!([], lines[i], lines[j])
            val = magnitude(reduce(JSON.json(result)))
            if val > max_magnitude max_magnitude = val end
        end
    end

    return max_magnitude
end

println("Solution part 1: ", solution_part_1(lines))
println("Solution part 2: ", solution_part_2(lines))