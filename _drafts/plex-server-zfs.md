---
layout: post
title: Plex server new ZFS setup
date: 2023-03-30
type: post
description: 
---

## What I'll cover in this post

This is a start to finish guide for taking brand new sealed drives from their packaging to a working ZFS zpool and dataset that's ready to store and serve media files for Plex.

---

## The why

If you're new to ZFS, just know that it's a high-performance file system and volume manager (aka RAID). ZFS is known for its data integrity and protection, easy management, scalability, and efficient storage utilization.

When you have a 10TB+ movie dataset, you're going to want a storage solution to ensures you don't loose your data. RAID isn't a backup, but it is the first line of defense in the fight for data integrity and protection.

As your library grows, you'll have invested 100s hours of your time. Don't trust your data to a single drive.

## Create mediastore/media dataset

If only a small percentage of the files in your dataset are smaller than the 1M record size, it's a reasonable choice to set the record size for your dataset to 1M. This is because the benefits of a larger record size for large files (improved performance) will likely outweigh the potential space inefficiency for small files.

When the record size is set to 1M, ZFS will still allocate space in smaller chunks as needed to store smaller files. However, there may be some space inefficiency due to internal fragmentation, which occurs when the allocated storage blocks are not fully utilized.

It's important to note that ZFS automatically compresses the data when using lz4 compression. This can help save space, even when the record size is set to 1M, as the actual space consumed on disk will be less than the record size for compressible data.

Given the small percentage of small files in a media library dataset, the 1M record size should be a suitable choice in most cases.

---

## Create the pool

This is the name of the zpool.

```
mediastore
```

Determine the device names to use for the zpool. Use this command to list the drives on the system.

```bash
ls -l /dev/disk/by-id/
```

This is the extracted output of that command:

```
scsi-SATA_ST18000NM000J-2T_ZR5D8NYK
scsi-SATA_ST18000NM000J-2T_ZR5DAJ78
scsi-SATA_ST18000NM000J-2T_ZR5DBKFT
scsi-SATA_ST18000NM000J-2T_ZR5DBKKX
scsi-SATA_ST18000NM000J-2T_ZR5DE6AT
scsi-SATA_ST18000NM000J-2T_ZR5DFDM6
```

Use this command to create the zpool.

```
sudo zpool create -o ashift=12 -O compression=lz4 -O dedup=off mediastore raidz2 /dev/disk/by-id/scsi-SATA_ST18000NM000J-2T_ZR5D8NYK /dev/disk/by-id/scsi-SATA_ST18000NM000J-2T_ZR5DAJ78 /dev/disk/by-id/scsi-SATA_ST18000NM000J-2T_ZR5DBKFT /dev/disk/by-id/scsi-SATA_ST18000NM000J-2T_ZR5DBKKX /dev/disk/by-id/scsi-SATA_ST18000NM000J-2T_ZR5DE6AT /dev/disk/by-id/scsi-SATA_ST18000NM000J-2T_ZR5DFDM6
```

## Create the dataset

Create a dataset called `media` within the `mediastore` pool.

```bash
sudo zfs create mediastore/media
```

## Update the dataset settings

Next, apply the recommended settings for large file datasets. These settings will disable file deduplication, enable compression (this might be already set and inherited from the zpool), and increase the record size to better handle large files.

Disable deduplication:

```bash
sudo zfs set dedup=off mediastore/media
```

Enable compression (LZ4 is recommended for its balance of performance and compression ratio):

```bash
sudo zfs set compression=lz4 mediastore/media
```

Set a larger record size, for example, 1MB (this can help improve performance for large files):

```bash
sudo zfs set recordsize=1M mediastore/media
```

Adjust the 'atime' property to 'off' to prevent unnecessary disk writes when files are accessed (this can improve performance):

```bash
sudo zfs set atime=off mediastore/media
```

At this point the `mediastore/media` dataset is created and optimized for storing large files.

It is now ready to use as the storage location for your media server.

## Confirm dataset settings

To display all settings for a specific ZFS dataset, you can use the `zfs get all` command followed by the pool and dataset name.

```bash
sudo zfs get all mediastore/media
```

Below is an example output from this command:

```
$ sudo zfs get all mediastore/media
NAME              PROPERTY              VALUE                  SOURCE
mediastore/media  type                  filesystem             -
mediastore/media  creation              Thu Mar 30 14:31 2023  -
mediastore/media  used                  192K                   -
mediastore/media  available             65.3T                  -
mediastore/media  referenced            192K                   -
mediastore/media  compressratio         1.00x                  -
mediastore/media  mounted               yes                    -
mediastore/media  quota                 none                   default
mediastore/media  reservation           none                   default
mediastore/media  recordsize            1M                     local
mediastore/media  mountpoint            /mediastore/media      default
mediastore/media  sharenfs              off                    default
mediastore/media  checksum              on                     default
mediastore/media  compression           lz4                    local
mediastore/media  atime                 off                    local
mediastore/media  devices               on                     default
mediastore/media  exec                  on                     default
mediastore/media  setuid                on                     default
mediastore/media  readonly              off                    default
mediastore/media  zoned                 off                    default
mediastore/media  snapdir               hidden                 default
mediastore/media  aclmode               discard                default
mediastore/media  aclinherit            restricted             default
mediastore/media  createtxg             24                     -
mediastore/media  canmount              on                     default
mediastore/media  xattr                 on                     default
mediastore/media  copies                1                      default
mediastore/media  version               5                      -
mediastore/media  utf8only              off                    -
mediastore/media  normalization         none                   -
mediastore/media  casesensitivity       sensitive              -
mediastore/media  vscan                 off                    default
mediastore/media  nbmand                off                    default
mediastore/media  sharesmb              off                    default
mediastore/media  refquota              none                   default
mediastore/media  refreservation        none                   default
mediastore/media  guid                  15674777953781949052   -
mediastore/media  primarycache          all                    default
mediastore/media  secondarycache        all                    default
mediastore/media  usedbysnapshots       0B                     -
mediastore/media  usedbydataset         192K                   -
mediastore/media  usedbychildren        0B                     -
mediastore/media  usedbyrefreservation  0B                     -
mediastore/media  logbias               latency                default
mediastore/media  objsetid              518                    -
mediastore/media  dedup                 off                    local
mediastore/media  mlslabel              none                   default
mediastore/media  sync                  standard               default
mediastore/media  dnodesize             legacy                 default
mediastore/media  refcompressratio      1.00x                  -
mediastore/media  written               192K                   -
mediastore/media  logicalused           42K                    -
mediastore/media  logicalreferenced     42K                    -
mediastore/media  volmode               default                default
mediastore/media  filesystem_limit      none                   default
mediastore/media  snapshot_limit        none                   default
mediastore/media  filesystem_count      none                   default
mediastore/media  snapshot_count        none                   default
mediastore/media  snapdev               hidden                 default
mediastore/media  acltype               off                    default
mediastore/media  context               none                   default
mediastore/media  fscontext             none                   default
mediastore/media  defcontext            none                   default
mediastore/media  rootcontext           none                   default
mediastore/media  relatime              off                    default
mediastore/media  redundant_metadata    all                    default
mediastore/media  overlay               on                     default
mediastore/media  encryption            off                    default
mediastore/media  keylocation           none                   default
mediastore/media  keyformat             none                   default
mediastore/media  pbkdf2iters           0                      default
mediastore/media  special_small_blocks  0                      default
```

## Add the dataset to Samba

Add to `/etc/samba/smb.conf`.

```bash
sudo vim /etc/samba/smb.conf
```

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

## Add the dataset to Docker config

Add to `docker-compose.yml`.

```
cd plex
```

```
vim docker-compose.yml
```

```
- "/mediastore/media:/media:rw"
```

## Directory structure

```
mediastore
├── media
│   ├── HD
│   ├── 4K
│   ├── Kids
│   ├── TV
│   ├── Music
```