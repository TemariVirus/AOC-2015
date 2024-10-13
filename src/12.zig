const std = @import("std");
const Value = std.json.Value;

fn sumNumbers(v: Value) i64 {
    switch (v) {
        .array => |arr| {
            var sum: i64 = 0;
            for (arr.items) |elem| {
                sum += sumNumbers(elem);
            }
            return sum;
        },
        .object => |obj| {
            var sum: i64 = 0;
            for (obj.values()) |elem| {
                sum += sumNumbers(elem);
            }
            return sum;
        },
        .integer => |i| return i,
        .bool,
        .float,
        .number_string,
        .string,
        .null,
        => return 0,
    }
}

pub fn part1(input: []const u8) !i64 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var s = std.json.Scanner.initCompleteInput(allocator, input);
    defer s.deinit();

    var arena = std.heap.ArenaAllocator.init(allocator);
    const arena_alloc = arena.allocator();
    defer arena.deinit();
    const v = try std.json.Value.jsonParse(
        arena_alloc,
        &s,
        .{ .max_value_len = std.math.maxInt(usize) },
    );

    return sumNumbers(v);
}

fn sumNumbers2(v: Value) i64 {
    switch (v) {
        .array => |arr| {
            var sum: i64 = 0;
            for (arr.items) |elem| {
                sum += sumNumbers2(elem);
            }
            return sum;
        },
        .object => |obj| {
            var sum: i64 = 0;
            for (obj.values()) |elem| {
                switch (elem) {
                    .string => |s| if (std.mem.eql(u8, s, "red")) return 0,
                    else => {},
                }
                sum += sumNumbers2(elem);
            }
            return sum;
        },
        .integer => |i| return i,
        .bool,
        .float,
        .number_string,
        .string,
        .null,
        => return 0,
    }
}

pub fn part2(input: []const u8) !i64 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var s = std.json.Scanner.initCompleteInput(allocator, input);
    defer s.deinit();

    var arena = std.heap.ArenaAllocator.init(allocator);
    const arena_alloc = arena.allocator();
    defer arena.deinit();
    const v = try std.json.Value.jsonParse(
        arena_alloc,
        &s,
        .{ .max_value_len = std.math.maxInt(usize) },
    );

    return sumNumbers2(v);
}
