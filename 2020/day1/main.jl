lines::Array{Int} = [parse(Int, line) for line in readlines("input.txt")]

function solution_part_1(lines::Array{Int})::Int
    for i in 1:length(lines)
        for j in 1:length(lines)
            if lines[i] + lines[j] == 2020
                return lines[i] * lines[j]
            end
        end
    end

    return 0
end

function solution_part_2(lines::Array{Int})::Int
    for i in 1:length(lines)
        for j in 1:length(lines)
            for k in 1:length(lines)
                if lines[i] + lines[j] + lines[k] == 2020
                    return lines[i] * lines[j] * lines[k]
                end
            end
        end
    end

    return 0
end

println("Solution part 1: ", solution_part_1(lines))
println("Solution part 2: ", solution_part_2(lines))