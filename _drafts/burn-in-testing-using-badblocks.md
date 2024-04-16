---
layout: post
title: Burn-in testing using badblocks
slug: burn-in-testing-using-badblocks
date: 2024-04-16 09:00:00+00:00
type: post
description:
---

## The command

This command performs 4 complete write and read cycles across the entire drive in write-mode test (`-w`), with the last write pass zeroing out the drive.

```bash
badblocks -b 4096 -wsv /dev/sdX
```

In my specific case, I used this command because I needed to get around the "must be 32-bit value" error which might have a limitation on handling large drives (greater than 2 TiB).

```bash
sudo badblocks -b 65536 -wsv -o badblocks_sda.log /dev/sda
```

Here's the breakdown of the command:

1.  `-b 4096`: Sets the block size to 4096 bytes.
2.  `-w`: Enables the write-mode test, which is a destructive test. It writes 4 predefined data patterns in sequence to each block on the device and then reads the data back, verifying that the data was correctly written.
3.  `-s`: Shows the progress of the test.
4.  `-v`: Enables verbose output mode, providing additional information about the test.

The predefined patterns used in the write-mode test are:

1.  0xaa (10101010)
2.  0x55 (01010101)
3.  0xff (11111111)
4.  0x00 (00000000)

These patterns are written and read back in sequence. The last pattern (0x00) effectively zeroes out the drive.

### Time required

The time required to complete a destructive write test using `badblocks` depends on several factors, such as the drive's performance, its connection interface, and the system's overall workload. It's difficult to give an exact time estimate, but we can provide a rough approximation.

Assuming a conservative average write speed of 100 MB/s for a modern hard drive, you can calculate the estimated time as follows:

1.  Convert 18 TB to MB: 18 TB _ 1024 GB/TB _ 1024 MB/GB = 18,874,368 MB
2.  Calculate the time: 18,874,368 MB / 100 MB/s = 188,743.68 seconds
3.  Convert seconds to hours: 188,743.68 seconds / 3600 seconds/hour ≈ 52.43 hours

Based on this rough estimation, the test would take approximately 52 hours to complete. However, this is just an approximation, and the actual time may be longer or shorter depending on the specific drive and system conditions. Keep in mind that the test involves both writing and reading, and the performance of these operations might differ, so it is better to allow for some extra time when planning the test.

Based on the following drive list:

```
sdg
sdh
sdi
sdj
sdk
sdl
```

Here are the `badblocks` commands with the `-o` option for logging bad blocks. Run these commands in separate tabs or terminal sessions on the remote machine.

#### /dev/sda

```bash
sudo badblocks -b 65536 -wsv -o badblocks_sda.log /dev/sda
```

```bash
watch -n 60 "sudo smartctl -A /dev/sda | grep Temperature_Celsius"
```

#### /dev/sdb

```bash
sudo badblocks -b 65536 -wsv -o badblocks_sdb.log /dev/sdb
```

```bash
watch -n 60 "sudo smartctl -A /dev/sdb | grep Temperature_Celsius"
```

#### /dev/sdc

```bash
sudo badblocks -b 65536 -wsv -o badblocks_sdc.log /dev/sdc
```

```bash
watch -n 60 "sudo smartctl -A /dev/sdc | grep Temperature_Celsius"
```

#### /dev/sdd

```bash
sudo badblocks -b 65536 -wsv -o badblocks_sdd.log /dev/sdd
```

```bash
watch -n 60 "sudo smartctl -A /dev/sdd | grep Temperature_Celsius"
```

#### /dev/sde

```bash
sudo badblocks -b 65536 -wsv -o badblocks_sde.log /dev/sde
```

```bash
watch -n 60 "sudo smartctl -A /dev/sde | grep Temperature_Celsius"
```

#### /dev/sdf

```bash
sudo badblocks -b 65536 -wsv -o badblocks_sdf.log /dev/sdf
```

```bash
watch -n 60 "sudo smartctl -A /dev/sdf | grep Temperature_Celsius"
```

---

```bash
badblocks -b 4096 -wsv -t 1 -p 0xAA /dev/sdX && badblocks -b 4096 -wsv -t 1 -p 0xFF /dev/sdX && badblocks -b 4096 -wsv -t 1 -p 0x00 /dev/sdX
```

This command performs two passes of the `badblocks` command, each with a different write pattern, to test the block device `/dev/sdX`. Here is a breakdown of what each part of the command does:

- `badblocks`: This is the command-line utility for testing block devices for bad blocks or disk errors.
- `-b 4096`: This option specifies the block size to use for the test. In this case, the block size is set to 4096 bytes.
- `-wsv`: This option tells `badblocks` to write a known pattern to each block before reading it, show progress during the test, and perform a non-destructive read-write test.
- `-t 1`: This option specifies that `badblocks` should perform a single pass of the read-write test.
- `-p 0xAA`: This option specifies the write pattern to use for the test. In this case, the pattern is 0xAA. This pattern is also known as the "walking 1's" pattern because it consists of a sequence of alternating 1's and 0's that "walk" across the data. This pattern is useful for testing a drive's ability to detect and correct errors, as well as its ability to distinguish between different data patterns.
- `-p 0xFF`: This option specifies the write pattern to use for the test. In this case, the pattern is 0xFF. This pattern consists of all 1's and is useful for testing a drive's ability to write and read data reliably at high speeds. Because all bits are set to 1, the drive will need to be able to write and read data without errors across all bits and at a high rate of speed.
- `/dev/sdX`: This specifies the block device to test. Replace `X` with the appropriate letter for the device you want to test.
- `&&`: This is the logical "and" operator, which allows you to chain multiple commands together so that the next command only runs if the previous one succeeds.

The command is run two times, each time with a different pattern:

1.  `badblocks -b 4096 -wsv -t 1 -p 0xAA /dev/sdX`: This writes the walking 1's pattern (0xAA) to each block on the device and then reads it back to check for errors.
2.  `badblocks -b 4096 -wsv -t 1 -p 0xFF /dev/sdX`: This writes the all-ones pattern (0xFF) to each block on the device and then reads it back to check for errors.
3.  Optional! `badblocks -b 4096 -wsv -t 1 -p 0x00 /dev/sdX`: This writes zeros (0x00) to each block on the device and then reads it back to check for errors.

By running the `badblocks` command with these three patterns, the command is able to test the device's ability to read and write data accurately with different types of data patterns. This can help identify any issues with the device, such as bad blocks or other errors, and ensure that the device is functioning correctly before use.

If your plan is to add the drive to a ZFS pool after the test, there is no need to zero it out beforehand. When you add a new drive to a ZFS pool, ZFS will automatically initialize the drive with zeros, so any existing data on the drive will be overwritten.

## Time estimated

If I ran this command on a 12TB hard drive how long can I expect this test to take to complete

```bash
badblocks -b 4096 -wsv -t 1 -p 0xAA /dev/sdX && badblocks -b 4096 -wsv -t 1 -p 0xFF /dev/sdX
```

The time it takes to complete a `badblocks` test with the command you provided depends on several factors, including the size and speed of the drive being tested, the computer's hardware, and the load on the system during the test.

As a rough estimate, you can use the following formula to calculate the time it will take to perform a read-write test on a drive using `badblocks`:

`time = (blocks ÷ rate) × passes`

Where:

- `blocks` is the total number of blocks on the drive.
- `rate` is the speed of the drive in blocks per second (B/s).
- `passes` is the number of test passes you are running.

For example, a 12TB drive has approximately 2.8 billion blocks (12 x 1024 x 1024 x 1024 ÷ 4096), assuming the blocks are 4096 bytes each. Let's assume the drive has a sustained write speed of 200 MB/s, which translates to 51,200 blocks per second (200 MB/s ÷ 4096 bytes/block). If you are running three passes of the `badblocks` command as in your example, the estimated time to complete the test would be:

`time = (2.8 billion ÷ 51,200) × 3` `time = 163,840 seconds` `time = 45.5 hours`

So, with these assumptions, the test would take approximately 45.5 hours to complete. However, keep in mind that this is a rough estimate, and the actual time could be longer or shorter depending on various factors. It's always a good idea to monitor the progress of the test and adjust your expectations accordingly.
