lines = readlines("input.txt")
lanternfish = parse.(Int16, split(lines[1], ","))

# First attempt. Not the most efficient. Obviously is better to use the second method also for the first part. I will leave this one here for reference of my first approach.
function process_lanternfish(lanternfish, days)
    for i in 1:days
        v = ones(Int16, size(lanternfish)[1])
        lanternfish -= v

        total_new_lanternfish = count(i -> (i % 7 == -1), lanternfish)

        if total_new_lanternfish > 0
            lanternfish = cat(lanternfish, ones(Int16, total_new_lanternfish) * 8, dims=1)
        end
    end

    return size(lanternfish)[1]
end

function process_lanternfish_part2(initial_lanternfish, days)
    initial_lanternfish = cat([1], initial_lanternfish, dims=1)
    lanternfish = Array{Any}[]
    push!(lanternfish, initial_lanternfish)
    for i in 1:days
        total_new_lanternfish = 0
        for j in 1:size(lanternfish)[1]
            v = ones(Int16, size(lanternfish[j])[1])
            lanternfish[j] -= v
            lanternfish[j][1] += 1

            total_new_lanternfish += count(i -> (i % 7 == -1), lanternfish[j]) * lanternfish[j][1]
        end

        if total_new_lanternfish > 1
            push!(lanternfish, [total_new_lanternfish, 8])
        elseif total_new_lanternfish == 1
            push!(lanternfish[1], 8)
        end
    end

    total_lanterfish = 0
    for j in 1:size(lanternfish)[1]
        total_lanterfish += (size(lanternfish[j])[1] - 1) * lanternfish[j][1]
    end

    return total_lanterfish
end

total_lanterfish = process_lanternfish(lanternfish, 80)
println("Solution part 1: ", total_lanterfish)

total_lanterfish = process_lanternfish_part2(lanternfish, 256)
println("Solution part 2: ", total_lanterfish)