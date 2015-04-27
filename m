From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 2/4] of: overlay: global sysfs enable attribute
Date: Mon, 27 Apr 2015 21:43:39 +0300
Message-ID: <1B376CD2-6F5C-4357-9A17-43046079E5CD@konsulko.com>
References: <1429868744-19863-1-git-send-email-pantelis.antoniou@konsulko.com> <1429868744-19863-3-git-send-email-pantelis.antoniou@konsulko.com> <20150424202922.GA14970@kroah.com> <355B6AF0-7F58-4BE4-BEE6-A77246D40652@konsulko.com> <20150427183915.GA29312@kroah.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150427183915.GA29312-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Greg,

> On Apr 27, 2015, at 21:39 , Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
>=20
> On Mon, Apr 27, 2015 at 09:13:56PM +0300, Pantelis Antoniou wrote:
>> Hi Greg,
>>=20
>>> On Apr 24, 2015, at 23:29 , Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
>>>=20
>>> On Fri, Apr 24, 2015 at 12:45:42PM +0300, Pantelis Antoniou wrote:
>>>> A throw once master enable switch to protect against any
>>>> further overlay applications if the administrator desires so.
>>>>=20
>>>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
>>>> ---
>>>> drivers/of/overlay.c | 45 ++++++++++++++++++++++++++++++++++++++++=
++++-
>>>> 1 file changed, 44 insertions(+), 1 deletion(-)
>>>>=20
>>>> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
>>>> index f17f5ef..c335809 100644
>>>> --- a/drivers/of/overlay.c
>>>> +++ b/drivers/of/overlay.c
>>>> @@ -21,6 +21,7 @@
>>>> #include <linux/err.h>
>>>> #include <linux/idr.h>
>>>> #include <linux/sysfs.h>
>>>> +#include <linux/atomic.h>
>>>>=20
>>>> #include "of_private.h"
>>>>=20
>>>> @@ -55,8 +56,12 @@ struct of_overlay {
>>>> 	struct kobject kobj;
>>>> };
>>>>=20
>>>> +/* master enable switch; once set to 0 can't be re-enabled */
>>>> +static atomic_t ov_enable =3D ATOMIC_INIT(1);
>>>> +
>>>> static int of_overlay_apply_one(struct of_overlay *ov,
>>>> 		struct device_node *target, const struct device_node *overlay);
>>>> +static int overlay_removal_is_ok(struct of_overlay *ov);
>>>>=20
>>>> static int of_overlay_apply_single_property(struct of_overlay *ov,
>>>> 		struct device_node *target, struct property *prop)
>>>> @@ -339,6 +344,37 @@ void of_overlay_release(struct kobject *kobj)
>>>> 	kfree(ov);
>>>> }
>>>>=20
>>>> +static ssize_t enable_show(struct kobject *kobj,
>>>> +		struct kobj_attribute *attr, char *buf)
>>>> +{
>>>> +	return snprintf(buf, PAGE_SIZE, "%d\n", atomic_read(&ov_enable))=
;
>>>> +}
>>>> +
>>>> +static ssize_t enable_store(struct kobject *kobj,
>>>> +		struct kobj_attribute *attr, const char *buf, size_t count)
>>>> +{
>>>> +	int ret;
>>>> +	long new_enable;
>>>> +
>>>> +	ret =3D kstrtol(buf, 10, &new_enable);
>>>> +	if (ret !=3D 0)
>>>> +		return ret;
>>>> +	if ((unsigned long)new_enable > 1)
>>>> +		return -EINVAL;
>>>> +	/* if we've disabled it, no going back */
>>>> +	if (atomic_read(&ov_enable) =3D=3D 0)
>>>> +		return -EPERM;
>>>> +	atomic_set(&ov_enable, (int)new_enable);
>>>> +	return count;
>>>> +}
>>>> +
>>>> +static struct kobj_attribute enable_attr =3D __ATTR_RW(enable);
>>>> +
>>>> +static const struct attribute *overlay_global_attrs[] =3D {
>>>> +	&enable_attr.attr,
>>>> +	NULL
>>>> +};
>>>=20
>>> Why not make this an attribute group and then attach it to the kobj=
_type
>>> to create the files in a race-free manner?
>>>=20
>>=20
>> Err, these are the global attributes. They are attached to the
>> parent of the overlay objects which is a kset object itself.
>=20
> Ick, no, never attach attributes to a kobject that you don't create
> yourself, otherwise it's a race that you lost.
>=20

Err, it is created by me. It=E2=80=99s a kset by the following call:

> ov_kset =3D kset_create_and_add("overlays", NULL, &of_kset->kobj);
>=20

What is the problem with this?

>>>> +
>>>> static struct kobj_type of_overlay_ktype =3D {
>>>> 	.release =3D of_overlay_release,
>>>> };
>>>> @@ -360,6 +396,10 @@ int of_overlay_create(struct device_node *tre=
e)
>>>> 	struct of_overlay *ov;
>>>> 	int err, id;
>>>>=20
>>>> +	/* administratively disabled */
>>>> +	if (!atomic_read(&ov_enable))
>>>> +		return -EPERM;
>>>> +
>>>> 	/* allocate the overlay structure */
>>>> 	ov =3D kzalloc(sizeof(*ov), GFP_KERNEL);
>>>> 	if (ov =3D=3D NULL)
>>>> @@ -596,5 +636,8 @@ int of_overlay_init(void)
>>>> 	if (!ov_kset)
>>>> 		return -ENOMEM;
>>>>=20
>>>> -	return 0;
>>>> +	rc =3D sysfs_create_files(&ov_kset->kobj, overlay_global_attrs);
>>>> +	WARN(rc, "%s: error adding global attributes\n", __func__);
>>>=20
>>> What can a user do with this warning message?  If nothing, then don=
't
>>> print it out, right?
>>>=20
>>> You are creating sysfs files _after_ the kobject has been announced=
 to
>>> userspace, causing nasty race conditions.  Please don't do that.
>>>=20
>>=20
>> This is at overlay_init() time, which is way way before userspace ev=
er
>> has a chance to start. If there=E2=80=99s a different way to attach =
a attribute
>> group to a kset object I=E2=80=99d like to find out how :)
>=20
> You can't load this as a module?  Where exactly in sysfs is this
> kobject, and who creates it?
>=20

No, there=E2=80=99s no way to load this as a module, it=E2=80=99s in /s=
ys/firmware/devicetree

And it=E2=80=99s created by the call to kset_create_and_add()

> thanks,
>=20
> greg k-h

Regards

=E2=80=94 Pantelis
