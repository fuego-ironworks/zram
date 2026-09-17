# AOSP: memory management daemon (`mmd`)

Source: https://source.android.com/docs/core/perf/mmd

Reviewed against the page updated 2026-06-17.

## Version boundary

AOSP documents `mmd` for **Android 17 and higher**. It is a current upstream reference design, not evidence that an older Android Go phone already contains these features.

## What `mmd` does

`mmd` centralizes zram setup and ongoing maintenance. `system_server` schedules work and communicates with `mmd` over Binder. Maintenance includes zram recompression, global writeback, and targeted per-process operations.

The documented page lifecycle is roughly:

```text
ordinary RAM
    -> initial zram swap using a fast compressor such as lz4
    -> idle tracking
    -> denser in-RAM recompression, for example zstd
    -> writeback of sufficiently cold pages to backing storage
```

AOSP's backing storage is a loop device backed by a file on **internal `/data`**. This is not a removable SD-card design.

## Per-process writeback and prefetch

When an Activity-hosting process moves into the cached background state, `CachedAppOptimizer` can ask `mmd` to write that process's zram pages back using a `pidfd`. When the application is brought back, Android can ask `mmd` to prefetch the process's swapped pages asynchronously while its UI is starting.

This is especially relevant to a Termux <-> ChatGPT switching experiment because it treats an application process as a unit rather than relying only on undirected global swap behavior.

## Important defaults

The documented defaults include:

- zram size: 50% of device RAM;
- zram writeback: **disabled by default**;
- default writeback backing-device size: 1 GiB;
- minimum remaining free `/data` space: 1.5 GiB;
- idle-page writeback age: dynamically about 20-25 hours by default;
- daily writeback budget: 24 GiB when budget accounting is enabled;
- recompression idle age: roughly 2-4 hours by default;
- maintenance normally requires the device to be idle and battery not low.

Those defaults target general Android behavior. They are not automatically appropriate for a low-RAM phone whose main problem is losing the immediately previous app after only minutes.

## Relevance to an Android Go fork

Rather than inventing a new swap architecture, an older Android Go fork can study/backport the same decomposition:

- kernel support for zram tracking/recompression/writeback;
- bounded `/data` backing storage;
- userspace maintenance policy;
- per-process writeback/prefetch where kernel support permits;
- coordination with ActivityManager and `lmkd`;
- explicit wear and free-space limits.

The backport should preserve the distinction between upstream design and features actually available in the target kernel.
