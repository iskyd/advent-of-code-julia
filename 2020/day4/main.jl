lines::Array{String} = readlines("input.txt")

function parse_passports(lines::Array{String})::Array{Dict{String,String}}
    passports = []
    passport = Dict()
    for line in lines
        if line == ""
            push!(passports, passport)
            passport = Dict()
        else
            for field in split(line, " ")
                key, value = split(field, ":")
                passport[key] = value
            end
        end
    end
    push!(passports, passport)

    return passports
end

function solution_part_1(passports::Array{Dict{String,String}})::Int
    valid_passports = 0
    for passport in passports
        if length(passport) == 8 || (length(passport) == 7 && !haskey(passport, "cid"))
            valid_passports += 1
        end
    end

    return valid_passports
end

function is_valid_number(value::String, min::Int, max::Int)::Bool
    try
        parsed = parse(Int, value)
        return parsed >= min && parsed <= max
    catch
        return false
    end
end

function is_valid_heigth(value::String)::Bool
    if endswith(value, "cm")
        return is_valid_number(value[1:end-2], 150, 193)
    elseif endswith(value, "in")
        return is_valid_number(value[1:end-2], 59, 76)
    else
        return false
    end
end

function solution_part_2(passports::Array{Dict{String,String}})::Int
    valid_passports = 0
    for passport in passports
        if length(passport) == 8 || (length(passport) == 7 && !haskey(passport, "cid"))
            if is_valid_number(passport["byr"], 1920, 2002) &&
               is_valid_number(passport["iyr"], 2010, 2020) &&
               is_valid_number(passport["eyr"], 2020, 2030) &&
               is_valid_heigth(passport["hgt"]) &&
               occursin(r"^#[0-9a-f]{6}$", passport["hcl"]) &&
               in(passport["ecl"], ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]) &&
               occursin(r"^[0-9]{9}$", passport["pid"])

                valid_passports += 1
            end
        end
    end

    return valid_passports
end

passports::Array{Dict{String,String}} = parse_passports(lines)

println("Solution part 1: ", solution_part_1(passports))
println("Solution part 2: ", solution_part_2(passports))