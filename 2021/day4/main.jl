lines = readlines("input.txt")

BOARD_SIZE = 5

function create_boards(input)
    lines_index = 1
    
    boards = Matrix{Int16}[]

    while true
        if lines_index > size(input)[1]
            break
        end

        board = zeros(Int16, BOARD_SIZE, BOARD_SIZE)
        for (index, row) in enumerate(input[lines_index:lines_index + BOARD_SIZE - 1])
            board_row = [parse(Int16, i) for i in filter(x -> x != "", split(row, " "))]
            board[index,:] = board_row
        end

        push!(boards, board)

        lines_index += BOARD_SIZE + 1
    end

    return boards
end

function has_board_won(board, numbers)
    for i in 1:BOARD_SIZE
        if issubset(board[i,:], numbers) || issubset(board[:,i], numbers)
            return true
        end
    end
    
    return false
end

function get_first_winning_board(boards, numbers)
    for i in 4:size(numbers)[1]
        for board in boards
            if has_board_won(board, numbers[1:i])
                return (board, numbers[1:i])
            end
        end
    end

    return (nothing, nothing)
end

function get_points(winning_board, drawn_numbers)
    sum_unmarked = 0
    for row in winning_board
        for element in row
            if !(element in drawn_numbers)
                sum_unmarked += element
            end
        end
    end

    return sum_unmarked * last(drawn_numbers)
end

function get_last_winning_board(boards, numbers)
    winning_board, drawn_numbers = get_first_winning_board(boards, numbers)
    
    tmp_boards = Matrix{Int16}[]
    for board in boards
        if board != winning_board
            push!(tmp_boards, board)
        end
    end

    if size(tmp_boards)[1] == 1
        return get_first_winning_board(tmp_boards, numbers)
    end 

    return get_last_winning_board(tmp_boards, numbers)
end

numbers = [parse(Int16, i) for i in split(lines[1], ",")]
boards = create_boards(lines[3:end])

winning_board, drawn_numbers = get_first_winning_board(boards, numbers)
println("Solution part 1: ", get_points(winning_board, drawn_numbers))

last_winning_board, drawn_numbers = get_last_winning_board(boards, numbers)
println("Solution part 2: ", get_points(last_winning_board, drawn_numbers))