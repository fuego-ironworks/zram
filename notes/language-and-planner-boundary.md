# Language and planner boundary

The zram experiment is a concrete implementation case for two neighboring projects.

## Idriç

Design note: https://github.com/isomorphisms/Idric/blob/edric-memory-tiering-lowering-note/EDRIC_MEMORY_TIERING.md

Idriç should be able to state the memory policy in semantic terms before exposing zram sysfs, Binder, DEX, native ABI, or machine instructions. The same source-level intent can lower through different target paths.

Example shape:

```text
when memory becomes scarce
    compress cold memory quickly

when machine is idle
    recompress older cold memory more densely
    only when restore remains fast
```

C is one possible lower form, not the definition of the operation. Android framework/controller pieces may lower to DEX; Linux/kernel-facing pieces ultimately require native mechanisms; direct machine-code and GPU paths remain possible where their execution models fit.

## ComputerScience

Architecture note: https://github.com/walnut-burgundy/computer-science/blob/memory-tiering-compression-policy/architecture-search/algorithms/staged-memory-compression.md

ComputerScience should eventually choose among implementation variants from target facts and measurements: compressor set, CPU/GPU behavior, tail decompression latency, memory pressure, reuse probability, storage latency/endurance, and the available Android/kernel interface.

`isomorphisms/zram` supplies the concrete target evidence. It should not encode a universal compiler/planner rule merely because one configuration works on the MIRO A1.
