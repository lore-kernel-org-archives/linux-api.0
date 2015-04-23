From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 3/4] of: overlay: Add sysfs attributes
Date: Thu, 23 Apr 2015 15:59:02 +0300
Message-ID: <5F0BA9FB-8345-4296-8595-0E4CD1C816AA@konsulko.com>
References: <1428434632-13789-1-git-send-email-pantelis.antoniou@konsulko.com> <1428434632-13789-4-git-send-email-pantelis.antoniou@konsulko.com> <CAL_JsqLMVBfQpmSjg9qfOvtM3RXMY3Dm+knN8h54gDCzx513-g@mail.gmail.com> <6E391B8F-936A-4FD1-B8CC-C9B5FCE0B291@konsulko.com> <20150423123346.GA19166@kroah.com> <98237E9E-04CB-4CD5-8B2F-63F070B54459@konsulko.com> <20150423125441.GA32303@kroah.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150423125441.GA32303-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Greg,

> On Apr 23, 2015, at 15:54 , Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
>=20
> On Thu, Apr 23, 2015 at 03:39:21PM +0300, Pantelis Antoniou wrote:
>> Hi Greg,
>>=20
>>> On Apr 23, 2015, at 15:33 , Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
>>>=20
>>> On Thu, Apr 23, 2015 at 03:00:03PM +0300, Pantelis Antoniou wrote:
>>>> Hi Rob,
>>>>=20
>>>>> On Apr 15, 2015, at 04:27 , Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
>>>>>=20
>>>>> On Tue, Apr 7, 2015 at 2:23 PM, Pantelis Antoniou
>>>>> <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org> wrote:
>>>>>> Implement a number of sysfs attributes for overlays.
>>>>>>=20
>>>>>> * A throw once master enable switch to protect against any
>>>>>> further overlay applications if the administrator desires so.
>>>>>=20
>>>>> This one should be a separate patch.
>>>>>=20
>>>>=20
>>>> OK.
>>>>=20
>>>>>> * A per overlay targets sysfs attribute listing the targets of
>>>>>> the installed overlay.
>>>>>=20
>>>>> What are targets? "targets lists targets" does not help me. The
>>>>> documentation doesn't help me either.
>>>>>=20
>>>>=20
>>>> It lists the targets of the overlay that has been applied. What do
>>>> you need in order to be helped? I mean what do you want listed?
>>>>=20
>>>>>> * A per overlay can_remove sysfs attribute that reports whether
>>>>>> the overlay can be removed or not due to another overlapping ove=
rlay.
>>>>>>=20
>>>>>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org=
>
>>>>>> ---
>>>>>> drivers/of/overlay.c | 167 +++++++++++++++++++++++++++++++++++++=
+++++++++++++-
>>>>>> 1 file changed, 166 insertions(+), 1 deletion(-)
>>>>>>=20
>>>>>> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
>>>>>> index f17f5ef..c54d097 100644
>>>>>> --- a/drivers/of/overlay.c
>>>>>> +++ b/drivers/of/overlay.c
>>>>>> @@ -21,6 +21,7 @@
>>>>>> #include <linux/err.h>
>>>>>> #include <linux/idr.h>
>>>>>> #include <linux/sysfs.h>
>>>>>> +#include <linux/atomic.h>
>>>>>>=20
>>>>>> #include "of_private.h"
>>>>>>=20
>>>>>> @@ -55,8 +56,12 @@ struct of_overlay {
>>>>>>      struct kobject kobj;
>>>>>> };
>>>>>>=20
>>>>>> +/* master enable switch; once set to 0 can't be re-enabled */
>>>>>> +static atomic_t ov_enable =3D ATOMIC_INIT(1);
>>>>>> +
>>>>>> static int of_overlay_apply_one(struct of_overlay *ov,
>>>>>>              struct device_node *target, const struct device_nod=
e *overlay);
>>>>>> +static int overlay_removal_is_ok(struct of_overlay *ov);
>>>>>>=20
>>>>>> static int of_overlay_apply_single_property(struct of_overlay *o=
v,
>>>>>>              struct device_node *target, struct property *prop)
>>>>>> @@ -345,6 +350,144 @@ static struct kobj_type of_overlay_ktype =3D=
 {
>>>>>>=20
>>>>>> static struct kset *ov_kset;
>>>>>>=20
>>>>>> +static ssize_t enable_read(struct file *filp, struct kobject *k=
obj,
>>>>>> +               struct bin_attribute *bin_attr, char *buf,
>>>>>> +               loff_t offset, size_t count)
>>>>>> +{
>>>>>> +       char tbuf[3];
>>>>>> +
>>>>>> +       if (offset < 0)
>>>>>> +               return -EINVAL;
>>>>>> +
>>>>>> +       if (offset >=3D sizeof(tbuf))
>>>>>> +               return 0;
>>>>>> +
>>>>>> +       if (count > sizeof(tbuf) - offset)
>>>>>> +               count =3D sizeof(tbuf) - offset;
>>>>>> +
>>>>>> +       /* fill in temp */
>>>>>> +       tbuf[0] =3D '0' + atomic_read(&ov_enable);
>>>>>> +       tbuf[1] =3D '\n';
>>>>>> +       tbuf[2] =3D '\0';
>>>>>> +
>>>>>> +       /* copy to buffer */
>>>>>> +       memcpy(buf, tbuf + offset, count);
>>>>>> +
>>>>>> +       return count;
>>>>>> +}
>>>>>> +
>>>>>> +static ssize_t enable_write(struct file *filp, struct kobject *=
kobj,
>>>>>> +               struct bin_attribute *bin_attr, char *buf,
>>>>>> +               loff_t off, size_t count)
>>>>>> +{
>>>>>> +       unsigned int new_enable;
>>>>>> +
>>>>>> +       if (off !=3D 0 || (buf[0] !=3D '0' && buf[0] !=3D '1'))
>>>>>> +               return -EINVAL;
>>>>>> +
>>>>>> +       new_enable =3D (unsigned int)(buf[0] - '0');
>>>>>> +       if (new_enable > 1)
>>>>>> +               return -EINVAL;
>>>>>> +
>>>>>> +       /* NOP for same value */
>>>>>> +       if (new_enable =3D=3D atomic_read(&ov_enable))
>>>>>> +               return count;
>>>>>> +
>>>>>> +       /* if we've disabled it, no going back */
>>>>>> +       if (atomic_read(&ov_enable) =3D=3D 0)
>>>>>> +               return -EPERM;
>>>>>> +
>>>>>> +       atomic_set(&ov_enable, new_enable);
>>>>>> +       return count;
>>>>>> +}
>>>>>> +
>>>>>> +/* just a single char + '\n' + '\0' */
>>>>>> +static BIN_ATTR_RW(enable, 3);
>>>>>=20
>>>>> Why are you using bin attribute? You are complicating the
>>>>> implementation needlessly.
>>>>>=20
>>>>=20
>>>> It=E2=80=99s the same reason that the device tree core is using it=
=2E
>>>=20
>>> It is doing that for "raw" device tree files, not individual attrib=
utes,
>>> right?
>>>=20
>>=20
>> Each property of a device tree is a binary attribute.
>=20
> Because they export binary data, right?  I don't have access to a
> machine that uses device tree at the moment to check this...
>=20
> Any specific file/function you are referring to?
>=20

Yes, they export binary data. It works because the device tree nodes
are raw kobjs.

>>>> Believe it or not, this is the simplest way to do it.
>>>> If you take a look at the sysfs attribute implementation, the bina=
ry
>>>> implementation is the one that=E2=80=99s using the least amount of=
 code.
>>>=20
>>> Then something is really wrong here.
>>>=20
>>>> To use a non-binary method we have to register per ktype sysfs_ops
>>>> and duplicate the way the non-binary attribute works.
>>>=20
>>> really?  Again, something must be wrong.
>>>=20
>>>> For the gory details look at sysfs_add_file_mode_ns() in fs/sysfs/=
file.c
>>>>=20
>>>> I can add the sysfs_ops but that=E2=80=99s going to be more compli=
cated not less.
>>>=20
>>=20
>> Please take a look in linux/sysfs.h.
>> The non-binary sysfs accessors are all using some kind of other kobj=
;=20
>> for instance DEVICE_ATTR is using a device_attribute, etc.
>>=20
>> For the overlay case, I=E2=80=99d have to create a of_overlay_attrib=
ute and work from
>> there.
>=20
> Yes, that is what you should be doing here as well.
>=20
> That's just the model we have to work with, the uses of "raw" kobject=
s
> are very limited, so it does take a bit more wrapper code to use them=
,
> sorry.
>=20

That=E2=80=99s fine, I can work with this. I was trying to avoid creati=
ng overlay
attributes but...

> You need access to the kobject anyway, which is why you need to provi=
de
> a type of attribute function, so that you get the right kobject.
>=20
> Or just use an attribute group, would that be simpler?  If you have m=
ore
> than one sysfs file, that's usually the best way to do things.
>=20

Attribute groups might work, but I have some more work to do to get the=
m to
work.

Thanks for answering definitively this.
=20
> thanks,
>=20
> greg k-h

Regards

=E2=80=94 Pantelis

--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
