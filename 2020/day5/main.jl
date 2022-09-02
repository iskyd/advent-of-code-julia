lines::Array{String} = readlines("input.txt")

function get_seat_id(seat::String)::Int
    row = parse(Int, replace(seat[1:7], 'F' => '0', 'B' => '1'), base=2)
    col = parse(Int, replace(seat[8:10], 'L' => '0', 'R' => '1'), base=2)

    return row * 8 + col
end

seat_ids = sort(map(get_seat_id, lines))

println("Solution part 1: ", maximum(seat_ids))
println("Solution part 2: ", setdiff(seat_ids[1]:seat_ids[end], seat_ids))