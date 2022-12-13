using ResumableFunctions

@resumable function get_pairs()::Tuple{String, String}
    p1 = p2 = ""
    for line in readlines("test.txt")
        if line == ""
            @yield p1, p2
            p1 = p2 = ""
        else
            if p1 === ""
                p1 = line
            else
                p2 = line
            end
        end
    end

    @yield p1, p2
end

function solution_part1()
    for (p1, p2) in get_pairs()
        println(p1)
        println(p2)
        println("----")
    end
end

println("Solution part 1: ", solution_part1())