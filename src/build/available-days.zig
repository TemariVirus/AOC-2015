const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();

    _ = args.next().?; // Executable path
    const source_dir = args.next() orelse return error.MissingSourcePath;
    const path = args.next() orelse return error.MissingOutputPath;

    var output_dir =
        try std.fs.openDirAbsolute(std.fs.path.dirname(path).?, .{});
    defer output_dir.close();

    const file = try std.fs.cwd().createFile(path, .{});
    defer file.close();
    var bf = std.io.bufferedWriter(file.writer());
    const writer = bf.writer();

    try writer.writeAll(
        \\pub const DayInfo = struct {
        \\    module: type,
        \\    day: u5,
        \\    input: []const u8,
        \\};
        \\pub const day_infos = [_]DayInfo{
        \\
    );

    var dir = try std.fs.openDirAbsolute(source_dir, .{ .iterate = true });
    defer dir.close();

    var iter = dir.iterate();
    while (try iter.next()) |entry| {
        if (entry.kind != .file or !std.mem.endsWith(u8, entry.name, ".zig")) {
            continue;
        }

        const name = std.fs.path.stem(entry.name);
        const number = std.fmt.parseInt(u8, name, 10) catch continue;
        if (number < 1 or number > 25) {
            continue;
        }

        // Copy file and import it
        try dir.copyFile(entry.name, output_dir, entry.name, .{});
        try writer.print(
            \\    .{{ .module = @import("{s}"), .day = {}, .input = "src/{s}.txt" }},
            \\
        ,
            .{ entry.name, number, name },
        );
    }

    try writer.writeAll("};");
    try bf.flush();
}
