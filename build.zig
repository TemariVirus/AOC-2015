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
    var input_file: [10]u8 = undefined;
    _ = std.fmt.bufPrint(&input_file, "src/{d:0>2}.txt", .{day}) catch unreachable;

    const day_lib = b.addModule("day", .{
        .root_source_file = lazyPath(b, &day_file),
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "AOC-2015",
        .root_source_file = lazyPath(b, "src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("day", day_lib);

    const options = b.addOptions();
    options.addOption([]const u8, "file", &input_file);
    exe.root_module.addOptions("input", options);

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}

fn lazyPath(b: *std.Build, path: []const u8) std.Build.LazyPath {
    return .{
        .src_path = .{
            .owner = b,
            .sub_path = path,
        },
    };
}
