From: Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
Subject: Re: [PATCH v7 2/6] of: overlay: global sysfs enable attribute
Date: Thu, 22 Oct 2015 23:25:45 +0300
Message-ID: <50F12602-3286-4037-B2FB-57A85601CAA7@antoniou-consulting.com>
References: <1445543427-26275-1-git-send-email-pantelis.antoniou@konsulko.com> <1445543427-26275-3-git-send-email-pantelis.antoniou@konsulko.com> <20151022201911.GB27977@kroah.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151022201911.GB27977-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Devicetree List <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Greg,

> On Oct 22, 2015, at 23:19 , Greg Kroah-Hartman <gregkh@linuxfoundatio=
n.org> wrote:
>=20
> On Thu, Oct 22, 2015 at 10:50:23PM +0300, Pantelis Antoniou wrote:
>> A throw once master enable switch to protect against any
>> further overlay applications if the administrator desires so.
>>=20
>> A kernel command line option is provided as well.
>>=20
>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
>> ---
>> drivers/of/overlay.c | 50 ++++++++++++++++++++++++++++++++++++++++++=
+++++++-
>> 1 file changed, 49 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
>> index 12c3e47..91f10ed 100644
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
>> @@ -55,8 +56,19 @@ struct of_overlay {
>> 	struct kobject kobj;
>> };
>>=20
>> +/* master enable switch; once set to 0 can't be re-enabled */
>> +static atomic_t ov_enable =3D ATOMIC_INIT(1);
>> +
>> +static int __init of_overlay_disable_setup(char *str __always_unuse=
d)
>> +{
>> +	atomic_set(&ov_enable, 0);
>> +	return 1;
>> +}
>> +__setup("of_overlay_disable", of_overlay_disable_setup);
>> +
>> static int of_overlay_apply_one(struct of_overlay *ov,
>> 		struct device_node *target, const struct device_node *overlay);
>> +static int overlay_removal_is_ok(struct of_overlay *ov);
>>=20
>> static int of_overlay_apply_single_property(struct of_overlay *ov,
>> 		struct device_node *target, struct property *prop)
>> @@ -339,6 +351,35 @@ void of_overlay_release(struct kobject *kobj)
>> 	kfree(ov);
>> }
>>=20
>> +static ssize_t enable_show(struct kobject *kobj,
>> +		struct kobj_attribute *attr, char *buf)
>> +{
>> +	return snprintf(buf, PAGE_SIZE, "%d\n", atomic_read(&ov_enable));
>=20
> Minor nit, you never need to care about the size of the buffer for a
> sysfs file, if you do, you are doing something wrong.  So this can ju=
st
> be:
> 	return sprintf(buf, "%d\n", atomic_read(&ov_enable));
>=20
>=20

Nice to know; I have a ingrained habit to avoid standard sprintf, so..

> Anyway, nothing worth keeping this from being merged:
>=20


Thanks!

> Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
>=20

Regards

=E2=80=94 Pantelis
