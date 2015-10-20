From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: Re: [PATCH v6 3/4] of: overlay: add per overlay sysfs attributes
Date: Wed, 21 Oct 2015 00:11:45 +0300
Message-ID: <8A0C91DE-EDF8-449D-918C-95C9807A7616@konsulko.com>
References: <1445368397-8732-1-git-send-email-pantelis.antoniou@konsulko.com> <1445368397-8732-4-git-send-email-pantelis.antoniou@konsulko.com> <CAL_JsqKFJttTsTfwZdMBPEjzqo_OLV=GpHTYZrDGnsgBjF3Bzg@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAL_JsqKFJttTsTfwZdMBPEjzqo_OLV=GpHTYZrDGnsgBjF3Bzg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Frank Rowand <frowand.list@gmail.com>, Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Rob,

> On Oct 21, 2015, at 00:04 , Rob Herring <robherring2@gmail.com> wrote=
:
>=20
> On Tue, Oct 20, 2015 at 2:13 PM, Pantelis Antoniou
> <pantelis.antoniou@konsulko.com> wrote:
>> * A per overlay can_remove sysfs attribute that reports whether
>> the overlay can be removed or not due to another overlapping overlay=
=2E
>>=20
>> * A target sysfs attribute listing the target of each fragment,
>> in a group named after the name of the fragment.
>>=20
>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>> ---
>> drivers/of/overlay.c | 103 +++++++++++++++++++++++++++++++++++++++++=
++++++++--
>> 1 file changed, 99 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
>> index 067404e..2d51d9e2 100644
>> --- a/drivers/of/overlay.c
>> +++ b/drivers/of/overlay.c
>> @@ -25,8 +25,23 @@
>>=20
>> #include "of_private.h"
>>=20
>> +/* fwd. decl */
>> +struct of_overlay;
>> +struct of_overlay_info;
>> +
>> +/* an attribute for each fragment */
>> +struct fragment_attribute {
>> +       struct attribute attr;
>> +       ssize_t (*show)(struct kobject *kobj, struct fragment_attrib=
ute *fattr,
>> +                       char *buf);
>> +       ssize_t (*store)(struct kobject *kobj, struct fragment_attri=
bute *fattr,
>> +                        const char *buf, size_t count);
>> +       struct of_overlay_info *ovinfo;
>> +};
>> +
>> /**
>>  * struct of_overlay_info - Holds a single overlay info
>> + * @info:      info node that contains the target and overlay
>>  * @target:    target of the overlay operation
>>  * @overlay:   pointer to the overlay contents node
>>  *
>> @@ -34,8 +49,13 @@
>>  * records.
>>  */
>> struct of_overlay_info {
>> +       struct of_overlay *ov;
>> +       struct device_node *info;
>>        struct device_node *target;
>>        struct device_node *overlay;
>> +       struct attribute_group attr_group;
>> +       struct attribute *attrs[2];
>> +       struct fragment_attribute target_attr;
>> };
>>=20
>> /**
>> @@ -52,6 +72,7 @@ struct of_overlay {
>>        struct list_head node;
>>        int count;
>>        struct of_overlay_info *ovinfo_tab;
>> +       const struct attribute_group **attr_groups;
>>        struct of_changeset cset;
>>        struct kobject kobj;
>> };
>> @@ -245,6 +266,8 @@ static int of_fill_overlay_info(struct of_overla=
y *ov,
>>        if (ovinfo->target =3D=3D NULL)
>>                goto err_fail;
>>=20
>> +       ovinfo->info =3D of_node_get(info_node);
>> +
>>        return 0;
>>=20
>> err_fail:
>> @@ -255,6 +278,17 @@ err_fail:
>>        return -EINVAL;
>> }
>>=20
>> +static ssize_t target_show(struct kobject *kobj,
>> +               struct fragment_attribute *fattr, char *buf)
>> +{
>> +       struct of_overlay_info *ovinfo =3D fattr->ovinfo;
>> +
>> +       return snprintf(buf, PAGE_SIZE, "%s\n",
>> +                       of_node_full_name(ovinfo->target));
>=20
> This can be a link to the node itself, can't it?
>=20

Yes. Do you want it like this?

> Rob

Regards

=E2=80=94 Pantelis
