const std = @import("std");

const INPUT = @embedFile("05.txt");

fn isNice1(s: []const u8) bool {
    // At least 3 vowels
    var vowels: usize = 0;
    for (s) |c| {
        if (c == 'a' or c == 'e' or c == 'i' or c == 'o' or c == 'u') {
            vowels += 1;
        }
        if (vowels >= 3) {
            break;
        }
    }
    if (vowels < 3) {
        return false;
    }

    // At least 2 consecutive letters
    for (0..s.len - 1) |i| {
        if (s[i] == s[i + 1]) {
            break;
        }
    } else {
        return false;
    }

    // Does not contain any of the following strings: ab, cd, pq, or xy
    for (0..s.len - 1) |i| {
        for ([_][]const u8{ "ab", "cd", "pq", "xy" }) |bad| {
            if (s[i] == bad[0] and s[i + 1] == bad[1]) {
                return false;
            }
        }
    }

    return true;
}

pub fn part1() usize {
    var lines = std.mem.tokenizeAny(u8, INPUT, "\n\r");
    var count: usize = 0;
    while (lines.next()) |line| {
        if (isNice1(line)) {
            count += 1;
        }
    }

    return count;
}

fn isNice2(s: []const u8) bool {
    // Contains a pair of letters that appears twice without overlaping
    var indices = [_]u8{0} ** (26 * 26); // Use 0 as null value
    for (1..s.len) |i| {
        const j = (@as(usize, s[i]) - 'a') * 26 + (@as(usize, s[i - 1]) - 'a');
        if (indices[j] == 0) {
            indices[j] = @intCast(i);
        }
        // Non-overlapping pairs have a distance of at least 2
        if (i - indices[j] >= 2) {
            break;
        }
    } else {
        return false;
    }

    // Letter repeats with exactly one letter between them
    for (0..s.len - 2) |i| {
        if (s[i] == s[i + 2]) {
            break;
        }
    } else {
        return false;
    }

    return true;
}

pub fn part2() usize {
    var lines = std.mem.tokenizeAny(u8, INPUT, "\n\r");
    var count: usize = 0;
    while (lines.next()) |line| {
        if (isNice2(line)) {
            count += 1;
        }
    }

    return count;
}
