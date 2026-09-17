# AGENTS.md

## Scope

This repository studies Android memory tiering with RAM, zram, and bounded internal-storage writeback, with low-RAM / Android Go devices as the first target.

## Evidence boundaries

Keep these claims separate:

1. **Upstream documented behavior** — supported by a linked Linux, AOSP, Android, Termux, or application source.
2. **Proposed backport or policy** — a design to test, not a claim that the target device supports it.
3. **Host/emulator evidence** — never upgrade this to physical-device acceptance.
4. **Physical-device evidence** — record device, Android version, kernel, configuration, commands, raw outputs, and writeback counters.

Do not claim that a process survived merely because its task card or Activity was reconstructed. Prefer PID/process evidence.

Do not treat internal storage and removable SD-card storage as interchangeable. The current design explicitly excludes removable SD cards from swap/writeback.

Do not copy entire third-party articles into this repository. Preserve URLs and write our own summaries, with short quotations only when necessary.

For flash-backed writeback, always record or bound write volume. A design without a write budget is incomplete.
