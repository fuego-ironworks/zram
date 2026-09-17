# Android app switching and process lifetime

## Three different objects

What appears to the user as one app window is at least three things:

1. the Android task / Activity state used to represent the visible UI;
2. the Linux process and its virtual memory;
3. durable state such as files, databases, and server-side conversation history.

They do not have the same lifetime.

A recent-task card can remain visible after the old process has been killed. When the user returns, Android can create a new process and reconstruct the Activity. Therefore a recents card is not evidence that a PID survived.

Source: https://developer.android.com/guide/components/activities/process-lifecycle

## Warm versus cold return

```text
warm return:
  app PID survives
  -> pages may still be resident or may fault/decompress back from zram
  -> Activity resumes

cold return:
  app PID is killed under memory pressure
  -> user returns
  -> Android starts a new PID
  -> Activity and application state are reconstructed from durable/saved state
```

The proposed zram work is intended to increase the fraction of useful app switches that remain in the first category without creating unacceptable thrashing.

## Memory pressure path

Android and Linux can reclaim memory in several qualitatively different ways:

- clean file-backed pages can be discarded and read again later;
- anonymous/private pages can be compressed into zram;
- newer Android designs can further recompress cold zram pages and optionally write them to backing storage;
- Android can finally kill cached processes through `lmkd` / ActivityManager policy.

Adding writeback capacity is not sufficient if the Android userspace kill policy still selects the process first. zram policy and `lmkd` policy therefore have to be evaluated together.

References:

- https://developer.android.com/topic/performance/memory-management
- https://source.android.com/docs/core/perf/lmkd
- https://source.android.com/docs/core/perf/mmd

## Termux is a special case

The Termux UI Activity and the terminal sessions are not identical. Termux keeps sessions in `TermuxService`, a foreground service intended to allow terminal sessions to survive the UI Activity. Closing or losing only the Activity can therefore free some UI memory while shells and their child processes remain alive.

Source: https://github.com/termux/termux-app/blob/master/app/src/main/java/com/termux/app/TermuxService.java

Modern Android can also impose restrictions on Termux child processes. A signal-9 child-process death must not be confused with Activity destruction or with `lmkd` killing the whole Termux application process.

Source: https://github.com/termux/termux-app

## What to measure on the MIRO A1

A useful app-switch experiment records:

- ChatGPT PID before leaving and after returning;
- Termux Activity PID, TermuxService PID, and important child PIDs;
- `/proc/meminfo` and `/proc/swaps`;
- zram `mm_stat`, `bd_stat`, compressor, and size;
- `lmkd`/ActivityManager kill logs;
- major/minor page faults if accessible;
- elapsed time from tap to responsive UI;
- whether the returned app was a warm or cold start;
- backing-storage bytes read/written if writeback is enabled.

The desired result is not merely fewer kills. It is fewer disruptive cold starts without making ordinary app switching slower.
