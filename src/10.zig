const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn part1(input: []const u8) usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    return growSequence(allocator, input, 40) catch unreachable;
}

pub fn part2(input: []const u8) usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    return growSequence(allocator, input, 50) catch unreachable;
}

pub fn growSequence(allocator: Allocator, sequence: []const u8, times: usize) !usize {
    var seq1 = std.ArrayList(u8).init(allocator);
    defer seq1.deinit();
    var seq2 = std.ArrayList(u8).init(allocator);
    seq2.appendSlice(sequence) catch unreachable;
    defer seq2.deinit();

    for (0..times) |_| {
        var last = seq2.items[0];
        var count: usize = 1;
        for (seq2.items[1..]) |n| {
            if (n == last) {
                count += 1;
            } else {
                try seq1.writer().print("{}", .{count});
                try seq1.append(last);
                last = n;
                count = 1;
            }
        }
        try seq1.writer().print("{}", .{count});
        try seq1.append(last);

        seq2.clearRetainingCapacity();
        std.mem.swap(std.ArrayList(u8), &seq1, &seq2);
    }

    return seq2.items.len;
}
