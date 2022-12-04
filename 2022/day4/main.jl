using ResumableFunctions

@resumable function get_pairs()
    for line in readlines("input.txt")
        s1, s2 = split(line, ",")
        n1, n2 = parse(Int, split(s1, "-")[1]), parse(Int, split(s1, "-")[2])
        n3, n4 = parse(Int, split(s2, "-")[1]),parse(Int, split(s2, "-")[2])

        @yield n1, n2, n3, n4
    end
end

function solution_part1()::Int
    total = 0
    for res in get_pairs()
        n1, n2, n3, n4 = res

        if (n1 >= n3 && n2 <= n4) || (n1 <= n3 && n2 >= n4)
            total += 1
        end
    end

    return total
end

function solution_part2()::Int
    total = 0
    for res in get_pairs()
        n1, n2, n3, n4 = res

        if !(n2 < n3 || n1 > n4)
            total += 1
        end
    end

    return total
end


println("Solution part 1: ", solution_part2())