const std = @import("std");
const Allocator = std.mem.Allocator;

fn parseInput(allocator: Allocator, input: []const u8) struct { [][]u32, usize } {
    var lines = std.mem.tokenizeAny(u8, input, "\n\r");
    var edges_count: usize = 0;
    while (lines.next()) |_| {
        edges_count += 1;
    }
    lines.reset();

    // The locations form a complete graph, so we can find the number of nodes from the number of edges
    const n = (1 + std.math.sqrt(8 * edges_count + 1)) / 2;
    var dists = allocator.alloc([]u32, n) catch unreachable;
    for (0..n) |i| {
        dists[i] = allocator.alloc(u32, n) catch unreachable;
    }

    var row: usize = 0;
    var col: usize = 0;
    while (lines.next()) |line| {
        col += 1;
        if (col >= n) {
            row += 1;
            col = row + 1;
        }

        var split = std.mem.splitBackwardsScalar(u8, line, ' ');
        const dist = std.fmt.parseInt(u32, split.first(), 10) catch unreachable;
        dists[col][row] = dist;
        dists[row][col] = dist;
    }

    return .{ dists, n };
}

fn bestPath(dists: []const []const u32, left: []usize, comptime cmp: fn (u32, u32) bool) u32 {
    if (left.len < 2) {
        return 0;
    }

    var best: u32 = bestPathInner(dists, left[1..], dists[left[0]][left[1]], cmp);
    // There is no restriction for the first edge
    for (0..left.len) |i| {
        // Travel from place i to place j
        std.mem.swap(usize, &left[i], &left[0]);
        for (0..left.len - 1) |_| {
            const dist = bestPathInner(dists, left[1..], dists[left[0]][left[1]], cmp);
            if (cmp(dist, best)) {
                best = dist;
            }
            std.mem.rotate(usize, left[1..], 1);
        }
        // Swap places back
        std.mem.swap(usize, &left[i], &left[0]);
    }

    return best;
}

fn bestPathInner(dists: []const []const u32, left: []usize, agg: u32, comptime cmp: fn (u32, u32) bool) u32 {
    if (left.len < 2) {
        return agg;
    }

    var best: u32 = bestPathInner(dists, left[1..], agg + dists[left[0]][left[1]], cmp);
    for (2..left.len) |i| {
        // Travel from place 0 to place i
        std.mem.swap(usize, &left[i], &left[1]);
        const dist = bestPathInner(dists, left[1..], agg + dists[left[0]][left[1]], cmp);
        if (cmp(dist, best)) {
            best = dist;
        }
        // Swap places back
        std.mem.swap(usize, &left[i], &left[1]);
    }

    return best;
}

pub fn part1(input: []const u8) u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const dists, const n = parseInput(allocator, input);
    defer {
        for (dists) |arr| {
            allocator.free(arr);
        }
        allocator.free(dists);
    }

    const left = allocator.alloc(usize, n) catch unreachable;
    defer allocator.free(left);
    for (0..n) |i| {
        left[i] = i;
    }

    return bestPath(dists, left, lt);
}

fn lt(a: u32, b: u32) bool {
    return a < b;
}

pub fn part2(input: []const u8) u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const dists, const n = parseInput(allocator, input);
    defer {
        for (dists) |arr| {
            allocator.free(arr);
        }
        allocator.free(dists);
    }

    const left = allocator.alloc(usize, n) catch unreachable;
    defer allocator.free(left);
    for (0..n) |i| {
        left[i] = i;
    }

    return bestPath(dists, left, gt);
}

fn gt(a: u32, b: u32) bool {
    return a > b;
}
