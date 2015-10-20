From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v6 3/4] of: overlay: add per overlay sysfs attributes
Date: Wed, 21 Oct 2015 00:15:00 +0300
Message-ID: <D2471EF1-6837-41CC-8205-FE7D8573ACC3@konsulko.com>
References: <1445368397-8732-1-git-send-email-pantelis.antoniou@konsulko.com> <1445368397-8732-4-git-send-email-pantelis.antoniou@konsulko.com> <20151020210806.GC28724@kroah.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151020210806.GC28724-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Greg,

> On Oct 21, 2015, at 00:08 , Greg Kroah-Hartman <gregkh@linuxfoundatio=
n.org> wrote:
>=20
> On Tue, Oct 20, 2015 at 10:13:16PM +0300, Pantelis Antoniou wrote:
>> * A per overlay can_remove sysfs attribute that reports whether
>> the overlay can be removed or not due to another overlapping overlay=
=2E
>>=20
>> * A target sysfs attribute listing the target of each fragment,
>> in a group named after the name of the fragment.
>>=20
>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
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
>> +	struct attribute attr;
>> +	ssize_t (*show)(struct kobject *kobj, struct fragment_attribute *f=
attr,
>> +			char *buf);
>> +	ssize_t (*store)(struct kobject *kobj, struct fragment_attribute *=
fattr,
>> +			 const char *buf, size_t count);
>> +	struct of_overlay_info *ovinfo;
>> +};
>> +
>> /**
>>  * struct of_overlay_info - Holds a single overlay info
>> + * @info:	info node that contains the target and overlay
>>  * @target:	target of the overlay operation
>>  * @overlay:	pointer to the overlay contents node
>>  *
>> @@ -34,8 +49,13 @@
>>  * records.
>>  */
>> struct of_overlay_info {
>> +	struct of_overlay *ov;
>> +	struct device_node *info;
>> 	struct device_node *target;
>> 	struct device_node *overlay;
>> +	struct attribute_group attr_group;
>> +	struct attribute *attrs[2];
>=20
> Why both 2 attributes _and_ an attribute group?  Why not put the
> attributes in the attribute group?
>=20
> And why just one attribute group?  Why not an array of them like the
> rest of the kernel is used to handle?
>=20

Because this makes it easier to add all the attributes for all the frag=
ments in a single
sysfs_create_groups() call, once for each overlay, instead of having a =
call to=20
sysfs_create_group() for each fragment of the overlay.

Reusing driver core helpers is good, no?

> thanks,
>=20
> greg k-h

Regards

=E2=80=94 Pantelis
