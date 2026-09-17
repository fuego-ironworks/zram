# Compression codec references

This keeps codec references available to the zram experiment without turning generic benchmark claims into target-specific facts.

## LZ4

Upstream: https://github.com/lz4/lz4

Proposed role: latency-first primary compression. Android 17 `mmd` describes a fast initial zram compressor such as LZ4 before later recompression.

## zstd

Upstream: https://github.com/facebook/zstd

Proposed role: denser secondary compression for pages that have remained cold long enough to justify extra CPU work. Android 17 `mmd` uses zstd as the documented default secondary recompression algorithm.

## LZO and other kernel compressors

Treat these as target-dependent candidates. The authoritative compressor set for one running kernel is the value exposed by `/sys/block/zram0/comp_algorithm`; do not assume another kernel's set.

## XZ / LZMA and other archive-oriented codecs

Keep them in the broader compression catalog, but do not place them on the interactive page-return path without measurements demonstrating acceptable decompression and tail latency. They may be excellent for durable archival data and still be wrong for memory that can be touched on the next app switch.

## Measurement rule

For each codec/level record at least:

- input class and size;
- compressed size;
- compression time and energy;
- decompression median/p95/p99 latency;
- total time to restore a useful application working set;
- CPU/GPU path and batch size;
- thermal state and frequency state;
- target kernel/device revision.

The planner should choose from measurements rather than a universal codec ranking.
