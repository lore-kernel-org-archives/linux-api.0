From: "Ivan.khoronzhuk" <ivan.khoronzhuk@globallogic.com>
Subject: Re: [dmidecode] [Patch v4] firmware: dmi-sysfs: add SMBIOS entry
 point area attribute
Date: Wed, 04 Mar 2015 14:30:31 +0200
Message-ID: <54F6FAE7.30801@globallogic.com>
References: <1423069563-26467-1-git-send-email-ivan.khoronzhuk@linaro.org> <20150226103622.09b9870a@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150226103622.09b9870a@endymion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
To: Jean Delvare <jdelvare@suse.de>, Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, grant.likely@linaro.org, matt.fleming@intel.com, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, dmidecode-devel@nongnu.org, leif.lindholm@linaro.org, msalter@redhat.com
List-Id: linux-api@vger.kernel.org


On 02/26/2015 11:36 AM, Jean Delvare wrote:
> Hi Ivan,
>
> Sorry for the late review.
>
> On Wed,  4 Feb 2015 19:06:03 +0200, Ivan Khoronzhuk wrote:
>> Some utils, like dmidecode and smbios, need to access SMBIOS entry
>> table area in order to get information like SMBIOS version, size, etc.
>> Currently it's done via /dev/mem. But for situation when /dev/mem
>> usage is disabled, the utils have to use dmi sysfs instead, which
>> doesn't represent SMBIOS entry. So this patch adds SMBIOS area to
>> dmi-sysfs in order to allow utils in question to work correctly with
>> dmi sysfs interface.
>>
>> Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> ---
>>
>> v1: https://lkml.org/lkml/2015/1/23/643
>> v2: https://lkml.org/lkml/2015/1/26/345
>> v3: https://lkml.org/lkml/2015/1/28/768
>>
>> v4..v2:
> Please always provide a list of changes from the previous version of
> the patch, otherwise it's quite confusing.

Typo v4..v2 -> v4..v3

>
>>    firmware: dmi_scan: add symbol to get SMBIOS entry area
>>    	- used u8 type for smbios_header var
>>    firmware: dmi-sysfs: add SMBIOS entry point area attribute
>>    	- replaced -ENODATA on -EINVAL
>>
>> v3..v2:
>>    firmware: dmi_scan: add symbol to get SMBIOS entry area
>>    firmware: dmi-sysfs: add SMBIOS entry point area attribute
>> 	- combined in one patch
>> 	- added SMBIOS information to ABI sysfs-dmi documentaton
>>
>> v2..v1:
>>    firmware: dmi_scan: add symbol to get SMBIOS entry area
>> 	- used additional static var to hold SMBIOS raw table size
>> 	- changed format of get_smbios_entry_area symbol
>> 	  returned pointer on const smbios table
>>
>>    firmware: dmi-sysfs: add SMBIOS entry point area attribute
>> 	- adopted to updated get_smbios_entry_area symbol
>>    	- removed redundant array to save smbios table
>>
>>   Documentation/ABI/testing/sysfs-firmware-dmi | 10 +++++++
>>   drivers/firmware/dmi-sysfs.c                 | 42 ++++++++++++++++++++++++++++
>>   drivers/firmware/dmi_scan.c                  | 26 +++++++++++++++++
>>   include/linux/dmi.h                          |  3 ++
>>   4 files changed, 81 insertions(+)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-firmware-dmi b/Documentation/ABI/testing/sysfs-firmware-dmi
>> index c78f9ab..3a9ffe8 100644
>> --- a/Documentation/ABI/testing/sysfs-firmware-dmi
>> +++ b/Documentation/ABI/testing/sysfs-firmware-dmi
>> @@ -12,6 +12,16 @@ Description:
>>   		cannot ensure that the data as exported to userland is
>>   		without error either.
>>   
>> +		The firmware provides DMI structures as a packed list of
>> +		data referenced by a SMBIOS table entry point. The SMBIOS
>> +		entry point contains general information, like SMBIOS
>> +		version, DMI table size, etc. The structure, content and
>> +		size of SMBIOS entry point is dependent on SMBIOS version.
>> +		That's why SMBIOS entry point is represented in dmi sysfs
>> +		like a raw attribute and is accessible via
>> +		/sys/firmware/dmi/smbios_raw_header. The format of SMBIOS
> As mentioned before, I don't like the name "smbios_raw_header". I think
> it should be "smbios_entry_point" or similar.

If Matt is OK to get another version,
Let it be smbios_entry_point.
If it's more convenient, it should be changed while it's possible.

>
>> +		entry point header can be read in SMBIOS specification.
>> +
>>   		DMI is structured as a large table of entries, where
>>   		each entry has a common header indicating the type and
>>   		length of the entry, as well as a firmware-provided
>> diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
>> index e0f1cb3..9b396d7 100644
>> --- a/drivers/firmware/dmi-sysfs.c
>> +++ b/drivers/firmware/dmi-sysfs.c
>> @@ -29,6 +29,8 @@
>>   #define MAX_ENTRY_TYPE 255 /* Most of these aren't used, but we consider
>>   			      the top entry type is only 8 bits */
>>   
>> +static const u8 *smbios_raw_header;
>> +
>>   struct dmi_sysfs_entry {
>>   	struct dmi_header dh;
>>   	struct kobject kobj;
>> @@ -646,9 +648,37 @@ static void cleanup_entry_list(void)
>>   	}
>>   }
>>   
>> +static ssize_t smbios_entry_area_raw_read(struct file *filp,
> This is confusing again, now it's named "entry_area"? Please be
> consistent and use entry_point everywhere.
>
> As mentioned before I believe that this code should live in dmi_scan
> and not dmi-sysfs.
>
>> +					  struct kobject *kobj,
>> +					  struct bin_attribute *bin_attr,
>> +					  char *buf, loff_t pos, size_t count)
>> +{
>> +	ssize_t size;
>> +
>> +	size = bin_attr->size;
>> +
>> +	if (size > pos)
>> +		size -= pos;
>> +	else
>> +		return 0;
>> +
>> +	if (count < size)
>> +		size = count;
>> +
>> +	memcpy(buf, &smbios_raw_header[pos], size);
>> +
>> +	return size;
>> +}
>> +
>> +static struct bin_attribute smbios_raw_area_attr = {
>> +	.read = smbios_entry_area_raw_read,
>> +	.attr = {.name = "smbios_raw_header", .mode = 0400},
>> +};
>> +
>>   static int __init dmi_sysfs_init(void)
>>   {
>>   	int error = -ENOMEM;
>> +	int size;
>>   	int val;
>>   
>>   	/* Set up our directory */
>> @@ -669,6 +699,18 @@ static int __init dmi_sysfs_init(void)
>>   		goto err;
>>   	}
>>   
>> +	smbios_raw_header = dmi_get_smbios_entry_area(&size);
>> +	if (!smbios_raw_header) {
>> +		pr_debug("dmi-sysfs: SMBIOS raw data is not available.\n");
>> +		error = -EINVAL;
>> +		goto err;
>> +	}
> I don't think this should have been a fatal error. Just because for
> some reason dmi_get_smbios_entry_area() returned NULL is no good reason
> for nor exposing /sys/firmware/dmi/entries as we used to.

It issues an error only in case of when entry table is not available,
if entry point is absent then dmi table is not available a fortiori.
So there is no reason to continue from that point.

> But anyway this is no longer relevant if the code is moved to dmi_scan
> as I suggested.
>
>> +
>> +	/* Create the raw binary file to access the entry area */
>> +	smbios_raw_area_attr.size = size;
>> +	if (sysfs_create_bin_file(dmi_kobj, &smbios_raw_area_attr))
>> +		goto err;
> I think this should have had a corresponding call to
> sysfs_remove_bin_file() in dmi_sysfs_exit(). (Again no longer relevant
> if the code is moved.)

The removing is done in kobject_del().
Doesn't it? In another way it should be done for
dmi/entries/*/raw attributes also.

>> +
>>   	pr_debug("dmi-sysfs: loaded.\n");
>>   
>>   	return 0;
>> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
>> index 420c8d8..99c5f6c 100644
>> --- a/drivers/firmware/dmi_scan.c
>> +++ b/drivers/firmware/dmi_scan.c
>> @@ -113,6 +113,8 @@ static void dmi_table(u8 *buf, int len, int num,
>>   	}
>>   }
>>   
>> +static u8 smbios_header[32];
>> +static int smbios_header_size;
>>   static phys_addr_t dmi_base;
>>   static u16 dmi_len;
>>   static u16 dmi_num;
>> @@ -474,6 +476,8 @@ static int __init dmi_present(const u8 *buf)
>>   	if (memcmp(buf, "_SM_", 4) == 0 &&
>>   	    buf[5] < 32 && dmi_checksum(buf, buf[5])) {
>>   		smbios_ver = get_unaligned_be16(buf + 6);
>> +		smbios_header_size = buf[5];
>> +		memcpy(smbios_header, buf, smbios_header_size);
>>   
>>   		/* Some BIOS report weird SMBIOS version, fix that up */
>>   		switch (smbios_ver) {
>> @@ -505,6 +509,8 @@ static int __init dmi_present(const u8 *buf)
>>   				pr_info("SMBIOS %d.%d present.\n",
>>   				       dmi_ver >> 8, dmi_ver & 0xFF);
>>   			} else {
>> +				smbios_header_size = 15;
>> +				memcpy(smbios_header, buf, smbios_header_size);
>>   				dmi_ver = (buf[14] & 0xF0) << 4 |
>>   					   (buf[14] & 0x0F);
>>   				pr_info("Legacy DMI %d.%d present.\n",
>> @@ -531,6 +537,8 @@ static int __init dmi_smbios3_present(const u8 *buf)
>>   		dmi_ver &= 0xFFFFFF;
>>   		dmi_len = get_unaligned_le32(buf + 12);
>>   		dmi_base = get_unaligned_le64(buf + 16);
>> +		smbios_header_size = buf[6];
>> +		memcpy(smbios_header, buf, smbios_header_size);
>>   
>>   		/*
>>   		 * The 64-bit SMBIOS 3.0 entry point no longer has a field
>> @@ -944,3 +952,21 @@ void dmi_memdev_name(u16 handle, const char **bank, const char **device)
>>   	}
>>   }
>>   EXPORT_SYMBOL_GPL(dmi_memdev_name);
>> +
>> +/**
>> + * dmi_get_smbios_entry_area - copy SMBIOS entry point area to array.
>> + * @size - pointer to assign actual size of SMBIOS entry point area.
>> + *
>> + * returns NULL if table is not available, otherwise returns pointer on
>> + * SMBIOS entry point area array.
>> + */
>> +const u8 *dmi_get_smbios_entry_area(int *size)
>> +{
>> +	if (!smbios_header_size || !dmi_available)
> I don't see why you need to check for !dmi_available. If
> smbios_header_size is non-zero then the required data is available. It
> is independent from dmi_walk_early() having succeeded or not.

Probably you are right.
It's better to check only smbios_header_size.

>
> If you really believe that this function should return NULL if
> dmi_walk_early() failed (I don't), then you should be consistent and
> only fill up smbios_header after dmi_walk_early() has been successfully
> called.
>
>> +		return NULL;
>> +
>> +	*size = smbios_header_size;
>> +
>> +	return smbios_header;
>> +}
>> +EXPORT_SYMBOL_GPL(dmi_get_smbios_entry_area);
>> diff --git a/include/linux/dmi.h b/include/linux/dmi.h
>> index f820f0a..8e1a28d 100644
>> --- a/include/linux/dmi.h
>> +++ b/include/linux/dmi.h
>> @@ -109,6 +109,7 @@ extern int dmi_walk(void (*decode)(const struct dmi_header *, void *),
>>   	void *private_data);
>>   extern bool dmi_match(enum dmi_field f, const char *str);
>>   extern void dmi_memdev_name(u16 handle, const char **bank, const char **device);
>> +const u8 *dmi_get_smbios_entry_area(int *size);
>>   
>>   #else
>>   
>> @@ -140,6 +141,8 @@ static inline void dmi_memdev_name(u16 handle, const char **bank,
>>   		const char **device) { }
>>   static inline const struct dmi_system_id *
>>   	dmi_first_match(const struct dmi_system_id *list) { return NULL; }
>> +static inline const u8 *dmi_get_smbios_entry_area(int *size)
>> +	{ return NULL; }
>>   
>>   #endif
>>   
> There's one thing I do not understand. I seem to understand that the
> goal behind this patch is to be able to run dmidecode without /dev/mem.
> Dmidecode currently reads 2 areas from /dev/mem: the 0xF0000-0xFFFFF
> area in search of the entry point, and the DMI data table itself. With
> this patch you make the entry point available through sysfs. But
> dmidecode will still need to access /dev/mem to access the DMI data
> table. So that does not really solve anything, does it?

It's supposed to read DMI table via entries presented by dmi-sysfs.
It contains raw attributes that can be used for these purposes.
No need to use /dev/mem.

Another case if you want to add binary of whole dmi table to be able to
read it directly in order to parse in dmidecode w/o any additional headache
with open/close. Well, it partly dupes currently present dmi-sysfs.
But it simplifies dmi table parsing for dmidecode, and who wants to use
dmi-sysfs, let them use it, but dmidecode will be reading raw entry.
Well let it be. Why not.

If others are OK, for dmidecode, and probably others tools also,
kernel can constantly expose two tables under /sys/firmware/dmi/tables/
smbios_entry_point and dmi_table. Independently on dmi-sysfs.


>
> If we expose the raw DMI/SMBIOS entry point through sysfs, I believe we
> want to expose the DMI table there too.
>
> Thanks,

-- 
Regards,
Ivan Khoronzhuk
