lines::Array{String} = readlines("input.txt")

function solution_part_1(lines::Array{String})::Int
    sum = 0
    questions = []
    for line in lines
        if line == ""
            sum += length(questions)
            questions = []
            continue
        end

        questions = unique([questions; split(line, "")])
    end

    sum += length(questions)

    return sum
end

function get_intesection(questions)
    intersection = questions[1]

    for i in 2:length(questions)
        intersection = intersect(intersection, questions[i])
    end

    return length(intersection)
end

function solution_part_2(lines::Array{String})::Int
    questions = []
    sum = 0
    for line in lines
        if line == ""
            sum += get_intesection(questions)
            questions = []
            continue
        end

        push!(questions, split(line, ""))
    end

    sum += get_intesection(questions)

    return sum
end

println("Solution part 1: ", solution_part_1(lines))
println("Solution part 2: ", solution_part_2(lines))