# AOSP: low-memory killer daemon (`lmkd`)

Source: https://source.android.com/docs/core/perf/lmkd

## Summary

`lmkd` is Android's userspace low-memory killer daemon. Modern Android uses pressure-stall information (PSI) and process importance / `oom_score_adj` to decide when memory pressure has become severe enough to kill processes.

AOSP exposes device-tuning properties including `ro.config.low_ram`; low-RAM devices, including Android Go-class devices, can use different policy from higher-memory devices. The documented Android 11-era strategy explicitly accounts for memory pressure and thrashing, not merely a single free-RAM threshold.

The kill hierarchy matters because a technically available swap or writeback tier does not automatically prevent process death. If Android's userspace policy decides a cached process is the correct victim, that process can still be killed.

## Relevance here

A useful Android Go fork therefore has two coupled pieces:

1. make additional reclaim tiers available, such as zram recompression/writeback;
2. tune process-killing policy so those tiers are actually given a chance to preserve a recently backgrounded application.

A change to zram alone should not be described as a complete multitasking fix.

## Acceptance boundary

Any proposed `lmkd` change needs measurements of pressure, kill events, app-return latency, and PID survival on the physical low-RAM device. A host or emulator run cannot establish the target-device tradeoff between thrashing and preserving cached processes.
