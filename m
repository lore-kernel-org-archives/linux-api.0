From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: Re: [PATCH v3 0/4] SysFS driver for QEMU fw_cfg device
Date: Mon, 5 Oct 2015 08:40:42 -0400
Message-ID: <20151005124042.GF1977@HEDWIG.INI.CMU.EDU>
References: <1443914889-9619-1-git-send-email-somlo@cmu.edu>
	<20151005100035.GA19064@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <20151005100035.GA19064@leverpostej>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: peter.maydell@linaro.org, paul@pwsan.com, matt.fleming@intel.com, catalin.marinas@arm.com, jordan.l.justen@intel.com, kernelnewbies@kernelnewbies.org, gregkh@linuxfoundation.org, zajec5@gmail.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, leif.lindholm@linaro.org, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, galak@codeaurora.org, mst@redhat.com, hanjun.guo@linaro.org, agross@codeaurora.org, pbonzini@redhat.com, linux-api@vger.kernel.org, lersek@redhat.com, kraxel@redhat.com
List-Id: linux-api@vger.kernel.org

On Mon, Oct 05, 2015 at 11:00:36AM +0100, Mark Rutland wrote:
> On Sat, Oct 03, 2015 at 07:28:05PM -0400, Gabriel L. Somlo wrote:
> > From: "Gabriel Somlo" <somlo@cmu.edu>
> > 
> > Allow access to QEMU firmware blobs, passed into the guest VM via
> > the fw_cfg device, through SysFS entries. Blob meta-data (e.g. name,
> > size, and fw_cfg key), as well as the raw binary blob data may be
> > accessed.
> > 
> > The SysFS access location is /sys/firmware/qemu_fw_cfg/... and was
> > selected based on overall similarity to the type of information
> > exposed under /sys/firmware/dmi/entries/...
> 
> What is the intended use of these?
> 
> Some of the keys in the example look like they'd come from other sources
> (e.g. the *-tables entries), while others look like kernel/bootloader
> configuration options (e.g. etc/boot-fail-wait, bootorder) -- I'm
> concerned about redundancy here.

Paolo already answered that (more eloquently than I would have) so I'll
leave it at that, for now...

> 
> > NEW (since v2): Using ACPI to detect the presence and details of the
> > fw_cfg virtual hardware device.
> > 
> >     Device Tree has been suggested by Ard as a comment on v2 of this
> >     patch, but after some deliberation I decided to go with ACPI,
> >     since it's supported on both x86 and some (uefi-enabled) versions
> >     of aarch64. I really don't see how I'd reasonably use *both* DT (on
> >     ARM) *and* ACPI (on x86), and after all I'm mostly concerned with
> >     x86, but originally wanted to maximize portability (which is where
> >     the register probing in earlier versions came from).
> 
> There are defintitely going to be arm64 VMs that don't use ACPI, so we
> may need DT support depending on what the intended use is.
> 
> I'm not sure I follow what the difficulty with supporting DT in addition
> to ACPI is? It looks like all you need is a compatible string and a reg
> entry.

Bearing in mind that I have almost no experience with arm:

I started out by probing all possible port-io and mmio locations where
fw_cfg registers might have been found, from a "classic" module_init
method.

Arm has DT, which as far as I understand will answer the following two
questions: 1. Do I have fw_cfg ? 2. If yes, what address range does it use ?
So that I could continue using a classic module_init, but won't need
to probe for the device.

PC (my primary architecture, the one I actually care about) does not
have DT. If I want to share the same code, I can't probe, so if I try
DT and don't find fw_cfg there (or somehow DT is no-op-ed out because
I'm on a PC guest), I could somehow look it up in ACPI the same way
(i.e., use ACPI as sort of a stand-in for DT).

But all ACPI-enabled drivers I could find use dedicated macros (i.e.
no more classic module_init() and module_exit(), but rather
module_acpi_driver() with .add and .remove methods on an acpi_driver
object, etc.) Not sure how I'd glue DT back into something like that.

In addition, Michael's comment earlier in the thread suggests that
even my current acpi version isn't sufficiently "orthodox" w.r.t.
ACPI, and I should be providing the hardware access routine as
an ACPI/AML routine, to avoid race conditions with the rest of ACPI,
and for encapsulation. I.e. it's even rude to use the fw_cfg node's
ACPI _CRS method (the part where I'd be treating it like a DT stand-in
only to query fw_cfg's hardware specifics).

So far, all the information I've been able to pull together points
away from a dual DT + ACPI all-in-one solution for fw_cfg. If you know
of an example where that's done in an acceptable way, please let
me know so I can use it for inspiration...

Thanks much,
--Gabriel

> 
> >     A patch set generating an ACPI device node for qemu's fw_cfg is
> >     currently under review on the qemu-devel list:
> > 
> >     http://lists.nongnu.org/archive/html/qemu-devel/2015-09/msg06946.html
> >     (sorry, gmane appears down at the moment...)
> > 
> > In consequence:
> > 
> > 	- Patch 1/4 is mostly the same as in v2;
> > 	- Patch 2/4 switches device initialization from register
> > 	  probing to using ACPI; this is a separate patch only to
> > 	  illustrate the transition from probing to ACPI, and I'm
> > 	  assuming it will end up squashed on top of patch 1/4 in
> > 	  the final version.
> > 
> > 	- Patches 3/4 and 4/4 add a "human-readable" directory
> > 	  hierarchy built from tokenizing fw_cfg blob names into
> > 	  '/'-separated components, with symlinks to each 'by_key'
> > 	  blob folder (same as in earlier versions). At Greg's
> > 	  suggestion I tried to build this folder hierarchy and
> > 	  leaf symlinks using udev rules, but so far I haven't been
> > 	  successful in figuring that out. If udev turns out to 
> > 	  be applicable after all, these two patches can be dropped
> > 	  from this series.
> > 
> > In other words, patches 1 and 2 give us the following "by_key" listing
> > of blobs contained in the qemu fw_cfg device (example pulled from a PC
> > qemu guest running Fedora 22), with the value of each "name" attribute
> > shown on the right:
> > 
> > $ tree /sys/firmware/qemu_fw_cfg/
> > /sys/firmware/qemu_fw_cfg/
> > |-- by_key
> > |   |-- 32
> > |   |   |-- key
> > |   |   |-- name			("etc/boot-fail-wait")
> > |   |   |-- raw
> > |   |   `-- size
> > |   |-- 33
> > |   |   |-- key
> > |   |   |-- name			("etc/smbios/smbios-tables")
> > |   |   |-- raw
> > |   |   `-- size
> > |   |-- 34
> > |   |   |-- key
> > |   |   |-- name			("etc/smbios/smbios-anchor")
> > |   |   |-- raw
> > |   |   `-- size
> > |   |-- 35
> > |   |   |-- key
> > |   |   |-- name			("etc/e820")
> > |   |   |-- raw
> > |   |   `-- size
> > |   |-- 36
> > |   |   |-- key
> > |   |   |-- name			("genroms/kvmvapic.bin")
> > |   |   |-- raw
> > |   |   `-- size
> > |   |-- 37
> > |   |   |-- key
> > |   |   |-- name			("etc/system-states")
> > |   |   |-- raw
> > |   |   `-- size
> > |   |-- 38
> > |   |   |-- key
> > |   |   |-- name			("etc/acpi/tables")
> > |   |   |-- raw
> > |   |   `-- size
> > |   |-- 39
> > |   |   |-- key
> > |   |   |-- name			("etc/table-loader")
> > |   |   |-- raw
> > |   |   `-- size
> > |   |-- 40
> > |   |   |-- key
> > |   |   |-- name			("etc/tpm/log")
> > |   |   |-- raw
> > |   |   `-- size
> > |   |-- 41
> > |   |   |-- key
> > |   |   |-- name			("etc/acpi/rsdp")
> > |   |   |-- raw
> > |   |   `-- size
> > |   `-- 42
> > |       |-- key
> > |       |-- name			("bootorder")
> > |       |-- raw
> > |       `-- size
> > |
> > ...
> > 
> > Additionally, patches 3 and 4 (mostly 4) give us the following
> > "user friendly" directory hierarchy as a complement to the above,
> > based on tokenizing each blob name into symlink-tipped (sub)directories:
> > 
> > ...
> > |-- by_name
> > |   |-- bootorder -> ../by_key/42
> > |   |-- etc
> > |   |   |-- acpi
> > |   |   |   |-- rsdp -> ../../../by_key/41
> > |   |   |   `-- tables -> ../../../by_key/38
> > |   |   |-- boot-fail-wait -> ../../by_key/32
> > |   |   |-- e820 -> ../../by_key/35
> > |   |   |-- smbios
> > |   |   |   |-- smbios-anchor -> ../../../by_key/34
> > |   |   |   `-- smbios-tables -> ../../../by_key/33
> > |   |   |-- system-states -> ../../by_key/37
> > |   |   |-- table-loader -> ../../by_key/39
> > |   |   `-- tpm
> > |   |       `-- log -> ../../../by_key/40
> > |   `-- genroms
> > |       `-- kvmvapic.bin -> ../../by_key/36
> > `-- rev
> > 
> > The trick is to figure out how to replace patches 3 and 4 with a
> > udev rule that would read the contents of each "name" attribute,
> > and build the "by_name" hierarchy and symlinks in userspace.
> > 
> > I tried:
> > 
> > $ udevadm info -a -p /sys/firmware/qemu_fw_cfg/by_key/33
> > 
> >   looking at device '/firmware/qemu_fw_cfg/by_key/33':
> >     KERNEL=="33"
> >     SUBSYSTEM==""
> >     DRIVER==""
> >     ATTR{key}=="33"
> >     ATTR{name}=="etc/smbios/smbios-tables"
> >     ATTR{size}=="388"
> > 
> >   looking at parent device '/firmware/qemu_fw_cfg/by_key':
> >     KERNELS=="by_key"
> >     SUBSYSTEMS==""
> >     DRIVERS==""
> > 
> >   looking at parent device '/firmware/qemu_fw_cfg':
> >     KERNELS=="qemu_fw_cfg"
> >     SUBSYSTEMS==""
> >     DRIVERS==""
> >     ATTRS{rev}=="1"
> > 
> > Then I tried creating a file, /usr/lib/udev/rules.d/99-qemu-fw-cfg.rules
> > containing the following line:
> > 
> > KERNELS=="qemu_fw_cfg", ATTRS{rev}=="1", SYMLINK="%p/%s{name}"
> > 
> > but NOTHING happens when I insert/remove qemu_fw_cfg.ko.  I also tried:
> > 
> > KERNELS=="qemu_fw_cfg", ATTRS{rev}=="1", PROGRAM="/foo %k"
> > 
> > where "/foo" basically did "echo $* > /tmp/bar", but no /tmp/bar file ever
> > showed up as a consequence of inserting/removing the qemu_fw_cfg.ko module.
> > 
> > At this point, I need help figuring out whether udev is really what would
> > get the second, user-friendly, "by_name" /sysfs directory tree created,
> > and how I'd go about that...
> > 
> > Thanks much,
> >   --Gabriel
> > 
> > Gabriel Somlo (4):
> >   firmware: introduce sysfs driver for QEMU's fw_cfg device
> >   firmware: use acpi to detect QEMU fw_cfg device for sysfs fw_cfg
> >     driver
> >   kobject: export kset_find_obj() for module use
> >   firmware: create directory hierarchy for sysfs fw_cfg entries
> > 
> >  .../ABI/testing/sysfs-firmware-qemu_fw_cfg         | 213 ++++++++
> >  drivers/firmware/Kconfig                           |  10 +
> >  drivers/firmware/Makefile                          |   1 +
> >  drivers/firmware/qemu_fw_cfg.c                     | 575 +++++++++++++++++++++
> >  lib/kobject.c                                      |   1 +
> >  5 files changed, 800 insertions(+)
> >  create mode 100644 Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg
> >  create mode 100644 drivers/firmware/qemu_fw_cfg.c
> > 
> > -- 
> > 2.4.3
> > 
