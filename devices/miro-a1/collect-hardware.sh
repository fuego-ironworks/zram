#!/system/bin/sh
# Capture hardware/memory identity for the physical FOXX/MIRO A1 without root.
#
# The output intentionally omits IMEI, Android ID, device serial number, SIM data,
# Wi-Fi/Bluetooth addresses, and full eMMC CID/serial values. It is meant to
# identify the hardware and memory/storage implementation, not the individual
# handset.

set -u

out=${1:-miro-a1-hardware.txt}
: > "$out"

section() {
    printf '\n===== %s =====\n' "$1" >> "$out"
}

emit_prop() {
    key=$1
    value=$(getprop "$key" 2>/dev/null || true)
    printf '%s\t%s\n' "$key" "$value" >> "$out"
}

emit_file() {
    path=$1
    if [ -r "$path" ]; then
        printf '\n--- %s ---\n' "$path" >> "$out"
        cat "$path" >> "$out" 2>/dev/null || true
        printf '\n' >> "$out"
    fi
}

emit_one_line_file() {
    label=$1
    path=$2
    if [ -r "$path" ]; then
        value=$(tr -d '\000' < "$path" 2>/dev/null || true)
        printf '%s\t%s\n' "$label" "$value" >> "$out"
    fi
}

section identity
for key in \
    ro.product.manufacturer \
    ro.product.brand \
    ro.product.model \
    ro.product.device \
    ro.product.board \
    ro.board.platform \
    ro.hardware \
    ro.boot.hardware \
    ro.soc.manufacturer \
    ro.soc.model \
    ro.build.version.release \
    ro.build.version.sdk \
    ro.build.version.security_patch \
    ro.build.fingerprint \
    ro.vendor.build.fingerprint \
    ro.product.cpu.abi \
    ro.product.cpu.abilist \
    ro.product.cpu.abilist32 \
    ro.product.cpu.abilist64 \
    ro.opengles.version \
    ro.hardware.egl \
    ro.boot.boot_devices \
    ro.boot.bootdevice
do
    emit_prop "$key"
done

printf 'uname\t' >> "$out"
uname -a >> "$out" 2>/dev/null || true
printf 'machine\t' >> "$out"
uname -m >> "$out" 2>/dev/null || true
printf 'page_size\t' >> "$out"
getconf PAGESIZE >> "$out" 2>/dev/null || true

section device_tree
emit_one_line_file model /sys/firmware/devicetree/base/model
emit_one_line_file compatible /sys/firmware/devicetree/base/compatible
emit_one_line_file root_model /proc/device-tree/model
emit_one_line_file root_compatible /proc/device-tree/compatible

section cpuinfo
emit_file /proc/cpuinfo

section cpu_topology_and_frequency
for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
    [ -d "$cpu" ] || continue
    name=$(basename "$cpu")
    printf '\n[%s]\n' "$name" >> "$out"
    for rel in \
        topology/core_id \
        topology/physical_package_id \
        cpufreq/cpuinfo_min_freq \
        cpufreq/cpuinfo_max_freq \
        cpufreq/scaling_min_freq \
        cpufreq/scaling_max_freq \
        cpufreq/scaling_cur_freq \
        cpufreq/scaling_available_frequencies \
        cpu_capacity
    do
        path="$cpu/$rel"
        [ -r "$path" ] || continue
        value=$(cat "$path" 2>/dev/null || true)
        printf '%s\t%s\n' "$rel" "$value" >> "$out"
    done
done

section memory
emit_file /proc/meminfo
emit_file /proc/swaps

section zram
if [ -d /sys/block/zram0 ]; then
    for rel in \
        comp_algorithm \
        disksize \
        mem_limit \
        mem_used_max \
        mm_stat \
        bd_stat \
        backing_dev \
        writeback_limit \
        writeback_limit_enable \
        idle \
        max_comp_streams \
        debug_stat
    do
        emit_one_line_file "$rel" "/sys/block/zram0/$rel"
    done
else
    printf 'zram0\tABSENT\n' >> "$out"
fi

section block_devices
for block in /sys/block/*; do
    [ -d "$block" ] || continue
    b=$(basename "$block")
    printf '\n[%s]\n' "$b" >> "$out"
    for rel in \
        size \
        queue/logical_block_size \
        queue/physical_block_size \
        queue/minimum_io_size \
        queue/optimal_io_size \
        queue/rotational \
        device/type \
        device/vendor \
        device/model \
        device/rev
    do
        path="$block/$rel"
        [ -r "$path" ] || continue
        value=$(tr -d '\000' < "$path" 2>/dev/null || true)
        printf '%s\t%s\n' "$rel" "$value" >> "$out"
    done
done

section emmc_mmc_identity
for dev in /sys/block/mmcblk*/device; do
    [ -d "$dev" ] || continue
    printf '\n[%s]\n' "${dev%/device}" >> "$out"
    for field in \
        type \
        name \
        manfid \
        oemid \
        date \
        fwrev \
        hwrev \
        erase_size \
        preferred_erase_size \
        rel_sectors \
        ocr
    do
        path="$dev/$field"
        [ -r "$path" ] || continue
        value=$(cat "$path" 2>/dev/null || true)
        printf '%s\t%s\n' "$field" "$value" >> "$out"
    done
    # Do not dump `cid` or serial: they can uniquely identify this handset.
done

section ufs_scsi_identity
for block in /sys/block/sd*; do
    [ -d "$block" ] || continue
    printf '\n[%s]\n' "$(basename "$block")" >> "$out"
    for rel in device/vendor device/model device/rev device/type; do
        path="$block/$rel"
        [ -r "$path" ] || continue
        value=$(tr -d '\000' < "$path" 2>/dev/null || true)
        printf '%s\t%s\n' "$rel" "$value" >> "$out"
    done
done

# Presence of these paths is useful even if ordinary app/Termux permissions do
# not allow their contents to be read.
printf '\nufs_sysfs_paths\n' >> "$out"
for path in /sys/class/ufs /sys/bus/platform/drivers/ufshcd /sys/bus/platform/drivers/*ufs*; do
    [ -e "$path" ] || continue
    ls -ld "$path" >> "$out" 2>/dev/null || true
done

section kernel_memory_features
if [ -r /proc/config.gz ]; then
    zcat /proc/config.gz 2>/dev/null | grep -E \
        '^(CONFIG_(SWAP|ZRAM|ZSMALLOC|ZPOOL|ZBUD|Z3FOLD|PSI|MEMCG|LZ4|LZO|ZSTD|CRYPTO_LZ4|CRYPTO_LZO|CRYPTO_ZSTD)|# CONFIG_(ZRAM|SWAP|PSI|MEMCG).*not set)' \
        >> "$out" || true
else
    printf '/proc/config.gz\tUNREADABLE_OR_ABSENT\n' >> "$out"
fi

section android_memory_properties
getprop 2>/dev/null | grep -E \
    '(^\[ro\.config\.low_ram\]|zram|lmk|mmd|swap|cached_apps_freezer)' \
    >> "$out" || true

section mounts_and_data_backing
# Keep only filesystem/block-device relationships; avoid application-specific
# package paths and user data directory listings.
mount 2>/dev/null | grep -E ' on /(data|metadata|cache|system|vendor|product)( |/)' >> "$out" || true

section checksums
printf 'receipt_file\t%s\n' "$out" >> "$out"

printf 'wrote %s\n' "$out"
sha256sum "$out" 2>/dev/null || true
