From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v5 3/4] of: overlay: add per overlay sysfs attributes
Date: Wed, 16 Sep 2015 22:08:08 +0300
Message-ID: <78DBB3F7-A3E8-431F-B8E2-AE54D24F9D00@konsulko.com>
References: <1442419751-4846-1-git-send-email-pantelis.antoniou@konsulko.com> <1442419751-4846-4-git-send-email-pantelis.antoniou@konsulko.com> <CAL_Jsq+N43c-A175QC0L9jpEP9ZptugDLChMEJgs76=1NEP3Mw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL_Jsq+N43c-A175QC0L9jpEP9ZptugDLChMEJgs76=1NEP3Mw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Rob,

> On Sep 16, 2015, at 19:45 , Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
>=20
> On Wed, Sep 16, 2015 at 11:09 AM, Pantelis Antoniou
> <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org> wrote:
>> The two default overlay attributes are:
>>=20
>> * A targets sysfs attribute listing the targets of the installed
>> overlay. The targets list the path on the kernel's device tree
>> where each overlay fragment is applied to
>>=20
>> * A per overlay can_remove sysfs attribute that reports whether
>> the overlay can be removed or not due to another overlapping overlay=
=2E
>>=20
>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
>> ---
>=20
> How about an answer to my v4 questions?
>=20

Q. "What will a user do with this information? Can this just be debugfs=
?
Don't we already have the targets in the overlay itself? If we are
going to provide some overlay info, shouldn't we provide all of it
(i.e. the FDT). For example, what do we do on a kexec?=E2=80=9D

A. The user can easily tell whether an overlay is removable using the c=
an_remove
attribute. This can be used by higher layer to inform users whether it=E2=
=80=99s safe to
remove an overlay or not (perhaps light up a BUSY led)

The targets attribute can let the user figure out what devices (as evid=
ent by the
nodes they point to) are affected by the overlay. This was actually use=
d by me
to figure out the TI LCDC DRM driver use of overlays by looking at the =
targets
pointing there.

Debugfs is a bad fit since these are per-overlay attributes that a user=
-space application
can use to present some kind of meaningful information to the user.

Providing the FDT of the overlay is only possible when the overlay orig=
in is indeed a
DT blob, which is not always the case. The overlay API only uses unflat=
tened trees.
The DT blob can be provided only by the caller, which has access to the=
 blob.
To hang the FDT blob to overlay kobj we need to extend the overlay API =
to=20
return the kobj of the overlay (which I intent to do in the near future=
).

Kexec is really tricky. I purposefully didn=E2=80=99t try to address it=
 since in the
previous discussion with Grant we couldn=E2=80=99t get to an agreed def=
ault. It seems it is
a per-platform/per-policy decision, and we lack the users to tell us wh=
ich is the most
prominent.
We have two ways to handle it: a) Leave the kernel tree as it is, flatt=
en it and
kexec with it. That would remove the overlays but the state of the the =
devices would persist.
b) Remove the overlays in the proper sequence and kexec with the clean =
kernel tree. That
would necessitate the re-application of the overlays to get to the same=
 device tree state.


> Rob
>=20

Regards

=E2=80=94 Pantelis

>> drivers/of/overlay.c | 53 ++++++++++++++++++++++++++++++++++++++++++=
++++++++++
>> 1 file changed, 53 insertions(+)
>>=20
>> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
>> index 62cfb99..cff3c05 100644
>> --- a/drivers/of/overlay.c
>> +++ b/drivers/of/overlay.c
>> @@ -373,8 +373,61 @@ static const struct attribute *overlay_global_a=
ttrs[] =3D {
>>        NULL
>> };
>>=20
>> +static ssize_t can_remove_show(struct kobject *kobj,
>> +               struct kobj_attribute *attr, char *buf)
>> +{
>> +       struct of_overlay *ov =3D kobj_to_overlay(kobj);
>> +
>> +       return snprintf(buf, PAGE_SIZE, "%d\n", overlay_removal_is_o=
k(ov));
>> +}
>> +
>> +static ssize_t targets_show(struct kobject *kobj,
>> +               struct kobj_attribute *attr, char *buf)
>> +{
>> +       struct of_overlay *ov =3D kobj_to_overlay(kobj);
>> +       struct of_overlay_info *ovinfo;
>> +       char *s, *e;
>> +       ssize_t ret;
>> +       int i, len;
>> +
>> +       s =3D buf;
>> +       e =3D buf + PAGE_SIZE;
>> +
>> +       mutex_lock(&of_mutex);
>> +
>> +       /* targets */
>> +       for (i =3D 0; i < ov->count; i++) {
>> +               ovinfo =3D &ov->ovinfo_tab[i];
>> +
>> +               len =3D snprintf(s, e - s, "%s\n",
>> +                               of_node_full_name(ovinfo->target));
>> +               if (len =3D=3D 0) {
>> +                       ret =3D -ENOSPC;
>> +                       goto err;
>> +               }
>> +               s +=3D len;
>> +       }
>> +
>> +       /* the buffer is zero terminated */
>> +       ret =3D s - buf;
>> +err:
>> +       mutex_unlock(&of_mutex);
>> +       return ret;
>> +}
>> +
>> +static struct kobj_attribute can_remove_attr =3D __ATTR_RO(can_remo=
ve);
>> +static struct kobj_attribute targets_attr =3D __ATTR_RO(targets);
>> +
>> +static struct attribute *overlay_attrs[] =3D {
>> +       &can_remove_attr.attr,
>> +       &targets_attr.attr,
>> +       NULL
>> +};
>> +
>> static struct kobj_type of_overlay_ktype =3D {
>>        .release =3D of_overlay_release,
>> +       .sysfs_ops =3D &kobj_sysfs_ops,   /* default kobj sysfs ops =
*/
>> +       .default_attrs =3D overlay_attrs,
>> };
>>=20
>> static struct kset *ov_kset;
>> --
>> 1.7.12
>>=20
