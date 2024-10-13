const std = @import("std");

const day_infos = @import("days").day_infos;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var total_time: u64 = 0;

    inline for (day_infos) |di| {
        const input: []const u8 = try std.fs.cwd().readFileAlloc(
            allocator,
            di.input,
            std.math.maxInt(usize),
        );
        defer allocator.free(input);

        if (@hasDecl(di.module, "part1")) {
            total_time += try runDayPart(di.day, 1, di.module.part1, input);
        }
        if (@hasDecl(di.module, "part2")) {
            total_time += try runDayPart(di.day, 2, di.module.part2, input);
        }
    }

    std.debug.print("Total Time: {}\n", .{std.fmt.fmtDuration(total_time)});
}

fn runDayPart(day: u5, part: u2, func: anytype, input: []const u8) !u64 {
    const start = std.time.nanoTimestamp();
    const answer = blk: {
        const ans = func(input);
        break :blk switch (@typeInfo((@TypeOf(ans)))) {
            .ErrorUnion => ans catch |e| return e,
            else => ans,
        };
    };
    const time_taken: u64 = @intCast(std.time.nanoTimestamp() - start);

    std.debug.print("Day {d:>2} Part {d:>1}: ", .{ day, part });
    switch (@typeInfo(@TypeOf(answer))) {
        .Pointer, .Array => std.debug.print("{s:>10}", .{answer}),
        else => std.debug.print("{any:>10}", .{answer}),
    }
    std.debug.print(" | Time: {}\n", .{std.fmt.fmtDuration(time_taken)});

    return time_taken;
}
