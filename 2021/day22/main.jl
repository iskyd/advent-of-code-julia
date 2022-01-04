lines = readlines("input.txt")

function solution_part_1(steps)
    cubes = zeros(Bool, 101, 101, 101)
    for step in steps
        status = split(step, " ")[1]
        (x, y, z) = split(split(step, " ")[2], ",")
        x = parse.(Int, split(match(r"x=(-*\d+..-*\d+)", x)[1], ".."))
        y = parse.(Int, split(match(r"y=(-*\d+..-*\d+)", y)[1], ".."))
        z = parse.(Int, split(match(r"z=(-*\d+..-*\d+)", z)[1], ".."))

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

println("Solution part 1: ", solution_part_1(lines))