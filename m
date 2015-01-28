From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [dmidecode] [Patch v3] firmware: dmi-sysfs: add SMBIOS entry
 point area raw attribute
Date: Wed, 28 Jan 2015 17:56:25 +0200
Message-ID: <54C906A9.1050001@linaro.org>
References: <1422448763-17583-1-git-send-email-ivan.khoronzhuk@linaro.org>
Reply-To: dmidecode-devel@nongnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dmidecode-devel-bounces+ghsdd-dmidecode-devel=m.gmane.org@nongnu.org>
In-Reply-To: <1422448763-17583-1-git-send-email-ivan.khoronzhuk@linaro.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/dmidecode-devel>,
	<mailto:dmidecode-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/dmidecode-devel>
List-Post: <mailto:dmidecode-devel@nongnu.org>
List-Help: <mailto:dmidecode-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/dmidecode-devel>,
	<mailto:dmidecode-devel-request@nongnu.org?subject=subscribe>
Errors-To: dmidecode-devel-bounces+ghsdd-dmidecode-devel=m.gmane.org@nongnu.org
Sender: dmidecode-devel-bounces+ghsdd-dmidecode-devel=m.gmane.org@nongnu.org
To: linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, grant.likely@linaro.org, matt.fleming@intel.com, linux-api@vger.kernel.org, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Cc: dmidecode-devel@nongnu.org, leif.lindholm@linaro.org
List-Id: linux-api@vger.kernel.org

+ linux-api@vger.kernel.org
+ linux-doc@vger.kernel.org

On 01/28/2015 02:39 PM, Ivan Khoronzhuk wrote:
> Some utils, like dmidecode and smbios, needs to access SMBIOS entry
> table area in order to get information like SMBIOS version, size, etc.
> Currently it's done via /dev/mem. But for situation when /dev/mem
> usage is disabled, the utils have to use dmi sysfs instead, which
> doesn't represent SMBIOS entry. So this patch adds SMBIOS area to
> dmi-sysfs in order to allow utils in question to work correctly with
> dmi sysfs interface.
>
> Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>
> v1: https://lkml.org/lkml/2015/1/23/643
> v2: https://lkml.org/lkml/2015/1/26/345
>
> v3..v2:
>    firmware: dmi_scan: add symbol to get SMBIOS entry area
>    firmware: dmi-sysfs: add SMBIOS entry point area attribute
> 	combined in one patch
> 	added SMBIOS information to ABI sysfs-dmi documentaton
>
> v2..v1:
>    firmware: dmi_scan: add symbol to get SMBIOS entry area
> 	- used additional static var to hold SMBIOS raw table size
> 	- changed format of get_smbios_entry_area symbol
> 	  returned pointer on const smbios table
>
>    firmware: dmi-sysfs: add SMBIOS entry point area attribute
> 	- adopted to updated get_smbios_entry_area symbol
>    	- removed redundant array to save smbios table
>
>
>   Documentation/ABI/testing/sysfs-firmware-dmi | 10 +++++++
>   drivers/firmware/dmi-sysfs.c                 | 42 ++++++++++++++++++++++++++++
>   drivers/firmware/dmi_scan.c                  | 26 +++++++++++++++++
>   include/linux/dmi.h                          |  3 ++
>   4 files changed, 81 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-firmware-dmi b/Documentation/ABI/testing/sysfs-firmware-dmi
> index c78f9ab..3a9ffe8 100644
> --- a/Documentation/ABI/testing/sysfs-firmware-dmi
> +++ b/Documentation/ABI/testing/sysfs-firmware-dmi
> @@ -12,6 +12,16 @@ Description:
>   		cannot ensure that the data as exported to userland is
>   		without error either.
>   
> +		The firmware provides DMI structures as a packed list of
> +		data referenced by a SMBIOS table entry point. The SMBIOS
> +		entry point contains general information, like SMBIOS
> +		version, DMI table size, etc. The structure, content and
> +		size of SMBIOS entry point is dependent on SMBIOS version.
> +		That's why SMBIOS entry point is represented in dmi sysfs
> +		like a raw attribute and is accessible via
> +		/sys/firmware/dmi/smbios_raw_header. The format of SMBIOS
> +		entry point header can be read in SMBIOS specification.
> +
>   		DMI is structured as a large table of entries, where
>   		each entry has a common header indicating the type and
>   		length of the entry, as well as a firmware-provided
> diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
> index e0f1cb3..61b6a38 100644
> --- a/drivers/firmware/dmi-sysfs.c
> +++ b/drivers/firmware/dmi-sysfs.c
> @@ -29,6 +29,8 @@
>   #define MAX_ENTRY_TYPE 255 /* Most of these aren't used, but we consider
>   			      the top entry type is only 8 bits */
>   
> +static const u8 *smbios_raw_header;
> +
>   struct dmi_sysfs_entry {
>   	struct dmi_header dh;
>   	struct kobject kobj;
> @@ -646,9 +648,37 @@ static void cleanup_entry_list(void)
>   	}
>   }
>   
> +static ssize_t smbios_entry_area_raw_read(struct file *filp,
> +					  struct kobject *kobj,
> +					  struct bin_attribute *bin_attr,
> +					  char *buf, loff_t pos, size_t count)
> +{
> +	ssize_t size;
> +
> +	size = bin_attr->size;
> +
> +	if (size > pos)
> +		size -= pos;
> +	else
> +		return 0;
> +
> +	if (count < size)
> +		size = count;
> +
> +	memcpy(buf, &smbios_raw_header[pos], size);
> +
> +	return size;
> +}
> +
> +static struct bin_attribute smbios_raw_area_attr = {
> +	.read = smbios_entry_area_raw_read,
> +	.attr = {.name = "smbios_raw_header", .mode = 0400},
> +};
> +
>   static int __init dmi_sysfs_init(void)
>   {
>   	int error = -ENOMEM;
> +	int size;
>   	int val;
>   
>   	/* Set up our directory */
> @@ -669,6 +699,18 @@ static int __init dmi_sysfs_init(void)
>   		goto err;
>   	}
>   
> +	smbios_raw_header = dmi_get_smbios_entry_area(&size);
> +	if (!smbios_raw_header) {
> +		pr_debug("dmi-sysfs: SMBIOS raw data is not available.\n");
> +		error = -ENODATA;
> +		goto err;
> +	}
> +
> +	/* Create the raw binary file to access the entry area */
> +	smbios_raw_area_attr.size = size;
> +	if (sysfs_create_bin_file(dmi_kobj, &smbios_raw_area_attr))
> +		goto err;
> +
>   	pr_debug("dmi-sysfs: loaded.\n");
>   
>   	return 0;
> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> index 420c8d8..d94c6b7 100644
> --- a/drivers/firmware/dmi_scan.c
> +++ b/drivers/firmware/dmi_scan.c
> @@ -113,6 +113,8 @@ static void dmi_table(u8 *buf, int len, int num,
>   	}
>   }
>   
> +static unsigned char smbios_header[32];
> +static int smbios_header_size;
>   static phys_addr_t dmi_base;
>   static u16 dmi_len;
>   static u16 dmi_num;
> @@ -474,6 +476,8 @@ static int __init dmi_present(const u8 *buf)
>   	if (memcmp(buf, "_SM_", 4) == 0 &&
>   	    buf[5] < 32 && dmi_checksum(buf, buf[5])) {
>   		smbios_ver = get_unaligned_be16(buf + 6);
> +		smbios_header_size = buf[5];
> +		memcpy(smbios_header, buf, smbios_header_size);
>   
>   		/* Some BIOS report weird SMBIOS version, fix that up */
>   		switch (smbios_ver) {
> @@ -505,6 +509,8 @@ static int __init dmi_present(const u8 *buf)
>   				pr_info("SMBIOS %d.%d present.\n",
>   				       dmi_ver >> 8, dmi_ver & 0xFF);
>   			} else {
> +				smbios_header_size = 15;
> +				memcpy(smbios_header, buf, smbios_header_size);
>   				dmi_ver = (buf[14] & 0xF0) << 4 |
>   					   (buf[14] & 0x0F);
>   				pr_info("Legacy DMI %d.%d present.\n",
> @@ -531,6 +537,8 @@ static int __init dmi_smbios3_present(const u8 *buf)
>   		dmi_ver &= 0xFFFFFF;
>   		dmi_len = get_unaligned_le32(buf + 12);
>   		dmi_base = get_unaligned_le64(buf + 16);
> +		smbios_header_size = buf[6];
> +		memcpy(smbios_header, buf, smbios_header_size);
>   
>   		/*
>   		 * The 64-bit SMBIOS 3.0 entry point no longer has a field
> @@ -944,3 +952,21 @@ void dmi_memdev_name(u16 handle, const char **bank, const char **device)
>   	}
>   }
>   EXPORT_SYMBOL_GPL(dmi_memdev_name);
> +
> +/**
> + * dmi_get_smbios_entry_area - copy SMBIOS entry point area to array.
> + * @size - pointer to assign actual size of SMBIOS entry point area.
> + *
> + * returns NULL if table is not available, otherwise returns pointer on
> + * SMBIOS entry point area array.
> + */
> +const u8 *dmi_get_smbios_entry_area(int *size)
> +{
> +	if (!smbios_header_size || !dmi_available)
> +		return NULL;
> +
> +	*size = smbios_header_size;
> +
> +	return smbios_header;
> +}
> +EXPORT_SYMBOL_GPL(dmi_get_smbios_entry_area);
> diff --git a/include/linux/dmi.h b/include/linux/dmi.h
> index f820f0a..8e1a28d 100644
> --- a/include/linux/dmi.h
> +++ b/include/linux/dmi.h
> @@ -109,6 +109,7 @@ extern int dmi_walk(void (*decode)(const struct dmi_header *, void *),
>   	void *private_data);
>   extern bool dmi_match(enum dmi_field f, const char *str);
>   extern void dmi_memdev_name(u16 handle, const char **bank, const char **device);
> +const u8 *dmi_get_smbios_entry_area(int *size);
>   
>   #else
>   
> @@ -140,6 +141,8 @@ static inline void dmi_memdev_name(u16 handle, const char **bank,
>   		const char **device) { }
>   static inline const struct dmi_system_id *
>   	dmi_first_match(const struct dmi_system_id *list) { return NULL; }
> +static inline const u8 *dmi_get_smbios_entry_area(int *size)
> +	{ return NULL; }
>   
>   #endif
>   


_______________________________________________
https://lists.nongnu.org/mailman/listinfo/dmidecode-devel
