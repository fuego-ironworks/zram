# zram

Research and implementation notes for Android memory tiering, especially low-RAM / Android Go devices.

The immediate use case is preserving recently backgrounded applications during frequent app switching without using removable SD-card storage as swap.

Working hierarchy:

```text
hot pages                -> ordinary RAM
recently cold pages      -> zram (compressed RAM)
older / pressured pages  -> bounded writeback on internal /data storage
last resort              -> process kill
```

This repository is source-first. `sources/` summarizes upstream documentation and source code; `notes/` records synthesis and proposed experiments. Do not treat proposed Android Go backports as device acceptance until measured on an actual target.
