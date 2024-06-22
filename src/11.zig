const std = @import("std");
const Allocator = std.mem.Allocator;
const assert = std.debug.assert;

pub fn part1(input: []const u8) [8]u8 {
    assert(input.len == 8);
    return nextPassword(input[0..8].*);
}

pub fn part2(input: []const u8) [8]u8 {
    assert(input.len == 8);
    return nextPassword(nextPassword(input[0..8].*));
}

fn nextPassword(password: [8]u8) [8]u8 {
    var pass = incrementDigit(password[0..8].*, password.len - 1);
    while (true) {
        // Passwords must not contain i, o or l
        for (0..pass.len) |i| {
            switch (pass[i]) {
                'i', 'o', 'l' => {
                    pass = incrementDigit(pass, i);
                    continue;
                },
                else => {},
            }
        }

        // Passwords must contain at least 2 different, non-overlapping pairs of letters
        var paired_letter: ?u8 = null;
        for (0..pass.len - 1) |i| {
            if (pass[i] == paired_letter) {
                continue;
            }

            if (pass[i] == pass[i + 1]) {
                if (paired_letter == null) {
                    paired_letter = pass[i];
                } else {
                    break;
                }
            }
        } else {
            if (pass[pass.len - 2] < pass[pass.len - 1]) {
                pass[pass.len - 2] = pass[pass.len - 1];
            } else if (pass[pass.len - 2] > pass[pass.len - 1]) {
                pass[pass.len - 1] = pass[pass.len - 2];
            } else {
                pass = incrementDigit(pass, pass.len - 2);
            }
            continue;
        }

        // Passwords must include an increasing string of at least three letters
        for (0..pass.len - 2) |i| {
            if (pass[i] + 1 == pass[i + 1] and pass[i + 1] + 1 == pass[i + 2]) {
                break;
            }
        } else {
            pass = incrementDigit(pass, pass.len - 1);
            continue;
        }

        // All conditions are satisfied
        break;
    }
    return pass;
}

fn incrementDigit(password: [8]u8, digit: usize) [8]u8 {
    assert(digit < 8);

    if (password[digit] == 'z') {
        assert(digit > 0);
        return incrementDigit(password, digit - 1);
    }

    var result = password;
    result[digit] += 1;
    @memset(result[digit + 1 ..], 'a');
    return result;
}
