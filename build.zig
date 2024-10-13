const std = @import("std");
const OptimizeMode = std.builtin.OptimizeMode;
const ResolvedTarget = std.Build.ResolvedTarget;
const Step = std.Build.Step;

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = if (b.option(u8, "day", "The day to run")) |day|
        try singleExe(b, target, optimize, day)
    else
        allExe(b, target, optimize);

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}

fn singleExe(b: *std.Build, target: ResolvedTarget, optimize: OptimizeMode, day: u8) !*Step.Compile {
    if (day < 1 or day > 25) {
        return error.dayOutOfRange;
    }
    var day_file: [10]u8 = undefined;
    _ = std.fmt.bufPrint(&day_file, "src/{d:0>2}.zig", .{day}) catch unreachable;
    var input_file: [10]u8 = undefined;
    _ = std.fmt.bufPrint(&input_file, "src/{d:0>2}.txt", .{day}) catch unreachable;

    const day_lib = b.addModule("day", .{
        .root_source_file = b.path(&day_file),
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "AOC-2015",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("day", day_lib);

    const options = b.addOptions();
    options.addOption([]const u8, "file", &input_file);
    exe.root_module.addOptions("input", options);

    return exe;
}

fn availableDays(b: *std.Build) std.Build.LazyPath {
    const days_exe = b.addExecutable(.{
        .name = "available-days",
        .root_source_file = b.path("src/build/available-days.zig"),
        // Use native target as this is a build script
        .target = b.resolveTargetQuery(
            std.Build.parseTargetQuery(.{}) catch unreachable,
        ),
    });

    const days_cmd = b.addRunArtifact(days_exe);
    days_cmd.addDirectoryArg(b.path("src"));
    days_cmd.expectExitCode(0);

    return days_cmd.addOutputFileArg("days.zig");
}

fn allExe(b: *std.Build, target: ResolvedTarget, optimize: OptimizeMode) *Step.Compile {
    const exe = b.addExecutable(.{
        .name = "AOC-2015",
        .root_source_file = b.path("src/all.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe.root_module.addImport("days", b.createModule(.{
        .root_source_file = availableDays(b),
    }));

    return exe;
}
