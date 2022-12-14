using ResumableFunctions
using JSON

filename = "input.txt"

lt(l::Int, r::Int) = l < r
lt(l::Vector, r::Int) = lt(l, [r])
lt(l::Int, r::Vector) = lt([l], r)
lt(l::Vector, r::Vector) = !isempty(r) && (isempty(l) || lt(l[1], r[1]) || (!lt(r[1], l[1]) && lt(l[2:end], r[2:end])))

@resumable function get_pairs()::Tuple{Vector{Any}, Vector{Any}}
    p1 = p2 = nothing
    for line in readlines(filename)
        if line == ""
            @yield p1, p2
            p1 = p2 = nothing
        else
            if p1 === nothing
                p1 = JSON.parse(line)
            else
                p2 = JSON.parse(line)
            end
        end
    end

    @yield p1, p2
end

function solution_part1()::Int
    return sum([index for (index, (p1, p2)) in enumerate(get_pairs()) if lt(p1, p2)])
end

function solution_part2()
    v = [JSON.parse(line) for line in readlines(filename) if line !== ""]
    push!(v, [[2]], [[6]])
    sort!(v, lt=lt)

    return findfirst(==([[2]]), v) * findfirst(==([[6]]), v)
end

println("Solution part 1: ", solution_part1())
println("Solution part 2: ", solution_part2())