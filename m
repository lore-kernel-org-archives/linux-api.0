From: Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH 3/5] of: overlay: Master enable switch
Date: Fri, 27 Mar 2015 11:25:51 -0700
Message-ID: <5E1A1C3D-5D4C-4E18-97CB-60781393A5A0@antoniou-consulting.com>
References: <1426624257-23003-1-git-send-email-pantelis.antoniou@konsulko.com> <1426624257-23003-4-git-send-email-pantelis.antoniou@konsulko.com> <CAL_JsqKZZW=Vq9Mry9H0yjnv=TW8P=xzyX3EjQP+B15U0roaBA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAL_JsqKZZW=Vq9Mry9H0yjnv=TW8P=xzyX3EjQP+B15U0roaBA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Andrew Morton <akpm@linux-foundation.org>, Matt Porter <matt.porter@linaro.org>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Rob,

> On Mar 24, 2015, at 22:25 , Rob Herring <robherring2@gmail.com> wrote=
:
>=20
> On Tue, Mar 17, 2015 at 3:30 PM, Pantelis Antoniou
> <pantelis.antoniou@konsulko.com> wrote:
>> Implement a throw once master enable switch to protect against any
>> further overlay applications if the administrator desires so.
>=20
> sysfs documentation?
>=20

OK, coming up.

>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>> ---
>> drivers/of/overlay.c | 66 ++++++++++++++++++++++++++++++++++++++++++=
+++++++++-
>> 1 file changed, 65 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
>> index f17f5ef..6688797 100644
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
>> @@ -55,6 +56,9 @@ struct of_overlay {
>>        struct kobject kobj;
>> };
>>=20
>> +/* master enable switch; once set to 0 can't be re-enabled */
>> +static atomic_t ov_enable =3D ATOMIC_INIT(1);
>> +
>> static int of_overlay_apply_one(struct of_overlay *ov,
>>                struct device_node *target, const struct device_node =
*overlay);
>>=20
>> @@ -345,6 +349,60 @@ static struct kobj_type of_overlay_ktype =3D {
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
>> +       int new_enable;
>> +
>> +       if (off !=3D 0 || (buf[0] !=3D '0' && buf[1] !=3D '1'))
>=20
> Is buf[1] correct here?
>=20

Nope.

>> +               return -EINVAL;
>> +
>> +       new_enable =3D buf[0] - '0';
>> +       if (new_enable !=3D 0 && new_enable !=3D 1)
>=20
> Make unsigned just "if (new_enable > 1)=E2=80=9D.
>=20

OK.

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
>> +
>> /**
>>  * of_overlay_create() - Create and apply an overlay
>>  * @tree:      Device node containing all the overlays
>> @@ -360,6 +418,10 @@ int of_overlay_create(struct device_node *tree)
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
>> @@ -596,5 +658,7 @@ int of_overlay_init(void)
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
