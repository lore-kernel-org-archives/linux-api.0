From: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Subject: [PATCH v5 0/4] SysFS driver for QEMU fw_cfg device
Date: Mon, 23 Nov 2015 10:57:40 -0500
Message-ID: <1448294264-17388-1-git-send-email-somlo@cmu.edu>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sudeep.holla-5wv7dgnIgG8@public.gmane.org, agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, revol-GANU6spQydw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Allow access to QEMU firmware blobs, passed into the guest VM via
the fw_cfg device, through SysFS entries. Blob meta-data (e.g. name,
size, and fw_cfg key), as well as the raw binary blob data may be
accessed.

The SysFS access location is /sys/firmware/qemu_fw_cfg/... and was
selected based on overall similarity to the type of information
exposed under /sys/firmware/dmi/entries/...

New since v4:

	Documentation (Patches 1/4 and 4/4) now points to the authoritative
	file in the QEMU source tree for any details related to the "hardware
	interface" of the fw_cfg device; Only details specific to sysfs (1/4) 
	and DT (4/4) should stay in the kernel docs.

Thanks,
  --Gabriel

>New (since v3):
>
>	Patch 1/4: Device probing now works with either ACPI, DT, or
>		   optionally by manually specifying a base, size, and
>		   register offsets on the command line. This way, all
>		   architectures offering fw_cfg can be supported, although
>		   x86 and ARM get *automatic* support via ACPI and/or DT.
>
>		   HUGE thanks to Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> for
>		   pointing out drivers/virtio/virtio_mmio.c, as an example
>		   on how to pull this off !!!
>
>		   Stefan: I saw Marc's DMA patches to fw_cfg. Since only
>		   x86 and ARM will support it starting with QEMU 2.5, and
>		   since I expect to get lots of otherwise interesting (but
>		   otherwise orthogonal) feedback on this series, I'd like
>		   to stick with ioread8() across the board for now. We can
>		   always patch in DMA support in a backward compatible way
>		   later, once this series gets (hopefully) accepted :)
>
>	Patch 2/4: (was 3/4 in v3): unchanged. Exports kset_find_obj() so
>		   modules can call it.
>
>	Patch 3/4: (was 4/4 in v3): rebased, but otherwise the same.
>		   Essentially, creates a "human readable" directory
>		   hierarchy from "path-like" tokens making up fw_cfg
>		   blob names. I'm not really sure there's a way to make
>		   this happen via udev rules, but I have at least one
>		   potential use case for doing it *before* udev becomes
>		   available (cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>),
>		   so I'd be happy to leave this functionality in the
>		   kernel module. See further below for an illustration
>		   of this.
>
>	Patch 4/4: Updates the existing ARM DT documentation for fw_cfg,
>		   mainly by pointing at the more comprehensive document
>		   introduced with Patch 1/4 for details on the fw_cfg
>		   device interface, leaving only the specific ARM/DT
>		   address/size node information in place.
>
>>  In addition to the "by_key" blob listing, e.g.:
>>  
>>  $ tree /sys/firmware/qemu_fw_cfg/
>>  /sys/firmware/qemu_fw_cfg/
>>  |-- by_key
>>  |   |-- 32
>>  |   |   |-- key
>>  |   |   |-- name                        ("etc/boot-fail-wait")
>>  |   |   |-- raw
>>  |   |   `-- size
>>  |   |-- 33
>>  |   |   |-- key
>>  |   |   |-- name                        ("etc/smbios/smbios-tables")
>>  |   |   |-- raw
>>  |   |   `-- size
>>  |   |-- 34
>>  |   |   |-- key
>>  |   |   |-- name                        ("etc/smbios/smbios-anchor")
>>  |   |   |-- raw
>>  |   |   `-- size
>>  |   |-- 35
>>  |   |   |-- key
>>  |   |   |-- name                        ("etc/e820")
>>  |   |   |-- raw
>>  |   |   `-- size
>>  |   |-- 36
>>  |   |   |-- key
>>  |   |   |-- name                        ("genroms/kvmvapic.bin")
>>  |   |   |-- raw
>>  |   |   `-- size
>>  |   |-- 37
>>  |   |   |-- key
>>  |   |   |-- name                        ("etc/system-states")
>>  |   |   |-- raw
>>  |   |   `-- size
>>  |   |-- 38
>>  |   |   |-- key
>>  |   |   |-- name                        ("etc/acpi/tables")
>>  |   |   |-- raw
>>  |   |   `-- size
>>  |   |-- 39
>>  |   |   |-- key
>>  |   |   |-- name                        ("etc/table-loader")
>>  |   |   |-- raw
>>  |   |   `-- size
>>  |   |-- 40
>>  |   |   |-- key
>>  |   |   |-- name                        ("etc/tpm/log")
>>  |   |   |-- raw
>>  |   |   `-- size
>>  |   |-- 41
>>  |   |   |-- key
>>  |   |   |-- name                        ("etc/acpi/rsdp")
>>  |   |   |-- raw
>>  |   |   `-- size
>>  |   `-- 42
>>  |       |-- key
>>  |       |-- name                        ("bootorder")
>>  |       |-- raw
>>  |       `-- size
>>  |
>>  ...
>>  
>>  Patch 3/4 also gets us a "human readable" "by_name" listing, like so:
>>  
>>  ...
>>  |-- by_name
>>  |   |-- bootorder -> ../by_key/42
>>  |   |-- etc
>>  |   |   |-- acpi
>>  |   |   |   |-- rsdp -> ../../../by_key/41
>>  |   |   |   `-- tables -> ../../../by_key/38
>>  |   |   |-- boot-fail-wait -> ../../by_key/32
>>  |   |   |-- e820 -> ../../by_key/35
>>  |   |   |-- smbios
>>  |   |   |   |-- smbios-anchor -> ../../../by_key/34
>>  |   |   |   `-- smbios-tables -> ../../../by_key/33
>>  |   |   |-- system-states -> ../../by_key/37
>>  |   |   |-- table-loader -> ../../by_key/39
>>  |   |   `-- tpm
>>  |   |       `-- log -> ../../../by_key/40
>>  |   `-- genroms
>>  |       `-- kvmvapic.bin -> ../../by_key/36
>>  `-- rev
>

Gabriel Somlo (4):
  firmware: introduce sysfs driver for QEMU's fw_cfg device
  kobject: export kset_find_obj() for module use
  firmware: create directory hierarchy for sysfs fw_cfg entries
  devicetree: update documentation for fw_cfg ARM bindings

 .../ABI/testing/sysfs-firmware-qemu_fw_cfg         | 100 +++
 Documentation/devicetree/bindings/arm/fw-cfg.txt   |  38 +-
 drivers/firmware/Kconfig                           |  19 +
 drivers/firmware/Makefile                          |   1 +
 drivers/firmware/qemu_fw_cfg.c                     | 714 +++++++++++++++++++++
 lib/kobject.c                                      |   1 +
 6 files changed, 837 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg
 create mode 100644 drivers/firmware/qemu_fw_cfg.c

-- 
2.4.3
