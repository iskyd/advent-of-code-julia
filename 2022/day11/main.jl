using DataStructures
using ResumableFunctions
using OrderedCollections

struct Operation
    op::Char
    value::String
end

struct Monkey
    items::Queue{Int}
    operation::Union{Operation, Nothing}
    test::Int
    throw_true::Int
    throw_false::Int
end

@resumable function get_monkeys_lines()
    res = []
    for line in readlines("input.txt")
        if line == ""
            @yield res
            res = []
        else
            push!(res, line)
        end
    end

    @yield res
end

function get_monkeys()::OrderedDict{Int, Monkey}
    monkeys = OrderedDict{Int, Monkey}()
    monkey_id::Int = 0
    for monkey_lines = get_monkeys_lines()
        monkey_id = parse(Int, match(r"(\d+)", monkey_lines[1])[1])

        items =  parse.(Int, split(monkey_lines[2][19:end], ","))
        q_items = Queue{Int}()
        for item in items
            enqueue!(q_items, item)
        end

        operation = Operation(monkey_lines[3][24], monkey_lines[3][26:end])
        test = parse(Int, monkey_lines[4][21:end])
        throw_true = parse(Int, monkey_lines[5][30:end])
        throw_false = parse(Int, monkey_lines[6][31:end])

        monkeys[monkey_id] = Monkey(q_items, operation, test, throw_true, throw_false)
    end

    return monkeys
end

function get_worry_level(monkey::Monkey, item::Int, m::Union{Int, Nothing}=nothing)::Int
    worry_level::Int = 0
    value::Int = monkey.operation.value == "old" ? item : parse(Int, monkey.operation.value)
    if monkey.operation.op == '+'
        worry_level = item + value
    elseif monkey.operation.op == '*'
        worry_level = item * value
    end

    if !(m === nothing)
        worry_level = mod(worry_level, m)
    else
        worry_level = div(worry_level, 3)
    end

    return worry_level
end

function play(monkeys::OrderedDict{Int, Monkey}, round::Int, divide::Bool=false)::Int
    m = lcm([monkeys[i].test for i in eachindex(monkeys)])

    inspects = OrderedDict{Int, Int}()
    for i in eachindex(monkeys)
        inspects[i] = 0
    end

    for _ in 1:round
        for i in eachindex(monkeys)
            monkey = monkeys[i]
            while !isempty(monkey.items)
                item = dequeue!(monkey.items)
                if divide === true
                    worry_level = get_worry_level(monkey, item)
                else
                    worry_level = get_worry_level(monkey, item, m)
                end

                if worry_level % monkey.test == 0
                    enqueue!(monkeys[monkey.throw_true].items, worry_level)
                else
                    enqueue!(monkeys[monkey.throw_false].items, worry_level)
                end

                inspects[i] += 1
            end
        end
    end

    return prod(sort([v for (k, v) in inspects], rev=true)[1:2])
end

monkeys = get_monkeys()

println("Solution part 1: ", play(deepcopy(monkeys), 20, true))
println("Solution part 2: ", play(deepcopy(monkeys), 10000, false))