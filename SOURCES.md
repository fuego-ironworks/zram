# Source ledger

Retrieved/reviewed 2026-09-17.

| Source | Kind | Why it matters |
| --- | --- | --- |
| https://docs.kernel.org/admin-guide/blockdev/zram.html | Linux kernel documentation | zram compression, backing devices, writeback, write budgets |
| https://developer.android.com/topic/performance/memory-management | Android Developers | RAM/zRAM/storage model, kswapd reclaim, low-memory killing |
| https://developer.android.com/topic/performance/memory-overview | Android Developers | cached-process behavior and app switching |
| https://source.android.com/docs/core/perf/lmkd | AOSP | `lmkd`, PSI, `oom_score_adj`, low-RAM tuning |
| https://source.android.com/docs/core/perf/mmd | AOSP | Android 17+ `mmd`, recompression, per-process writeback/prefetch, `/data` backing |
| https://developer.android.com/guide/components/activities/process-lifecycle | Android Developers | process importance hierarchy and cached-process death/recreation |
| https://developer.android.com/about/versions/14/behavior-changes-all | Android Developers | cached-app execution restrictions and Android-managed process lifecycle |
| https://github.com/termux/termux-app/blob/master/app/src/main/java/com/termux/app/TermuxService.java | Termux source | Termux sessions/service can outlive the Activity |
| https://github.com/termux/termux-app | Termux project documentation | Android 12+ phantom-process and signal-9 warning |
| https://source.android.com/docs/automotive/flash-wear | AOSP | internal flash wear, wear leveling, write-pattern considerations |
| https://help.openai.com/en/articles/8167621-how-can-i-access-my-chat-history-in-the-chatgpt-android-app | OpenAI Help Center | Android chat history is retrievable independently of one app-process lifetime |

Summaries live under `sources/`. Synthesis and proposed work live under `notes/`.
