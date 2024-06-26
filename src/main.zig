const std = @import("std");
const day = @import("day");
const input_file = @import("input").file;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const input: []const u8 = try std.fs.cwd().readFileAlloc(allocator, input_file, std.math.maxInt(usize));
    defer allocator.free(input);

    if (@hasDecl(day, "part1")) {
        const start = std.time.nanoTimestamp();
        const answer = day.part1(input);
        const time_taken: u64 = @intCast(std.time.nanoTimestamp() - start);

        std.debug.print("--- Part 1 ---\n", .{});
        switch (@typeInfo(@TypeOf(answer))) {
            .Pointer, .Array => std.debug.print("Answer: {s}\n", .{answer}),
            else => std.debug.print("Answer: {any}\n", .{answer}),
        }
        std.debug.print("Time Taken: {}\n", .{std.fmt.fmtDuration(time_taken)});
    }

    if (@hasDecl(day, "part2")) {
        const start = std.time.nanoTimestamp();
        const answer = day.part2(input);
        const time_taken: u64 = @intCast(std.time.nanoTimestamp() - start);

        std.debug.print("--- Part 2 ---\n", .{});
        switch (@typeInfo(@TypeOf(answer))) {
            .Pointer, .Array => std.debug.print("Answer: {s}\n", .{answer}),
            else => std.debug.print("Answer: {any}\n", .{answer}),
        }
        std.debug.print("Time Taken: {}\n", .{std.fmt.fmtDuration(time_taken)});
    }
}
