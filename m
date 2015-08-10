From: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Subject: Re: [PATCH 1/3] firmware: introduce sysfs driver for QEMU's fw_cfg
 device
Date: Mon, 10 Aug 2015 15:02:22 -0400
Message-ID: <20150810190222.GN31816@HEDWIG.INI.CMU.EDU>
References: <cover.1439220623.git.somlo@cmu.edu>
 <3b039351aba44759627fa77a0003dad685a9f21d.1439220623.git.somlo@cmu.edu>
 <20150810183054.GA18817@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150810183054.GA18817-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, paul-DWxLp4Yu+b8AvxtiuMwx3w@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gleb-RmZWMc9puTNJc61us3aD9laTQe2KTcn/@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kernelnewbies-7JyXY6prKcjpASu1u0TL5ti2O/JbrIOy@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Aug 10, 2015 at 11:30:54AM -0700, Greg KH wrote:
> On Mon, Aug 10, 2015 at 12:31:18PM -0400, Gabriel L. Somlo wrote:
> > From: "Gabriel Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
> > 
> > Make fw_cfg entries of type "file" available via sysfs. Entries
> > are listed under /sys/firmware/fw_cfg/by_select, in folders named
> > after each entry's selector key. Filename, selector value, and
> > size read-only attributes are included for each entry. Also, a
> > "raw" attribute allows retrieval of the full binary content of
> > each entry.
> > 
> > This patch also provides a documentation file outlining the
> > guest-side "hardware" interface exposed by the QEMU fw_cfg device.
> > 
> > Signed-off-by: Gabriel Somlo <somlo-D+Gtc/HYRWM@public.gmane.org>
> > ---
> >  Documentation/ABI/testing/sysfs-firmware-fw_cfg | 169 +++++++++
> >  drivers/firmware/Kconfig                        |  10 +
> >  drivers/firmware/Makefile                       |   1 +
> >  drivers/firmware/fw_cfg.c                       | 438 ++++++++++++++++++++++++
> >  4 files changed, 618 insertions(+)
> >  create mode 100644 Documentation/ABI/testing/sysfs-firmware-fw_cfg
> >  create mode 100644 drivers/firmware/fw_cfg.c
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-firmware-fw_cfg b/Documentation/ABI/testing/sysfs-firmware-fw_cfg
> > new file mode 100644
> > index 0000000..3a7e7f2
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-firmware-fw_cfg
> > @@ -0,0 +1,169 @@
> > +What:		/sys/firmware/fw_cfg/
> 
> /sys/firmware/qemu_fw/ ?
> 
> "fw_cfg" is very vague and not descriptive at all.

How about /sys/firmware/qemu_fw_cfg/, then ? In the QEMU universe,
"fw_cfg" is familiar. OTOH "qemu_fw" would not immediately ring a bell...

> 
> 
> > +Date:		August 2015
> > +Contact:	Gabriel Somlo <somlo-D+Gtc/HYRWM@public.gmane.org>
> > +Description:
> > +		Several different architectures supported by QEMU (x86, arm,
> > +		sun4*, ppc/mac) are provisioned with a firmware configuration
> > +		(fw_cfg) device, used by the host to provide configuration data
> > +		to the starting guest. While most of this data is meant for use
> > +		by the guest BIOS, starting with QEMU v2.4, guest VMs may be
> > +		started with arbitrary fw_cfg entries supplied directly on the
> > +		command line, which therefore may be of interest to userspace.
> > +
> > +		=== Guest-side Hardware Interface ===
> > +
> > +		The fw_cfg device is available to guest VMs as a pair (control
> > +		and data) of registers, accessible as either a IO ports or as
> > +		MMIO addresses, depending on the architecture.
> > +
> > +		--- Control Register ---
> > +
> > +		Width: 16-bit
> > +		Access: Write-Only
> > +		Endianness: LE (if IOport) or BE (if MMIO)
> > +
> > +		A write to the control register selects the index for one of
> > +		the firmware configuration items (or "blobs") available on the
> > +		fw_cfg device, which can subsequently be read from the data
> > +		register.
> > +
> > +		Each time the control register is written, an data offset
> > +		internal to the fw_cfg device will be set to zero. This data
> > +		offset impacts which portion of the selected fw_cfg blob is
> > +		accessed by reading the data register, as explained below.
> > +
> > +		--- Data Register ---
> > +
> > +		Width: 8-bit (if IOport), or 8/16/32/64-bit (if MMIO)
> > +		Access: Read-Only
> > +		Endianness: string preserving
> > +
> > +		The data register allows access to an array of bytes which
> > +		represent the fw_cfg blob last selected by a write to the
> > +		control register.
> > +
> > +		Immediately following a write to the control register, the data
> > +		offset will be set to zero. Each successful read access to the
> > +		data register will increment the data offset by the appropriate
> > +		access width.
> > +
> > +		Each fw_cfg blob has a maximum associated data length. Once the
> > +		data offset exceeds this maximum length, any subsequent reads
> > +		via the data register will return 0x00.
> > +
> > +		An N-byte wide read of the data register will return the next
> > +		available N bytes of the selected fw_cfg blob, as a substring,
> > +		in increasing address order, similar to memcpy(), zero-padded
> > +		if necessary should the maximum data length of the selected
> > +		item be reached, as described above.
> > +
> > +		--- Per-arch Register Details ---
> > +
> > +		-------------------------------------------------------------
> > +		arch	access	       base	ctrl	ctrl	data	data
> > +			mode	    address	offset	endian	offset	width
> > +									max.
> > +		-------------------------------------------------------------
> > +		x86	IOport	      0x510	0	LE	1	 8
> > +		x86_64	IOport	      0x510	0	LE	1	 8
> > +		arm	MMIO	  0x9020000	8	BE	0	64
> > +		sun4u	IOport	      0x510	0	LE	1	 8
> > +		sun4m	MMIO	0xd00000510	0	BE	2	 8
> > +		ppc/mac	MMIO	 0xf0000510	0	BE	2	 8
> > +		-------------------------------------------------------------
> > +
> > +		NOTE: On platforms where the fw_cfg registers are exposed as
> > +		IO ports, the data port number will always be one greater than
> > +		the port number of the control register. I.e., the two ports
> > +		are overlapping, and can not be mapped separately.
> > +
> > +		=== Firmware Configuration Items of Interest ===
> > +
> > +		Originally, the index key, size, and formatting of blobs in
> > +		fw_cfg was hard coded by mutual agreement between QEMU on the
> > +		host side, and the BIOS running on the guest. Later on, a file
> > +		transfer interface was added: by reading a special blob, the
> > +		fw_cfg consumer can retrieve a list of records containing the
> > +		name, selector key, and size of further fw_cfg blobs made
> > +		available by the host. Below we describe three fw_cfg blobs
> > +		of interest to the sysfs driver.
> > +
> > +		--- Signature (Key 0x0000, FW_CFG_SIGNATURE) ---
> > +
> > +		The presence of the fw_cfg device can be verified by selecting
> > +		the signature blob by writing 0x0000 to the control register,
> > +		and reading four bytes from the data register. If the fw_cfg
> > +		device is present, the four bytes read will match the ASCII
> > +		characters "QEMU".
> 
> Why is this a binary sysfs file?  It really sounds like you want a char
> device, so you can do ioctl commands on it, right?

I felt it necessary to explain the most important fw_cfg blobs before
getting into the sysfs layout proper. This blob isn't displayed in
sysfs, just used by the module_init function to confirm we have, in
fact, a valid fw_cfg device present on the system.

> 
> 
> > +
> > +		--- Revision (Key 0x0001, FW_CFG_ID) ---
> > +
> > +		A 32-bit little-endian unsigned integer, this item is used as
> > +		an interface revision number.
> > +
> > +		--- File Directory (Key 0x0019, FW_CFG_FILE_DIR) ---
> > +
> > +		Any fw_cfg blobs stored at key 0x0020 FW_CFG_FILE_FIRST() or
> > +		higher will have an associated entry in this "directory" blob,
> > +		which facilitates the discovery of available items by software
> > +		(e.g. BIOS) running on the guest. The format of the directory
> > +		blob is shown below.
> > +
> > +		NOTE: All integers are stored in big-endian format!
> > +
> > +		/* the entire file directory "blob" */
> > +		struct FWCfgFiles {
> > +			uint32_t count;		/* total number of entries */
> > +			struct FWCfgFile f[];	/* entry array, see below */
> > +		};
> > +
> > +		/* an individual directory entry, 64 bytes total */
> > +		struct FWCfgFile {
> > +			uint32_t size;		/* size of referenced blob */
> > +			uint16_t select;	/* blob selector key */
> > +			uint16_t reserved;
> > +			char name[56];		/* blob name, nul-term. ascii */
> > +		};
> > +
> > +		=== SysFS fw_cfg Interface ===
> > +
> > +		The fw_cfg sysfs interface described in this document is only
> > +		intended to display discoverable blobs (i.e., those registered
> > +		with the file directory), as there is no way to determine the
> > +		presence or size of "legacy" blobs (with selector keys between
> > +		0x0002 and 0x0018) programmatically.
> > +
> > +		All fw_cfg information is shown under:
> > +
> > +			/sys/firmware/fw_cfg/
> > +
> > +		The only legacy blob displayed is the fw_cfg device revision:
> > +
> > +			/sys/firmware/fw_cfg/rev
> > +
> > +		--- Discoverable fw_cfg blobs by selector key ---
> > +
> > +		All discoverable blobs listed in the fw_cfg file directory are
> > +		displayed as entries named after their unique selector key
> > +		value, e.g.:
> > +
> > +			/sys/firmware/fw_cfg/by_select/32
> > +			/sys/firmware/fw_cfg/by_select/33
> > +			/sys/firmware/fw_cfg/by_select/34
> > +			...
> > +
> > +		Each such fw_cfg sysfs entry has the following values exported
> > +		as attributes:
> > +
> > +		name  	: The 56-byte nul-terminated ASCII string used as the
> > +			  blob's 'file name' in the fw_cfg directory.
> > +		size  	: The length of the blob, as given in the fw_cfg
> > +			  directory.
> > +		select	: The value of the blob's selector key as given in the
> > +			  fw_cfg directory. This value is the same as used in
> > +			  the parent directory name.
> > +			  how the rest of the entry should be interpreted.
> > +		raw	: The raw bytes of the blob, obtained by selecting the
> > +			  entry via the control register, and reading a number
> > +			  of bytes equal to the blob size from the data
> > +			  register.
> > diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> > index 99c69a3..f5cbe81 100644
> > --- a/drivers/firmware/Kconfig
> > +++ b/drivers/firmware/Kconfig
> > @@ -136,6 +136,16 @@ config QCOM_SCM
> >  	bool
> >  	depends on ARM || ARM64
> >  
> > +config FW_CFG_SYSFS
> > +	tristate "QEMU fw_cfg device support in sysfs"
> > +	depends on SYSFS
> > +	default n
> > +	help
> > +	  Say Y or M here to enable the exporting of the QEMU firmware
> > +	  configuration (fw_cfg) file entries via sysfs. Entries are
> > +	  found under /sys/firmware/fw_cfg when this option is enabled
> > +	  and loaded.
> > +
> >  source "drivers/firmware/broadcom/Kconfig"
> >  source "drivers/firmware/google/Kconfig"
> >  source "drivers/firmware/efi/Kconfig"
> > diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
> > index 4a4b897..b81b46e 100644
> > --- a/drivers/firmware/Makefile
> > +++ b/drivers/firmware/Makefile
> > @@ -13,6 +13,7 @@ obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
> >  obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
> >  obj-$(CONFIG_QCOM_SCM)		+= qcom_scm.o
> >  obj-$(CONFIG_QCOM_SCM)		+= qcom_scm-32.o
> > +obj-$(CONFIG_FW_CFG_SYSFS)	+= fw_cfg.o
> >  CFLAGS_qcom_scm-32.o :=$(call as-instr,.arch_extension sec,-DREQUIRES_SEC=1)
> >  
> >  obj-y				+= broadcom/
> > diff --git a/drivers/firmware/fw_cfg.c b/drivers/firmware/fw_cfg.c
> > new file mode 100644
> > index 0000000..be17411
> > --- /dev/null
> > +++ b/drivers/firmware/fw_cfg.c
> > @@ -0,0 +1,438 @@
> > +/*
> > + * drivers/firmware/fw_cfg.c
> > + *
> > + * Expose entries from QEMU's firmware configuration (fw_cfg) device in
> > + * sysfs (read-only, under "/sys/firmware/fw_cfg/...").
> > + *
> > + * Copyright 2015 Carnegie Mellon University
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/capability.h>
> > +#include <linux/slab.h>
> > +#include <linux/io.h>
> > +#include <linux/ioport.h>
> > +#include <linux/ctype.h>
> > +
> > +/* selector values for "well-known" fw_cfg entries */
> > +#define FW_CFG_SIGNATURE  0x00
> > +#define FW_CFG_ID         0x01
> > +#define FW_CFG_FILE_DIR   0x19
> > +
> > +/* size in bytes of fw_cfg signature */
> > +#define FW_CFG_SIG_SIZE 4
> > +
> > +/* fw_cfg "file name" is up to 56 characters (including terminating nul) */
> > +#define FW_CFG_MAX_FILE_PATH 56
> > +
> > +/* fw_cfg file directory entry type */
> > +struct fw_cfg_file {
> > +	uint32_t size;
> > +	uint16_t select;
> > +	uint16_t reserved;
> 
> Those aren't valid kernel types, use u32, and u16 please.
> 
> > +	char name[FW_CFG_MAX_FILE_PATH];
> > +};
> > +
> > +/* fw_cfg device i/o access options type */
> > +struct fw_cfg_access {
> > +	phys_addr_t start;
> > +	uint8_t size;
> > +	uint8_t ctrl_offset;
> > +	uint8_t data_offset;
> 
> u8.

Got it, s/uintXX_t/uXX/g in v2 :)

> 
> > +	bool is_mmio;
> > +	const char *name;
> > +};
> > +
> > +/* fw_cfg device i/o access available options for known architectures */
> > +static struct fw_cfg_access fw_cfg_modes[] = {
> > +	{ 0x510,       2, 0, 1, false, "fw_cfg on i386, sun4u" },
> > +	{ 0x9020000,  10, 8, 0,  true, "fw_cfg on arm" },
> > +	{ 0xd00000510, 3, 0, 2,  true, "fw_cfg on sun4m" },
> > +	{ 0xf0000510,  3, 0, 2,  true, "fw_cfg on ppc/mac" },
> 
> named identifiers please.

OK, will do.

> 
> 
> > +	{ }
> > +};
> > +
> > +/* fw_cfg device i/o currently selected option set */
> > +static struct fw_cfg_access *fw_cfg_mode;
> > +
> > +/* fw_cfg device i/o register addresses */
> > +static void __iomem *fw_cfg_dev_base;
> > +static void __iomem *fw_cfg_dev_ctrl;
> > +static void __iomem *fw_cfg_dev_data;
> > +
> > +/* atomic access to fw_cfg device (potentially slow i/o, so using mutex) */
> > +static DEFINE_MUTEX(fw_cfg_dev_lock);
> > +
> > +/* pick apropriate endianness for selector key */
> > +static inline uint16_t fw_cfg_sel_endianness(uint16_t select)
> > +{
> > +	return fw_cfg_mode->is_mmio ? cpu_to_be16(select) : cpu_to_le16(select);
> > +}
> > +
> > +/* type for fw_cfg "directory scan" visitor/callback function */
> > +typedef int (*fw_cfg_file_callback)(const struct fw_cfg_file *f);
> > +
> > +/* run a given callback on each fw_cfg directory entry */
> > +static int fw_cfg_scan_dir(fw_cfg_file_callback callback)
> > +{
> > +	int ret = 0;
> > +	uint32_t count, i;
> 
> u32.  Please remove all the *_t variable types.  and i should be an int
> here, right?

i goes from 0 up to count, where count is u32. So I figured i should
be u32 as well, but in practice int would work just as well (count is
highly unlikely to be large enough to go past INT_MAX). Let me know if
you still want me to make it an int.

> 
> > +	struct fw_cfg_file f;
> > +
> > +	mutex_lock(&fw_cfg_dev_lock);
> > +	iowrite16(fw_cfg_sel_endianness(FW_CFG_FILE_DIR), fw_cfg_dev_ctrl);
> > +	ioread8_rep(fw_cfg_dev_data, &count, sizeof(count));
> > +	for (i = 0; i < be32_to_cpu(count); i++) {
> > +		ioread8_rep(fw_cfg_dev_data, &f, sizeof(f));
> > +		ret = callback(&f);
> > +		if (ret)
> > +			break;
> > +	}
> > +	mutex_unlock(&fw_cfg_dev_lock);
> > +	return ret;
> > +}
> > +
> > +/* read chunk of given fw_cfg blob (caller responsible for sanity-check) */
> > +static inline void fw_cfg_read_blob(uint16_t select,
> > +				    void *buf, loff_t pos, size_t count)
> > +{
> > +	mutex_lock(&fw_cfg_dev_lock);
> > +	iowrite16(fw_cfg_sel_endianness(select), fw_cfg_dev_ctrl);
> > +	while (pos-- > 0)
> > +		ioread8(fw_cfg_dev_data);
> > +	ioread8_rep(fw_cfg_dev_data, buf, count);
> > +	mutex_unlock(&fw_cfg_dev_lock);
> > +}
> > +
> > +/* clean up fw_cfg device i/o setup */
> > +static void fw_cfg_io_cleanup(void)
> > +{
> > +	if (fw_cfg_mode->is_mmio) {
> > +		iounmap(fw_cfg_dev_base);
> > +		release_mem_region(fw_cfg_mode->start, fw_cfg_mode->size);
> > +	} else {
> > +		ioport_unmap(fw_cfg_dev_base);
> > +		release_region(fw_cfg_mode->start, fw_cfg_mode->size);
> > +	}
> > +}
> > +
> > +/* probe and map fw_cfg device */
> > +static int __init fw_cfg_io_probe(void)
> > +{
> > +	char sig[FW_CFG_SIG_SIZE];
> > +
> > +	for (fw_cfg_mode = &fw_cfg_modes[0];
> > +	     fw_cfg_mode->start; fw_cfg_mode++) {
> > +
> > +		phys_addr_t start = fw_cfg_mode->start;
> > +		uint8_t size = fw_cfg_mode->size;
> > +
> > +		/* reserve and map mmio or ioport region */
> > +		if (fw_cfg_mode->is_mmio) {
> > +			if (!request_mem_region(start, size, fw_cfg_mode->name))
> > +				continue;
> > +			fw_cfg_dev_base = ioremap(start, size);
> > +			if (!fw_cfg_dev_base) {
> > +				release_mem_region(start, size);
> > +				continue;
> > +			}
> > +		} else {
> > +			if (!request_region(start, size, fw_cfg_mode->name))
> > +				continue;
> > +			fw_cfg_dev_base = ioport_map(start, size);
> > +			if (!fw_cfg_dev_base) {
> > +				release_region(start, size);
> > +				continue;
> > +			}
> > +		}
> > +
> > +		/* set control and data register addresses */
> > +		fw_cfg_dev_ctrl = fw_cfg_dev_base + fw_cfg_mode->ctrl_offset;
> > +		fw_cfg_dev_data = fw_cfg_dev_base + fw_cfg_mode->data_offset;
> > +
> > +		/* verify fw_cfg device signature */
> > +		fw_cfg_read_blob(FW_CFG_SIGNATURE, sig, 0, FW_CFG_SIG_SIZE);
> > +		if (memcmp(sig, "QEMU", FW_CFG_SIG_SIZE) == 0)
> > +			/* success, we're done */
> > +			return 0;
> > +
> > +		/* clean up before probing next access mode */
> > +		fw_cfg_io_cleanup();
> > +	}
> > +
> > +	return -ENODEV;
> > +}
> > +
> > +/* fw_cfg revision attribute, placed in top-level /sys/fw_cfg directory */
> > +static uint32_t fw_cfg_rev;
> > +
> > +static ssize_t fw_cfg_showrev(struct kobject *k, struct attribute *a, char *buf)
> > +{
> > +	return sprintf(buf, "%u\n", fw_cfg_rev);
> > +}
> > +
> > +static const struct {
> > +	struct attribute attr;
> > +	ssize_t (*show)(struct kobject *k, struct attribute *a, char *buf);
> > +} fw_cfg_rev_attr = {
> > +	.attr = { .name = "rev", .mode = S_IRUSR },
> > +	.show = fw_cfg_showrev,
> > +};
> > +
> > +/* fw_cfg_sysfs_entry type */
> > +struct fw_cfg_sysfs_entry {
> > +	struct kobject kobj;
> > +	struct fw_cfg_file f;
> > +	struct list_head list;
> > +};
> > +
> > +/* get fw_cfg_sysfs_entry from kobject member */
> > +static inline struct fw_cfg_sysfs_entry *to_entry(struct kobject *kobj)
> > +{
> > +	return container_of(kobj, struct fw_cfg_sysfs_entry, kobj);
> > +}
> > +
> > +/* fw_cfg_sysfs_attribute type */
> > +struct fw_cfg_sysfs_attribute {
> > +	struct attribute attr;
> > +	ssize_t (*show)(struct fw_cfg_sysfs_entry *entry, char *buf);
> > +};
> > +
> > +/* get fw_cfg_sysfs_attribute from attribute member */
> > +static inline struct fw_cfg_sysfs_attribute *to_attr(struct attribute *attr)
> > +{
> > +	return container_of(attr, struct fw_cfg_sysfs_attribute, attr);
> > +}
> > +
> > +/* global cache of fw_cfg_sysfs_entry objects */
> > +static LIST_HEAD(fw_cfg_entry_cache);
> > +
> > +/* kobjects removed lazily by kernel, mutual exclusion needed */
> > +static DEFINE_SPINLOCK(fw_cfg_cache_lock);
> > +
> > +static inline void fw_cfg_sysfs_cache_enlist(struct fw_cfg_sysfs_entry *entry)
> > +{
> > +	spin_lock(&fw_cfg_cache_lock);
> > +	list_add_tail(&entry->list, &fw_cfg_entry_cache);
> > +	spin_unlock(&fw_cfg_cache_lock);
> > +}
> > +
> > +static inline void fw_cfg_sysfs_cache_delist(struct fw_cfg_sysfs_entry *entry)
> > +{
> > +	spin_lock(&fw_cfg_cache_lock);
> > +	list_del(&entry->list);
> > +	spin_unlock(&fw_cfg_cache_lock);
> > +}
> > +
> > +static void fw_cfg_sysfs_cache_cleanup(void)
> > +{
> > +	struct fw_cfg_sysfs_entry *entry, *next;
> > +
> > +	list_for_each_entry_safe(entry, next, &fw_cfg_entry_cache, list) {
> > +		/* will end up invoking fw_cfg_sysfs_cache_delist()
> > +		 * via each object's release() method (i.e. destructor) */
> > +		kobject_put(&entry->kobj);
> > +	}
> > +}
> > +
> > +/* default_attrs: per-entry attributes and show methods */
> > +
> > +#define FW_CFG_SYSFS_ATTR(_attr) \
> > +struct fw_cfg_sysfs_attribute fw_cfg_sysfs_attr_##_attr = { \
> > +	.attr = { .name = __stringify(_attr), .mode = S_IRUSR }, \
> > +	.show = fw_cfg_sysfs_show_##_attr, \
> > +}
> > +
> > +static ssize_t fw_cfg_sysfs_show_size(struct fw_cfg_sysfs_entry *e, char *buf)
> > +{
> > +	return sprintf(buf, "%u\n", e->f.size);
> > +}
> > +
> > +static ssize_t fw_cfg_sysfs_show_select(struct fw_cfg_sysfs_entry *e, char *buf)
> > +{
> > +	return sprintf(buf, "%u\n", e->f.select);
> > +}
> > +
> > +static ssize_t fw_cfg_sysfs_show_name(struct fw_cfg_sysfs_entry *e, char *buf)
> > +{
> > +	return sprintf(buf, "%s\n", e->f.name);
> > +}
> > +
> > +static FW_CFG_SYSFS_ATTR(size);
> > +static FW_CFG_SYSFS_ATTR(select);
> > +static FW_CFG_SYSFS_ATTR(name);
> > +
> > +static struct attribute *fw_cfg_sysfs_entry_attrs[] = {
> > +	&fw_cfg_sysfs_attr_size.attr,
> > +	&fw_cfg_sysfs_attr_select.attr,
> > +	&fw_cfg_sysfs_attr_name.attr,
> > +	NULL,
> > +};
> > +
> > +/* sysfs_ops: find fw_cfg_[entry, attribute] and call appropriate show method */
> > +static ssize_t fw_cfg_sysfs_attr_show(struct kobject *kobj, struct attribute *a,
> > +				      char *buf)
> > +{
> > +	struct fw_cfg_sysfs_entry *entry = to_entry(kobj);
> > +	struct fw_cfg_sysfs_attribute *attr = to_attr(a);
> > +
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return -EACCES;
> 
> Shouldn't the file permissions handle this properly for you?
> 
> > +
> > +	return attr->show(entry, buf);
> > +}
> > +
> > +static const struct sysfs_ops fw_cfg_sysfs_attr_ops = {
> > +	.show = fw_cfg_sysfs_attr_show,
> > +};
> > +
> > +/* release: destructor, to be called via kobject_put() */
> > +static void fw_cfg_sysfs_release_entry(struct kobject *kobj)
> > +{
> > +	struct fw_cfg_sysfs_entry *entry = to_entry(kobj);
> > +
> > +	fw_cfg_sysfs_cache_delist(entry);
> > +	kfree(entry);
> > +}
> > +
> > +/* kobj_type: ties together all properties required to register an entry */
> > +static struct kobj_type fw_cfg_sysfs_entry_ktype = {
> > +	.default_attrs = fw_cfg_sysfs_entry_attrs,
> > +	.sysfs_ops = &fw_cfg_sysfs_attr_ops,
> > +	.release = fw_cfg_sysfs_release_entry,
> > +};
> > +
> > +/* raw-read method and attribute */
> > +static ssize_t fw_cfg_sysfs_read_raw(struct file *filp, struct kobject *kobj,
> > +				     struct bin_attribute *bin_attr,
> > +				     char *buf, loff_t pos, size_t count)
> > +{
> > +	struct fw_cfg_sysfs_entry *entry = to_entry(kobj);
> > +
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return -EACCES;
> 
> Again, file permissions?

In retrospect, you're right. I used another, existing sysfs driver as
inspiration, and this particular redundancy slipped through the cracks
during cleanup. I'll get rid of it for v2.

> 
> > +
> > +	if (pos > entry->f.size)
> > +		return -EINVAL;
> > +
> > +	if (count > entry->f.size - pos)
> > +		count = entry->f.size - pos;
> > +
> > +	fw_cfg_read_blob(entry->f.select, buf, pos, count);
> > +	return count;
> > +}
> > +
> > +static struct bin_attribute fw_cfg_sysfs_attr_raw = {
> > +	.attr = { .name = "raw", .mode = 0400 },
> > +	.read = fw_cfg_sysfs_read_raw,
> > +};
> > +
> > +/* kobjects & kset representing top-level, by_select, and by_name folders */
> > +static struct kobject *fw_cfg_top_ko;
> > +static struct kobject *fw_cfg_sel_ko;
> > +
> > +/* callback function to register an individual fw_cfg file */
> > +static int __init fw_cfg_register_file(const struct fw_cfg_file *f)
> > +{
> > +	int err;
> > +	struct fw_cfg_sysfs_entry *entry;
> > +
> > +	/* allocate new entry */
> > +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> > +	if (!entry)
> > +		return -ENOMEM;
> > +
> > +	/* set file entry information */
> > +	entry->f.size = be32_to_cpu(f->size);
> > +	entry->f.select = be16_to_cpu(f->select);
> > +	strcpy(entry->f.name, f->name);
> > +
> > +	/* register entry under "/sys/firmware/fw_cfg/by_select/" */
> > +	err = kobject_init_and_add(&entry->kobj, &fw_cfg_sysfs_entry_ktype,
> > +				   fw_cfg_sel_ko, "%d", entry->f.select);
> > +	if (err)
> > +		goto err_register;
> > +
> > +	/* add raw binary content access */
> > +	err = sysfs_create_bin_file(&entry->kobj, &fw_cfg_sysfs_attr_raw);
> > +	if (err)
> > +		goto err_add_raw;
> > +
> > +	/* success, add entry to global cache */
> > +	fw_cfg_sysfs_cache_enlist(entry);
> > +	return 0;
> > +
> > +err_add_raw:
> > +	kobject_del(&entry->kobj);
> > +err_register:
> > +	kfree(entry);
> > +	return err;
> > +}
> > +
> > +/* unregister top-level or by_select folder */
> > +static inline void fw_cfg_kobj_cleanup(struct kobject *kobj)
> > +{
> > +	kobject_del(kobj);
> > +	kobject_put(kobj);
> > +}
> > +
> > +static int __init fw_cfg_sysfs_init(void)
> > +{
> > +	int err;
> > +
> > +	/* probe for the fw_cfg "hardware" */
> > +	err = fw_cfg_io_probe();
> > +	if (err)
> > +		return err;
> > +
> > +	/* create /sys/firmware/fwcfg/ and its subdirectories */
> > +	err = -ENOMEM;
> > +	fw_cfg_top_ko = kobject_create_and_add("fw_cfg", firmware_kobj);
> > +	if (!fw_cfg_top_ko)
> > +		goto err_top;
> > +	fw_cfg_sel_ko = kobject_create_and_add("by_select", fw_cfg_top_ko);
> > +	if (!fw_cfg_sel_ko)
> > +		goto err_sel;
> > +
> > +	/* get revision number, add matching top-level attribute */
> > +	fw_cfg_read_blob(FW_CFG_ID, &fw_cfg_rev, 0, sizeof(fw_cfg_rev));
> > +	fw_cfg_rev = le32_to_cpu(fw_cfg_rev);
> > +	err = sysfs_create_file(fw_cfg_top_ko, &fw_cfg_rev_attr.attr);
> > +	if (err)
> > +		goto err_rev;
> > +
> > +	/* process fw_cfg file directory entry, registering each file */
> > +	err = fw_cfg_scan_dir(fw_cfg_register_file);
> 
> Dealing with all of these "raw" kobjecs makes me nervous.  Why can't you
> use 'struct device' for this instead, on the system bus?

I'll have to read up on 'struct device' to figure out why I would or
wouldn't want to do that instead -- sorry, still a n00b trying to
drink from the firehose :)

Mainly, qemu's fw_cfg is a read-only "device", so one wouldn't ever
care to try writing anything to it. /sys/firmware/... feels like a fit
because fw_cfg contains binary blobs originally meant to be used by
the bios (it's how SeaBIOS and OVMF pull smbios and acpi tables out of
the host and set them up in guest memory before booting the guest kernel,
as one of the many examples).

The most similar example (and the existing driver I used as an example
during implementation) is dmi-sysfs.c, which also exposes all the
metadata for each smbios table as numeric (or string) read-only attributes,
and has a "raw" attribute which allows dumping each table in its
entirety. Same thing here -- I want to expose the name, size, and
select key for each blob, but also allow access to the "payload", i.e.
the blob itself.

Thanks much for the feedback !
--Gabriel
