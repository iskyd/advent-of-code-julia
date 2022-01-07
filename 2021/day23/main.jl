using DataStructures

struct State
    hallway::Vector{Int8}
    rooms::Vector{Vector{Int8}}
end

function encode(state::State)
    d = Dict{Int8,Char}(0 => '.', 1 => 'A', 2 => 'B', 3 => 'C', 4 => 'D')
    str = ""

    for h in state.hallway
        str *= d[h]
    end
    
    for i in 1:trunc(Int8, length(state.rooms[1]))
        str *= join([d[x[i]] for x in state.rooms], "")
    end

    return str
end

function parse_input(lines::Vector{String})
    d = Dict{Char,Int8}('A' => 1, 'B' => 2, 'C' => 3, 'D' => 4)
    hallway = [0 for _ in 1:11]

    x = []
    for line in lines
        for c in line
            if !(c in ['#', '.', ' ']) push!(x, d[c]) end
        end
    end

    rows = []
    total_rows = trunc(Int8, length(x) / 4)
    for i in 1:total_rows
        push!(rows, x[(i-1)*4+1:(i-1)*4+4])
    end

    rooms = []
    for i in 1:4
        push!(rooms, [j[i] for j in rows])
    end

    return State(hallway, rooms)
end

function next_states(state::State)
    statescosts = Tuple{State,Int}[]

    restinds = intersect([1, 2, 4, 6, 8, 10, 11], findall(x -> x == 0, state.hallway))
    blockerinds = findall(x -> x != 0, state.hallway)

    for bi in blockerinds
        v = state.hallway[bi]
        entry = 2*v + 1

        add = findlast(x -> x == 0, state.rooms[v])
        add === nothing && continue
        skip = false
        for i = add + 1:length(state.rooms[v])
            if state.rooms[v][i] != v
                skip = true
                break
            end
        end
        skip && continue
        m, M = minmax(entry, bi)
        if !any(b -> b ∈ m+1:M-1, blockerinds)
            cost = (M - m + add) * 10^(v - 1)
            push!(statescosts, (swap(state, bi, v, add), cost))
        end
    end

    for room in 1:4
        lastzero = findlast(x -> x == 0, state.rooms[room])
        lastzero == length(state.rooms[room]) && continue
        if lastzero === nothing
            add = 1
        else
            add = lastzero + 1
        end
        all(state.rooms[room][add:length(state.rooms[room])] .== room) && continue


        entry = room * 2 + 1
        for resti in restinds
            m, M = minmax(entry, resti)
            if !any(b -> b ∈ m+1:M-1, blockerinds)
                cost = (M - m + add) * 10^(state.rooms[room][add] - 1)
                push!(statescosts, (swap(state, resti, room, add), cost))
            end
        end
    end

    return statescosts
end

function swap(state::State, hallwayind::Integer, roomnumber::Integer, roomind::Integer)
    hallway = copy(state.hallway)
    rooms = deepcopy(state.rooms)
    tmp = hallway[hallwayind]
    hallway[hallwayind] = rooms[roomnumber][roomind]
    rooms[roomnumber][roomind] = tmp

    return State(hallway, rooms)
end

function dijkstra(state::State, solution::String)
    distances = DefaultDict{String,Int}(typemax(Int))
    distances[encode(state)] = 0
    queue = PriorityQueue{State,Int}()
    queue[state] = 0
    
    while !isempty(queue)
        current = dequeue!(queue)
        encode(current) == solution && break

        for (neighbour, cost) in next_states(current)
            ndist = distances[encode(current)] + cost
            if ndist < distances[encode(neighbour)]
                distances[encode(neighbour)] = ndist
                queue[neighbour] = ndist
            end
        end
    end

    return distances[solution]
end

function solution_part_1(state::State)
    solution = '.' ^ 11 * "ABCD" ^ 2

    return dijkstra(state, solution)
end

function solution_part_2(state::State)
    solution = '.' ^ 11 * "ABCD" ^ 4

    return dijkstra(state, solution)
end

println("Solution part 1: ", solution_part_1(parse_input(readlines("input.txt"))))
println("Solution part 2: ", solution_part_2(parse_input(readlines("input2.txt"))))