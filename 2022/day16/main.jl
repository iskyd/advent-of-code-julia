using Memoize
using DataStructures

struct Valve
    flow::Int
    connections::Vector{String}
end

function parse_input()::Tuple{OrderedDict{String,Valve},OrderedDict{String,OrderedDict{String,Float64}}}
    valves = OrderedDict{String,Valve}()
    for line in readlines("input.txt")
        splitted = split(line, " ")
        flow = parse(Int, match(r"rate=(\d+);", splitted[5])[1])
        valves[splitted[2]] = Valve(flow, replace.(splitted[10:end], "," => ""))
    end

    steps = OrderedDict{String,OrderedDict{String,Float64}}() # float64 to use Inf https://en.wikipedia.org/wiki/Floyd-Warshall_algorithm
    for (key, valve) in valves
        steps[key] = OrderedDict(k => k in valve.connections ? 1 : Inf for (k, v) in valves)
    end

    for k in keys(steps)
        for i in keys(steps)
            for j in keys(steps)
                steps[i][j] = min(steps[i][j], steps[i][k] + steps[k][j])
            end
        end
    end

    return valves, steps
end

@memoize function travel(
    valves::OrderedDict{String,Valve},
    steps::OrderedDict{String,OrderedDict{String,Float64}},
    last::String, minutes_left::Int, state::OrderedDict{String,Int},
    current_state::Int, current_flow::Int, result::Dict{Int,Int})
    result[current_state] = max(haskey(result, current_state) ? result[current_state] : 0, current_flow)
    for (key, valve) in valves
        m = trunc(Int, minutes_left - steps[last][key] - 1)
        if (state[key] & current_state !== 0) || m <= 0
            continue
        end

        travel(valves, steps, key, m, state, current_state | state[key], current_flow + m * valve.flow, result)
    end

    return result
end

function solution_part1(valves::OrderedDict{String,Valve}, steps::OrderedDict{String,OrderedDict{String,Float64}})::Int
    minutes_left = 30
    filtered = filter(x -> x[2].flow > 0, valves)
    state = OrderedDict(v => 1 << (i - 1) for (i, v) in enumerate(keys(filtered)))

    return maximum(values(travel(filtered, steps, "AA", minutes_left, state, 0, 0, Dict{Int,Int}())))
end

function solution_part2(valves::OrderedDict{String,Valve}, steps::OrderedDict{String,OrderedDict{String,Float64}})::Int
    minutes_left = 26
    filtered = filter(x -> x[2].flow > 0, valves)
    state = OrderedDict(v => 1 << (i - 1) for (i, v) in enumerate(keys(filtered)))

    paths = travel(filtered, steps, "AA", minutes_left, state, 0, 0, Dict{Int,Int}())
    
    return maximum(my_val + el_val for (k1, my_val) in paths
                         for (k2, el_val) in paths if !(k1 & k2 !== 0))
end

valves, steps = parse_input()
println("Solution part 1: ", solution_part1(valves, steps))
println("Solution part 2: ", solution_part2(valves, steps))