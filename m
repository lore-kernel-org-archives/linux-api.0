From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: [PATCH 0/3] SysFS driver for QEMU firmware config
	device (fw_cfg)
Date: Mon, 10 Aug 2015 12:31:17 -0400
Message-ID: <cover.1439220623.git.somlo@cmu.edu>
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
To: gregkh@linuxfoundation.org, ralf@linux-mips.org, zajec5@gmail.com, paul@pwsan.com, galak@codeaurora.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, rjones@redhat.com, jordan.l.justen@intel.com, x86@kernel.org, qemu-devel@nongnu.org, gleb@cloudius-systems.com, matt.fleming@intel.com, kernelnewbies@kernelnewbies.org, kraxel@redhat.com, pbonzini@redhat.com, lersek@redhat.com
List-Id: linux-api@vger.kernel.org

From: "Gabriel Somlo" <somlo@cmu.edu>

This patch set makes QEMU fw_cfg blobs available for viewing (read-only)
via SysFS.

Several different architectures supported by QEMU are set up with a
"firmware configuration" (fw_cfg) device, used to pass configuration
"blobs" into the guest by the host running QEMU.

Historically, these config blobs were mostly of interest to the guest
BIOS, but since QEMU v2.4 it is possible to insert arbitrary blobs via
the command line, which makes them potentially interesting to userspace
(e.g. for passing early boot environment variables, etc.).

In addition to cc-ing the people and lists indicated by get-maintainer.pl,
I've added a few extra lists suggested by Matt Fleming on the qemu-devel
list, as well as the qemu-devel list itself.

Also cc-ing kernelnewbies, as this is my very first kenel contribution,
so please go easy on me for whatever silly n00b mistakes I might have still
missed, in spite of trying hard to do all my homework properly... :)

The series consists of three patches:

  1/3 - probes for the qemu fw_cfg device in locations known to work on
	the supported architectures, in decreasing order of "likelihood".

	While it *may* be possible to detect the presence of fw_cfg via
	acpi or dtb (on x86 and arm, respectively), there's no way I know
	of attempting that on sun4 and ppc/mac, so I've stuck with simply
	probing (the fw_cfg_modes[] structure and fw_cfg_io_probe() function)
	in fw_cfg.c. I could use some advice on how else that could be
	done more elegantly, if needed.

	Upon successfully detecting a present fw_cfg device, we set up
	/sys/firmware/fw_cfg/by_select entries for each blob available
	on the fw_cfg device.

  2/3 - export kset_find_obj() (in lib/kobject.c) for use with modules,
	which will come in handy in patch #3, below.

  3/3 - add a "user friendly" way of listing fw_cfg blobs by name rather
	than by unique selector key.

	Since fw_cfg blob names are traditionally set up to look like
	path names, it would be nice to mirror that fact when displaying
	them under /sys/firmware/fw_cfg in a "by_name" subdirectory.

	I'm using ksets to reflect subdirectories matching "dirname"
	tokens separated by '/' within each fw_cfg blob "filename",
	and symlinks into the "by_select" subdirectory for each "basename".

	Since the fw_cfg device doesn't enforce that blob names have
	well-behaved and non-conflicting names, it is possible (though
	unlikely) that there will be blobs named:

		"etc/foo/bar"
	and
		"etc/foo"

	where "foo" will try to be both a subdirectory AND a symlink under
	/sys/firmware/fw_cfg/by_name/etc/. In such an event, the latter
	fw_cfg blob will simply be skipped from having an entry created
	under the user-friendly "by_name" subdirectory, remaining listed
	only as an entry under the "by_select" subdirectory.

I have tested this on x86_64 and armv7hl+lpae kernels. Builds and installs
OK as both a module and linked directly into the kernel.

TIA for the feedback and advice,
  --Gabriel
  
Gabriel Somlo (3):
  firmware: introduce sysfs driver for QEMU's fw_cfg device
  kobject: export kset_find_obj() to be used from modules
  firmware: fw_cfg: create directory hierarchy for fw_cfg file names

 Documentation/ABI/testing/sysfs-firmware-fw_cfg | 211 +++++++++
 drivers/firmware/Kconfig                        |  10 +
 drivers/firmware/Makefile                       |   1 +
 drivers/firmware/fw_cfg.c                       | 542 ++++++++++++++++++++++++
 lib/kobject.c                                   |   1 +
 5 files changed, 765 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-fw_cfg
 create mode 100644 drivers/firmware/fw_cfg.c

-- 
2.4.3
