# Staged compression policy

## Objective

The goal is not maximum compression ratio. The goal is to preserve useful process state while keeping interactive return latency low.

A good policy is staged:

```text
hot / actively used page
    -> ordinary RAM

reclaimed page
    -> very fast first-pass compression in zram

page stays cold while the machine is idle
    -> opportunistic denser recompression in zram

page stays cold and RAM pressure remains high
    -> bounded writeback to internal /data backing storage

interactive working set is needed again
    -> prefetch / fault back, with decompression kept off the UI-critical path as much as possible
```

This matches the architecture AOSP documents for Android 17 `mmd`: fast initial compression (the documentation uses LZ4 as the example), later idle-page recompression (zstd is the default secondary algorithm), then optional writeback of sufficiently cold pages to a loop device backed by internal `/data` storage.

Source: https://source.android.com/docs/core/perf/mmd

## The important selection rule

Do not choose a codec from compression ratio alone. Measure the entire return path:

```text
return_cost
  = backing-read latency, if any
  + decompression latency
  + page-fault / kernel bookkeeping
  + scheduler delay
  + time until the app's critical working set is resident
```

Compressed size matters because it changes RAM occupancy and, after writeback, storage I/O. But a smaller representation is a loss if decompression adds visible latency.

Track at least median, p95 and p99 restore latency. Tail latency matters more than a good average when a user taps an app and expects it immediately.

## Candidate codec roles

### LZ4 or similarly fast primary codec

Use for the first reclaim path when compression must be nearly free. AOSP explicitly uses LZ4 as the example fast primary codec in `mmd`, and separately recommends LZ4 for Android kernel/ramdisk compression when decompression speed matters.

References:

- https://source.android.com/docs/core/perf/mmd
- https://source.android.com/docs/core/architecture/kernel/boot-time-opt
- https://github.com/lz4/lz4

### zstd as a denser secondary codec

Use only after a page has stayed idle long enough that extra compression work is worth doing. Android 17 `mmd` defaults `mmd.zram.recompression.algorithm` to `zstd` and describes decompressing a fast LZ4 page and recompressing it with zstd.

Reference: https://github.com/facebook/zstd

The zstd compression level is a policy variable. Do not assume that a high level is better: compression time, resulting size, decompression time, energy and cache effects all belong in the measurement.

### LZO / other kernel-supported zram algorithms

Treat as candidates when the target kernel actually exposes them. The authoritative list for one booted device is `/sys/block/zram0/comp_algorithm`, not a generic list copied from another kernel.

### XZ/LZMA and archive-oriented codecs

Keep available in the broader compression catalog, but do not put them on the interactive zram path merely because they can obtain a high ratio. They need target measurements proving that compression cost and restore/decompression latency satisfy the interactive budget. They are more naturally candidates for durable archival data than for a page that may be touched on the next app switch.

## Opportunistic background recompression

The deeper pass should be deliberately polite:

- run only after data has demonstrated that it is cold;
- run at low scheduling priority;
- yield to foreground work immediately;
- prefer device-idle periods;
- avoid running when battery is low or thermal pressure is high;
- impose a CPU-time/energy budget as well as a memory-saving threshold;
- stop recompressing pages whose expected saving is too small.

AOSP already gives a useful model: its zram maintenance is asynchronous, low-priority work and is normally scheduled with `device idle` and `battery not low` constraints. High-priority prefetch can run before low-priority maintenance.

## GPU recompression is an experiment, not an assumption

Idle GPU time is potentially useful, especially if a codec or transform can process many independent blocks in parallel. But 4 KiB swap pages are small. GPU dispatch, synchronization, data movement, driver wake-up and power-state transitions may cost more than the compression itself.

A GPU path is accepted only if end-to-end measurements beat the CPU path for the same workload while preserving interactive decompression latency and energy constraints. Batch size is part of the experiment: a GPU may make sense for a large cold-page batch even when it is a poor choice for one page.

## Decompression gate

Any codec admitted to an interactive tier needs a decompression contract. The exact numerical budget must come from target measurements, but the rule is simple:

```text
if denser compression causes a user-visible restore regression,
keep the faster representation.
```

This means the representation of a cold page is not final. It can move from fast compression to denser compression and later be prefetched toward RAM as its probability of use rises.

## ComputerScience ownership

The eventual `computer-science` planner should choose among these variants using target facts and measurements rather than hard-coding `LZ4 -> zstd` universally. Inputs include:

- target CPU and optional GPU;
- supported kernel compressors;
- page size and zram implementation;
- compression/decompression throughput and tail latency;
- compression ratio by workload;
- RAM pressure;
- storage read/write latency and endurance budget;
- energy/thermal state;
- probability and timing of reuse.

`isomorphisms/zram` owns the Android/zram implementation experiment. `walnut-burgundy/computer-science` owns the higher-level decision model.
