const std = @import("std");
const Md5 = std.crypto.hash.Md5;

pub fn part1(input: []const u8) usize {
    var str: [32]u8 = undefined;
    @memcpy(str[0..input.len], input);
    var i: usize = 1;
    while (true) : (i += 1) {
        const num_len = (std.fmt.bufPrint(str[input.len..], "{d}", .{i}) catch unreachable).len;
        var hash: [Md5.digest_length]u8 = undefined;
        Md5.hash(str[0 .. input.len + num_len], &hash, .{});

        if (hash[0] == 0 and hash[1] == 0 and hash[2] & 0xF0 == 0) {
            return i;
        }
    }
    unreachable;
}

pub fn part2(input: []const u8) usize {
    var str: [32]u8 = undefined;
    @memcpy(str[0..input.len], input);
    var i: usize = 1;
    while (true) : (i += 1) {
        const num_len = (std.fmt.bufPrint(str[input.len..], "{d}", .{i}) catch unreachable).len;
        var hash: [Md5.digest_length]u8 = undefined;
        Md5.hash(str[0 .. input.len + num_len], &hash, .{});

        if (hash[0] == 0 and hash[1] == 0 and hash[2] == 0) {
            return i;
        }
    }
    unreachable;
}
