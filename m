From: "Ivan.khoronzhuk" <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Subject: Re: [Patch] firmware: dmi_scan: split dmisubsystem from dmi-sysfs
Date: Thu, 19 Mar 2015 19:35:34 +0200
Message-ID: <550B08E6.5050200@globallogic.com>
References: <1426539451-2119-1-git-send-email-ivan.khoronzhuk@globallogic.com> <1426779055.4267.1907.camel@chaos.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426779055.4267.1907.camel-H7Kp9ZFCxt/N0uC3ymp8PA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dmidecode-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 19.03.15 17:30, Jean Delvare wrote:
> Hi Ivan,
>
> Le Monday 16 March 2015 =C3=A0 22:57 +0200, Ivan Khoronzhuk a =C3=A9c=
rit :
>> Some utils, like dmidecode and smbios, need to access SMBIOS entry
>> table area in order to get information like SMBIOS version, size, et=
c.
>> Currently it's done via /dev/mem. But for situation when /dev/mem
>> usage is disabled, the utils have to use dmi sysfs instead, which
>> doesn't represent SMBIOS entry and adds code/delay redundancy when d=
irect
>> access for table is needed.
>>
>> So this patch creates dmi subsystem and adds SMBIOS entry point to a=
llow
>> utils in question to work correctly without /dev/mem. Also patch add=
s
>> raw dmi table to simplify dmi table processing in user space, as wer=
e
>> proposed by Jean Delvare.
> "as was proposed" or even "as proposed" sounds more correct.
>
> BTW, which tree is your patch based on? I can't get it to apply clean=
ly
> on top of any kernel version I tried. I adjusted the patch to my tree
> but it means I'm not reviewing your code exactly. Please send patches
> which can be applied on top of some recent vanilla tree (3.19 or 4.0-=
rc4
> would be OK at the moment.)

Oh, sorry I forgot to mention, it's based on efi/next, but with consump=
tion
that Matt will remove old version:
  85c83ea firmware: dmi-sysfs: Add SMBIOS entry point area attribute

As you remember, your propositions were slightly late,
and patch had been applied on efi/next when you commented.

Matt, Could you please remove old version.
I hope it will be replaced by new one.

>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
>> ---
>>
>> This patch is logical continuation of
>> "[dmidecode] [Patch v4] firmware: dmi-sysfs: add SMBIOS entry point =
area attribute"
>> https://lkml.org/lkml/2015/2/4/475
>>
>> Pay attention that this includes /sys/firmware/dmi for holding table=
s instead of
>> /sys/firmware/dmi/table as were proposed.
> Why is that? I proposed /sys/firmware/dmi/tables because the acpi
> subsystem puts its own tables in /sys/firmware/acpi/tables. It seemed
> reasonable to follow that example for consistency. What is your reaso=
n
> for doing it differently?

I just like it more instead of catalog/catalog/catalog...
But it's only proposition. Let's it be under tables.

>
>>   Documentation/ABI/testing/sysfs-firmware-dmi       | 122 +++------=
------------
>>   .../ABI/testing/sysfs-firmware-dmi-entries         | 110 +++++++++=
++++++++++
> This is adding a lot of noise to your patch, making it harder to revi=
ew
> and backport. If you think that the contents of sysfs-firmware-dmi wo=
uld
> rather go in a documentation file named sysfs-firmware-dmi-entries, I
> have no objection, but it should be done in a separate patch.

yes.

>>   drivers/firmware/dmi-sysfs.c                       |  12 +-
>>   drivers/firmware/dmi_scan.c                        | 115 +++++++++=
++++++++--
>>   include/linux/dmi.h                                |   2 +
>>   5 files changed, 238 insertions(+), 123 deletions(-)
>>   create mode 100644 Documentation/ABI/testing/sysfs-firmware-dmi-en=
tries
>>
>> diff --git a/Documentation/ABI/testing/sysfs-firmware-dmi b/Document=
ation/ABI/testing/sysfs-firmware-dmi
>> index c78f9ab..6413128 100644
>> --- a/Documentation/ABI/testing/sysfs-firmware-dmi
>> +++ b/Documentation/ABI/testing/sysfs-firmware-dmi
>> @@ -1,110 +1,16 @@
>>   What:		/sys/firmware/dmi/
>> -Date:		February 2011
>> -Contact:	Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> +Date:		March 2015
>> +Contact:	Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
>>   Description:
>> (...)
>> +		The firmware provides DMI structures as a packed list of
>> +		data referenced by a SMBIOS table entry point. The SMBIOS
>> +		entry point contains general information, like SMBIOS
>> +		version, DMI table size, etc. The structure, content and
>> +		size of SMBIOS entry point is dependent on SMBIOS version.
>> +		That's why SMBIOS entry point is represented in dmi sysfs
>> +		like a raw attribute and is accessible via
>> +		/sys/firmware/dmi/smbios_entry_point. The format of SMBIOS
>> +		entry point header can be read in SMBIOS specification.
>> +		To simplify access and processing delay in user space,
> "processing delay" doesn't really describe the problem that was prese=
nt
> with the previous patch set. It was more a problem of processing time=
,
> CPU and memory usage, and code complexity. Anyway I see no reason to
> explain that here, given that this proposal was rejected.
>
> You'd rather just explain that the raw data is provided through sysfs=
 as
> an alternative to utilities reading them from /dev/mem (as you alread=
y
> correctly explain in the patch description.) That's what your new pat=
ch
> is all about.

yes

>
>> +		subsystem provides also raw dmi table under
> DMI better spelled capitalized. I'd also avoid mentioning "subsystem"=
,
> I'm not sure why you're using that word (and also in the subject), sy=
sfs
> is a virtual file system, and there is no such thing as a "dmi

dmi -> DMI.
According subsystem, it was erroneously noticed from efi.c.
It seems confusing to me too, let avoid it.

> subsystem".
>
>> +		/sys/firmware/dmi/dmi_table.
> As said before I'd make it /sys/firmware/dmi/tables/DMI to mimic what
> acpi does.
>
>> diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sys=
fs.c
>> index e0f1cb3..390067d 100644
>> --- a/drivers/firmware/dmi-sysfs.c
>> +++ b/drivers/firmware/dmi-sysfs.c
>> @@ -566,7 +566,6 @@ static struct kobj_type dmi_sysfs_entry_ktype =3D=
 {
>>   	.default_attrs =3D dmi_sysfs_entry_attrs,
>>   };
>>  =20
>> -static struct kobject *dmi_kobj;
>>   static struct kset *dmi_kset;
>>  =20
>>   /* Global count of all instances seen.  Only for setup */
>> @@ -651,10 +650,10 @@ static int __init dmi_sysfs_init(void)
>>   	int error =3D -ENOMEM;
>>   	int val;
>>  =20
>> -	/* Set up our directory */
>> -	dmi_kobj =3D kobject_create_and_add("dmi", firmware_kobj);
>> -	if (!dmi_kobj)
>> -		goto err;
>> +	if (!dmi_kobj) {
>> +		pr_err("dmi-sysfs: dmi subsysterm is absent.\n");
> Typo: subsystem. Then again the use of this word keeps confusing me, =
but
> it's a minor thing.
>
>> +		return -EINVAL;
> The original code had a single error path and I see no reason to chan=
ge
> that. -EINVAL seems inappropriate for this case, I'd rather return
> -ENOSYS.

ENOSYS better.

>
>> +	}
>>  =20
>>   	dmi_kset =3D kset_create_and_add("entries", NULL, dmi_kobj);
>>   	if (!dmi_kset)
>> @@ -675,7 +674,6 @@ static int __init dmi_sysfs_init(void)
>>   err:
>>   	cleanup_entry_list();
>>   	kset_unregister(dmi_kset);
>> -	kobject_put(dmi_kobj);
>>   	return error;
>>   }
>>  =20
>> @@ -685,8 +683,6 @@ static void __exit dmi_sysfs_exit(void)
>>   	pr_debug("dmi-sysfs: unloading.\n");
>>   	cleanup_entry_list();
>>   	kset_unregister(dmi_kset);
>> -	kobject_del(dmi_kobj);
>> -	kobject_put(dmi_kobj);
>>   }
>>  =20
>>   module_init(dmi_sysfs_init);
>> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan=
=2Ec
>> index c9cb725..3fca52a 100644
>> --- a/drivers/firmware/dmi_scan.c
>> +++ b/drivers/firmware/dmi_scan.c
>> @@ -10,6 +10,9 @@
>>   #include <asm/dmi.h>
>>   #include <asm/unaligned.h>
>>  =20
>> +struct kobject *dmi_kobj;
>> +EXPORT_SYMBOL_GPL(dmi_kobj);
>> +
>>   /*
>>    * DMI stands for "Desktop Management Interface".  It is part
>>    * of and an antecedent to, SMBIOS, which stands for System
>> @@ -20,6 +23,9 @@ static const char dmi_empty_string[] =3D "        =
";
>>   static u32 dmi_ver __initdata;
>>   static u32 dmi_len;
>>   static u16 dmi_num;
>> +static u8 smbios_entry_point[32];
>> +static int smbios_entry_point_size;
>> +
>>   /*
>>    * Catch too early calls to dmi_check_system():
>>    */
>> @@ -118,6 +124,7 @@ static void dmi_table(u8 *buf,
>>   }
>>  =20
>>   static phys_addr_t dmi_base;
>> +static u8 *dmi_tb;
> Where "tb" stands for... "table", but you couldn't use that because a
> function by that name already exist, right? I can think of two less
> cryptic ways to solve this: either you rename function dmi_table to,
> say, dmi_decode_table (which would be a better name anyway IMHO), or =
you
> name your variable dmi_table_p or dmi_raw_table. But "tb" is not
> immediate enough to understand.

If others are OK, I'll better rename dmi_table function to=20
dmi_decode_table()
(or maybe dmidecode_table :), joke)
as it's more appropriate to what it's doing.
And accordingly dmi_tb to dmi_table.

>>  =20
>>   static int __init dmi_walk_early(void (*decode)(const struct dmi_h=
eader *,
>>   		void *))
>> @@ -476,6 +483,8 @@ static int __init dmi_present(const u8 *buf)
>>   	if (memcmp(buf, "_SM_", 4) =3D=3D 0 &&
>>   	    buf[5] < 32 && dmi_checksum(buf, buf[5])) {
>>   		smbios_ver =3D get_unaligned_be16(buf + 6);
>> +		smbios_entry_point_size =3D buf[5];
>> +		memcpy(smbios_entry_point, buf, smbios_entry_point_size);
>>  =20
>>   		/* Some BIOS report weird SMBIOS version, fix that up */
>>   		switch (smbios_ver) {
>> @@ -508,6 +517,8 @@ static int __init dmi_present(const u8 *buf)
>>   					dmi_ver >> 8, dmi_ver & 0xFF,
>>   					(dmi_ver < 0x0300) ? "" : ".x");
>>   			} else {
>> +				smbios_entry_point_size =3D 15;
>> +				memcpy(smbios_entry_point, buf, 15);
>>   				dmi_ver =3D (buf[14] & 0xF0) << 4 |
>>   					   (buf[14] & 0x0F);
>>   				pr_info("Legacy DMI %d.%d present.\n",
>> @@ -535,6 +546,8 @@ static int __init dmi_smbios3_present(const u8 *=
buf)
>>   		dmi_ver &=3D 0xFFFFFF;
>>   		dmi_len =3D get_unaligned_le32(buf + 12);
>>   		dmi_base =3D get_unaligned_le64(buf + 16);
>> +		smbios_entry_point_size =3D buf[6];
>> +		memcpy(smbios_entry_point, buf, smbios_entry_point_size);
>>  =20
>>   		/*
>>   		 * The 64-bit SMBIOS 3.0 entry point no longer has a field
> This is inconsistent. You should either use smbios_entry_point_size a=
s
> the last argument to memcpy() in all 3 cases (my preference), or you
> should use buf[5], 15 and buf[6] respectively, but not mix.

You probably meant "memcpy(smbios_entry_point, buf, 15)"
Just wanted to avoid redundant line break.

>
>> @@ -638,6 +651,95 @@ void __init dmi_scan_machine(void)
>>   	dmi_initialized =3D 1;
>>   }
>>  =20
>> +static ssize_t smbios_entry_point_read(struct file *filp,
>> +				       struct kobject *kobj,
>> +				       struct bin_attribute *bin_attr,
>> +				       char *buf, loff_t pos, size_t count)
>> +{
>> +	ssize_t size;
>> +
>> +	size =3D bin_attr->size;
>> +
>> +	if (size > pos)
>> +		size -=3D pos;
>> +	else
>> +		return 0;
>> +
>> +	if (count < size)
>> +		size =3D count;
>> +
>> +	memcpy(buf, &smbios_entry_point[pos], size);
>> +
>> +	return size;
>> +}
>> +
>> +static ssize_t dmi_table_read(struct file *filp,
>> +			      struct kobject *kobj,
>> +			      struct bin_attribute *bin_attr,
>> +			      char *buf, loff_t pos, size_t count)
>> +{
>> +	ssize_t size;
>> +
>> +	size =3D bin_attr->size;
>> +
>> +	if (size > pos)
>> +		size -=3D pos;
>> +	else
>> +		return 0;
>> +
>> +	if (count < size)
>> +		size =3D count;
>> +
>> +	memcpy(buf, &dmi_tb[pos], size);
>> +
>> +	return size;
>> +}
> Looking at drivers/acpi/bgrt.c, there seems to be a more simple way t=
o
> implement this: fill in the file size and contents (.private) at
> run-time and let sysfs handle all the rest. You already do the former=
 so
> you're actually very close.

I'll look.

>
>> +BIN_ATTR_RO(dmi_table, 0);
>> +BIN_ATTR_RO(smbios_entry_point, 0);
> These should both be static.

Yes.

>
> This will make dmi_table readable by all users, instead of just root =
as
> it should be. The DMI data contains private information (serial numbe=
rs,
> UUID...) You will see that some files under /sys/devices/virtual/dmi/=
id
> can't be read by regular users for this reason.

Yes.

>
>> +/*
>> + * Register the dmi subsystem under the firmware subsysterm
> Same typo again: subsystem.
>
>> + */
>> +static int __init dmisubsys_init(void)
>> +{
>> +	int ret =3D -ENOMEM;
> There's only one error case which returns that value so it would be
> better set in that error path.

yep.

>
>> +
>> +	if (!smbios_entry_point_size || !dmi_available) {
> I already mentioned in a previous review that I don't think you need =
to
> check for !dmi_available, and you said you agreed.

No.
Previously only smbios entry point was exported.
Now DMI table was added.
smbios_entry_point_size doesn't mean DMI table is present.


>
>> +		ret =3D -EINVAL;
> Again -ENOSYS or similar would be more appropriate (not that it matte=
rs
> a lot in practice though as I don't think there is any way to actuall=
y
> retrieve this value.)

ENOSYS better

>
>> +		goto err;
>> +	}
>> +
>> +	/* Set up dmi directory at /sys/firmware/dmi */
>> +	dmi_kobj =3D kobject_create_and_add("dmi", firmware_kobj);
>> +	if (!dmi_kobj)
>> +		goto err;
>> +
>> +	bin_attr_smbios_entry_point.size =3D smbios_entry_point_size;
>> +	ret =3D sysfs_create_bin_file(dmi_kobj, &bin_attr_smbios_entry_poi=
nt);
>> +	if (ret)
>> +		goto err;
>> +
>> +	if (!dmi_tb) {
> I don't like this. You should know which of this function and dmi_wal=
k()
> is called first. If you don't, then how can you guarantee that a race
> condition can't happen?

Shit.
Maybe better to leave dmi_walk as it was
and map it only here.

>
> This makes me wonder if that code wouldn't rather go in
> dmi_scan_machine() rather than a separate function.
>
>> +		dmi_tb =3D dmi_remap(dmi_base, dmi_len);
>> +		if (!dmi_tb)
>> +			goto err;
>> +	}
>> +
>> +	bin_attr_dmi_table.size =3D dmi_len;
>> +	ret =3D sysfs_create_bin_file(dmi_kobj, &bin_attr_dmi_table);
>> +	if (ret)
>> +		goto err;
>> +
>> +	return 0;
>> +err:
>> +	pr_err("dmi: Firmware registration failed.\n");
> n
> I said in a previous review that files that have been created should =
be
> explicitly deleted, and I still think so.

I dislike it, but if you insist I'll do this.

>
>> +	kobject_del(dmi_kobj);
>> +	kobject_put(dmi_kobj);
> I think you also need to explicitly set dmi_kobj to NULL here, otherw=
ise
> dmi-sysfs will try to use an object which no longer exists.

Yes.

>
> An alternative approach would be to leave dmi_kobj available even if =
the
> binary files could not be created. As this case is very unlikely to
> happen, I don't care which way you choose.

I also thought about such approach. But imaged a situation when DMI=20
catalog is
empty and no one uses dmi-sysfs (which probably is more frequently), de=
cided
to delete it. So dmi_kobj =3D 0.

>
>> +	return ret;
>> +}
>> +subsys_initcall(dmisubsys_init);
>> +
>>   /**
>>    * dmi_set_dump_stack_arch_desc - set arch description for dump_st=
ack()
>>    *
>> @@ -897,18 +999,17 @@ EXPORT_SYMBOL(dmi_get_date);
>>   int dmi_walk(void (*decode)(const struct dmi_header *, void *),
>>   	     void *private_data)
>>   {
>> -	u8 *buf;
>> -
>>   	if (!dmi_available)
>>   		return -1;
>>  =20
>> -	buf =3D dmi_remap(dmi_base, dmi_len);
>> -	if (buf =3D=3D NULL)
>> -		return -1;
>> +	if (!dmi_tb) {
>> +		dmi_tb =3D dmi_remap(dmi_base, dmi_len);
>> +		if (!dmi_tb)
>> +			return -1;
>> +	}
>>  =20
>> -	dmi_table(buf, decode, private_data);
>> +	dmi_table(dmi_tb, decode, private_data);
>>  =20
>> -	dmi_unmap(buf);
>>   	return 0;
>>   }
>>   EXPORT_SYMBOL_GPL(dmi_walk);
>> diff --git a/include/linux/dmi.h b/include/linux/dmi.h
>> index f820f0a..316293e 100644
>> --- a/include/linux/dmi.h
>> +++ b/include/linux/dmi.h
>> @@ -93,6 +93,7 @@ struct dmi_dev_onboard {
>>   	int devfn;
>>   };
>>  =20
>> +extern struct kobject *dmi_kobj;
>>   extern int dmi_check_system(const struct dmi_system_id *list);
>>   const struct dmi_system_id *dmi_first_match(const struct dmi_syste=
m_id *list);
>>   extern const char * dmi_get_system_info(int field);
>> @@ -112,6 +113,7 @@ extern void dmi_memdev_name(u16 handle, const ch=
ar **bank, const char **device);
>>  =20
>>   #else
>>  =20
>> +extern struct kobject *dmi_kobj;
> No, if CONFIG_DMI is not set then dmi_scan isn't built and dmi_kobj d=
oes
> not exist.

Yep

>
>>   static inline int dmi_check_system(const struct dmi_system_id *lis=
t) { return 0; }
>>   static inline const char * dmi_get_system_info(int field) { return=
 NULL; }
>>   static inline const struct dmi_device * dmi_find_device(int type, =
const char *name,
>

--=20
Regards,
Ivan Khoronzhuk
