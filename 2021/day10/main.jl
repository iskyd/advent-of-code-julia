lines = readlines("input.txt")

OPENING_TAGS = Dict(
    '(' => 3,
    '[' => 57,
    '{' => 1197,
    '<' => 25137,
)

CLOSING_TAGS = Dict(
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137,
)

function solution_part_1(lines)
    points = 0
    for line in lines
        stack = []
        for char in line
            if haskey(OPENING_TAGS, char)
                push!(stack, char)
            elseif haskey(CLOSING_TAGS, char)
                last = pop!(stack)

                if OPENING_TAGS[last] != CLOSING_TAGS[char]
                    points += CLOSING_TAGS[char]
                    break
                end
            end
        end
    end

    return points
end

println("Solution part 1: ", solution_part_1(lines))