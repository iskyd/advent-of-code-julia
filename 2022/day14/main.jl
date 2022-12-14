DELTAS = [CartesianIndex(0, 1), CartesianIndex(-1, 1), CartesianIndex(1, 1)]

function get_map()::Set{CartesianIndex}
    map = Set{CartesianIndex}()

    for line in readlines("input.txt")
        line_points = Vector{CartesianIndex}()
        for coordinates in split(line, " -> ")
            point = CartesianIndex(parse.(Int, split(coordinates, ","))...)
            
            push!(line_points, point)
        end

        for i in 2:length(line_points)
            current_point = line_points[i]
            previous_point = line_points[i - 1]

            if current_point[1] !== previous_point[1]
                # Horizontal line
                for x in min(current_point[1], previous_point[1]):max(current_point[1], previous_point[1])
                    push!(map, CartesianIndex(x, current_point[2]))
                end
            elseif current_point[2] !== previous_point[2]
                # Vertical line
                for y in min(current_point[2], previous_point[2]):max(current_point[2], previous_point[2])
                    push!(map, CartesianIndex(current_point[1], y))
                end
            end
        end
    end

    return map
end

function fall(map::Set{CartesianIndex}, sand::CartesianIndex, max_y::Int)::Bool
    @label before_while
    while sand[2] <= max_y
        for delta in DELTAS
            if !(sand + delta in map)
                sand += delta
                @goto before_while
            end
        end

        push!(map, sand)

        return true
    end

    # abyss
    return false
end

function fall2floor(map::Set{CartesianIndex}, sand::CartesianIndex, max_y::Int)::CartesianIndex
    if sand in map
        return sand
    end

    @label before_while
    while sand[2] <= max_y
        for delta in DELTAS
            if !(sand + delta in map)
                sand += delta
                @goto before_while
            end
        end

        break
    end

    # abyss
    return sand
end

function solution_part1(map::Set{CartesianIndex})::Int
    max_y = maximum([point[2] for point in map])
    units = 0
    while true
        res = fall(map, CartesianIndex(500, 0), max_y)
        if res === false break end
        units += 1
    end

    return units
end

function solution_part2(map::Set{CartesianIndex})::Int
    max_y = maximum([point[2] for point in map])
    units = 0
    while true
        res = fall2floor(map, CartesianIndex(500, 0), max_y)
        push!(map, res)
        units += 1

        if res === CartesianIndex(500, 0) break end
    end

    return units
end

map = get_map()
println("Solution part 1: ", solution_part1(deepcopy(map)))
println("Solution part 2: ", solution_part2(deepcopy(map)))