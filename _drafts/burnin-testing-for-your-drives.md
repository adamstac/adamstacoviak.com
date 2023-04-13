---
title: Burn-in testing for your drives
date: 2023-03-27
type: post
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

1. `-b 4096`: Sets the block size to 4096 bytes.
2. `-w`: Enables the write-mode test, which is a destructive test. It writes 4 predefined data patterns in sequence to each block on the device and then reads the data back, verifying that the data was correctly written.
3. `-s`: Shows the progress of the test.
4. `-v`: Enables verbose output mode, providing additional information about the test.

The predefined patterns used in the write-mode test are:

1. 0xaa (10101010)
2. 0x55 (01010101)
3. 0xff (11111111)
4. 0x00 (00000000)

These patterns are written and read back in sequence. The last pattern (0x00) effectively zeroes out the drive.

### Time required

The time required to complete a destructive write test using `badblocks` depends on several factors, such as the drive's performance, its connection interface, and the system's overall workload. It's difficult to give an exact time estimate, but we can provide a rough approximation.

Assuming a conservative average write speed of 100 MB/s for a modern hard drive, you can calculate the estimated time as follows:

1.  Convert 18 TB to MB: 18 TB * 1024 GB/TB * 1024 MB/GB = 18,874,368 MB
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

## Create the zpool

This is the name of the zpool.

```
mediastore
```

OR...

```
mediapool
```

Determine the device names to use for the zpool. Use this command to list the drives on the system.

```bash
ls -l /dev/disk/by-id/
```

Use this command to create the zpool.

```
sudo zpool create -o ashift=12 -O compression=lz4 -O dedup=off mediastore mirror /dev/disk/by-id/[drive1] /dev/disk/by-id/[drive2] mirror /dev/disk/by-id/[drive3] /dev/disk/by-id/[drive4] mirror /dev/disk/by-id/[drive5] /dev/disk/by-id/[drive6]
```

Add to `/etc/samba/smb.conf`.

```
[MEDIA]
    comment = MEDIA dataset
    path = /mediastore/media
    browseable = yes
    writeable = yes
    readonly = no
    guest ok = no
    valid users = adamstacoviak
    force user = adamstacoviak
    force group = adamstacoviak
```

Add to `docker-compose.yml`.

```
- "/media-mirror/media:/media:rw"
```