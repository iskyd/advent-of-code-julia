using IterTools
using Caching

lines = readlines("input.txt")

BOARD_LENGTH = 10

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

    return players
end

function solution_part_1(players)
    last_dice_value = 0
    current_player = 1
    total_rolled = 0
    while players[1]["score"] < 1000 && players[2]["score"] < 1000
        dice_values = [x for x in last_dice_value + 1:last_dice_value + 3]
        dice_values = dice_values .% 100
        replace!(dice_values, 0 => 100)

        last_dice_value = dice_values[end]
        
        new_position = players[current_player]["position"] + sum(dice_values)
        new_position = new_position .% BOARD_LENGTH
        if new_position == 0 new_position = 10 end
        
        players[current_player]["position"] = new_position
        players[current_player]["score"] += players[current_player]["position"]
        
        current_player = current_player == 1 ? 2 : 1
        total_rolled += 1
    end
    
    loser = players[1]["score"] < players[2]["score"] ? 1 : 2
    
    return players[loser]["score"] * total_rolled * 3
end

@cache function play_out(p1_position, p1_score, p2_position, p2_score, current_player)
    if p1_score >= 21 return 1, 0 elseif p2_score >= 21 return 0, 1 end

    tot_p1_wins = 0
    tot_p2_wins = 0

    for (d1, d2, d3) in product((1, 2, 3), (1, 2, 3), (1, 2, 3))
        starting_position = current_player == 1 ? p1_position : p2_position

        new_position = starting_position + (d1 + d2 + d3)
        new_position = new_position .% BOARD_LENGTH
        if new_position == 0 new_position = 10 end
        
        if current_player == 1
            new_score = p1_score + new_position
            p1_wins, p2_wins = play_out(new_position, new_score, p2_position, p2_score, 2)
        else
            new_score = p2_score + new_position
            p1_wins, p2_wins = play_out(p1_position, p1_score, new_position, new_score, 1)
        end

        tot_p1_wins += p1_wins
        tot_p2_wins += p2_wins
    end

    return tot_p1_wins, tot_p2_wins
end

function solution_part_2(players)
    p1_wins, p2_wins = play_out(players[1]["position"], 0, players[2]["position"], 0, 1)
    return max(p1_wins, p2_wins)
end

players = init_game(lines)
println("Solution part 1: ", solution_part_1(players))

players = init_game(lines)
println("Solution part 2: ", solution_part_2(players))