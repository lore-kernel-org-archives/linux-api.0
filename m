From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v5 1/4] of: overlay: kobjectify overlay objects
Date: Sun, 4 Oct 2015 20:22:10 +0100
Message-ID: <20151004192210.GD9649@kroah.com>
References: <1442419751-4846-1-git-send-email-pantelis.antoniou@konsulko.com>
 <1442419751-4846-2-git-send-email-pantelis.antoniou@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1442419751-4846-2-git-send-email-pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Cc: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Sep 16, 2015 at 07:09:08PM +0300, Pantelis Antoniou wrote:
> We are going to need the overlays to appear on sysfs with runtime
> global properties (like master enable) so turn them into kobjects.
> 
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/of/base.c       |  7 +++++++
>  drivers/of/of_private.h |  9 +++++++++
>  drivers/of/overlay.c    | 52 +++++++++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 66 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 8b5a187..31c0c8f 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -192,6 +192,7 @@ int __of_attach_node_sysfs(struct device_node *np)
>  void __init of_core_init(void)
>  {
>  	struct device_node *np;
> +	int ret;
>  
>  	/* Create the kset, and register existing nodes */
>  	mutex_lock(&of_mutex);
> @@ -208,6 +209,12 @@ void __init of_core_init(void)
>  	/* Symlink in /proc as required by userspace ABI */
>  	if (of_root)
>  		proc_symlink("device-tree", NULL, "/sys/firmware/devicetree/base");
> +
> +	ret = of_overlay_init();
> +	if (ret != 0)
> +		pr_warn("of_init: of_overlay_init failed!\n");
> +
> +	return 0;
>  }
>  
>  static struct property *__of_find_property(const struct device_node *np,
> diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
> index 8e882e7..120eb44 100644
> --- a/drivers/of/of_private.h
> +++ b/drivers/of/of_private.h
> @@ -90,4 +90,13 @@ extern void __of_detach_node_sysfs(struct device_node *np);
>  #define for_each_transaction_entry_reverse(_oft, _te) \
>  	list_for_each_entry_reverse(_te, &(_oft)->te_list, node)
>  
> +#if defined(CONFIG_OF_OVERLAY)
> +extern int of_overlay_init(void);
> +#else
> +static inline int of_overlay_init(void)
> +{
> +	return 0;
> +}
> +#endif
> +
>  #endif /* _LINUX_OF_PRIVATE_H */
> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
> index 24e025f..eeb3ec2 100644
> --- a/drivers/of/overlay.c
> +++ b/drivers/of/overlay.c
> @@ -20,6 +20,7 @@
>  #include <linux/slab.h>
>  #include <linux/err.h>
>  #include <linux/idr.h>
> +#include <linux/sysfs.h>
>  
>  #include "of_private.h"
>  
> @@ -51,6 +52,7 @@ struct of_overlay {
>  	int count;
>  	struct of_overlay_info *ovinfo_tab;
>  	struct of_changeset cset;
> +	struct kobject kobj;
>  };
>  
>  static int of_overlay_apply_one(struct of_overlay *ov,
> @@ -325,6 +327,24 @@ static int of_free_overlay_info(struct of_overlay *ov)
>  static LIST_HEAD(ov_list);
>  static DEFINE_IDR(ov_idr);
>  
> +static inline struct of_overlay *kobj_to_overlay(struct kobject *kobj)
> +{
> +	return container_of(kobj, struct of_overlay, kobj);
> +}
> +
> +void of_overlay_release(struct kobject *kobj)
> +{
> +	struct of_overlay *ov = kobj_to_overlay(kobj);
> +
> +	kfree(ov);
> +}
> +
> +static struct kobj_type of_overlay_ktype = {
> +	.release = of_overlay_release,
> +};
> +
> +static struct kset *ov_kset;
> +
>  /**
>   * of_overlay_create() - Create and apply an overlay
>   * @tree:	Device node containing all the overlays
> @@ -350,6 +370,9 @@ int of_overlay_create(struct device_node *tree)
>  
>  	of_changeset_init(&ov->cset);
>  
> +	/* initialize kobject */
> +	kobject_init(&ov->kobj, &of_overlay_ktype);
> +
>  	mutex_lock(&of_mutex);
>  
>  	id = idr_alloc(&ov_idr, ov, 0, 0, GFP_KERNEL);
> @@ -385,6 +408,14 @@ int of_overlay_create(struct device_node *tree)
>  		goto err_revert_overlay;
>  	}
>  
> +	ov->kobj.kset = ov_kset;
> +	err = kobject_add(&ov->kobj, NULL, "%d", id);

NULL for the parent?  Really?  Where does that cause this kobject to
show up in the sysfs tree?

> @@ -512,7 +545,9 @@ int of_overlay_destroy(int id)
>  	of_free_overlay_info(ov);
>  	idr_remove(&ov_idr, id);
>  	of_changeset_destroy(&ov->cset);
> -	kfree(ov);
> +
> +	kobject_del(&ov->kobj);
> +	kobject_put(&ov->kobj);

Two drops of the reference?

>  
>  	err = 0;
>  
> @@ -542,7 +577,8 @@ int of_overlay_destroy_all(void)
>  		of_changeset_revert(&ov->cset);
>  		of_free_overlay_info(ov);
>  		idr_remove(&ov_idr, ov->id);
> -		kfree(ov);
> +		kobject_del(&ov->kobj);
> +		kobject_put(&ov->kobj);

Again, why 2?

thanks,

greg k-h
