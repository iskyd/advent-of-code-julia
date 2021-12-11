lines = readlines("input.txt")

function count_list_comprehensions(lines)
	return count(i -> (i == 1), [parse(Int64, lines[i]) > parse(Int64, lines[i - 1]) ? true : false for i in 2:size(lines)[1]])
end

print(count_list_comprehensions(lines))
