From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/4] firmware: use acpi to detect QEMU fw_cfg device
 for sysfs fw_cfg driver
Date: Sun, 4 Oct 2015 10:54:57 +0300
Message-ID: <20151004103555-mutt-send-email-mst@redhat.com>
References: <1443914889-9619-1-git-send-email-somlo@cmu.edu>
 <1443914889-9619-3-git-send-email-somlo@cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443914889-9619-3-git-send-email-somlo-D+Gtc/HYRWM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, paul-DWxLp4Yu+b8AvxtiuMwx3w@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernelnewbies-7JyXY6prKcjpASu1u0TL5ti2O/JbrIOy@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Oct 03, 2015 at 07:28:07PM -0400, Gabriel L. Somlo wrote:
> From: Gabriel Somlo <somlo-D+Gtc/HYRWM@public.gmane.org>
> 
> Instead of blindly probing fw_cfg registers at known IOport and MMIO
> locations, use the ACPI subsystem to determine whether a QEMU fw_cfg
> device is present, and, if found, to initialize it.
> 
> This limits portability to architectures which support ACPI (x86 and
> UEFI-enabled aarch64), but avoids touching hardware registers before
> being certain that our device is present.
> 
> NOTE: The standard way to verify the presence of fw_cfg on arm VMs
> would have been to use the device tree, but that would have left out
> x86, which is the primary architecture targeted by this patch.
> 
> Signed-off-by: Gabriel Somlo <somlo-D+Gtc/HYRWM@public.gmane.org>

IMHO it's not a good idea to probe registers provided
by CRS like this.
It seems quite reasonable that we'd want to add some
extra registers in the future, and this probing will break.

Further, accessing registers directly means that there's
no way to have ACPI code access them as that would
cause race conditions.

Maybe we should provide access methods in ACPI instead?


> ---
>  .../ABI/testing/sysfs-firmware-qemu_fw_cfg         |   4 +
>  drivers/firmware/Kconfig                           |   2 +-
>  drivers/firmware/qemu_fw_cfg.c                     | 201 +++++++++++----------
>  3 files changed, 113 insertions(+), 94 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg b/Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg
> index f1ef44e..e9761bf 100644
> --- a/Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg
> +++ b/Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg
> @@ -76,6 +76,10 @@ Description:
>  		the port number of the control register. I.e., the two ports
>  		are overlapping, and can not be mapped separately.
>  
> +		NOTE 2. QEMU publishes the register details in the device tree
> +		on arm guests, and in ACPI (under _HID "QEMU0002") on x86 and
> +		select arm (aarch64) VM types.
> +
>  		=== Firmware Configuration Items of Interest ===
>  
>  		Originally, the index key, size, and formatting of blobs in
> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> index 0466e80..bc12d31 100644
> --- a/drivers/firmware/Kconfig
> +++ b/drivers/firmware/Kconfig
> @@ -137,7 +137,7 @@ config ISCSI_IBFT
>  
>  config FW_CFG_SYSFS
>  	tristate "QEMU fw_cfg device support in sysfs"
> -	depends on SYSFS
> +	depends on SYSFS && ACPI
>  	default n
>  	help
>  	  Say Y or M here to enable the exporting of the QEMU firmware
> diff --git a/drivers/firmware/qemu_fw_cfg.c b/drivers/firmware/qemu_fw_cfg.c
> index 3a67a16..f935afb 100644
> --- a/drivers/firmware/qemu_fw_cfg.c
> +++ b/drivers/firmware/qemu_fw_cfg.c
> @@ -8,6 +8,7 @@
>   */
>  
>  #include <linux/module.h>
> +#include <linux/acpi.h>
>  #include <linux/slab.h>
>  #include <linux/io.h>
>  #include <linux/ioport.h>
> @@ -35,53 +36,10 @@ struct fw_cfg_file {
>  	char name[FW_CFG_MAX_FILE_PATH];
>  };
>  
> -/* fw_cfg device i/o access options type */
> -struct fw_cfg_access {
> -	const char *name;
> -	phys_addr_t base;
> -	u8 size;
> -	u8 ctrl_offset;
> -	u8 data_offset;
> -	bool is_mmio;
> -};
> -
> -/* table of fw_cfg device i/o access options for known architectures */
> -static struct fw_cfg_access fw_cfg_modes[] = {
> -	{
> -		.name = "fw_cfg IOport on i386, sun4u",
> -		.base = 0x510,
> -		.size = 0x02,
> -		.ctrl_offset = 0x00,
> -		.data_offset = 0x01,
> -		.is_mmio = false,
> -	}, {
> -		.name = "fw_cfg MMIO on arm",
> -		.base = 0x9020000,
> -		.size = 0x0a,
> -		.ctrl_offset = 0x08,
> -		.data_offset = 0x00,
> -		.is_mmio = true,
> -	}, {
> -		.name = "fw_cfg MMIO on sun4m",
> -		.base = 0xd00000510,
> -		.size = 0x03,
> -		.ctrl_offset = 0x00,
> -		.data_offset = 0x02,
> -		.is_mmio = true,
> -	}, {
> -		.name = "fw_cfg MMIO on ppc/mac",
> -		.base = 0xf0000510,
> -		.size = 0x03,
> -		.ctrl_offset = 0x00,
> -		.data_offset = 0x02,
> -		.is_mmio = true,
> -	}, { } /* END */
> -};
> -
> -/* fw_cfg device i/o currently selected option set */
> -static struct fw_cfg_access *fw_cfg_mode;
> -
>  /* fw_cfg device i/o register addresses */
> +static bool fw_cfg_is_mmio;
> +static phys_addr_t fw_cfg_phys_base;
> +static u32 fw_cfg_phys_size;
>  static void __iomem *fw_cfg_dev_base;
>  static void __iomem *fw_cfg_reg_ctrl;
>  static void __iomem *fw_cfg_reg_data;
> @@ -92,7 +50,7 @@ static DEFINE_MUTEX(fw_cfg_dev_lock);
>  /* pick appropriate endianness for selector key */
>  static inline u16 fw_cfg_sel_endianness(u16 key)
>  {
> -	return fw_cfg_mode->is_mmio ? cpu_to_be16(key) : cpu_to_le16(key);
> +	return fw_cfg_is_mmio ? cpu_to_be16(key) : cpu_to_le16(key);
>  }
>  
>  /* type for fw_cfg "directory scan" visitor/callback function */
> @@ -133,60 +91,100 @@ static inline void fw_cfg_read_blob(u16 key,
>  /* clean up fw_cfg device i/o */
>  static void fw_cfg_io_cleanup(void)
>  {
> -	if (fw_cfg_mode->is_mmio) {
> +	if (fw_cfg_is_mmio) {
>  		iounmap(fw_cfg_dev_base);
> -		release_mem_region(fw_cfg_mode->base, fw_cfg_mode->size);
> +		release_mem_region(fw_cfg_phys_base, fw_cfg_phys_size);
>  	} else {
>  		ioport_unmap(fw_cfg_dev_base);
> -		release_region(fw_cfg_mode->base, fw_cfg_mode->size);
> +		release_region(fw_cfg_phys_base, fw_cfg_phys_size);
>  	}
>  }
>  
> -/* probe and map fw_cfg device */
> -static int __init fw_cfg_io_probe(void)
> +/* configure fw_cfg device i/o from ACPI _CRS method */
> +static acpi_status fw_cfg_walk_crs(struct acpi_resource *r, void *context)
> +{
> +	struct acpi_resource_io *io;
> +	struct acpi_resource_fixed_memory32 *mmio;
> +
> +	switch (r->type) {
> +	case ACPI_RESOURCE_TYPE_END_TAG:
> +		return AE_OK;
> +	case ACPI_RESOURCE_TYPE_IO:
> +		io = &r->data.io;
> +		/* physical base addr should NOT be already set */
> +		if (fw_cfg_phys_base)
> +			return AE_ERROR;
> +		if (!request_region(io->minimum,
> +				    io->address_length, "fw_cfg_io"))
> +			return AE_ERROR;
> +		fw_cfg_dev_base = ioport_map(io->minimum, io->address_length);
> +		if (!fw_cfg_dev_base) {
> +			release_region(io->minimum, io->address_length);
> +			return AE_ERROR;
> +		}
> +		fw_cfg_phys_base = io->minimum;
> +		fw_cfg_phys_size = io->address_length;
> +		fw_cfg_is_mmio = false;
> +		/* set register addresses (pc/i386 offsets) */
> +		fw_cfg_reg_ctrl = fw_cfg_dev_base + 0x00;
> +		fw_cfg_reg_data = fw_cfg_dev_base + 0x01;
> +		return AE_OK;
> +	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
> +		mmio = &r->data.fixed_memory32;
> +		/* physical base addr should NOT be already set */
> +		if (fw_cfg_phys_base)
> +			return AE_ERROR;
> +		/* MMIO and ACPI, but not on ARM ?!?! */
> +		if (mmio->address_length < 0x0a)
> +			return AE_ERROR;
> +		if (!request_mem_region(mmio->address,
> +					mmio->address_length, "fw_cfg_mem"))
> +			return AE_ERROR;
> +		fw_cfg_dev_base = ioremap(mmio->address, mmio->address_length);
> +		if (!fw_cfg_dev_base) {
> +			release_mem_region(mmio->address, mmio->address_length);
> +			return AE_ERROR;
> +		}
> +		fw_cfg_phys_base = mmio->address;
> +		fw_cfg_phys_size = mmio->address_length;
> +		fw_cfg_is_mmio = true;
> +		/* set register addresses (arm offsets) */
> +		fw_cfg_reg_ctrl = fw_cfg_dev_base + 0x08;
> +		fw_cfg_reg_data = fw_cfg_dev_base + 0x00;
> +		return AE_OK;
> +	default:
> +		return AE_ERROR;
> +	}
> +}
> +
> +/* initialize fw_cfg device i/o from ACPI data */
> +static int fw_cfg_acpi_init(struct acpi_device *dev)
>  {
>  	char sig[FW_CFG_SIG_SIZE];
> +	acpi_status status;
> +	int err;
>  
> -	for (fw_cfg_mode = &fw_cfg_modes[0];
> -	     fw_cfg_mode->base; fw_cfg_mode++) {
> -
> -		phys_addr_t base = fw_cfg_mode->base;
> -		u8 size = fw_cfg_mode->size;
> -
> -		/* reserve and map mmio or ioport region */
> -		if (fw_cfg_mode->is_mmio) {
> -			if (!request_mem_region(base, size, fw_cfg_mode->name))
> -				continue;
> -			fw_cfg_dev_base = ioremap(base, size);
> -			if (!fw_cfg_dev_base) {
> -				release_mem_region(base, size);
> -				continue;
> -			}
> -		} else {
> -			if (!request_region(base, size, fw_cfg_mode->name))
> -				continue;
> -			fw_cfg_dev_base = ioport_map(base, size);
> -			if (!fw_cfg_dev_base) {
> -				release_region(base, size);
> -				continue;
> -			}
> -		}
> +	err = acpi_bus_get_status(dev);
> +	if (err < 0)
> +		return err;
>  
> -		/* set control and data register addresses */
> -		fw_cfg_reg_ctrl = fw_cfg_dev_base + fw_cfg_mode->ctrl_offset;
> -		fw_cfg_reg_data = fw_cfg_dev_base + fw_cfg_mode->data_offset;
> +	if (!(dev->status.enabled && dev->status.functional))
> +		return -ENODEV;
>  
> -		/* verify fw_cfg device signature */
> -		fw_cfg_read_blob(FW_CFG_SIGNATURE, sig, 0, FW_CFG_SIG_SIZE);
> -		if (memcmp(sig, "QEMU", FW_CFG_SIG_SIZE) == 0)
> -			/* success, we're done */
> -			return 0;
> +	/* extract device i/o details from _CRS */
> +	status = acpi_walk_resources(dev->handle, METHOD_NAME__CRS,
> +				     fw_cfg_walk_crs, NULL);
> +	if (status != AE_OK || !fw_cfg_phys_base)
> +		return -ENODEV;
>  
> -		/* clean up before probing next access mode */
> +	/* verify fw_cfg device signature */
> +	fw_cfg_read_blob(FW_CFG_SIGNATURE, sig, 0, FW_CFG_SIG_SIZE);
> +	if (memcmp(sig, "QEMU", FW_CFG_SIG_SIZE) != 0) {
>  		fw_cfg_io_cleanup();
> +		return -ENODEV;
>  	}
>  
> -	return -ENODEV;
> +	return 0;
>  }
>  
>  /* fw_cfg revision attribute, in /sys/firmware/qemu_fw_cfg top-level dir. */
> @@ -353,7 +351,7 @@ static struct kobject *fw_cfg_top_ko;
>  static struct kobject *fw_cfg_sel_ko;
>  
>  /* callback function to register an individual fw_cfg file */
> -static int __init fw_cfg_register_file(const struct fw_cfg_file *f)
> +static int fw_cfg_register_file(const struct fw_cfg_file *f)
>  {
>  	int err;
>  	struct fw_cfg_sysfs_entry *entry;
> @@ -397,12 +395,12 @@ static inline void fw_cfg_kobj_cleanup(struct kobject *kobj)
>  	kobject_put(kobj);
>  }
>  
> -static int __init fw_cfg_sysfs_init(void)
> +static int fw_cfg_sysfs_add(struct acpi_device *dev)
>  {
>  	int err;
>  
> -	/* probe for the fw_cfg "hardware" */
> -	err = fw_cfg_io_probe();
> +	/* initialize fw_cfg device i/o from ACPI data */
> +	err = fw_cfg_acpi_init(dev);
>  	if (err)
>  		return err;
>  
> @@ -443,14 +441,31 @@ err_top:
>  	return err;
>  }
>  
> -static void __exit fw_cfg_sysfs_exit(void)
> +static int fw_cfg_sysfs_remove(struct acpi_device *dev)
>  {
>  	pr_debug("fw_cfg: unloading.\n");
>  	fw_cfg_sysfs_cache_cleanup();
>  	fw_cfg_kobj_cleanup(fw_cfg_sel_ko);
>  	fw_cfg_kobj_cleanup(fw_cfg_top_ko);
>  	fw_cfg_io_cleanup();
> +	return 0;
>  }
>  
> -module_init(fw_cfg_sysfs_init);
> -module_exit(fw_cfg_sysfs_exit);
> +static const struct acpi_device_id fw_cfg_sysfs_device_ids[] = {
> +	{ "QEMU0002", 0 },
> +	{ "", 0 },
> +};
> +MODULE_DEVICE_TABLE(acpi, fw_cfg_sysfs_device_ids);
> +
> +static struct acpi_driver fw_cfg_sysfs_driver = {
> +	.name =		"fw_cfg",
> +	.class =	"QEMU",
> +	.ids =		fw_cfg_sysfs_device_ids,
> +	.ops =		{
> +				.add =		fw_cfg_sysfs_add,
> +				.remove =	fw_cfg_sysfs_remove,
> +			},
> +	.owner =	THIS_MODULE,
> +};
> +
> +module_acpi_driver(fw_cfg_sysfs_driver);
> -- 
> 2.4.3
