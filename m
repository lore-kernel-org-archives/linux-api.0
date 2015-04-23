From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: Re: [PATCH v2 3/4] of: overlay: Add sysfs attributes
Date: Thu, 23 Apr 2015 15:39:21 +0300
Message-ID: <98237E9E-04CB-4CD5-8B2F-63F070B54459@konsulko.com>
References: <1428434632-13789-1-git-send-email-pantelis.antoniou@konsulko.com> <1428434632-13789-4-git-send-email-pantelis.antoniou@konsulko.com> <CAL_JsqLMVBfQpmSjg9qfOvtM3RXMY3Dm+knN8h54gDCzx513-g@mail.gmail.com> <6E391B8F-936A-4FD1-B8CC-C9B5FCE0B291@konsulko.com> <20150423123346.GA19166@kroah.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150423123346.GA19166@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Rob Herring <robherring2@gmail.com>, Grant Likely <grant.likely@secretlab.ca>, Andrew Morton <akpm@linux-foundation.org>, Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Greg,

> On Apr 23, 2015, at 15:33 , Greg KH <greg@kroah.com> wrote:
>=20
> On Thu, Apr 23, 2015 at 03:00:03PM +0300, Pantelis Antoniou wrote:
>> Hi Rob,
>>=20
>>> On Apr 15, 2015, at 04:27 , Rob Herring <robherring2@gmail.com> wro=
te:
>>>=20
>>> On Tue, Apr 7, 2015 at 2:23 PM, Pantelis Antoniou
>>> <pantelis.antoniou@konsulko.com> wrote:
>>>> Implement a number of sysfs attributes for overlays.
>>>>=20
>>>> * A throw once master enable switch to protect against any
>>>> further overlay applications if the administrator desires so.
>>>=20
>>> This one should be a separate patch.
>>>=20
>>=20
>> OK.
>>=20
>>>> * A per overlay targets sysfs attribute listing the targets of
>>>> the installed overlay.
>>>=20
>>> What are targets? "targets lists targets" does not help me. The
>>> documentation doesn't help me either.
>>>=20
>>=20
>> It lists the targets of the overlay that has been applied. What do
>> you need in order to be helped? I mean what do you want listed?
>>=20
>>>> * A per overlay can_remove sysfs attribute that reports whether
>>>> the overlay can be removed or not due to another overlapping overl=
ay.
>>>>=20
>>>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>>>> ---
>>>> drivers/of/overlay.c | 167 +++++++++++++++++++++++++++++++++++++++=
+++++++++++-
>>>> 1 file changed, 166 insertions(+), 1 deletion(-)
>>>>=20
>>>> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
>>>> index f17f5ef..c54d097 100644
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
>>>>       struct kobject kobj;
>>>> };
>>>>=20
>>>> +/* master enable switch; once set to 0 can't be re-enabled */
>>>> +static atomic_t ov_enable =3D ATOMIC_INIT(1);
>>>> +
>>>> static int of_overlay_apply_one(struct of_overlay *ov,
>>>>               struct device_node *target, const struct device_node=
 *overlay);
>>>> +static int overlay_removal_is_ok(struct of_overlay *ov);
>>>>=20
>>>> static int of_overlay_apply_single_property(struct of_overlay *ov,
>>>>               struct device_node *target, struct property *prop)
>>>> @@ -345,6 +350,144 @@ static struct kobj_type of_overlay_ktype =3D=
 {
>>>>=20
>>>> static struct kset *ov_kset;
>>>>=20
>>>> +static ssize_t enable_read(struct file *filp, struct kobject *kob=
j,
>>>> +               struct bin_attribute *bin_attr, char *buf,
>>>> +               loff_t offset, size_t count)
>>>> +{
>>>> +       char tbuf[3];
>>>> +
>>>> +       if (offset < 0)
>>>> +               return -EINVAL;
>>>> +
>>>> +       if (offset >=3D sizeof(tbuf))
>>>> +               return 0;
>>>> +
>>>> +       if (count > sizeof(tbuf) - offset)
>>>> +               count =3D sizeof(tbuf) - offset;
>>>> +
>>>> +       /* fill in temp */
>>>> +       tbuf[0] =3D '0' + atomic_read(&ov_enable);
>>>> +       tbuf[1] =3D '\n';
>>>> +       tbuf[2] =3D '\0';
>>>> +
>>>> +       /* copy to buffer */
>>>> +       memcpy(buf, tbuf + offset, count);
>>>> +
>>>> +       return count;
>>>> +}
>>>> +
>>>> +static ssize_t enable_write(struct file *filp, struct kobject *ko=
bj,
>>>> +               struct bin_attribute *bin_attr, char *buf,
>>>> +               loff_t off, size_t count)
>>>> +{
>>>> +       unsigned int new_enable;
>>>> +
>>>> +       if (off !=3D 0 || (buf[0] !=3D '0' && buf[0] !=3D '1'))
>>>> +               return -EINVAL;
>>>> +
>>>> +       new_enable =3D (unsigned int)(buf[0] - '0');
>>>> +       if (new_enable > 1)
>>>> +               return -EINVAL;
>>>> +
>>>> +       /* NOP for same value */
>>>> +       if (new_enable =3D=3D atomic_read(&ov_enable))
>>>> +               return count;
>>>> +
>>>> +       /* if we've disabled it, no going back */
>>>> +       if (atomic_read(&ov_enable) =3D=3D 0)
>>>> +               return -EPERM;
>>>> +
>>>> +       atomic_set(&ov_enable, new_enable);
>>>> +       return count;
>>>> +}
>>>> +
>>>> +/* just a single char + '\n' + '\0' */
>>>> +static BIN_ATTR_RW(enable, 3);
>>>=20
>>> Why are you using bin attribute? You are complicating the
>>> implementation needlessly.
>>>=20
>>=20
>> It=E2=80=99s the same reason that the device tree core is using it.
>=20
> It is doing that for "raw" device tree files, not individual attribut=
es,
> right?
>=20

Each property of a device tree is a binary attribute.

>> Believe it or not, this is the simplest way to do it.
>> If you take a look at the sysfs attribute implementation, the binary
>> implementation is the one that=E2=80=99s using the least amount of c=
ode.
>=20
> Then something is really wrong here.
>=20
>> To use a non-binary method we have to register per ktype sysfs_ops
>> and duplicate the way the non-binary attribute works.
>=20
> really?  Again, something must be wrong.
>=20
>> For the gory details look at sysfs_add_file_mode_ns() in fs/sysfs/fi=
le.c
>>=20
>> I can add the sysfs_ops but that=E2=80=99s going to be more complica=
ted not less.
>=20

Please take a look in linux/sysfs.h.
The non-binary sysfs accessors are all using some kind of other kobj;=20
for instance DEVICE_ATTR is using a device_attribute, etc.

=46or the overlay case, I=E2=80=99d have to create a of_overlay_attribu=
te and work from
there.

> Only use binary sysfs files if you are accepting binary data directly
> from userspace and using it as a "pass-through" to the kernel.
>=20
> Otherwise just use a "normal" sysfs file.  I don't understand the
> problem here, sysfs shouldn't be hard to use for simple attributes, t=
hat
> was not the goal here at all.
>=20

There is no generic (i.e. not kobj type specific), non-binary sysfs fil=
e interface right now.
I can add one for my case, but that=E2=80=99s more code.

It=E2=80=99s your call.

> thanks,
>=20
> greg k-h

Regards

=E2=80=94 Pantelis
