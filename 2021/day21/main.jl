lines = readlines("input.txt")

function init_game(lines)
    players = Dict(
        1 => Dict(
            "position" => parse(Int, lines[1][end]),
            "score" => 0
        ),
        2 => Dict(
            "position" => parse(Int, lines[2][end]),
            "score" => 0
        )
    )

    board = []

    return players
end

function solution_part_1(players)
    board_length = 10
    last_dice_value = 0
    current_player = 1
    total_rolled = 0
    while players[1]["score"] < 1000 && players[2]["score"] < 1000
        dice_values = [x for x in last_dice_value + 1:last_dice_value + 3]
        dice_values = dice_values .% 100
        replace!(dice_values, 0 => 100)

        last_dice_value = dice_values[end]
        
        new_position = players[current_player]["position"] + sum(dice_values)
        new_position = new_position .% board_length
        if new_position == 0 new_position = 10 end
        
        players[current_player]["position"] = new_position
        players[current_player]["score"] += players[current_player]["position"]

        println("Player : ", current_player, " score: ", players[current_player]["score"])
        
        current_player = current_player == 1 ? 2 : 1
        total_rolled += 1
    end
    
    loser = players[1]["score"] < players[2]["score"] ? 1 : 2
    
    return players[loser]["score"] * total_rolled * 3
end

players = init_game(lines)
println("Solution part 1: ", solution_part_1(players))