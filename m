From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: [PATCH v2 0/3] SysFS driver for QEMU fw_cfg device
Date: Tue, 11 Aug 2015 14:44:46 -0400
Message-ID: <cover.1439315079.git.somlo@cmu.edu>
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

New since v1:

    1/3:

	- renamed sysfs path components:

		s/fw_cfg/qemu_fw_cfg/g, at Greg's suggestion
		
		s/by_select/by_key/g since it feels a bit more intuitive

	- attribute "select" renamed to "key", along the same train of
	  thought.

	- renamed actual source file from "fw_cfg.c" to "qemu_fw_cfg.c"
	  and doc file in Documentation/ABI/testing to
	  "sysfs-firmware-qemu_fw_cfg"

	- s/uintXX_t/uXX/g, at Greg's suggestion

	- using named identifiers to initialize access mode table
	  (static struct fw_cfg_access fw_cfg_modes[]) per Greg's
	  suggestion

	- removed redundant "capable(CAP_SYS_ADMIN)" checks (per Greg's
	  feedback)

    2/3:

	- EXPORT_SYMBOL(kset_find_obj) statement moved immediately
	  after kset_find_obj() definition.

Re. 'struct device' vs. straight-up kobject:

I dug around a bit, and found a bunch of stuff under /sys/devices
(such as e.g. /sys/devices/virtual/dmi and /sys/devices/platform/applesmc)

The first one is particularly interesting, as it presents a
somewhat different view of the same internal information displayed by
/sys/firmware/dmi/, only /sys/devices/virtual/dmi looks more "cooked",
in that it exposes individual fields of the several different DMI tables.

None of the subfolders of /sys/devices/... appears to facilitate access
to the "raw blobs" contained by the respective devices represented there.

Even applesmc (the other device with which I'm somewhat familiar) does
a lot of "cooking" of the values held by the device.

So, at the end of the day, I want the information I expose about fw_cfg
to look more like /sys/firmware/dmi than like /sys/devices/virtual/dmi
in that I have a bunch of cached metadata attributes for each of the
blobs, and want to offer access to the raw blob data, and there's no
rhyme or reason to the actual internals of any of the blobs, so offering
a "cooked" view like in /sys/devices/... doesn't feel like the best fit...

Obviously, I may be totally wrong... :)

Lastly, re. Greg's comment on patch 3/3:
> Shouldn't all of this be done in userspace with the symlinks and all?
> It seems like you are trying to duplicate the /dev/block/by-name and
> such.  Policy decisions like symlinks and naming should be done there,
> in userspace, and not directly in sysfs if at all possible.

OK, so here's the "pseudo-bash" equivalent of what this patch does:

	#upon successful qemu_fw_cfg.ko insertion

	BY_KEY="/sys/firmware/qemu_fw_cfg/by_key"
	BY_NAME="/sys/firmware/qemu_fw_cfg/by_name"

	mkdir -p $BY_NAME

	for KEY in $(ls $BY_KEY); do
		FILE=$(cat $BY_KEY/$KEY/name)
		[ mkdir -p $BY_NAME/$(dirname $FILE) ] || continue
		pushd $BY_NAME/$(dirname $FILE)
		ln -s $BY_KEY/$KEY $(basename $FILE)
		popd
	done

Note how it MAY fail to mkdir, in which case it skips to the next key,
or it MAY fail to create the symlink, in which case it just moves on
to the next key as well.

Again, the fw_cfg device doesn't have any notion of nested directories,
it just parrots back some random string someone choose as a name for a
given blob, but these strings typically contain slash-separated ASCII
which "looks like" it "could" be a path name :)

If there's a reasonable way to do this dynamically, immediately upon
insertion of the qemu_fw_cfg.ko module, patches 2/3 and 3/3 could be
dropped.

But before that, I'd appreciate a pointer to how/where this can be done
in userspace. Would it be available e.g. during early boot, early enough
to e.g. raw-dump an ASCII blob containing shell variable definitions (e.g.
to set hostname on the guest, etc ?)

Doing it as part of the qemu_fw_cfg.ko module itself has the advantage
of it being available immediately, without anything having to "watch"
for the module being inserted.

But if userspace is the standard, "canonical" place to do something like
this, I'd be happy to give it a try, once I find the right tree to bark
up on... :)

Thanks much,
   Gabriel


Old "cover-letter" blurb for v1:
> Several different architectures supported by QEMU are set up with a
> "firmware configuration" (fw_cfg) device, used to pass configuration
> "blobs" into the guest by the host running QEMU.
>
> Historically, these config blobs were mostly of interest to the guest
> BIOS, but since QEMU v2.4 it is possible to insert arbitrary blobs via
> the command line, which makes them potentially interesting to userspace
> (e.g. for passing early boot environment variables, etc.).
>
> In addition to cc-ing the people and lists indicated by get-maintainer.pl,
> I've added a few extra lists suggested by Matt Fleming on the qemu-devel
> list, as well as the qemu-devel list itself.
>
> Also cc-ing kernelnewbies, as this is my very first kenel contribution,
> so please go easy on me for whatever silly n00b mistakes I might have still
> missed, in spite of trying hard to do all my homework properly... :)
>
> The series consists of three patches:
>
>   1/3 - probes for the qemu fw_cfg device in locations known to work on
> 	the supported architectures, in decreasing order of "likelihood".
>
> 	While it *may* be possible to detect the presence of fw_cfg via
> 	acpi or dtb (on x86 and arm, respectively), there's no way I know
> 	of attempting that on sun4 and ppc/mac, so I've stuck with simply
> 	probing (the fw_cfg_modes[] structure and fw_cfg_io_probe() function)
> 	in fw_cfg.c. I could use some advice on how else that could be
> 	done more elegantly, if needed.
>
> 	Upon successfully detecting a present fw_cfg device, we set up
> 	/sys/firmware/fw_cfg/by_select entries for each blob available
> 	on the fw_cfg device.
>
>   2/3 - export kset_find_obj() (in lib/kobject.c) for use with modules,
> 	which will come in handy in patch #3, below.
>
>   3/3 - add a "user friendly" way of listing fw_cfg blobs by name rather
> 	than by unique selector key.
>
> 	Since fw_cfg blob names are traditionally set up to look like
> 	path names, it would be nice to mirror that fact when displaying
> 	them under /sys/firmware/fw_cfg in a "by_name" subdirectory.
>
> 	I'm using ksets to reflect subdirectories matching "dirname"
> 	tokens separated by '/' within each fw_cfg blob "filename",
> 	and symlinks into the "by_select" subdirectory for each "basename".
>
> 	Since the fw_cfg device doesn't enforce that blob names have
> 	well-behaved and non-conflicting names, it is possible (though
> 	unlikely) that there will be blobs named:
>
> 		"etc/foo/bar"
> 	and
> 		"etc/foo"
>
> 	where "foo" will try to be both a subdirectory AND a symlink under
> 	/sys/firmware/fw_cfg/by_name/etc/. In such an event, the latter
> 	fw_cfg blob will simply be skipped from having an entry created
> 	under the user-friendly "by_name" subdirectory, remaining listed
> 	only as an entry under the "by_select" subdirectory.
>
> I have tested this on x86_64 and armv7hl+lpae kernels. Builds and installs
> OK as both a module and linked directly into the kernel.

Gabriel Somlo (3):
  firmware: introduce sysfs driver for QEMU's fw_cfg device
  kobject: export kset_find_obj() to be used from modules
  firmware: fw_cfg: create directory hierarchy for fw_cfg file names

 .../ABI/testing/sysfs-firmware-qemu_fw_cfg         | 210 ++++++++
 drivers/firmware/Kconfig                           |  10 +
 drivers/firmware/Makefile                          |   1 +
 drivers/firmware/qemu_fw_cfg.c                     | 560 +++++++++++++++++++++
 lib/kobject.c                                      |   1 +
 5 files changed, 782 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg
 create mode 100644 drivers/firmware/qemu_fw_cfg.c

-- 
2.4.3
