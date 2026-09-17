# Android process lifecycle

Source: https://developer.android.com/guide/components/activities/process-lifecycle

## Summary

Android gives a process an importance level based on the components it hosts. Foreground and visible work are strongly protected; cached processes exist largely so returning to a recently used app can be fast and are deliberately expendable when memory is needed.

A cached process can contain stopped Activities. Android can kill that process without running `onDestroy()`. A later return can create a new process and reconstruct the Activity from saved/durable state.

This is why an Android task/recents card is not a process-liveness receipt. For memory-tiering experiments use a PID before and after the switch.

## Relevance

The zram experiment should distinguish:

- same PID, mostly resident;
- same PID, pages restored from zram/writeback;
- different PID, application reconstructed after process death.

Only the second category demonstrates the behavior we are trying to improve with deeper memory tiering.
