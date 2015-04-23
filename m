From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 3/4] of: overlay: Add sysfs attributes
Date: Thu, 23 Apr 2015 15:00:03 +0300
Message-ID: <6E391B8F-936A-4FD1-B8CC-C9B5FCE0B291@konsulko.com>
References: <1428434632-13789-1-git-send-email-pantelis.antoniou@konsulko.com> <1428434632-13789-4-git-send-email-pantelis.antoniou@konsulko.com> <CAL_JsqLMVBfQpmSjg9qfOvtM3RXMY3Dm+knN8h54gDCzx513-g@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL_JsqLMVBfQpmSjg9qfOvtM3RXMY3Dm+knN8h54gDCzx513-g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Rob,

> On Apr 15, 2015, at 04:27 , Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
>=20
> On Tue, Apr 7, 2015 at 2:23 PM, Pantelis Antoniou
> <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org> wrote:
>> Implement a number of sysfs attributes for overlays.
>>=20
>> * A throw once master enable switch to protect against any
>> further overlay applications if the administrator desires so.
>=20
> This one should be a separate patch.
>=20

OK.

>> * A per overlay targets sysfs attribute listing the targets of
>> the installed overlay.
>=20
> What are targets? "targets lists targets" does not help me. The
> documentation doesn't help me either.
>=20

It lists the targets of the overlay that has been applied. What do
you need in order to be helped? I mean what do you want listed?

>> * A per overlay can_remove sysfs attribute that reports whether
>> the overlay can be removed or not due to another overlapping overlay=
=2E
>>=20
>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
>> ---
>> drivers/of/overlay.c | 167 +++++++++++++++++++++++++++++++++++++++++=
+++++++++-
>> 1 file changed, 166 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
>> index f17f5ef..c54d097 100644
>> --- a/drivers/of/overlay.c
>> +++ b/drivers/of/overlay.c
>> @@ -21,6 +21,7 @@
>> #include <linux/err.h>
>> #include <linux/idr.h>
>> #include <linux/sysfs.h>
>> +#include <linux/atomic.h>
>>=20
>> #include "of_private.h"
>>=20
>> @@ -55,8 +56,12 @@ struct of_overlay {
>>        struct kobject kobj;
>> };
>>=20
>> +/* master enable switch; once set to 0 can't be re-enabled */
>> +static atomic_t ov_enable =3D ATOMIC_INIT(1);
>> +
>> static int of_overlay_apply_one(struct of_overlay *ov,
>>                struct device_node *target, const struct device_node =
*overlay);
>> +static int overlay_removal_is_ok(struct of_overlay *ov);
>>=20
>> static int of_overlay_apply_single_property(struct of_overlay *ov,
>>                struct device_node *target, struct property *prop)
>> @@ -345,6 +350,144 @@ static struct kobj_type of_overlay_ktype =3D {
>>=20
>> static struct kset *ov_kset;
>>=20
>> +static ssize_t enable_read(struct file *filp, struct kobject *kobj,
>> +               struct bin_attribute *bin_attr, char *buf,
>> +               loff_t offset, size_t count)
>> +{
>> +       char tbuf[3];
>> +
>> +       if (offset < 0)
>> +               return -EINVAL;
>> +
>> +       if (offset >=3D sizeof(tbuf))
>> +               return 0;
>> +
>> +       if (count > sizeof(tbuf) - offset)
>> +               count =3D sizeof(tbuf) - offset;
>> +
>> +       /* fill in temp */
>> +       tbuf[0] =3D '0' + atomic_read(&ov_enable);
>> +       tbuf[1] =3D '\n';
>> +       tbuf[2] =3D '\0';
>> +
>> +       /* copy to buffer */
>> +       memcpy(buf, tbuf + offset, count);
>> +
>> +       return count;
>> +}
>> +
>> +static ssize_t enable_write(struct file *filp, struct kobject *kobj=
,
>> +               struct bin_attribute *bin_attr, char *buf,
>> +               loff_t off, size_t count)
>> +{
>> +       unsigned int new_enable;
>> +
>> +       if (off !=3D 0 || (buf[0] !=3D '0' && buf[0] !=3D '1'))
>> +               return -EINVAL;
>> +
>> +       new_enable =3D (unsigned int)(buf[0] - '0');
>> +       if (new_enable > 1)
>> +               return -EINVAL;
>> +
>> +       /* NOP for same value */
>> +       if (new_enable =3D=3D atomic_read(&ov_enable))
>> +               return count;
>> +
>> +       /* if we've disabled it, no going back */
>> +       if (atomic_read(&ov_enable) =3D=3D 0)
>> +               return -EPERM;
>> +
>> +       atomic_set(&ov_enable, new_enable);
>> +       return count;
>> +}
>> +
>> +/* just a single char + '\n' + '\0' */
>> +static BIN_ATTR_RW(enable, 3);
>=20
> Why are you using bin attribute? You are complicating the
> implementation needlessly.
>=20

It=E2=80=99s the same reason that the device tree core is using it.

Believe it or not, this is the simplest way to do it.
If you take a look at the sysfs attribute implementation, the binary
implementation is the one that=E2=80=99s using the least amount of code=
=2E

To use a non-binary method we have to register per ktype sysfs_ops
and duplicate the way the non-binary attribute works.

=46or the gory details look at sysfs_add_file_mode_ns() in fs/sysfs/fil=
e.c

I can add the sysfs_ops but that=E2=80=99s going to be more complicated=
 not less.

>> +
>> +static ssize_t targets_read(struct file *filp, struct kobject *kobj=
,
>> +               struct bin_attribute *bin_attr, char *buf,
>> +               loff_t offset, size_t count)
>> +{
>> +       struct of_overlay *ov =3D kobj_to_overlay(kobj);
>> +       struct of_overlay_info *ovinfo;
>> +       char *tmpbuf, *s, *e;
>> +       const char *name;
>> +       ssize_t ret;
>> +       int i, len;
>> +
>> +       /* allocate work buffer; we know that PAGE_SIZE is enough */
>> +       tmpbuf =3D kmalloc(PAGE_SIZE, GFP_KERNEL);
>> +       if (tmpbuf =3D=3D NULL)
>> +               return -ENOMEM;
>> +
>> +       s =3D tmpbuf;
>> +       e =3D tmpbuf + PAGE_SIZE;
>> +
>> +       mutex_lock(&of_mutex);
>> +
>> +       /* targets */
>> +       for (i =3D 0; i < ov->count; i++) {
>> +               ovinfo =3D &ov->ovinfo_tab[i];
>> +
>> +               name =3D of_node_full_name(ovinfo->target);
>> +               len =3D strlen(name);
>> +               if (s + len + 1 >=3D e)
>> +                       return -ENOMEM;
>=20
> Leaking memory here and holding the mutex.
>=20

OK

>> +               memcpy(s, name, len);
>> +               s +=3D len;
>> +               *s++ =3D '\n';
>> +       }
>> +       if (s + 1 >=3D e)
>> +               return -ENOMEM;

> And here.
>=20

OK

>> +       *s++ =3D '\0';
>> +
>> +       /* the buffer is zero terminated */
>> +       len =3D s - tmpbuf;
>> +
>> +       mutex_unlock(&of_mutex);
>> +
>> +       /* perform the read */
>> +       ret =3D memory_read_from_buffer(buf, count, &offset, tmpbuf,=
 len);
>> +
>> +       /* free the temporary buffer */
>> +       kfree(tmpbuf);
>> +
>> +       return ret;
>> +}
>> +
>> +/* targets property */
>> +static BIN_ATTR_RO(targets, PAGE_SIZE);
>> +
>> +static ssize_t can_remove_read(struct file *filp, struct kobject *k=
obj,
>> +               struct bin_attribute *bin_attr, char *buf,
>> +               loff_t offset, size_t count)
>> +{
>> +       struct of_overlay *ov =3D kobj_to_overlay(kobj);
>> +       char tbuf[3];
>> +
>> +       if (offset < 0)
>> +               return -EINVAL;
>> +
>> +       if (offset >=3D sizeof(tbuf))
>> +               return 0;
>> +
>> +       if (count > sizeof(tbuf) - offset)
>> +               count =3D sizeof(tbuf) - offset;
>> +
>> +       /* fill in temp */
>> +       tbuf[0] =3D '0' + overlay_removal_is_ok(ov);
>> +       tbuf[1] =3D '\n';
>> +       tbuf[2] =3D '\0';
>> +
>> +       /* copy to buffer */
>> +       memcpy(buf, tbuf + offset, count);
>> +
>> +       return count;
>> +}
>> +
>> +/* can_remove property */
>> +static BIN_ATTR_RO(can_remove, 3);
>=20
> Same question about bin attr here.
>=20

Same answer as above.

>> +
>> /**
>>  * of_overlay_create() - Create and apply an overlay
>>  * @tree:      Device node containing all the overlays
>> @@ -360,6 +503,10 @@ int of_overlay_create(struct device_node *tree)
>>        struct of_overlay *ov;
>>        int err, id;
>>=20
>> +       /* administratively disabled */
>> +       if (!atomic_read(&ov_enable))
>> +               return -EPERM;
>> +
>>        /* allocate the overlay structure */
>>        ov =3D kzalloc(sizeof(*ov), GFP_KERNEL);
>>        if (ov =3D=3D NULL)
>> @@ -416,6 +563,22 @@ int of_overlay_create(struct device_node *tree)
>>                goto err_cancel_overlay;
>>        }
>>=20
>> +       /* create targets file */
>> +       err =3D sysfs_create_bin_file(&ov->kobj, &bin_attr_targets);
>> +       if (err !=3D 0) {
>> +               pr_err("%s: sysfs_create_bin_file() failed for tree@=
%s\n",
>> +                               __func__, tree->full_name);
>> +               goto err_cancel_overlay;
>> +       }
>> +
>> +       /* create can_remove file */
>> +       err =3D sysfs_create_bin_file(&ov->kobj, &bin_attr_can_remov=
e);
>> +       if (err !=3D 0) {
>> +               pr_err("%s: sysfs_create_bin_file() failed for tree@=
%s\n",
>> +                               __func__, tree->full_name);
>> +               goto err_cancel_overlay;
>> +       }
>> +
>>        /* add to the tail of the overlay list */
>>        list_add_tail(&ov->node, &ov_list);
>>=20
>> @@ -596,5 +759,7 @@ int of_overlay_init(void)
>>        if (!ov_kset)
>>                return -ENOMEM;
>>=20
>> -       return 0;
>> +       rc =3D sysfs_create_bin_file(&ov_kset->kobj, &bin_attr_enabl=
e);
>> +       WARN(rc, "%s: error adding enable attribute\n", __func__);
>> +       return rc;
>> }
>> --
>> 1.7.12

Regards

=E2=80=94 Pantelis

--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
