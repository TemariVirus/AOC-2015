const INPUT = @embedFile("01.txt");

pub fn part1() i32 {
    var floor: i32 = 0;
    for (INPUT) |c| {
        switch (c) {
            '(' => floor += 1,
            ')' => floor -= 1,
            else => unreachable,
        }
    }
    return floor;
}

pub fn part2() u32 {
    var floor: i32 = 0;
    for (INPUT, 0..) |c, i| {
        switch (c) {
            '(' => floor += 1,
            ')' => floor -= 1,
            else => unreachable,
        }
        if (floor < 0) {
            return @intCast(i + 1);
        }
    }
    // Basement should eventually be reached
    unreachable;
}
