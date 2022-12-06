function get_stream()::Vector{Char}
    return map(c -> only(c), split(readlines("input.txt")[1], ""))
end

function solution(stream::Vector{Char}, n::Int)::Int
    i = 1
    while i < length(stream) - (n - 1)
        if length(unique(stream[i:i + n - 1])) == n
            break
        end
        i += 1
    end

    return i + n - 1
end

stream = get_stream()
println("Solution part 1: ", solution(stream, 4))
println("Solution part 2: ", solution(stream, 14))