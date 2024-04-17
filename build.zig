const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const day = b.option(u8, "day", "The day to run").?;
    if (day < 1 or day > 25) {
        return error.dayOutOfRange;
    }
    var day_file: [10]u8 = undefined;
    _ = std.fmt.bufPrint(&day_file, "src/{d:0>2}.zig", .{day}) catch unreachable;

    const day_lib = b.addModule("day", .{
        .root_source_file = .{ .path = &day_file },
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "AOC-2015",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("day", day_lib);

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
