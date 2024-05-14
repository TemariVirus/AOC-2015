const std = @import("std");
const Allocator = std.mem.Allocator;
const assert = std.debug.assert;

const OutputMap = std.AutoHashMap(u16, []const u8);
const ValueMap = std.AutoHashMap(u16, u16);

fn varToNum(name: []const u8) u16 {
    assert(name.len > 0);
    assert(name.len <= 2);

    if (name.len == 1) {
        return name[0];
    }
    return (@as(u16, name[0]) << 8) | name[1];
}

fn parseInput(allocator: Allocator, input: []const u8) !OutputMap {
    var output_map = OutputMap.init(allocator);
    errdefer output_map.deinit();

    var lines = std.mem.tokenizeAny(u8, input, "\n\r");
    while (lines.next()) |line| {
        var split = std.mem.splitSequence(u8, line, " -> ");
        const expr = split.next().?;
        const output = split.next().?;
        try output_map.put(varToNum(output), expr);
    }

    return output_map;
}

fn eval(var_name: []const u8, output_map: OutputMap, value_map: *ValueMap) !u16 {
    // Constant
    if (std.ascii.isDigit(var_name[0])) {
        return try std.fmt.parseInt(u16, var_name, 10);
    }

    // Variable with known value
    const var_num = varToNum(var_name);
    if (value_map.get(var_num)) |v| {
        return v;
    }

    const expr = output_map.get(var_num) orelse unreachable;
    var parts = std.mem.tokenizeScalar(u8, expr, ' ');

    // Must have at least 1 part
    const s1 = parts.next().?;
    const split2 = parts.next();
    const split3 = parts.next();

    // Binary operator
    if (split3) |s3| {
        const v1 = try eval(s1, output_map, value_map);
        const v3 = try eval(s3, output_map, value_map);

        const s2 = split2.?;
        const output = switch (s2[0]) {
            'A' => blk: {
                assert(std.mem.eql(u8, s2, "AND"));
                break :blk v1 & v3;
            },
            'O' => blk: {
                assert(std.mem.eql(u8, s2, "OR"));
                break :blk v1 | v3;
            },
            'L' => blk: {
                assert(std.mem.eql(u8, s2, "LSHIFT"));
                break :blk v1 << @intCast(v3);
            },
            'R' => blk: {
                assert(std.mem.eql(u8, s2, "RSHIFT"));
                break :blk v1 >> @intCast(v3);
            },
            else => unreachable,
        };
        try value_map.put(var_num, output);
        return output;
    }

    // Unary operator
    if (split2) |s2| {
        assert(std.mem.eql(u8, s1, "NOT"));
        const output = ~(try eval(s2, output_map, value_map));
        try value_map.put(var_num, output);
        return output;
    }

    // Assignment
    const output = try eval(s1, output_map, value_map);
    try value_map.put(var_num, output);
    return output;
}

pub fn part1(input: []const u8) u16 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var output_map = parseInput(allocator, input) catch unreachable;
    defer output_map.deinit();

    var values = ValueMap.init(allocator);
    defer values.deinit();

    return eval("a", output_map, &values) catch unreachable;
}

pub fn part2(input: []const u8) u16 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var output_map = parseInput(allocator, input) catch unreachable;
    defer output_map.deinit();

    var values = ValueMap.init(allocator);
    defer values.deinit();

    const a_value = eval("a", output_map, &values) catch unreachable;
    var buf = [_]u8{0} ** 5;
    const a_str = std.fmt.bufPrint(&buf, "{}", .{a_value}) catch unreachable;
    output_map.put(varToNum("b"), a_str) catch unreachable;
    values.clearRetainingCapacity();

    return eval("a", output_map, &values) catch unreachable;
}
