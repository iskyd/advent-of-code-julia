using ResumableFunctions

struct Command
    direction::Char
    steps::Int
end

MOVES = Dict(
    'U' => (0, 1),
    'D' => (0, -1),
    'L' => (-1, 0),
    'R' => (1, 0),
)

@resumable function get_commands()::Command
    for line in readlines("input.txt")
        direction = line[1]
        commands = parse(Int, strip(line[2:end]))

        @yield Command(direction, commands)
    end
end

function solution(rope_length::Int)::Int
    body = [[0, 0] for _ in 1:rope_length]
    visited = Set{Tuple{Int, Int}}()
    push!(visited, (0, 0))

    for command in get_commands()
        for _ in 1:command.steps
            body[1][1] += MOVES[command.direction][1]
            body[1][2] += MOVES[command.direction][2]

            for i in 2:length(body)
                cx, cy = body[i - 1][1] - body[i][1], body[i - 1][2] - body[i][2]
                if max(abs(cx), abs(cy)) > 1
                    body[i][1] += cx > 0 ? 1 : cx < 0 ? -1 : 0 
                    body[i][2] += cy > 0 ? 1 : cy < 0 ? -1 : 0
                end
            end

            push!(visited, (body[end][1], body[end][2]))
        end
    end

    return length(visited)
end

println("Solution part 1: ", solution(2))
println("Solution part 2: ", solution(10))