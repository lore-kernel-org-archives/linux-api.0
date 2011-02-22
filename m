From: Rob Lippert <rlippert-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 2/5] firmware: Basic dmi-sysfs support
Date: Tue, 22 Feb 2011 15:49:30 -0800
Message-ID: <AANLkTi=wpVRSxY0HTnnJEeEN-VEOBQ7XJM5TrUu9Chqd@mail.gmail.com>
References: <20110217212754.3967.98648.stgit@mike.mtv.corp.google.com> <20110217212805.3967.47547.stgit@mike.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110217212805.3967.47547.stgit-tzAwxxnF6Tt6FDdRrpk8kO4/NqBCd+6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Olof Johansson <olofj-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Jon Mayer <jonmayer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Duncan Laurie <dlaurie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aaron Durbin <adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Hendrix <dhendrix-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Feb 17, 2011 at 1:28 PM, Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrot=
e:
> Introduce a new module "dmi-sysfs" that exports the broken out entrie=
s
> of the DMI table through sysfs.
>
> Entries are enumerated via dmi_walk() on module load, and are populat=
ed
> as kobjects rooted at /sys/firmware/dmi/entries.
>
> Entries are named "<type>-<instance>", where:
> =A0 <type> =A0 =A0 =A0 : is the type of the entry, and
> =A0 <instance> =A0 : is the ordinal count within the DMI table of tha=
t
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0entry type. =A0This instance is us=
ed in lieu the DMI
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0entry's handle as no assurances ar=
e made by the kernel
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0that handles are unique.
>
> All entries export the following attributes:

Can you add an entry here for index/ordinal in the set of all tables?
This way the user can walk the tables in the original order exported
by the BIOS.  Some (buggy) BIOSes don't properly set up links between
things like MEM_ARRAY and MEM_DEVICE tables but depend on the position
of the table relative to other tables.

> =A0 length =A0 =A0 =A0 : The length of the formatted portion of the e=
ntry
> =A0 handle =A0 =A0 =A0 : The handle given to this entry by the firmwa=
re
> =A0 raw =A0 =A0 =A0 =A0 =A0: The raw bytes of the entire entry, inclu=
ding the
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0formatted portion, the unformatted=
 (strings) portion,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0and the two terminating nul charac=
ters.
>
> Entries in dmi-sysfs are kobject backed members called "struct
> dmi_sysfs_entry" and belong to dmi_kset. =A0They are threaded through
> entry_list (protected by entry_list_lock) so that we can find them at
> cleanup time.
>
> Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> =A0drivers/firmware/Kconfig =A0 =A0 | =A0 11 +
> =A0drivers/firmware/Makefile =A0 =A0| =A0 =A01
> =A0drivers/firmware/dmi-sysfs.c | =A0362 ++++++++++++++++++++++++++++=
++++++++++++++
> =A03 files changed, 374 insertions(+), 0 deletions(-)
> =A0create mode 100644 drivers/firmware/dmi-sysfs.c
>
> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> index e710424..959175d 100644
> --- a/drivers/firmware/Kconfig
> +++ b/drivers/firmware/Kconfig
> @@ -113,6 +113,17 @@ config DMIID
> =A0 =A0 =A0 =A0 =A0information from userspace through /sys/class/dmi/=
id/ or if you want
> =A0 =A0 =A0 =A0 =A0DMI-based module auto-loading.
>
> +config DMI_SYSFS
> + =A0 =A0 =A0 tristate "DMI table support in sysfs"
> + =A0 =A0 =A0 depends on SYSFS && DMI
> + =A0 =A0 =A0 default X86
> + =A0 =A0 =A0 help
> + =A0 =A0 =A0 =A0 Say Y or M here to enable the exporting of the raw =
DMI table
> + =A0 =A0 =A0 =A0 data via sysfs. =A0This is useful for consuming the=
 data without
> + =A0 =A0 =A0 =A0 requiring any access to /dev/mem at all. =A0Tables =
are found
> + =A0 =A0 =A0 =A0 under /sys/firmware/dmi when this option is enabled=
 and
> + =A0 =A0 =A0 =A0 loaded.
> +
> =A0config ISCSI_IBFT_FIND
> =A0 =A0 =A0 =A0bool "iSCSI Boot Firmware Table Attributes"
> =A0 =A0 =A0 =A0depends on X86
> diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
> index 1c3c173..20c17fc 100644
> --- a/drivers/firmware/Makefile
> +++ b/drivers/firmware/Makefile
> @@ -2,6 +2,7 @@
> =A0# Makefile for the linux kernel.
> =A0#
> =A0obj-$(CONFIG_DMI) =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D dmi_scan.o
> +obj-$(CONFIG_DMI_SYSFS) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D dmi-sysf=
s.o
> =A0obj-$(CONFIG_EDD) =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D edd.o
> =A0obj-$(CONFIG_EFI_VARS) =A0 =A0 =A0 =A0 +=3D efivars.o
> =A0obj-$(CONFIG_EFI_PCDP) =A0 =A0 =A0 =A0 +=3D pcdp.o
> diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysf=
s.c
> new file mode 100644
> index 0000000..adcd604
> --- /dev/null
> +++ b/drivers/firmware/dmi-sysfs.c
> @@ -0,0 +1,362 @@
> +/*
> + * dmi-sysfs.c
> + *
> + * This module exports the DMI tables read-only to userspace through=
 the
> + * sysfs file system.
> + *
> + * Data is currently found below
> + * =A0 =A0/sys/firmware/dmi/...
> + *
> + * DMI attributes are presented in attribute files with names
> + * formatted using %d-%d, so that the first integer indicates the
> + * structure type (0-255), and the second field is the instance of t=
hat
> + * entry.
> + *
> + * Copyright 2010 Google, Inc.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/kobject.h>
> +#include <linux/dmi.h>
> +#include <linux/capability.h>
> +#include <linux/slab.h>
> +#include <linux/list.h>
> +#include <linux/io.h>
> +
> +#define MAX_ENTRY_TYPE 255 /* Most of these aren't used, but we cons=
ider
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 the top ent=
ry type is only 8 bits */
> +
> +struct dmi_sysfs_entry {
> + =A0 =A0 =A0 struct dmi_header dh;
> + =A0 =A0 =A0 struct kobject kobj;
> + =A0 =A0 =A0 int instance;
> + =A0 =A0 =A0 struct list_head list;
> +};
> +
> +/*
> + * Global list of dmi_sysfs_entry. =A0Even though this should only b=
e
> + * manipulated at setup and teardown, the lazy nature of the kobject
> + * system means we get lazy removes.
> + */
> +static LIST_HEAD(entry_list);
> +static DEFINE_SPINLOCK(entry_list_lock);
> +
> +/* dmi_sysfs_attribute - Top level attribute. used by all entries. *=
/
> +struct dmi_sysfs_attribute {
> + =A0 =A0 =A0 struct attribute attr;
> + =A0 =A0 =A0 ssize_t (*show)(struct dmi_sysfs_entry *entry, char *bu=
f);
> +};
> +
> +#define DMI_SYSFS_ATTR(_entry, _name) \
> +struct dmi_sysfs_attribute dmi_sysfs_attr_##_entry##_##_name =3D { \
> + =A0 =A0 =A0 .attr =3D {.name =3D __stringify(_name), .mode =3D 0400=
}, \
> + =A0 =A0 =A0 .show =3D dmi_sysfs_##_entry##_##_name, \
> +}
> +
> +/*
> + * dmi_sysfs_mapped_attribute - Attribute where we require the entry=
 be
> + * mapped in. =A0Use in conjunction with dmi_sysfs_specialize_attr_o=
ps.
> + */
> +struct dmi_sysfs_mapped_attribute {
> + =A0 =A0 =A0 struct attribute attr;
> + =A0 =A0 =A0 ssize_t (*show)(struct dmi_sysfs_entry *entry,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct dmi_header=
 *dh,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *buf);
> +};
> +
> +#define DMI_SYSFS_MAPPED_ATTR(_entry, _name) \
> +struct dmi_sysfs_mapped_attribute dmi_sysfs_attr_##_entry##_##_name =
=3D { \
> + =A0 =A0 =A0 .attr =3D {.name =3D __stringify(_name), .mode =3D 0400=
}, \
> + =A0 =A0 =A0 .show =3D dmi_sysfs_##_entry##_##_name, \
> +}
> +
> +/*************************************************
> + * Generic DMI entry support.
> + *************************************************/
> +
> +static struct dmi_sysfs_entry *to_entry(struct kobject *kobj)
> +{
> + =A0 =A0 =A0 return container_of(kobj, struct dmi_sysfs_entry, kobj)=
;
> +}
> +
> +static struct dmi_sysfs_attribute *to_attr(struct attribute *attr)
> +{
> + =A0 =A0 =A0 return container_of(attr, struct dmi_sysfs_attribute, a=
ttr);
> +}
> +
> +static ssize_t dmi_sysfs_attr_show(struct kobject *kobj,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
struct attribute *_attr, char *buf)
> +{
> + =A0 =A0 =A0 struct dmi_sysfs_entry *entry =3D to_entry(kobj);
> + =A0 =A0 =A0 struct dmi_sysfs_attribute *attr =3D to_attr(_attr);
> +
> + =A0 =A0 =A0 /* DMI stuff is only ever admin visible */
> + =A0 =A0 =A0 if (!capable(CAP_SYS_ADMIN))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EACCES;
> +
> + =A0 =A0 =A0 return attr->show(entry, buf);
> +}
> +
> +static const struct sysfs_ops dmi_sysfs_attr_ops =3D {
> + =A0 =A0 =A0 .show =3D dmi_sysfs_attr_show,
> +};
> +
> +typedef ssize_t (*dmi_callback)(struct dmi_sysfs_entry *,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const s=
truct dmi_header *dh, void *);
> +
> +struct find_dmi_data {
> + =A0 =A0 =A0 struct dmi_sysfs_entry =A0*entry;
> + =A0 =A0 =A0 dmi_callback =A0 =A0 =A0 =A0 =A0 =A0callback;
> + =A0 =A0 =A0 void =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*private;
> + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 instance_co=
untdown;
> + =A0 =A0 =A0 ssize_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret;
> +};
> +
> +static void find_dmi_entry_helper(const struct dmi_header *dh,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 voi=
d *_data)
> +{
> + =A0 =A0 =A0 struct find_dmi_data *data =3D _data;
> + =A0 =A0 =A0 struct dmi_sysfs_entry *entry =3D data->entry;
> +
> + =A0 =A0 =A0 /* Is this the entry we want? */
> + =A0 =A0 =A0 if (dh->type !=3D entry->dh.type)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> +
> + =A0 =A0 =A0 if (data->instance_countdown !=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* try the next instance? */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 data->instance_countdown--;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Found the entry */
> + =A0 =A0 =A0 data->ret =3D data->callback(entry, dh, data->private);
> +}
> +
> +/* State for passing the read parameters through dmi_find_entry() */
> +struct dmi_read_state {
> + =A0 =A0 =A0 char *buf;
> + =A0 =A0 =A0 loff_t pos;
> + =A0 =A0 =A0 size_t count;
> +};
> +
> +static ssize_t find_dmi_entry(struct dmi_sysfs_entry *entry,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dmi_callbac=
k callback, void *private)
> +{
> + =A0 =A0 =A0 struct find_dmi_data data =3D {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .entry =3D entry,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .callback =3D callback,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .private =3D private,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .instance_countdown =3D entry->instance=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ret =3D -EIO, =A0/* To signal the entr=
y disappeared */
> + =A0 =A0 =A0 };
> + =A0 =A0 =A0 int ret;
> +
> + =A0 =A0 =A0 ret =3D dmi_walk(find_dmi_entry_helper, &data);
> + =A0 =A0 =A0 /* This shouldn't happen, but just in case. */
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 return data.ret;
> +}
> +
> +/*
> + * Calculate and return the byte length of the dmi entry identified =
by
> + * dh. =A0This includes both the formatted portion as well as the
> + * unformatted string space, including the two trailing nul characte=
rs.
> + */
> +static size_t dmi_entry_length(const struct dmi_header *dh)
> +{
> + =A0 =A0 =A0 const char *p =3D (const char *)dh;
> +
> + =A0 =A0 =A0 p +=3D dh->length;
> +
> + =A0 =A0 =A0 while (p[0] || p[1])
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 p++;
> +

Is there any chance this could walk outside of SMBIOS space on a
corrupted table?  I can point you at some machines with corrupted
tables to test on if you want.

> + =A0 =A0 =A0 return 2 + p - (const char *)dh;
> +}
> +
> +/*************************************************
> + * Generic DMI entry support.
> + *************************************************/
> +
> +static ssize_t dmi_sysfs_entry_length(struct dmi_sysfs_entry *entry,=
 char *buf)
> +{
> + =A0 =A0 =A0 return sprintf(buf, "%d\n", entry->dh.length);
> +}
> +
> +static ssize_t dmi_sysfs_entry_handle(struct dmi_sysfs_entry *entry,=
 char *buf)
> +{
> + =A0 =A0 =A0 return sprintf(buf, "%d\n", entry->dh.handle);
> +}
> +
> +static DMI_SYSFS_ATTR(entry, length);
> +static DMI_SYSFS_ATTR(entry, handle);
> +
> +static struct attribute *dmi_sysfs_entry_attrs[] =3D {
> + =A0 =A0 =A0 &dmi_sysfs_attr_entry_length.attr,
> + =A0 =A0 =A0 &dmi_sysfs_attr_entry_handle.attr,
> + =A0 =A0 =A0 NULL,
> +};
> +
> +static ssize_t dmi_entry_raw_read_helper(struct dmi_sysfs_entry *ent=
ry,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0const struct dmi_header *dh,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0void *_state)
> +{
> + =A0 =A0 =A0 struct dmi_read_state *state =3D _state;
> + =A0 =A0 =A0 size_t entry_length;
> +
> + =A0 =A0 =A0 entry_length =3D dmi_entry_length(dh);
> +
> + =A0 =A0 =A0 return memory_read_from_buffer(state->buf, state->count=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0&state->pos, dh, entry_length);
> +}
> +
> +static ssize_t dmi_entry_raw_read(struct file *filp,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 str=
uct kobject *kobj,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 str=
uct bin_attribute *bin_attr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cha=
r *buf, loff_t pos, size_t count)
> +{
> + =A0 =A0 =A0 struct dmi_sysfs_entry *entry =3D to_entry(kobj);
> + =A0 =A0 =A0 struct dmi_read_state state =3D {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .buf =3D buf,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .pos =3D pos,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .count =3D count,
> + =A0 =A0 =A0 };
> +
> + =A0 =A0 =A0 return find_dmi_entry(entry, dmi_entry_raw_read_helper,=
 &state);
> +}
> +
> +static const struct bin_attribute dmi_entry_raw_attr =3D {
> + =A0 =A0 =A0 .attr =3D {.name =3D "raw", .mode =3D 0400},
> + =A0 =A0 =A0 .read =3D dmi_entry_raw_read,
> +};
> +
> +static void dmi_sysfs_entry_release(struct kobject *kobj)
> +{
> + =A0 =A0 =A0 struct dmi_sysfs_entry *entry =3D to_entry(kobj);
> + =A0 =A0 =A0 sysfs_remove_bin_file(&entry->kobj, &dmi_entry_raw_attr=
);
> + =A0 =A0 =A0 spin_lock(&entry_list_lock);
> + =A0 =A0 =A0 list_del(&entry->list);
> + =A0 =A0 =A0 spin_unlock(&entry_list_lock);
> + =A0 =A0 =A0 kfree(entry);
> +}
> +
> +static struct kobj_type dmi_sysfs_entry_ktype =3D {
> + =A0 =A0 =A0 .release =3D dmi_sysfs_entry_release,
> + =A0 =A0 =A0 .sysfs_ops =3D &dmi_sysfs_attr_ops,
> + =A0 =A0 =A0 .default_attrs =3D dmi_sysfs_entry_attrs,
> +};
> +
> +static struct kobject *dmi_kobj;
> +static struct kset *dmi_kset;
> +
> +/* Global count of all instances seen. =A0Only for setup */
> +static int __initdata instance_counts[MAX_ENTRY_TYPE + 1];
> +
> +static void __init dmi_sysfs_register_handle(const struct dmi_header=
 *dh,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0void *_ret)
> +{
> + =A0 =A0 =A0 struct dmi_sysfs_entry *entry;
> + =A0 =A0 =A0 int *ret =3D _ret;
> +
> + =A0 =A0 =A0 /* If a previous entry saw an error, short circuit */
> + =A0 =A0 =A0 if (*ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> +
> + =A0 =A0 =A0 /* Allocate and register a new entry into the entries s=
et */
> + =A0 =A0 =A0 entry =3D kzalloc(sizeof(*entry), GFP_KERNEL);
> + =A0 =A0 =A0 if (!entry) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *ret =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Set the key */
> + =A0 =A0 =A0 entry->dh =3D *dh;
> + =A0 =A0 =A0 entry->instance =3D instance_counts[dh->type]++;
> +
> + =A0 =A0 =A0 entry->kobj.kset =3D dmi_kset;
> + =A0 =A0 =A0 *ret =3D kobject_init_and_add(&entry->kobj, &dmi_sysfs_=
entry_ktype, NULL,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 "%d-%d", dh->type, entry->instance);
> +
> + =A0 =A0 =A0 if (*ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(entry);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Thread on the global list for cleanup */
> + =A0 =A0 =A0 spin_lock(&entry_list_lock);
> + =A0 =A0 =A0 list_add_tail(&entry->list, &entry_list);
> + =A0 =A0 =A0 spin_unlock(&entry_list_lock);
> +
> + =A0 =A0 =A0 /* Create the raw binary file to access the entry */
> + =A0 =A0 =A0 *ret =3D sysfs_create_bin_file(&entry->kobj, &dmi_entry=
_raw_attr);
> + =A0 =A0 =A0 if (*ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
> +
> + =A0 =A0 =A0 return;
> +out_err:
> + =A0 =A0 =A0 kobject_put(&entry->kobj);
> + =A0 =A0 =A0 return;
> +}
> +
> +static void cleanup_entry_list(void)
> +{
> + =A0 =A0 =A0 struct dmi_sysfs_entry *entry, *next;
> +
> + =A0 =A0 =A0 /* No locks, we are on our way out */
> + =A0 =A0 =A0 list_for_each_entry_safe(entry, next, &entry_list, list=
) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kobject_put(&entry->kobj);
> + =A0 =A0 =A0 }
> +}
> +
> +static int __init dmi_sysfs_init(void)
> +{
> + =A0 =A0 =A0 int error =3D -ENOMEM;
> + =A0 =A0 =A0 int val;
> +
> + =A0 =A0 =A0 /* Set up our directory */
> + =A0 =A0 =A0 dmi_kobj =3D kobject_create_and_add("dmi", firmware_kob=
j);
> + =A0 =A0 =A0 if (!dmi_kobj)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err;
> +
> + =A0 =A0 =A0 dmi_kset =3D kset_create_and_add("entries", NULL, dmi_k=
obj);
> + =A0 =A0 =A0 if (!dmi_kset)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err;
> +
> + =A0 =A0 =A0 val =3D 0;
> + =A0 =A0 =A0 error =3D dmi_walk(dmi_sysfs_register_handle, &val);
> + =A0 =A0 =A0 if (error)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err;
> + =A0 =A0 =A0 if (val) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D val;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 pr_info("dmi-sysfs: loaded.\n");
> +
> + =A0 =A0 =A0 return 0;
> +err:
> + =A0 =A0 =A0 cleanup_entry_list();
> + =A0 =A0 =A0 kset_unregister(dmi_kset);
> + =A0 =A0 =A0 kobject_put(dmi_kobj);
> + =A0 =A0 =A0 return error;
> +}
> +
> +/* clean up everything. */
> +static void __exit dmi_sysfs_exit(void)
> +{
> + =A0 =A0 =A0 pr_info("dmi-sysfs: unloading.\n");
> + =A0 =A0 =A0 cleanup_entry_list();
> + =A0 =A0 =A0 kset_unregister(dmi_kset);
> + =A0 =A0 =A0 kobject_put(dmi_kobj);
> +}
> +
> +module_init(dmi_sysfs_init);
> +module_exit(dmi_sysfs_exit);
> +
> +MODULE_AUTHOR("Google, Inc.");
> +MODULE_DESCRIPTION("DMI sysfs support");
> +MODULE_LICENSE("GPL");
>
>
