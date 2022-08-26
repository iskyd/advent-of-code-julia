lines::Array{String} = readlines("input.txt")

struct Policy
    min::Int
    max::Int
    letter::Char
end

function parse_policy(line::String)::Policy
    min::Int, max::Int = parse.(Int, split(match(r"(\d+-\d+)", line)[1], "-"))
    letter::Char = match(r"(\w):", line)[1][1]

    return Policy(min, max, letter)
end

function parse_password(line::String)::String
    return match(r": (\w+)", line)[1]
end

function is_valid_password_part_1(policy::Policy, password::String)::Bool
    c::Int = count(x -> x == policy.letter, password)
    return c >= policy.min && c <= policy.max
end

function is_valid_password_part_2(policy::Policy, password::String)::Bool
    return (password[policy.min] == policy.letter) ⊻ (password[policy.max] == policy.letter)
end

policies::Array{Policy} = [parse_policy(line) for line in lines]
passwords::Array{String} = [parse_password(line) for line in lines]

println("Solution part 1: ", sum([is_valid_password_part_1(policies[i], passwords[i]) for i in 1:length(lines)]))
println("Solution part 2: ", sum([is_valid_password_part_2(policies[i], passwords[i]) for i in 1:length(lines)]))