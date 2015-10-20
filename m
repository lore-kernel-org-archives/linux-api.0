From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v6 2/4] of: overlay: global sysfs enable attribute
Date: Tue, 20 Oct 2015 14:06:09 -0700
Message-ID: <20151020210609.GB28724@kroah.com>
References: <1445368397-8732-1-git-send-email-pantelis.antoniou@konsulko.com>
 <1445368397-8732-3-git-send-email-pantelis.antoniou@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445368397-8732-3-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robherring2@gmail.com>, Frank Rowand <frowand.list@gmail.com>, Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Pantelis Antoniou <panto@antoniou-consulting.com>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 20, 2015 at 10:13:15PM +0300, Pantelis Antoniou wrote:
> A throw once master enable switch to protect against any
> further overlay applications if the administrator desires so.
> 
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> ---
>  drivers/of/overlay.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
> index 12c3e47..067404e 100644
> --- a/drivers/of/overlay.c
> +++ b/drivers/of/overlay.c
> @@ -21,6 +21,7 @@
>  #include <linux/err.h>
>  #include <linux/idr.h>
>  #include <linux/sysfs.h>
> +#include <linux/atomic.h>
>  
>  #include "of_private.h"
>  
> @@ -55,8 +56,12 @@ struct of_overlay {
>  	struct kobject kobj;
>  };
>  
> +/* master enable switch; once set to 0 can't be re-enabled */
> +static atomic_t ov_enable = ATOMIC_INIT(1);
> +
>  static int of_overlay_apply_one(struct of_overlay *ov,
>  		struct device_node *target, const struct device_node *overlay);
> +static int overlay_removal_is_ok(struct of_overlay *ov);
>  
>  static int of_overlay_apply_single_property(struct of_overlay *ov,
>  		struct device_node *target, struct property *prop)
> @@ -339,6 +344,35 @@ void of_overlay_release(struct kobject *kobj)
>  	kfree(ov);
>  }
>  
> +static ssize_t enable_show(struct kobject *kobj,
> +		struct kobj_attribute *attr, char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%d\n", atomic_read(&ov_enable));
> +}
> +
> +static ssize_t enable_store(struct kobject *kobj,
> +		struct kobj_attribute *attr, const char *buf, size_t count)
> +{
> +	int ret;
> +	bool new_enable;
> +
> +	ret = strtobool(buf, &new_enable);
> +	if (ret != 0)
> +		return ret;
> +	/* if we've disabled it, no going back */
> +	if (atomic_read(&ov_enable) == 0)
> +		return -EPERM;
> +	atomic_set(&ov_enable, (int)new_enable);
> +	return count;
> +}
> +
> +static struct kobj_attribute enable_attr = __ATTR_RW(enable);
> +
> +static const struct attribute *overlay_global_attrs[] = {
> +	&enable_attr.attr,
> +	NULL
> +};
> +
>  static struct kobj_type of_overlay_ktype = {
>  	.release = of_overlay_release,
>  };
> @@ -360,6 +394,10 @@ int of_overlay_create(struct device_node *tree)
>  	struct of_overlay *ov;
>  	int err, id;
>  
> +	/* administratively disabled */
> +	if (!atomic_read(&ov_enable))
> +		return -EPERM;
> +
>  	/* allocate the overlay structure */
>  	ov = kzalloc(sizeof(*ov), GFP_KERNEL);
>  	if (ov == NULL)
> @@ -594,5 +632,8 @@ int of_overlay_init(void)
>  	if (!ov_kset)
>  		return -ENOMEM;
>  
> -	return 0;
> +	rc = sysfs_create_files(&ov_kset->kobj, overlay_global_attrs);
> +	WARN(rc, "%s: error adding global attributes\n", __func__);
> +
> +	return rc;
>  }

Shouldn't this also be allowed to be overridden as a boot and build time
parameter to prevent any races on systems that don't want this?

thanks,

greg k-h
