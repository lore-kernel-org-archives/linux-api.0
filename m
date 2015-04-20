From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [Patch v2 2/3] firmware: dmi_scan: add SBMIOS entry and DMI tables
Date: Mon, 20 Apr 2015 11:32:28 -0700
Message-ID: <CAFECyb_qEhKrut3C2yaY9ruMQeQc-3dO7RUwACMPX-oOSc8aZA@mail.gmail.com>
References: <1429525187-3376-1-git-send-email-ivan.khoronzhuk@globallogic.com>
	<1429525187-3376-3-git-send-email-ivan.khoronzhuk@globallogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429525187-3376-3-git-send-email-ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, dmidecode-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 20, 2015 at 3:19 AM, Ivan Khoronzhuk
<ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org> wrote:
> Some utils, like dmidecode and smbios, need to access SMBIOS entry
> table area in order to get information like SMBIOS version, size, etc.
> Currently it's done via /dev/mem. But for situation when /dev/mem
> usage is disabled, the utils have to use dmi sysfs instead, which
> doesn't represent SMBIOS entry and adds code/delay redundancy when direct
> access for table is needed.
>
> So this patch creates dmi/tables and adds SMBIOS entry point to allow
> utils in question to work correctly without /dev/mem. Also patch adds
> raw dmi table to simplify dmi table processing in user space, as
> proposed by Jean Delvare.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>

Tested-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Tested with dmidecode w/patches to read tables from sysfs.  The dmidecode
patches are posted on dmidecode-devel and should be commited upstream soon.

Thanks,
Roy

> ---
>  .../ABI/testing/sysfs-firmware-dmi-tables          | 22 ++++++
>  drivers/firmware/dmi-sysfs.c                       | 17 +++--
>  drivers/firmware/dmi_scan.c                        | 82 ++++++++++++++++++++++
>  include/linux/dmi.h                                |  2 +
>  4 files changed, 114 insertions(+), 9 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-firmware-dmi-tables
>
> diff --git a/Documentation/ABI/testing/sysfs-firmware-dmi-tables b/Documentation/ABI/testing/sysfs-firmware-dmi-tables
> new file mode 100644
> index 0000000..ff3cac8
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-firmware-dmi-tables
> @@ -0,0 +1,22 @@
> +What:          /sys/firmware/dmi/tables/
> +Date:          April 2015
> +Contact:       Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
> +Description:
> +               The firmware provides DMI structures as a packed list of
> +               data referenced by a SMBIOS table entry point. The SMBIOS
> +               entry point contains general information, like SMBIOS
> +               version, DMI table size, etc. The structure, content and
> +               size of SMBIOS entry point is dependent on SMBIOS version.
> +               The format of SMBIOS entry point and DMI structures
> +               can be read in SMBIOS specification.
> +
> +               The dmi/tables provides raw SMBIOS entry point and DMI tables
> +               through sysfs as an alternative to utilities reading them
> +               from /dev/mem. The raw SMBIOS entry point and DMI table are
> +               presented as binary attributes and are accessible via:
> +
> +               /sys/firmware/dmi/tables/smbios_entry_point
> +               /sys/firmware/dmi/tables/DMI
> +
> +               The complete DMI information can be obtained using these two
> +               tables.
> diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
> index e0f1cb3..ef76e5e 100644
> --- a/drivers/firmware/dmi-sysfs.c
> +++ b/drivers/firmware/dmi-sysfs.c
> @@ -566,7 +566,6 @@ static struct kobj_type dmi_sysfs_entry_ktype = {
>         .default_attrs = dmi_sysfs_entry_attrs,
>  };
>
> -static struct kobject *dmi_kobj;
>  static struct kset *dmi_kset;
>
>  /* Global count of all instances seen.  Only for setup */
> @@ -648,17 +647,20 @@ static void cleanup_entry_list(void)
>
>  static int __init dmi_sysfs_init(void)
>  {
> -       int error = -ENOMEM;
> +       int error;
>         int val;
>
> -       /* Set up our directory */
> -       dmi_kobj = kobject_create_and_add("dmi", firmware_kobj);
> -       if (!dmi_kobj)
> +       if (!dmi_kobj) {
> +               pr_err("dmi-sysfs: dmi entry is absent.\n");
> +               error = -ENODATA;
>                 goto err;
> +       }
>
>         dmi_kset = kset_create_and_add("entries", NULL, dmi_kobj);
> -       if (!dmi_kset)
> +       if (!dmi_kset) {
> +               error = -ENOMEM;
>                 goto err;
> +       }
>
>         val = 0;
>         error = dmi_walk(dmi_sysfs_register_handle, &val);
> @@ -675,7 +677,6 @@ static int __init dmi_sysfs_init(void)
>  err:
>         cleanup_entry_list();
>         kset_unregister(dmi_kset);
> -       kobject_put(dmi_kobj);
>         return error;
>  }
>
> @@ -685,8 +686,6 @@ static void __exit dmi_sysfs_exit(void)
>         pr_debug("dmi-sysfs: unloading.\n");
>         cleanup_entry_list();
>         kset_unregister(dmi_kset);
> -       kobject_del(dmi_kobj);
> -       kobject_put(dmi_kobj);
>  }
>
>  module_init(dmi_sysfs_init);
> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> index a864a6b..9705be2 100644
> --- a/drivers/firmware/dmi_scan.c
> +++ b/drivers/firmware/dmi_scan.c
> @@ -10,6 +10,9 @@
>  #include <asm/dmi.h>
>  #include <asm/unaligned.h>
>
> +struct kobject *dmi_kobj;
> +EXPORT_SYMBOL_GPL(dmi_kobj);
> +
>  /*
>   * DMI stands for "Desktop Management Interface".  It is part
>   * of and an antecedent to, SMBIOS, which stands for System
> @@ -20,6 +23,9 @@ static const char dmi_empty_string[] = "        ";
>  static u32 dmi_ver __initdata;
>  static u32 dmi_len;
>  static u16 dmi_num;
> +static u8 smbios_entry_point[32];
> +static int smbios_entry_point_size;
> +
>  /*
>   * Catch too early calls to dmi_check_system():
>   */
> @@ -478,6 +484,8 @@ static int __init dmi_present(const u8 *buf)
>         if (memcmp(buf, "_SM_", 4) == 0 &&
>             buf[5] < 32 && dmi_checksum(buf, buf[5])) {
>                 smbios_ver = get_unaligned_be16(buf + 6);
> +               smbios_entry_point_size = buf[5];
> +               memcpy(smbios_entry_point, buf, smbios_entry_point_size);
>
>                 /* Some BIOS report weird SMBIOS version, fix that up */
>                 switch (smbios_ver) {
> @@ -512,6 +520,9 @@ static int __init dmi_present(const u8 *buf)
>                                 pr_info("SMBIOS %d.%d present.\n",
>                                        dmi_ver >> 8, dmi_ver & 0xFF);
>                         } else {
> +                               smbios_entry_point_size = 15;
> +                               memcpy(smbios_entry_point, buf,
> +                                      smbios_entry_point_size);
>                                 pr_info("Legacy DMI %d.%d present.\n",
>                                        dmi_ver >> 8, dmi_ver & 0xFF);
>                         }
> @@ -538,6 +549,8 @@ static int __init dmi_smbios3_present(const u8 *buf)
>                 dmi_num = 0;                    /* No longer specified */
>                 dmi_len = get_unaligned_le32(buf + 12);
>                 dmi_base = get_unaligned_le64(buf + 16);
> +               smbios_entry_point_size = buf[6];
> +               memcpy(smbios_entry_point, buf, smbios_entry_point_size);
>
>                 if (dmi_walk_early(dmi_decode) == 0) {
>                         pr_info("SMBIOS %d.%d.%d present.\n",
> @@ -629,6 +642,75 @@ void __init dmi_scan_machine(void)
>         dmi_initialized = 1;
>  }
>
> +static ssize_t raw_table_read(struct file *file, struct kobject *kobj,
> +                             struct bin_attribute *attr, char *buf,
> +                             loff_t pos, size_t count)
> +{
> +       memcpy(buf, attr->private + pos, count);
> +       return count;
> +}
> +
> +static BIN_ATTR(smbios_entry_point, S_IRUSR, raw_table_read, NULL, 0);
> +static BIN_ATTR(DMI, S_IRUSR, raw_table_read, NULL, 0);
> +
> +static int __init dmi_init(void)
> +{
> +       int ret;
> +       u8 *dmi_table = NULL;
> +       struct kobject *tables_kobj = NULL;
> +
> +       if (!dmi_available) {
> +               ret = -ENODATA;
> +               goto err;
> +       }
> +
> +       /*
> +        * Set up dmi directory at /sys/firmware/dmi. This entry should stay
> +        * even after farther error, as it can be used by other modules like
> +        * dmi-sysfs.
> +        */
> +       dmi_kobj = kobject_create_and_add("dmi", firmware_kobj);
> +       tables_kobj = kobject_create_and_add("tables", dmi_kobj);
> +       if (!(dmi_kobj && tables_kobj)) {
> +               ret = -ENOMEM;
> +               goto err;
> +       }
> +
> +       bin_attr_smbios_entry_point.size = smbios_entry_point_size;
> +       bin_attr_smbios_entry_point.private = smbios_entry_point;
> +       ret = sysfs_create_bin_file(tables_kobj, &bin_attr_smbios_entry_point);
> +       if (ret)
> +               goto err;
> +
> +       dmi_table = dmi_remap(dmi_base, dmi_len);
> +       if (!dmi_table) {
> +               ret = -ENOMEM;
> +               goto err;
> +       }
> +
> +       bin_attr_DMI.size = dmi_len;
> +       bin_attr_DMI.private = dmi_table;
> +       ret = sysfs_create_bin_file(tables_kobj, &bin_attr_DMI);
> +       if (!ret)
> +               return 0;
> +
> +err:
> +       pr_err("dmi: Firmware registration failed.\n");
> +
> +       if (tables_kobj) {
> +               sysfs_remove_bin_file(tables_kobj,
> +                                     &bin_attr_smbios_entry_point);
> +               kobject_del(tables_kobj);
> +               kobject_put(tables_kobj);
> +       }
> +
> +       if (dmi_table)
> +               dmi_unmap(dmi_table);
> +
> +       return ret;
> +}
> +subsys_initcall(dmi_init);
> +
>  /**
>   * dmi_set_dump_stack_arch_desc - set arch description for dump_stack()
>   *
> diff --git a/include/linux/dmi.h b/include/linux/dmi.h
> index f820f0a..2f9f988 100644
> --- a/include/linux/dmi.h
> +++ b/include/linux/dmi.h
> @@ -2,6 +2,7 @@
>  #define __DMI_H__
>
>  #include <linux/list.h>
> +#include <linux/kobject.h>
>  #include <linux/mod_devicetable.h>
>
>  /* enum dmi_field is in mod_devicetable.h */
> @@ -93,6 +94,7 @@ struct dmi_dev_onboard {
>         int devfn;
>  };
>
> +extern struct kobject *dmi_kobj;
>  extern int dmi_check_system(const struct dmi_system_id *list);
>  const struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list);
>  extern const char * dmi_get_system_info(int field);
> --
> 1.9.1
>
