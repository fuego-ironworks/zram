# Internal flash storage and write wear

Source: https://source.android.com/docs/automotive/flash-wear

Related Android 17 memory-tiering source: https://source.android.com/docs/core/perf/mmd

## Summary

Phone "internal disk" storage is normally NAND flash behind a managed storage interface such as eMMC or UFS. It is different from a removable SD card but still has finite program/erase endurance.

Managed flash performs wear leveling and other translation internally, so rewriting one logical block does not imply repeatedly programming one fixed physical NAND cell. Even so, total writes, write amplification, capacity, workload and controller behavior affect lifetime.

Android's current zram writeback design therefore treats write volume as a policy variable rather than an unlimited resource. The documented `mmd` policy includes a daily writeback budget (24 GiB by default), a maximum amount per writeback round, a free-space floor, and idle-age requirements.

## Repository policy

The current target design uses **internal `/data` backing storage**, never the removable SD card, unless an entirely separate experiment explicitly changes that boundary.

Every writeback experiment must record:

- backing-device type and model;
- bytes written back;
- configured daily/rolling write budget;
- free-space reserve;
- write amplification information when the device exposes it;
- observed performance benefit.

A reduction in application kills is not enough to justify unrestricted storage writes.
