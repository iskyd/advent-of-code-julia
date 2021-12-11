lines = readlines("input.txt")
lines = [parse(Int16, line) for line in lines]

function count_part_1(lines)
	return count(i -> (i == true), [lines[i] > lines[i - 1] ? true : false for i in 2:size(lines)[1]])
end

function count_part_2(lines)
	return count_part_1([lines[i] + lines[i - 1] + lines[i - 2] for i in 3:size(lines)[1]])
end

println("Solution part 1: ", count_part_1(lines))
println("Solution part 2: ", count_part_2(lines))
