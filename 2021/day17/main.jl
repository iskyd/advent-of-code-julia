line = readlines("input.txt")[1]
target = Dict()

target['x'] = parse.(Int16, split(match(r"x=(\d+..\d+)", line)[1], ".."))
target['y'] = parse.(Int16, split(match(r"y=(-*\d+..-*\d+)", line)[1], ".."))

function move_next_step(x, y, x_velocity, y_velocity)
    x += x_velocity
    y += y_velocity

    if x_velocity > 0 x_velocity -= 1 end
    y_velocity -= 1

    return x, y, x_velocity, y_velocity
end

function is_in_target_area(x, y)
    return x >= target['x'][1] && x <= target['x'][2] && y >= target['y'][1] && y <= target['y'][2]
end

function solution_part_1()
    n = -target['y'][1] - 1
    return trunc(Int16, n*(n + 1) / 2)
end

function solution_part_2()
    total_velocities = 0
    min_x_velocity = trunc(Int16, (target['x'][1] * 2) ^ 0.5 -1)

    for y_velocity in target['y'][1]:abs(target['y'][1])
        for x_velocity in min_x_velocity:target['x'][2]
            x, y, dx, dy = 0, 0, x_velocity, y_velocity
            while true
                x, y, dx, dy = move_next_step(x, y, dx, dy)
                if is_in_target_area(x, y)
                    total_velocities += 1
                    break
                end

                if (x > target['x'][2] && y < target['y'][2]) || (dx == 0 && y < target['y'][2]) break end
            end
        end
    end

    return total_velocities
end

println("Solution part 1: ", solution_part_1())
println("Solution part 2: ", solution_part_2())