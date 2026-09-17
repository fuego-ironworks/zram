# Linux kernel: zram

Source: https://docs.kernel.org/admin-guide/blockdev/zram.html

## Summary

`zram` creates block devices such as `/dev/zram0` whose contents are compressed and kept in RAM. A common use is swap: a memory page can leave ordinary resident RAM, be compressed into zram, and later be decompressed when accessed again. Compression therefore trades CPU work for a larger effective memory capacity; it does not turn RAM into persistent storage.

The kernel exposes zram configuration and accounting through `/sys/block/zram*`. Important controls include device size, compression algorithm, memory limits, idle tracking, backing device, and writeback limits.

With `CONFIG_ZRAM_WRITEBACK`, zram can evict selected pages from RAM to backing storage. The documented categories include idle pages and poorly compressible pages. Current kernel documentation also describes compressed writeback and batched writeback.

The backing device must be configured before the zram device is initialized. The exact interface and kernel features vary by kernel version, so a target Android kernel must be probed rather than assumed to support the current upstream interface.

## Wear boundary

The kernel documentation explicitly warns that heavy writeback to flash can cause wear. `writeback_limit` and `writeback_limit_enable` exist so userspace can impose a write budget. A phone design that enables backing storage without a bounded write policy is incomplete.

## Relevance here

This is the kernel primitive behind the proposed hierarchy:

```text
RAM -> compressed zram -> bounded backing storage
```

It does not by itself control Android process-killing policy. Android userspace can still kill a cached process even when more swap/writeback capacity exists.
