From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: [PATCH v7 0/4] SysFS driver for QEMU fw_cfg device
Date: Wed, 27 Jan 2016 21:57:26 -0500
Message-ID: <1453949850-13076-1-git-send-email-somlo@cmu.edu>
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: gregkh@linuxfoundation.org, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de, lersek@redhat.com, ralf@linux-mips.org, rmk+kernel@arm.linux.org.uk, eric@anholt.net, hanjun.guo@linaro.org, zajec5@gmail.com, sudeep.holla@arm.com, agross@codeaurora.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: peter.maydell@linaro.org, ehabkost@redhat.com, ard.biesheuvel@linaro.org, matt@codeblueprint.co.uk, stefanha@gmail.com, mst@redhat.com, qemu-devel@nongnu.org, leif.lindholm@linaro.org, luto@amacapital.net, kraxel@redhat.com, pbonzini@redhat.com, imammedo@redhat.com, revol@free.fr, rth@twiddle.net
List-Id: linux-api@vger.kernel.org

From: "Gabriel Somlo" <somlo@cmu.edu>

Allow access to QEMU firmware blobs, passed into the guest VM via
the fw_cfg device, through SysFS entries. Blob meta-data (e.g. name,
size, and fw_cfg key), as well as the raw binary blob data may be
accessed.

The SysFS access location is /sys/firmware/qemu_fw_cfg/... and was
selected based on overall similarity to the type of information
exposed under /sys/firmware/dmi/entries/...

This functionality is primarily intended to serve as a host->guest
configuration data transfer mechanism that is both:

	- asynchronous: the host doesn't need to wait for the guest
			to be ready to accept data (e.g., by starting
			an agent daemon)

	- out-of-band:  there is no need to commandeer a guest element
			normally visible and available to the guest user
			(e.g., kernel cmdline, mounting floppy/cdrom, etc.)

QEMU now allows arbitrary fw_cfg blobs to be added via the command line,
so it would be nice to make them easy to retrieve from within the guest
OS, and the niceset and easiest way I can think of is

	cat /sys/firmware/qemu-fw-cfg/.../<some-blob-name>/raw

New since v6:

	- added architecture-specific default values for fw_cfg register
	  offsets: DT and/or ACPI will only give us the base address and
	  total size of the fw_cfg register set, but not individual register
	  offsets *within* this total extent. The specific offsets are
	  different across architectures, and this version adds #defines
	  so that reasonable defaults can be used on each supported platform.

Thanks,
  --Gabriel

>New since v5:
>
>	- fixed typos in documentation files (Patches 1/4 and 4/4
>
>	- printf/scanf type modifier for phys_addr_t now matches
>	  arch-specific width (u32 vs. u64), avoiding compiler warnings.
>	  (tested on i386 with and without PAE, and on armv7hl with and
>	   without lpae -- the latter pair took quite a while on an
>	   emulated QEMU guest :) )
>
>>New since v4:
>>
>>	Documentation (Patches 1/4 and 4/4) now points to the authoritative
>>	file in the QEMU source tree for any details related to the "hardware
>>	interface" of the fw_cfg device; Only details specific to sysfs (1/4) 
>>	and DT (4/4) should stay in the kernel docs.
>>
>>>New (since v3):
>>>
>>>	Patch 1/4: Device probing now works with either ACPI, DT, or
>>>		   optionally by manually specifying a base, size, and
>>>		   register offsets on the command line. This way, all
>>>		   architectures offering fw_cfg can be supported, although
>>>		   x86 and ARM get *automatic* support via ACPI and/or DT.
>>>
>>>		   HUGE thanks to Laszlo Ersek <lersek@redhat.com> for
>>>		   pointing out drivers/virtio/virtio_mmio.c, as an example
>>>		   on how to pull this off !!!
>>>
>>>		   Stefan: I saw Marc's DMA patches to fw_cfg. Since only
>>>		   x86 and ARM will support it starting with QEMU 2.5, and
>>>		   since I expect to get lots of otherwise interesting (but
>>>		   otherwise orthogonal) feedback on this series, I'd like
>>>		   to stick with ioread8() across the board for now. We can
>>>		   always patch in DMA support in a backward compatible way
>>>		   later, once this series gets (hopefully) accepted :)
>>>
>>>	Patch 2/4: (was 3/4 in v3): unchanged. Exports kset_find_obj() so
>>>		   modules can call it.
>>>
>>>	Patch 3/4: (was 4/4 in v3): rebased, but otherwise the same.
>>>		   Essentially, creates a "human readable" directory
>>>		   hierarchy from "path-like" tokens making up fw_cfg
>>>		   blob names. I'm not really sure there's a way to make
>>>		   this happen via udev rules, but I have at least one
>>>		   potential use case for doing it *before* udev becomes
>>>		   available (cc: Andy Lutomirski <luto@amacapital.net>),
>>>		   so I'd be happy to leave this functionality in the
>>>		   kernel module. See further below for an illustration
>>>		   of this.
>>>
>>>	Patch 4/4: Updates the existing ARM DT documentation for fw_cfg,
>>>		   mainly by pointing at the more comprehensive document
>>>		   introduced with Patch 1/4 for details on the fw_cfg
>>>		   device interface, leaving only the specific ARM/DT
>>>		   address/size node information in place.
>>>
>>>>  In addition to the "by_key" blob listing, e.g.:
>>>>  
>>>>  $ tree /sys/firmware/qemu_fw_cfg/
>>>>  /sys/firmware/qemu_fw_cfg/
>>>>  |-- by_key
>>>>  |   |-- 32
>>>>  |   |   |-- key
>>>>  |   |   |-- name                        ("etc/boot-fail-wait")
>>>>  |   |   |-- raw
>>>>  |   |   `-- size
>>>>  |   |-- 33
>>>>  |   |   |-- key
>>>>  |   |   |-- name                        ("etc/smbios/smbios-tables")
>>>>  |   |   |-- raw
>>>>  |   |   `-- size
>>>>  |   |-- 34
>>>>  |   |   |-- key
>>>>  |   |   |-- name                        ("etc/smbios/smbios-anchor")
>>>>  |   |   |-- raw
>>>>  |   |   `-- size
>>>>  |   |-- 35
>>>>  |   |   |-- key
>>>>  |   |   |-- name                        ("etc/e820")
>>>>  |   |   |-- raw
>>>>  |   |   `-- size
>>>>  |   |-- 36
>>>>  |   |   |-- key
>>>>  |   |   |-- name                        ("genroms/kvmvapic.bin")
>>>>  |   |   |-- raw
>>>>  |   |   `-- size
>>>>  |   |-- 37
>>>>  |   |   |-- key
>>>>  |   |   |-- name                        ("etc/system-states")
>>>>  |   |   |-- raw
>>>>  |   |   `-- size
>>>>  |   |-- 38
>>>>  |   |   |-- key
>>>>  |   |   |-- name                        ("etc/acpi/tables")
>>>>  |   |   |-- raw
>>>>  |   |   `-- size
>>>>  |   |-- 39
>>>>  |   |   |-- key
>>>>  |   |   |-- name                        ("etc/table-loader")
>>>>  |   |   |-- raw
>>>>  |   |   `-- size
>>>>  |   |-- 40
>>>>  |   |   |-- key
>>>>  |   |   |-- name                        ("etc/tpm/log")
>>>>  |   |   |-- raw
>>>>  |   |   `-- size
>>>>  |   |-- 41
>>>>  |   |   |-- key
>>>>  |   |   |-- name                        ("etc/acpi/rsdp")
>>>>  |   |   |-- raw
>>>>  |   |   `-- size
>>>>  |   `-- 42
>>>>  |       |-- key
>>>>  |       |-- name                        ("bootorder")
>>>>  |       |-- raw
>>>>  |       `-- size
>>>>  |
>>>>  ...
>>>>  
>>>>  Patch 3/4 also gets us a "human readable" "by_name" listing, like so:
>>>>  
>>>>  ...
>>>>  |-- by_name
>>>>  |   |-- bootorder -> ../by_key/42
>>>>  |   |-- etc
>>>>  |   |   |-- acpi
>>>>  |   |   |   |-- rsdp -> ../../../by_key/41
>>>>  |   |   |   `-- tables -> ../../../by_key/38
>>>>  |   |   |-- boot-fail-wait -> ../../by_key/32
>>>>  |   |   |-- e820 -> ../../by_key/35
>>>>  |   |   |-- smbios
>>>>  |   |   |   |-- smbios-anchor -> ../../../by_key/34
>>>>  |   |   |   `-- smbios-tables -> ../../../by_key/33
>>>>  |   |   |-- system-states -> ../../by_key/37
>>>>  |   |   |-- table-loader -> ../../by_key/39
>>>>  |   |   `-- tpm
>>>>  |   |       `-- log -> ../../../by_key/40
>>>>  |   `-- genroms
>>>>  |       `-- kvmvapic.bin -> ../../by_key/36
>>>>  `-- rev

Gabriel Somlo (4):
  firmware: introduce sysfs driver for QEMU's fw_cfg device
  kobject: export kset_find_obj() for module use
  firmware: create directory hierarchy for sysfs fw_cfg entries
  devicetree: update documentation for fw_cfg ARM bindings

 .../ABI/testing/sysfs-firmware-qemu_fw_cfg         | 100 +++
 Documentation/devicetree/bindings/arm/fw-cfg.txt   |  38 +-
 drivers/firmware/Kconfig                           |  19 +
 drivers/firmware/Makefile                          |   1 +
 drivers/firmware/qemu_fw_cfg.c                     | 751 +++++++++++++++++++++
 lib/kobject.c                                      |   1 +
 6 files changed, 874 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg
 create mode 100644 drivers/firmware/qemu_fw_cfg.c

-- 
2.4.3
