using Combinatorics

function get_scanners()
    f = open("input.txt")
    s = read(f, String)
    close(f)

    s = split(s, "\n\n")

    scanners = []

    for i in 1:length(s)
        scanner = Dict(
            "id" => i - 1,
            "positions" => []
        )

        for position in split(s[i], "\n")
            if match(r"--- scanner \d+ ---", position) !== nothing continue end

            x, y, z = parse.(Int, split(position, ","))
            push!(scanner["positions"], Dict(
                "x" => x,
                "y" => y,
                "z" => z
            ))
        end

        push!(scanners, scanner)
    end

    return scanners
end

function calculate_distance(p1, p2)
    return (p1["x"] - p2["x"])^2 + (p1["y"] - p2["y"])^2 + (p1["z"] - p2["z"])^2
end

function distances(scanner)
    distances = []
    for (position1, position2) in collect(combinations(scanner["positions"], 2))
        push!(distances, calculate_distance(position1, position2))
    end

    return distances
end

function get_rotations(point)
    x, y, z = point

    return [
        [x, y, z],
        [z, y, -x],
        [-x, y, -z],
        [-z, y, x],
        [-x, -y, z],
        [-z, -y, -x],
        [x, -y, -z],
        [z, -y, x],
        [x, -z, y],
        [y, -z, -x],
        [-x, -z, -y],
        [-y, -z, x],
        [x, z, -y],
        [-y, z, -x],
        [-x, z, y],
        [y, z, x],
        [z, x, y],
        [y, x, -z],
        [-z, x, -y],
        [-y, x, z],
        [-z, -x, y],
        [y, -x, z],
        [z, -x, -y],
        [-y, -x, -z]
    ]
end

function rotate(point, index)
    return get_rotations(point)[index]
end

function find_common_beacons(scanner1, scanner2)
    d1 = distances(scanner1)
    d2 = distances(scanner2)

    c1 = collect(combinations(scanner1["positions"], 2))
    c2 = collect(combinations(scanner2["positions"], 2))

    common_beacons1 = []
    common_beacons2 = []

    if length(intersect(d1, d2)) >= 66 # 12x11/2=66 (66 common distances = 12 common beacons)
        for c in intersect(d1, d2)
            i1 = findall(x->x==c, d1)[1]
            i2 = findall(x->x==c, d2)[1]
            
            push!(common_beacons1, [c1[i1][1]["x"], c1[i1][1]["y"], c1[i1][1]["z"]], [c1[i1][2]["x"], c1[i1][2]["y"], c1[i1][2]["z"]])
            push!(common_beacons2, [c2[i2][1]["x"], c2[i2][1]["y"], c2[i2][1]["z"]], [c2[i2][2]["x"], c2[i2][2]["y"], c2[i2][2]["z"]])
        end

        common_beacons1 = unique(common_beacons1)
        common_beacons2 = unique(common_beacons2)

        p1 = common_beacons1[1] # Reference point
        match_found = false
        dx = nothing
        rotation_index = nothing
        for p2 in common_beacons2
            for (index, r) in enumerate(get_rotations(p2))
                dx = p1 - r
                common_beacons2_rotated = [rotate(x, index) + dx for x in common_beacons2]
                matching_points = intersect(common_beacons1, common_beacons2_rotated)
                if length(matching_points) >= 12
                    rotation_index = index
                    match_found = true
                    break
                end
            end

            if match_found === true break end
        end

        if match_found === true
            rotated_beacons = [rotate([x["x"], x["y"], x["z"]], rotation_index) + dx for x in scanner2["positions"]]
            return dx, rotated_beacons
        end
    end
    
    return [0, 0, 0], []
end

function overlaps(scanners)
    translated = [1]
    refs = [1]
    abs_scanner = Dict(
        1 => Dict(
            "positions" => scanners[1]["positions"],
            "id" => scanners[1]["id"]
        )
    )
    relative_positions = Dict(
        1 => [0, 0, 0]
    )

    while length(translated) < length(scanners)
        iref = pop!(refs)
        beacon1 = abs_scanner[iref]
        for i in 1:length(scanners)
            if i == iref || i in translated continue end
            beacon2 = scanners[i]
            dx, rotated_beacons = find_common_beacons(beacon1, beacon2)
            if length(rotated_beacons) > 0
                abs_scanner[i] = Dict(
                    "positions" => [Dict("x" => x[1], "y" => x[2], "z" => x[3]) for x in rotated_beacons],
                    "id" => scanners[i]["id"]
                )

                relative_positions[i] = dx
                push!(translated, i)
                push!(refs, i)
            end
        end
    end

    return abs_scanner, relative_positions
end

function manhattan_distance(pt1, pt2)
    return sum([abs(x1-x2) for (x1, x2) in zip(pt1, pt2)])
end

function solution_part_1(scanners)
    abs_scanner, relative_positions = overlaps(scanners)
    o = []
    for i in 1:length(abs_scanner)
        x = [[x["x"], x["y"], x["z"]] for x in abs_scanner[i]["positions"]]
        push!(o, x...)
        o = unique(o)
    end

    return length(o), relative_positions
end

function solution_part_2(relative_positions)
    return maximum([manhattan_distance(pt1, pt2) for (pt1, pt2) in combinations(relative_positions, 2)])    
end

scanners = get_scanners()
sol1, relative_positions = solution_part_1(scanners)
println("Solution part 1: ", sol1)
println("Solution part 1: ", solution_part_2(relative_positions))