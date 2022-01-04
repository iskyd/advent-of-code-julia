lines = readlines("input.txt")

struct Cube
    min_x::Int
    max_x::Int
    min_y::Int
    max_y::Int
    min_z::Int
    max_z::Int
    value::Int
end

function get_coordinates(step)
    (x, y, z) = split(split(step, " ")[2], ",")
    x = parse.(Int, split(match(r"x=(-*\d+..-*\d+)", x)[1], ".."))
    y = parse.(Int, split(match(r"y=(-*\d+..-*\d+)", y)[1], ".."))
    z = parse.(Int, split(match(r"z=(-*\d+..-*\d+)", z)[1], ".."))

    return x, y, z
end

function solution_part_1(steps)
    cubes = zeros(Bool, 101, 101, 101)
    for step in steps
        status = split(step, " ")[1]
        (x, y, z) = get_coordinates(step)

        if x[1] > 50 || x[1] < -50 || y[1] > 50 || y[1] < -50 || z[1] > 50 || z[1] < -50
            continue
        end

        for i in (x, y, z)
            i .+= 51
        end

        if status == "on"
            cubes[x[1]:x[2], y[1]:y[2], z[1]:z[2]] .= 1
        else
            cubes[x[1]:x[2], y[1]:y[2], z[1]:z[2]] .= 0
        end
    end

    return count(i->(i == 1), cubes)
end

function find_intersection(cube1, cube2)
    if !(cube1.min_x <= cube2.max_x && cube1.max_x >= cube2.min_x) return nothing end
    if !(cube1.min_y <= cube2.max_y && cube1.max_y >= cube2.min_y) return nothing end
    if !(cube1.min_z <= cube2.max_z && cube1.max_z >= cube2.min_z) return nothing end
    
    min_x = max(cube1.min_x, cube2.min_x)
    max_x = min(cube1.max_x, cube2.max_x)
    min_y = max(cube1.min_y, cube2.min_y)
    max_y = min(cube1.max_y, cube2.max_y)
    min_z = max(cube1.min_z, cube2.min_z)
    max_z = min(cube1.max_z, cube2.max_z)

    status = cube1.value * cube2.value
    if cube1.value == cube2.value
        status = -cube1.value
    elseif cube1.value == 1 && cube2.value == -1
        status = 1
    end
    
    return Cube(min_x, max_x, min_y, max_y, min_z, max_z, status)
end

function get_volume(cube::Cube)
    return (cube.max_x - cube.min_x + 1) * (cube.max_y - cube.min_y + 1) * (cube.max_z - cube.min_z + 1)
end

function solution_part_2(steps)
    cubes = []
    
    for step in steps
        status = split(step, " ")[1]
        (x, y, z) = get_coordinates(step)

        current = Cube(x[1], x[2], y[1], y[2], z[1], z[2], status == "on" ? 1 : -1)
        intersections = []
        for cube in cubes
            intersection = find_intersection(current, cube)
            if intersection !== nothing push!(intersections, intersection) end
        end

        for intersection in intersections
            push!(cubes, intersection)
        end

        if status == "on"
            push!(cubes, current)
        end
    end

    res = 0
    for cube in cubes
        res += get_volume(cube) * cube.value
    end

    return res
end

println("Solution part 1: ", solution_part_1(lines))
println("Solution part 2: ", solution_part_2(lines))