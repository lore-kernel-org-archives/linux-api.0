From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v7 2/6] of: overlay: global sysfs enable attribute
Date: Thu, 22 Oct 2015 13:19:11 -0700
Message-ID: <20151022201911.GB27977@kroah.com>
References: <1445543427-26275-1-git-send-email-pantelis.antoniou@konsulko.com>
 <1445543427-26275-3-git-send-email-pantelis.antoniou@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1445543427-26275-3-git-send-email-pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Cc: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 22, 2015 at 10:50:23PM +0300, Pantelis Antoniou wrote:
> A throw once master enable switch to protect against any
> further overlay applications if the administrator desires so.
> 
> A kernel command line option is provided as well.
> 
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/of/overlay.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 49 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
> index 12c3e47..91f10ed 100644
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
> @@ -55,8 +56,19 @@ struct of_overlay {
>  	struct kobject kobj;
>  };
>  
> +/* master enable switch; once set to 0 can't be re-enabled */
> +static atomic_t ov_enable = ATOMIC_INIT(1);
> +
> +static int __init of_overlay_disable_setup(char *str __always_unused)
> +{
> +	atomic_set(&ov_enable, 0);
> +	return 1;
> +}
> +__setup("of_overlay_disable", of_overlay_disable_setup);
> +
>  static int of_overlay_apply_one(struct of_overlay *ov,
>  		struct device_node *target, const struct device_node *overlay);
> +static int overlay_removal_is_ok(struct of_overlay *ov);
>  
>  static int of_overlay_apply_single_property(struct of_overlay *ov,
>  		struct device_node *target, struct property *prop)
> @@ -339,6 +351,35 @@ void of_overlay_release(struct kobject *kobj)
>  	kfree(ov);
>  }
>  
> +static ssize_t enable_show(struct kobject *kobj,
> +		struct kobj_attribute *attr, char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%d\n", atomic_read(&ov_enable));

Minor nit, you never need to care about the size of the buffer for a
sysfs file, if you do, you are doing something wrong.  So this can just
be:
	return sprintf(buf, "%d\n", atomic_read(&ov_enable));


Anyway, nothing worth keeping this from being merged:

Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
