From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v5 1/4] of: overlay: kobjectify overlay objects
Date: Tue, 20 Oct 2015 16:47:51 +0300
Message-ID: <D785F4FF-CD2F-4ABA-A673-F51D76D628CA@konsulko.com>
References: <1442419751-4846-1-git-send-email-pantelis.antoniou@konsulko.com> <1442419751-4846-2-git-send-email-pantelis.antoniou@konsulko.com> <20151004192210.GD9649@kroah.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151004192210.GD9649-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Devicetree List <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Greg,

> On Oct 4, 2015, at 22:22 , Greg Kroah-Hartman <gregkh@linuxfoundation=
=2Eorg> wrote:
>=20
> On Wed, Sep 16, 2015 at 07:09:08PM +0300, Pantelis Antoniou wrote:
>> We are going to need the overlays to appear on sysfs with runtime
>> global properties (like master enable) so turn them into kobjects.
>>=20
>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
>> ---
>> drivers/of/base.c       |  7 +++++++
>> drivers/of/of_private.h |  9 +++++++++
>> drivers/of/overlay.c    | 52 +++++++++++++++++++++++++++++++++++++++=
++++++++--
>> 3 files changed, 66 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/drivers/of/base.c b/drivers/of/base.c
>> index 8b5a187..31c0c8f 100644
>> --- a/drivers/of/base.c
>> +++ b/drivers/of/base.c
>> @@ -192,6 +192,7 @@ int __of_attach_node_sysfs(struct device_node *n=
p)
>> void __init of_core_init(void)
>> {
>> 	struct device_node *np;
>> +	int ret;
>>=20
>> 	/* Create the kset, and register existing nodes */
>> 	mutex_lock(&of_mutex);
>> @@ -208,6 +209,12 @@ void __init of_core_init(void)
>> 	/* Symlink in /proc as required by userspace ABI */
>> 	if (of_root)
>> 		proc_symlink("device-tree", NULL, "/sys/firmware/devicetree/base")=
;
>> +
>> +	ret =3D of_overlay_init();
>> +	if (ret !=3D 0)
>> +		pr_warn("of_init: of_overlay_init failed!\n");
>> +
>> +	return 0;
>> }
>>=20
>> static struct property *__of_find_property(const struct device_node =
*np,
>> diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
>> index 8e882e7..120eb44 100644
>> --- a/drivers/of/of_private.h
>> +++ b/drivers/of/of_private.h
>> @@ -90,4 +90,13 @@ extern void __of_detach_node_sysfs(struct device_=
node *np);
>> #define for_each_transaction_entry_reverse(_oft, _te) \
>> 	list_for_each_entry_reverse(_te, &(_oft)->te_list, node)
>>=20
>> +#if defined(CONFIG_OF_OVERLAY)
>> +extern int of_overlay_init(void);
>> +#else
>> +static inline int of_overlay_init(void)
>> +{
>> +	return 0;
>> +}
>> +#endif
>> +
>> #endif /* _LINUX_OF_PRIVATE_H */
>> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
>> index 24e025f..eeb3ec2 100644
>> --- a/drivers/of/overlay.c
>> +++ b/drivers/of/overlay.c
>> @@ -20,6 +20,7 @@
>> #include <linux/slab.h>
>> #include <linux/err.h>
>> #include <linux/idr.h>
>> +#include <linux/sysfs.h>
>>=20
>> #include "of_private.h"
>>=20
>> @@ -51,6 +52,7 @@ struct of_overlay {
>> 	int count;
>> 	struct of_overlay_info *ovinfo_tab;
>> 	struct of_changeset cset;
>> +	struct kobject kobj;
>> };
>>=20
>> static int of_overlay_apply_one(struct of_overlay *ov,
>> @@ -325,6 +327,24 @@ static int of_free_overlay_info(struct of_overl=
ay *ov)
>> static LIST_HEAD(ov_list);
>> static DEFINE_IDR(ov_idr);
>>=20
>> +static inline struct of_overlay *kobj_to_overlay(struct kobject *ko=
bj)
>> +{
>> +	return container_of(kobj, struct of_overlay, kobj);
>> +}
>> +
>> +void of_overlay_release(struct kobject *kobj)
>> +{
>> +	struct of_overlay *ov =3D kobj_to_overlay(kobj);
>> +
>> +	kfree(ov);
>> +}
>> +
>> +static struct kobj_type of_overlay_ktype =3D {
>> +	.release =3D of_overlay_release,
>> +};
>> +
>> +static struct kset *ov_kset;
>> +
>> /**
>>  * of_overlay_create() - Create and apply an overlay
>>  * @tree:	Device node containing all the overlays
>> @@ -350,6 +370,9 @@ int of_overlay_create(struct device_node *tree)
>>=20
>> 	of_changeset_init(&ov->cset);
>>=20
>> +	/* initialize kobject */
>> +	kobject_init(&ov->kobj, &of_overlay_ktype);
>> +
>> 	mutex_lock(&of_mutex);
>>=20
>> 	id =3D idr_alloc(&ov_idr, ov, 0, 0, GFP_KERNEL);
>> @@ -385,6 +408,14 @@ int of_overlay_create(struct device_node *tree)
>> 		goto err_revert_overlay;
>> 	}
>>=20
>> +	ov->kobj.kset =3D ov_kset;
>> +	err =3D kobject_add(&ov->kobj, NULL, "%d", id);
>=20
> NULL for the parent?  Really?  Where does that cause this kobject to
> show up in the sysfs tree?
>=20

It shows up in the root of it=E2=80=99s kset, i.e. /sys/firmware/device=
tree/overlays

It=E2=80=99s a common idiom in the kernel as evident by:

$ grep 'kobject_add([^,]*,[^,]NULL' drivers/ -r
drivers/of/base.c:		rc =3D kobject_add(&np->kobj, NULL, "%s",
drivers/firmware/memmap.c:	if (kobject_add(&entry->kobj, NULL, "%d", ma=
p_entries_nr++))
drivers/firmware/efi/runtime-map.c:	ret =3D kobject_add(&entry->kobj, N=
ULL, "%d", nr);

>> @@ -512,7 +545,9 @@ int of_overlay_destroy(int id)
>> 	of_free_overlay_info(ov);
>> 	idr_remove(&ov_idr, id);
>> 	of_changeset_destroy(&ov->cset);
>> -	kfree(ov);
>> +
>> +	kobject_del(&ov->kobj);
>> +	kobject_put(&ov->kobj);
>=20
> Two drops of the reference?
>=20

There=E2=80=99s a single drop. Only kobject_put drops the reference. Bu=
t you=E2=80=99re right,
the kobject_del is not required; it=E2=80=99s performed implicitly by t=
he kobj_cleanup()
method.

=46ixing in the new patch.

> void of_overlay_release(struct kobject *kobj)
> {
>         struct of_overlay *ov =3D kobj_to_overlay(kobj);
>=20
>         of_node_put(ov->target_root);
>         kfree(ov->indirect_id);
>         kfree(ov);
> }

>>=20
>> 	err =3D 0;
>>=20
>> @@ -542,7 +577,8 @@ int of_overlay_destroy_all(void)
>> 		of_changeset_revert(&ov->cset);
>> 		of_free_overlay_info(ov);
>> 		idr_remove(&ov_idr, ov->id);
>> -		kfree(ov);
>> +		kobject_del(&ov->kobj);
>> +		kobject_put(&ov->kobj);
>=20
> Again, why 2?
>=20
> thanks,
>=20
> greg k-h

Regards

=E2=80=94 Pantelis
