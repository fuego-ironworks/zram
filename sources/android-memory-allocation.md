# Android: memory allocation among processes

Source: https://developer.android.com/topic/performance/memory-management

Related overview: https://developer.android.com/topic/performance/memory-overview

## Summary

Android treats unused RAM as wasted capacity and normally keeps recently used applications resident so returning to them can be fast. The documentation distinguishes ordinary RAM, zRAM, and persistent storage.

Clean file-backed pages can be discarded from RAM because the kernel can read the same bytes from storage again later. Dirty private pages and anonymous pages cannot simply be discarded; under memory pressure the kernel can move/compress them into zRAM. Accessing such a page later causes it to be brought back into ordinary RAM.

When reclaim and zRAM are not enough, Android kills processes. Recently used or foreground-visible processes have greater protection than ordinary cached background processes, but a cached process is never guaranteed to survive.

The application-switching consequence is that two visually identical returns can be very different:

```text
warm return: same process survived and is reused
cold return: old process died; Android reconstructs the Activity in a new process
```

## Version boundary

This Android Developers page describes the traditional model in which persistent storage is not generally used as Linux swap because of flash wear. Android 17+ `mmd` adds an explicit zram writeback path to internal `/data` backing storage. Therefore the older statement must not be generalized to all newer Android memory-management configurations.

## Relevance here

The visible app/task is not the same object as the Linux process. A recents card remaining on screen is not evidence that the old PID or its anonymous memory survived.
