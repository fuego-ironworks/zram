# MIRO A1 public specification mirror

This is a text mirror of the parts of public documents that matter to the memory-tiering work. It does not reproduce entire third-party PDFs.

## FCC identity

FCC equipment ID: `2AQRM-A1`

Applicant/manufacturer in FCC test reports: FOXX Development Inc.

Product: Smart Phone

Model/type reference: A1

Trade marks listed by the test report: MIRO, FOXXD, FOXX.

The Wi-Fi test report identifies the tested A1 sample as `TCT241128E021-0101`, issued 2024-12-25 after testing from 2024-11-29 through 2024-12-24.

Primary filing index: https://fccid.io/2AQRM-A1

## Public FCC artifacts retained by reference

### Internal photographs

Document ID: `7995528`

Direct PDF: https://fccid.io/2AQRM-A1/Internal-Photos/Internal-Photos-7995528.pdf

Pages: 5

Reported file SHA-256: `16c614721336c127c5d624af55e38b2621451641ed5c752b843848a0c5386c08`

The photographs show the A1 enclosure, removable battery, main board, shielded/unshielded board sides and component packages. They are useful as a board-level cross-check, but this repository does not infer an unreadable chip marking from a low-resolution rendering.

### User manual

Document ID: `7995529`

Index: https://fccid.io/2AQRM-A1/User-Manual/User-manual-7995529

Reported file SHA-256: `8995f5ec44fedc20acc0cab394c5fdfdecc76976c18e3ebff5b382ac26b863e1`

### 2.4 GHz Wi-Fi test report

Document ID: `7995534`

Direct mirror: https://device.report/m/26dc8fdfe021a84bcf6ae2e4680b24352183b5b29dde8897d0e2f03792aef689.pdf

Pages: 66

File identity from the public mirror/FCC record: `26dc8fdfe021a84bcf6ae2e4680b24352183b5b29dde8897d0e2f03792aef689`

Report number: `TCT241128E023`

The report verifies model A1 and FOXX/MIRO identity. It is radio-compliance evidence, not a CPU or storage datasheet.

### Bluetooth LE test report

Document ID: `7995533`

Mirror: https://device.report/m/f49e0233a0290a72ba26bd49dafc79c7fcda569dce575b6dc2b6082b50bb421e.pdf

Reported file SHA-256: `f49e0233a0290a72ba26bd49dafc79c7fcda569dce575b6dc2b6082b50bb421e`

## A1 product-level hardware listing

A MIRO A1 listing sold by Foxx reports:

- Android 14 Go;
- 5.99 inch 576x1152 IPS display;
- 2 GB RAM;
- 32 GB internal storage;
- system chip `SC9863`;
- eight Arm Cortex-A55 CPU cores;
- advertised frequency up to 1.8 GHz;
- removable approximately 3000 mAh battery;
- Wi-Fi 802.11 b/g/n and Bluetooth 4.2.

Source: https://www.newegg.com/miro-a1-5-99-4g-black/p/23B-00MN-00003

This is model-level evidence. The physical phone's exact silicon revision remains subject to device-side confirmation.

## SC9863A platform reference

UNISOC's official SC9863A page reports:

- CPU: Arm Cortex-A55;
- cores: 8;
- maximum CPU frequency: 1.6 GHz;
- process: 28 nm HPC+ / 22 nm listing;
- GPU: Imagination PowerVR GE8322;
- maximum GPU frequency: 550 MHz;
- RAM interfaces: LPDDR3, LPDDR4/LPDDR4X;
- storage interface: eMMC 5.1;
- Wi-Fi: b/g/n;
- Bluetooth: 4.2.

Source: https://www.unisoc.com/en/product/SmartPhone/9863A

Do not silently rewrite the A1 listing's `SC9863` to `SC9863A`. The official page is retained as the leading platform reference because the public specifications line up closely, but the exact SoC string needs a physical-device or unambiguous board/BOM receipt.

## Why the storage distinction matters

`32 GB internal storage` describes capacity, not protocol or NAND package. The SC9863A platform reference says eMMC 5.1, which would normally mean a managed NAND package combining NAND and an eMMC controller. It is not UFS. But this repository waits for the phone's `/sys/block` identity before asserting eMMC for the individual handset.

Once a physical receipt supplies the eMMC manufacturer ID/product name or a UFS vendor/model, add the manufacturer's exact device datasheet here and record its public hash/source.
