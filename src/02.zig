const std = @import("std");
const Allocator = std.mem.Allocator;

const INPUT = @embedFile("02.txt");

fn parseInput(allocator: Allocator, input: []const u8) ![][3]u32 {
    var sizes = std.ArrayList([3]u32).init(allocator);
    defer sizes.deinit();

    var lines = std.mem.tokenizeAny(u8, input, "\r\n");
    while (lines.next()) |line| {
        var numbers = std.mem.splitScalar(u8, line, 'x');
        const l = std.fmt.parseInt(u32, numbers.next().?, 10) catch unreachable;
        const w = std.fmt.parseInt(u32, numbers.next().?, 10) catch unreachable;
        const h = std.fmt.parseInt(u32, numbers.next().?, 10) catch unreachable;

        try sizes.append(.{ l, w, h });
    }

    return sizes.toOwnedSlice();
}

pub fn part1() u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const sizes = parseInput(allocator, INPUT) catch unreachable;
    defer allocator.free(sizes);

    var total: u32 = 0;
    for (sizes) |size| {
        const face1 = size[0] * size[1];
        const face2 = size[1] * size[2];
        const face3 = size[2] * size[0];
        const min = @min(face1, @min(face2, face3));
        total += 2 * (face1 + face2 + face3) + min;
    }

    return total;
}

pub fn part2() u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const sizes = parseInput(allocator, INPUT) catch unreachable;
    defer allocator.free(sizes);

    var total: u32 = 0;
    for (sizes) |size| {
        const perimeter1 = 2 * (size[0] + size[1]);
        const perimeter2 = 2 * (size[1] + size[2]);
        const perimeter3 = 2 * (size[2] + size[0]);
        const volume = size[0] * size[1] * size[2];
        total += @min(perimeter1, @min(perimeter2, perimeter3)) + volume;
    }

    return total;
}
