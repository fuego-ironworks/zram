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

These facts establish a 32-bit Android userspace execution target. They do **not** prove that the physical CPU core is an ARMv7-era core.

## ARM / Thumb boundary

For application binaries, the exact established Android ABI is `armeabi-v7a`:

- 32-bit AArch32 process ABI;
- ARMv7-A is the compatibility/baseline architecture associated with the ABI;
- Thumb-2/T32 is part of the ABI's supported instruction-set surface;
- pointers are 32-bit in this process ABI.

Current Android NDK documentation lists `armeabi-v7a` as the 32-bit Arm ABI and includes Thumb-2. Historical NDK documentation makes the compatibility baseline explicit as ARMv7-A + Thumb-2 + VFPv3-D16, with additional extensions depending on NDK generation and target assumptions.

Sources:

- https://developer.android.com/ndk/guides/abis
- https://android.googlesource.com/platform/ndk/+/26f2392/docs/CPU-ARCH-ABIS.html

The public MIRO A1 listing says the model uses Cortex-A55 cores. Arm documents Cortex-A55 as an **Armv8.2-A** core, and its technical reference manual documents AArch32 A32 and T32 support. Therefore, if the physical SoC is confirmed to match that model-level listing, the useful description is:

```text
physical core architecture: Armv8.2-A Cortex-A55
executed Android ABI:       32-bit armeabi-v7a
native code forms:          A32 and Thumb-2/T32
```

That is not contradictory: a newer Arm core can run a 32-bit ARMv7-compatible Android ABI.

Until the physical CPU identification is captured, preserve the narrower verified statement:

```text
verified operating-system/application target: armv7l + armeabi-v7a
physical CPU microarchitecture: not yet proven by a retained device-side CPU-ID receipt
```

Arm Cortex-A55 reference:
https://documentation-service.arm.com/static/5e7e1405b471823cb9de57ae

## Model-level public documentation, not yet a silicon receipt

FOXX's FCC filing identifies the tested device as a Smart Phone, model A1, FCC ID `2AQRM-A1`. The public radio test reports use sample number `TCT241128E021-0101`.

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

Because the retail A1 material says `SC9863` and 1.8 GHz while the official UNISOC page is `SC9863A` and 1.6 GHz, this repository does **not** collapse those into one exact physical-device claim. The exact SoC model/revision must come from the phone or an unambiguous board/BOM source.

The FCC internal-photo exhibit shows the main board and packages, but the available public rendering is not used here to guess chip markings that are not reliably legible.

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
- FCC Wi-Fi test report mirror, report `TCT241128E023`: https://device.report/m/26dc8fdfe021a84bcf6ae2e4680b24352183b5b29dde8897d0e2f03792aef689
- MIRO A1 retail specification: https://www.newegg.com/miro-a1-5-99-4g-black/p/23B-00MN-00003
- UNISOC SC9863A official specification: https://www.unisoc.com/en/product/SmartPhone/9863A
