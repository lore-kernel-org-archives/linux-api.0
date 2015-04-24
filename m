From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 2/4] of: overlay: global sysfs enable attribute
Date: Fri, 24 Apr 2015 22:36:19 +0200
Message-ID: <20150424203619.GC14970@kroah.com>
References: <1429868744-19863-1-git-send-email-pantelis.antoniou@konsulko.com>
 <1429868744-19863-3-git-send-email-pantelis.antoniou@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1429868744-19863-3-git-send-email-pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Cc: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 24, 2015 at 12:45:42PM +0300, Pantelis Antoniou wrote:
> A throw once master enable switch to protect against any
> further overlay applications if the administrator desires so.
> 
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/of/overlay.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
> index f17f5ef..c335809 100644
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
> @@ -339,6 +344,37 @@ void of_overlay_release(struct kobject *kobj)
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
> +	long new_enable;
> +
> +	ret = kstrtol(buf, 10, &new_enable);

strtobool()?
