using Statistics

lines = readlines("input.txt")

OPENING_TAGS = Dict('(' => 3, '[' => 57, '{' => 1197, '<' => 25137,)
CLOSING_TAGS = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137,)
TAGS = Dict('(' => ')', '[' => ']', '{' => '}', '<' => '>',)
SCORES = Dict(')' => 1, ']' => 2, '}' => 3, '>' => 4,)

function is_line_corrupted(line)
    stack = []
    for char in line
        if haskey(OPENING_TAGS, char)
            push!(stack, char)
        elseif haskey(CLOSING_TAGS, char)
            last = pop!(stack)

            if OPENING_TAGS[last] != CLOSING_TAGS[char]
                return (true, CLOSING_TAGS[char])
            end
        end
    end

    return (false, 0)
end

function solution_part_1(lines)
    points = 0
    for line in lines
        (corrupted, line_points) =  is_line_corrupted(line)
        points += line_points
    end

    return points
end

function solution_part_2(lines)
    incomplete_lines = []
    for line in lines
        (corrupted, line_points) =  is_line_corrupted(line)
        if corrupted === false
            push!(incomplete_lines, line)
        end
    end

    scores = []
    for line in incomplete_lines
        stack = []
        for char in line
            if haskey(OPENING_TAGS, char)
                push!(stack, char)
            elseif haskey(CLOSING_TAGS, char)
                last = pop!(stack)
            end
        end

        added_chars = []
        while length(stack) > 0
            last = pop!(stack)
            push!(added_chars, TAGS[last])
        end

        score = 0
        for char in added_chars
            score = score * 5 + SCORES[char]
        end

        push!(scores, score)
    end

    return trunc(Int, median(scores))
end

println("Solution part 1: ", solution_part_1(lines))
println("Solution part 2: ", solution_part_2(lines))