const std = @import("std");
const day = @import("day");

pub fn main() !void {
    if (@hasDecl(day, "part1")) {
        const start = std.time.nanoTimestamp();
        const answer = day.part1();
        const time_taken: u64 = @intCast(std.time.nanoTimestamp() - start);

        std.debug.print("--- Part 1 ---\n", .{});
        std.debug.print("Answer: {}\n", .{answer});
        std.debug.print("Time Taken: {}\n", .{std.fmt.fmtDuration(time_taken)});
    }

    if (@hasDecl(day, "part2")) {
        const start = std.time.nanoTimestamp();
        const answer = day.part2();
        const time_taken: u64 = @intCast(std.time.nanoTimestamp() - start);

        std.debug.print("--- Part 2 ---\n", .{});
        std.debug.print("Answer: {}\n", .{answer});
        std.debug.print("Time Taken: {}\n", .{std.fmt.fmtDuration(time_taken)});
    }
}