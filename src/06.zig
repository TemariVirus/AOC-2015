const std = @import("std");
const Allocator = std.mem.Allocator;
const assert = std.debug.assert;

const LightSet = std.bit_set.ArrayBitSet(usize, 1_000_000);

const InstructionType = enum {
    turn_on,
    turn_off,
    toggle,
};
const Instruction = struct {
    type: InstructionType,
    start_x: u16,
    start_y: u16,
    end_x: u16,
    end_y: u16,

    pub fn applyOnSet(self: Instruction, lights: *LightSet) void {
        for (self.start_y..self.end_y) |y| {
            const start = y * 1000 + self.start_x;
            const end = y * 1000 + self.end_x;
            switch (self.type) {
                .turn_on => lights.setRangeValue(.{
                    .start = start,
                    .end = end,
                }, true),
                .turn_off => lights.setRangeValue(.{
                    .start = start,
                    .end = end,
                }, false),
                .toggle => toggleRange(lights, .{
                    .start = start,
                    .end = end,
                }),
            }
        }
    }

    pub fn apply(self: Instruction, lights: []u8) void {
        // TODO: use SIMD if not already being used in release mode
        for (self.start_y..self.end_y) |y| {
            for (self.start_x..self.end_x) |x| {
                const index = y * 1000 + x;
                switch (self.type) {
                    .turn_on => lights[index] += 1,
                    .turn_off => lights[index] -|= 1,
                    .toggle => lights[index] += 2,
                }
            }
        }
    }
};

fn toggleRange(self: *LightSet, range: std.bit_set.Range) void {
    assert(range.end <= LightSet.bit_length);
    assert(range.start <= range.end);
    if (range.start == range.end) return;

    const start_mask_index = range.start >> @bitSizeOf(LightSet.ShiftInt);
    const start_bit = @as(LightSet.ShiftInt, @truncate(range.start));

    const end_mask_index = range.end >> @bitSizeOf(LightSet.ShiftInt);
    const end_bit = @as(LightSet.ShiftInt, @truncate(range.end));

    if (start_mask_index == end_mask_index) {
        const mask1 = std.math.boolMask(LightSet.MaskInt, true) << start_bit;
        const mask2 = std.math.boolMask(LightSet.MaskInt, true) >> (@bitSizeOf(LightSet.MaskInt) - 1) - (end_bit - 1);
        self.masks[start_mask_index] ^= mask1 & mask2;
    } else {
        var bulk_mask_index: usize = undefined;
        if (start_bit > 0) {
            self.masks[start_mask_index] =
                self.masks[start_mask_index] ^ (std.math.boolMask(LightSet.MaskInt, true) << start_bit);
            bulk_mask_index = start_mask_index + 1;
        } else {
            bulk_mask_index = start_mask_index;
        }

        while (bulk_mask_index < end_mask_index) : (bulk_mask_index += 1) {
            self.masks[bulk_mask_index] ^= std.math.boolMask(LightSet.MaskInt, true);
        }

        if (end_bit > 0) {
            self.masks[end_mask_index] =
                self.masks[end_mask_index] ^ ~(std.math.boolMask(LightSet.MaskInt, true) << end_bit);
        }
    }
}

fn parseCoord(str: []const u8) !struct { u16, u16 } {
    var parts = std.mem.splitScalar(u8, str, ',');
    const x = try std.fmt.parseInt(u16, parts.next().?, 10);
    const y = try std.fmt.parseInt(u16, parts.next().?, 10);
    return .{ x, y };
}

fn parseInput(allocator: Allocator, input: []const u8) ![]const Instruction {
    var instructions = std.ArrayList(Instruction).init(allocator);
    errdefer instructions.deinit();

    var lines = std.mem.tokenizeAny(u8, input, "\n\r");
    while (lines.next()) |line| {
        var parts = std.mem.splitSequence(u8, line, " through ");
        const first = parts.next().?;
        const end = parts.next().?;

        var first_parts = std.mem.splitBackwardsScalar(u8, first, ' ');
        const start = first_parts.next().?;
        const type_str = first_parts.rest();

        const start_x, const start_y = try parseCoord(start);
        const end_x, const end_y = try parseCoord(end);
        const instruction_type = if (std.mem.eql(u8, type_str, "turn on"))
            InstructionType.turn_on
        else if (std.mem.eql(u8, type_str, "turn off"))
            InstructionType.turn_off
        else if (std.mem.eql(u8, type_str, "toggle"))
            InstructionType.toggle
        else
            unreachable;
        // Add 1 as we're using exclusive end coordinates
        try instructions.append(.{
            .type = instruction_type,
            .start_x = start_x,
            .start_y = start_y,
            .end_x = end_x + 1,
            .end_y = end_y + 1,
        });
    }

    return instructions.toOwnedSlice();
}

pub fn part1(input: []const u8) usize {
    // Splitting the lights into rectangles with the same on/off state, may
    // improve performance since with only 300 instructions there'll be at most
    // a few thousand rectangles.

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const instructions = parseInput(allocator, input) catch unreachable;
    defer allocator.free(instructions);

    var lights = LightSet.initEmpty();
    for (instructions) |instruction| {
        instruction.applyOnSet(&lights);
    }
    return lights.count();
}

pub fn part2(input: []const u8) usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const instructions = parseInput(allocator, input) catch unreachable;
    defer allocator.free(instructions);

    var lights = [_]u8{0} ** 1_000_000;
    for (instructions) |instruction| {
        instruction.apply(&lights);
    }

    var total_brightness: usize = 0;
    for (lights) |light| {
        total_brightness += light;
    }
    return total_brightness;
}
