# FOXX / MIRO A1 target dossier

This directory is the target-specific evidence boundary for the Android Go phone used for physical acceptance.

## Directly observed on the physical phone

The following values come from retained physical-phone receipts or terminal output, not from a retail listing:

| Field | Observed value |
| --- | --- |
| Product/model | MIRO A1 / A1 |
| Android release | 14 |
| Android API | 34 |
| Build fingerprint | `MIRO/A1/A1:14/UP1A.231005.007/1736153679:user/release-keys` |
| Primary ABI | `armeabi-v7a` |
| ABI list | `armeabi-v7a,armeabi` |
| 64-bit ABI list | empty |
| Kernel machine | `armv7l` |
| Kernel | `5.15.149-android13-8-g8407b75767d0-dirty` |
| Kernel build stamp from `uname` | `#1 SMP PREEMPT Tue Aug 27 08:10:29 UTC 2024` |
| Page size | 4096 bytes |
| C library observed by native acceptance probe | Bionic |

These facts establish a 32-bit Android userspace/kernel execution target. They do **not** prove that the physical CPU core is an ARMv7-era core.

## ARM / Thumb boundary

For application binaries, the exact established ABI is Android `armeabi-v7a`:

- 32-bit AArch32 process ABI;
- ARMv7-A is the ABI baseline;
- Thumb-2/T32 code is part of the usable ARMv7-A application target;
- pointers are 32-bit in this process ABI.

The likely SoC family uses Cortex-A55 cores, which are newer Arm cores capable of AArch32 execution. Therefore keep two statements separate:

```text
verified operating-system/application target: armv7l + armeabi-v7a
physical CPU microarchitecture: not yet proven by a retained device-side CPU-ID receipt
```

Do not rewrite `armeabi-v7a` as proof that the silicon itself is ARMv7-only.

## Model-level public documentation, not yet a silicon receipt

FOXX's FCC filing identifies the tested device as a Smart Phone, model A1, with MIRO / FOXXD / FOXX trademarks and FCC ID `2AQRM-A1`.

A current MIRO A1 retail specification lists:

- system chip: `SC9863`;
- eight Arm Cortex-A55 cores;
- advertised clock: up to 1.8 GHz;
- RAM: 2 GB;
- internal storage: 32 GB;
- Android 14 Go.

UNISOC's official `SC9863A` page specifies:

- eight Cortex-A55 cores;
- maximum CPU frequency 1.6 GHz;
- PowerVR GE8322 GPU, up to 550 MHz;
- LPDDR3 or LPDDR4/LPDDR4X memory support;
- eMMC 5.1 storage interface.

Because the retail A1 material says `SC9863` and 1.8 GHz while the official UNISOC page is `SC9863A` and 1.6 GHz, this repository does **not** collapse those into one exact device claim. The exact SoC model/revision must come from the phone or an unambiguous board/BOM source.

## Internal storage boundary

The phone has 32 GB of advertised internal storage, but the exact storage package, NAND vendor, NAND geometry and controller revision have not yet been captured from the physical phone.

The SC9863A reference platform documents an **eMMC 5.1** interface. That makes eMMC the leading model-level expectation, but it is not yet promoted to a physical-device fact here. In particular, do not write `UFS` merely because newer phones commonly use UFS.

The collection script in this directory distinguishes the common cases:

- `mmcblk*` plus MMC sysfs identity -> eMMC/SD-style block device;
- SCSI `sd*` devices plus UFS host/sysfs evidence -> UFS;
- storage product/manufacturer fields are retained while unique serial/CID values are omitted by default.

Once the device output is captured, the exact eMMC/UFS package can be looked up against its manufacturer's public datasheet and that specification can be added under `reference/`.

## Evidence levels used here

`physical` means emitted by or executed on this phone.

`model` means a source specifically identifying FOXX/MIRO A1 but not necessarily this individual handset revision.

`platform-reference` means documentation for a candidate SoC/platform. It is useful for planning but cannot silently fill an unknown physical field.

## Primary public sources

- FCC filing and exhibits for FOXX A1: https://fccid.io/2AQRM-A1
- FCC internal photographs, document 7995528: https://fccid.io/2AQRM-A1/Internal-Photos/Internal-Photos-7995528.pdf
- FCC user manual, document 7995529: https://fccid.io/2AQRM-A1/User-Manual/User-manual-7995529
- MIRO A1 retail specification: https://www.newegg.com/miro-a1-5-99-4g-black/p/23B-00MN-00003
- UNISOC SC9863A official specification: https://www.unisoc.com/en/product/SmartPhone/9863A
