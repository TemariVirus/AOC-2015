pub fn part1(input: []const u8) i32 {
    var floor: i32 = 0;
    for (input) |c| {
        switch (c) {
            '(' => floor += 1,
            ')' => floor -= 1,
            else => unreachable,
        }
    }
    return floor;
}

pub fn part2(input: []const u8) u32 {
    var floor: i32 = 0;
    for (input, 0..) |c, i| {
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
