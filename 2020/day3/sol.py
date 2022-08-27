def day3p1(right=3, down=1):
    lr_pos = 0
    tree_ct = 0
    with open('input.txt') as f:
        lines = f.readlines()
        for i in range(0, len(lines), down):
            line = lines[i].strip()
            if '#' == line[lr_pos]:
                tree_ct += 1
            lr_pos += right
            lr_pos = lr_pos % len(line)

    return tree_ct

print(day3p1())

def day3p2():
    total = 1
    total *= day3p1(1)
    total *= day3p1(3)
    total *= day3p1(5)
    total *= day3p1(7)
    total *= day3p1(1, 2)
    return total

print(day3p2())