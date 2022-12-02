function solution_part1()::Int
    total_score = 0
    for line in readlines("input.txt")
        splitted = split(line, " ")
        opponents_move, move = first(splitted[1]), first(splitted[2])
        opponents_move_value::Int = Int(opponents_move) - Int('A')
        move_value::Int = Int(move) - Int('X')
        round_score = (move_value + 1) + (mod(move_value - opponents_move_value + 1, 3) * 3)

        total_score += round_score
    end

    return total_score
end

function solution_part2()::Int
    total_score = 0
    for line in readlines("input.txt")
        splitted = split(line, " ")
        opponents_move, result = first(splitted[1]), first(splitted[2])
        opponents_move_value::Int = Int(opponents_move) - Int('A')
        result_value::Int = Int(result) - Int('X')
        round_score = (result_value * 3) + (mod(opponents_move_value + result_value + 2, 3)) + 1

        total_score += round_score        
    end

    return total_score
end

println("Solution part 1: ", solution_part1())
println("Solution part 2: ", solution_part2())