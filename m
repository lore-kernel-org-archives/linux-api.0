From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v6 2/4] of: overlay: global sysfs enable attribute
Date: Wed, 21 Oct 2015 11:47:05 +0300
Message-ID: <239C2ADB-C80E-40BF-9FED-BC61CF496AF1@konsulko.com>
References: <1445368397-8732-1-git-send-email-pantelis.antoniou@konsulko.com> <1445368397-8732-3-git-send-email-pantelis.antoniou@konsulko.com> <20151020210609.GB28724@kroah.com> <CAL_JsqLxvO4ke79rbBvq2ybPDeXdFtL+_Y4G9uFbz19eeSp3vg@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL_JsqLxvO4ke79rbBvq2ybPDeXdFtL+_Y4G9uFbz19eeSp3vg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Rob,

> On Oct 21, 2015, at 00:50 , Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
>=20
> On Tue, Oct 20, 2015 at 4:06 PM, Greg Kroah-Hartman
> <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
>> On Tue, Oct 20, 2015 at 10:13:15PM +0300, Pantelis Antoniou wrote:
>>> A throw once master enable switch to protect against any
>>> further overlay applications if the administrator desires so.
>>>=20
>>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
>>> ---
>>> drivers/of/overlay.c | 43 +++++++++++++++++++++++++++++++++++++++++=
+-
>>> 1 file changed, 42 insertions(+), 1 deletion(-)
>>>=20
>>> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
>>> index 12c3e47..067404e 100644
>>> --- a/drivers/of/overlay.c
>>> +++ b/drivers/of/overlay.c
>>> @@ -21,6 +21,7 @@
>>> #include <linux/err.h>
>>> #include <linux/idr.h>
>>> #include <linux/sysfs.h>
>>> +#include <linux/atomic.h>
>>>=20
>>> #include "of_private.h"
>>>=20
>>> @@ -55,8 +56,12 @@ struct of_overlay {
>>>      struct kobject kobj;
>>> };
>>>=20
>>> +/* master enable switch; once set to 0 can't be re-enabled */
>>> +static atomic_t ov_enable =3D ATOMIC_INIT(1);
>>> +
>>> static int of_overlay_apply_one(struct of_overlay *ov,
>>>              struct device_node *target, const struct device_node *=
overlay);
>>> +static int overlay_removal_is_ok(struct of_overlay *ov);
>>>=20
>>> static int of_overlay_apply_single_property(struct of_overlay *ov,
>>>              struct device_node *target, struct property *prop)
>>> @@ -339,6 +344,35 @@ void of_overlay_release(struct kobject *kobj)
>>>      kfree(ov);
>>> }
>>>=20
>>> +static ssize_t enable_show(struct kobject *kobj,
>>> +             struct kobj_attribute *attr, char *buf)
>>> +{
>>> +     return snprintf(buf, PAGE_SIZE, "%d\n", atomic_read(&ov_enabl=
e));
>>> +}
>>> +
>>> +static ssize_t enable_store(struct kobject *kobj,
>>> +             struct kobj_attribute *attr, const char *buf, size_t =
count)
>>> +{
>>> +     int ret;
>>> +     bool new_enable;
>>> +
>>> +     ret =3D strtobool(buf, &new_enable);
>>> +     if (ret !=3D 0)
>>> +             return ret;
>>> +     /* if we've disabled it, no going back */
>>> +     if (atomic_read(&ov_enable) =3D=3D 0)
>>> +             return -EPERM;
>>> +     atomic_set(&ov_enable, (int)new_enable);
>>> +     return count;
>>> +}
>>> +
>>> +static struct kobj_attribute enable_attr =3D __ATTR_RW(enable);
>>> +
>>> +static const struct attribute *overlay_global_attrs[] =3D {
>>> +     &enable_attr.attr,
>>> +     NULL
>>> +};
>>> +
>>> static struct kobj_type of_overlay_ktype =3D {
>>>      .release =3D of_overlay_release,
>>> };
>>> @@ -360,6 +394,10 @@ int of_overlay_create(struct device_node *tree=
)
>>>      struct of_overlay *ov;
>>>      int err, id;
>>>=20
>>> +     /* administratively disabled */
>>> +     if (!atomic_read(&ov_enable))
>>> +             return -EPERM;
>>> +
>>>      /* allocate the overlay structure */
>>>      ov =3D kzalloc(sizeof(*ov), GFP_KERNEL);
>>>      if (ov =3D=3D NULL)
>>> @@ -594,5 +632,8 @@ int of_overlay_init(void)
>>>      if (!ov_kset)
>>>              return -ENOMEM;
>>>=20
>>> -     return 0;
>>> +     rc =3D sysfs_create_files(&ov_kset->kobj, overlay_global_attr=
s);
>>> +     WARN(rc, "%s: error adding global attributes\n", __func__);
>>> +
>>> +     return rc;
>>> }
>>=20
>> Shouldn't this also be allowed to be overridden as a boot and build =
time
>> parameter to prevent any races on systems that don't want this?
>=20
> Build time is already there to disable overlays. A command line optio=
n
> would be good though.
>=20

No problemo. I=E2=80=99ll include it in the next version to go out toda=
y.

> Rob

Regards

=E2=80=94 Pantelis
