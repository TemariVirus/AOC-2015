const std = @import("std");

const INPUT = @embedFile("03.txt");

pub fn part1() usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var x: i32 = 0;
    var y: i32 = 0;

    var visited = std.AutoHashMap([2]i32, void).init(allocator);
    defer visited.deinit();

    visited.put(.{ x, y }, {}) catch unreachable;

    for (INPUT) |c| {
        switch (c) {
            '^' => y += 1,
            'v' => y -= 1,
            '>' => x += 1,
            '<' => x -= 1,
            else => unreachable,
        }
        visited.put(.{ x, y }, {}) catch unreachable;
    }

    return visited.count();
}

pub fn part2() usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var x1: i32 = 0;
    var y1: i32 = 0;
    var x2: i32 = 0;
    var y2: i32 = 0;

    var visited = std.AutoHashMap([2]i32, void).init(allocator);
    defer visited.deinit();

    visited.put(.{ x1, y1 }, {}) catch unreachable;

    for (INPUT, 0..) |c, i| {
        const x = if (i % 2 == 0) &x1 else &x2;
        const y = if (i % 2 == 0) &y1 else &y2;
        switch (c) {
            '^' => y.* += 1,
            'v' => y.* -= 1,
            '>' => x.* += 1,
            '<' => x.* -= 1,
            else => unreachable,
        }
        visited.put(.{ x.*, y.* }, {}) catch unreachable;
    }

    return visited.count();
}
