line = readlines("input.txt")[1]
target = Dict()

target['x'] = parse.(Int16, split(match(r"x=(\d+..\d+)", line)[1], ".."))
target['y'] = parse.(Int16, split(match(r"y=(-*\d+..-*\d+)", line)[1], ".."))

function move_next_step(x, y, x_velocity, y_velocity)
    x += x_velocity
    y += y_velocity

    if x_velocity != 0 x_velocity += trunc(Int8, -1 * (x_velocity / abs(x_velocity))) end
    y_velocity += -1

    return x, y, x_velocity, y_velocity
end

function is_in_target_area(x, y)
    return x >= target['x'][1] && x <= target['x'][2] && y >= target['y'][1] && y <= target['y'][2]
end

function solution_part_1()
    max_y = 0

    possible_max_x = target['x'][2] % 2 == 0 ? target['x'][2] : target['x'][2] + 1
    possible_min_x = 1
    for i in 1:possible_max_x
        if sum([j for j in 1:i]) > target['x'][1]
            possible_min_x = i
            break
        end
    end

    for i in 1:200
        x, y = 0, 0
        x_velocity, y_velocity = possible_min_x, i
        starting_x_velocity, starting_y_velocity = x_velocity, y_velocity
        current_max_y = 0
        while true
            x, y, x_velocity, y_velocity = move_next_step(x, y, x_velocity, y_velocity)
            if y > current_max_y current_max_y = y end
            if is_in_target_area(x, y)
                max_y = current_max_y
                break
            end

            if x > target['x'][2] || y < target['y'][2] break end
        end
    end

    return max_y
end

println("Solution part 1: ", solution_part_1())