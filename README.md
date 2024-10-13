# AOC-2015

Fast solutions for Advent of Code 2015 written in Zig!

## Usage

Create the `src/dd.txt` file containing your input, where `dd` is the day number (e.g. `src/01.txt` for day 1).

Then, run this command in the base directory:

```bash
zig build run -Dday=dd
```

To run all days, run:

```bash
zig build run
```

The program runs in debug mode by default. To optimize for speed, add the `-Doptimize=ReleaseFast` flag.

## Timings

- Compiler: Zig 0.13.0
- Optimize mode: ReleaseFast
- CPU: Intel i7-8700

```txt
Day  1 Part 1:        +74 | Time: 0ns
Day  1 Part 1:        +74 | Time: 0ns
Day  1 Part 2:       1795 | Time: 0ns
Day  1 Part 2:       1795 | Time: 0ns
Day  2 Part 1:    1606483 | Time: 0ns
Day  2 Part 2:    3842356 | Time: 0ns
Day  3 Part 1:       2081 | Time: 0ns
Day  3 Part 2:       2341 | Time: 1.059ms
Day  4 Part 1:     254575 | Time: 28.708ms
Day  4 Part 2:    1038736 | Time: 106.523ms
Day  5 Part 1:        238 | Time: 0ns
Day  5 Part 2:         69 | Time: 0ns
Day  6 Part 1:     543903 | Time: 0ns
Day  6 Part 2:   14687245 | Time: 1.506ms
Day  7 Part 1:      16076 | Time: 0ns
Day  7 Part 2:       2797 | Time: 0ns
Day  8 Part 1:       1350 | Time: 0ns
Day  8 Part 2:       2085 | Time: 0ns
Day  9 Part 1:        207 | Time: 0ns
Day  9 Part 2:        804 | Time: 0ns
Day 10 Part 1:     329356 | Time: 850.5us
Day 10 Part 2:    4666278 | Time: 151.132ms
Day 11 Part 1:   hepxxyzz | Time: 0ns
Day 11 Part 2:   heqaabcc | Time: 0ns
Day 12 Part 1:    +191164 | Time: 0ns
Day 12 Part 2:     +87842 | Time: 0ns
Total Time: 289.78ms
```
