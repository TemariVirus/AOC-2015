const std = @import("std");

pub fn part1(input: []const u8) usize {
    var lines = std.mem.tokenizeAny(u8, input, "\n\r");
    var sum: usize = 0;
    while (lines.next()) |line| {
        sum += 2;

        var i: usize = 1;
        while (i < line.len - 1) {
            if (line[i] == '\\') {
                if (line[i + 1] == 'x') {
                    sum += 3;
                    i += 4;
                } else {
                    sum += 1;
                    i += 2;
                }
            } else {
                i += 1;
            }
        }
    }
    return sum;
}

pub fn part2(input: []const u8) usize {
    var lines = std.mem.tokenizeAny(u8, input, "\n\r");
    var sum: usize = 0;
    while (lines.next()) |line| {
        sum += 2 +
            std.mem.count(u8, line, "\\") +
            std.mem.count(u8, line, "\"");
    }
    return sum;
}
