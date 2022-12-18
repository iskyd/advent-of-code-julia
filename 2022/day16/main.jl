using Memoize

struct Valve
    flow::Int
    connections::Vector{String}
end

function parse_input()::Dict{String, Valve}
    valves = Dict{String, Valve}()
    for line in readlines("input.txt")
        splitted = split(line, " ")
        flow = parse(Int, match(r"rate=(\d+);", splitted[5])[1])
        valves[splitted[2]] = Valve(flow, replace.(splitted[10:end], "," => ""))
    end

    return valves
end

@memoize function maxflow(valves::Dict{String, Valve}, current::String, opened::Vector{String}, minutes_left::Int)::Int
    if minutes_left == 0
        return 0
    end

    best = 0
    if !(current in opened)
        val = (minutes_left - 1) * valves[current].flow
        for connection in valves[current].connections
            if val > 0
                best = max(best, val + maxflow(valves, connection, vcat(opened, [current]), minutes_left - 2))
            end

            best = max(best, maxflow(valves, connection, opened, minutes_left - 1))
        end 
    end

    return best
end

function solution_part1(valves::Dict{String, Valve})::Int
    return maxflow(valves, "AA", Vector{String}(), 30)
end

valves = parse_input()
println("Solution part 1: ", solution_part1(valves))