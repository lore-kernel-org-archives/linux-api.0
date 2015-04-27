From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: Re: [PATCH v3 2/4] of: overlay: global sysfs enable attribute
Date: Mon, 27 Apr 2015 21:25:03 +0300
Message-ID: <9F31828D-016A-4C01-A75D-DF9891DE417A@konsulko.com>
References: <1429868744-19863-1-git-send-email-pantelis.antoniou@konsulko.com> <1429868744-19863-3-git-send-email-pantelis.antoniou@konsulko.com> <20150424203619.GC14970@kroah.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150424203619.GC14970@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Rob Herring <robherring2@gmail.com>, Grant Likely <grant.likely@secretlab.ca>, Andrew Morton <akpm@linux-foundation.org>, Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, devicetree@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Greg,

> On Apr 24, 2015, at 23:36 , Greg KH <greg@kroah.com> wrote:
>=20
> On Fri, Apr 24, 2015 at 12:45:42PM +0300, Pantelis Antoniou wrote:
>> A throw once master enable switch to protect against any
>> further overlay applications if the administrator desires so.
>>=20
>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>> ---
>> drivers/of/overlay.c | 45 ++++++++++++++++++++++++++++++++++++++++++=
++-
>> 1 file changed, 44 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
>> index f17f5ef..c335809 100644
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
>> 	struct kobject kobj;
>> };
>>=20
>> +/* master enable switch; once set to 0 can't be re-enabled */
>> +static atomic_t ov_enable =3D ATOMIC_INIT(1);
>> +
>> static int of_overlay_apply_one(struct of_overlay *ov,
>> 		struct device_node *target, const struct device_node *overlay);
>> +static int overlay_removal_is_ok(struct of_overlay *ov);
>>=20
>> static int of_overlay_apply_single_property(struct of_overlay *ov,
>> 		struct device_node *target, struct property *prop)
>> @@ -339,6 +344,37 @@ void of_overlay_release(struct kobject *kobj)
>> 	kfree(ov);
>> }
>>=20
>> +static ssize_t enable_show(struct kobject *kobj,
>> +		struct kobj_attribute *attr, char *buf)
>> +{
>> +	return snprintf(buf, PAGE_SIZE, "%d\n", atomic_read(&ov_enable));
>> +}
>> +
>> +static ssize_t enable_store(struct kobject *kobj,
>> +		struct kobj_attribute *attr, const char *buf, size_t count)
>> +{
>> +	int ret;
>> +	long new_enable;
>> +
>> +	ret =3D kstrtol(buf, 10, &new_enable);
>=20
> strtobool()?

OK

Regards

=E2=80=94 Pantelis
