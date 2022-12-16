function manatthan_distance(p1::CartesianIndex, p2::CartesianIndex)
    return abs(p1[1] - p2[1]) + abs(p1[2] - p2[2])
end

function get_sensors_beacons()::Tuple{Vector{CartesianIndex},Vector{CartesianIndex}}
    sensors = Vector{CartesianIndex}()
    beacons = Vector{CartesianIndex}()

    for line in readlines("input.txt")
        sensor_match = match(r"Sensor at x=(-?\d+), y=(-?\d+)", line)
        beacon_match = match(r"beacon is at x=(-?\d+), y=(-?\d+)", line)

        push!(sensors, CartesianIndex(parse(Int, sensor_match[1]), parse(Int, sensor_match[2])))
        push!(beacons, CartesianIndex(parse(Int, beacon_match[1]), parse(Int, beacon_match[2])))
    end

    return sensors, beacons
end

function solution_part1(sensors::Vector{CartesianIndex}, beacons::Vector{CartesianIndex})::Int
    Y = 2000000
    dists = [manatthan_distance(sensors[i], beacons[i]) for i in 1:length(sensors)]
    intervals = Vector{Tuple{Int,Int}}()
    max_x, min_x = -Inf, Inf
    for (i, sensor) in enumerate(sensors)
        dx = dists[i] - abs(sensor[2] - Y)
        if dx > 0
            push!(intervals, (sensor[1] - dx, sensor[1] + dx))
            max_x, min_x = max(max_x, sensor[1] + dx), min(min_x, sensor[1] - dx)
        end
    end

    existing_beacons = Set{Int}([b[1] for b in beacons if b[2] == Y])
    
    res = 0
    for x in min_x:max_x
        if x in existing_beacons continue end

        for (left, right) in intervals
            if left <= x <= right
                res += 1
                break
            end
        end
    end

    return res
end

function solution_part2(sensors::Vector{CartesianIndex}, beacons::Vector{CartesianIndex})::Int
    pos_lines = Vector{Int}()
    neg_lines = Vector{Int}()
    dists = [manatthan_distance(sensors[i], beacons[i]) for i in 1:length(sensors)]

    for (i, sensor) in enumerate(sensors)
        d = dists[i]
        push!(neg_lines, [sensor[1] + sensor[2] - d, sensor[1] + sensor[2] + d]...)
        push!(pos_lines, [sensor[1] - sensor[2] - d, sensor[1] - sensor[2] + d]...)
    end

    pos = neg = nothing

    for i in 1:length(sensors)*2
        for j in i+1:length(sensors)*2
            a, b = pos_lines[i], pos_lines[j]

            if abs(a - b) == 2
                pos = min(a, b) + 1
            end

            a, b = neg_lines[i], neg_lines[j]
            if abs(a - b) == 2
                neg = min(a, b) + 1
            end
        end
    end

    x, y = (pos + neg) // 2, (neg - pos) // 2
    return x * 4_000_000 + y
end

sensors, beacons = get_sensors_beacons()
println("Solution part 1: ", solution_part1(sensors, beacons))
println("Solution part 2: ", solution_part2(sensors, beacons))