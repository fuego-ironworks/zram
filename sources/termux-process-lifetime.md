# Termux process/session lifetime

Primary source: https://github.com/termux/termux-app/blob/master/app/src/main/java/com/termux/app/TermuxService.java

Project notes: https://github.com/termux/termux-app

## Summary

Termux separates the terminal UI Activity from the service that owns terminal sessions. `TermuxService` is a foreground service designed so terminal sessions can continue when the Activity is no longer in the foreground or has been destroyed.

Therefore these events are different:

```text
Termux Activity destroyed
Termux application process killed
TermuxService stopped
shell exits
individual child process receives SIGKILL
```

A memory experiment must identify which event occurred instead of calling all of them "Termux closed."

Termux also documents Android 12+ process-management behavior that can kill child/phantom processes. A child exiting with signal 9 is not by itself proof that `lmkd` killed the entire Termux application process.

## Relevance

When comparing Termux and ChatGPT switching, record at least the Termux application/service PID and the important shell/child PIDs. Killing only the Activity may free far less memory than actually stopping the service and its children.
