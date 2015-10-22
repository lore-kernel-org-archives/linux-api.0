From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v7 5/6] of: overlay: add per overlay sysfs attributes
Date: Thu, 22 Oct 2015 13:21:41 -0700
Message-ID: <20151022202141.GE27977@kroah.com>
References: <1445543427-26275-1-git-send-email-pantelis.antoniou@konsulko.com>
 <1445543427-26275-6-git-send-email-pantelis.antoniou@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1445543427-26275-6-git-send-email-pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Cc: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 22, 2015 at 10:50:26PM +0300, Pantelis Antoniou wrote:
> * A per overlay can_remove sysfs attribute that reports whether
> the overlay can be removed or not due to another overlapping overlay.
> 
> * A target sysfs attribute listing the target of each fragment,
> in a group named after the name of the fragment.
> 
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/of/overlay.c | 103 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 99 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
> index 91f10ed..6398810 100644
> --- a/drivers/of/overlay.c
> +++ b/drivers/of/overlay.c
> @@ -25,8 +25,23 @@
>  
>  #include "of_private.h"
>  
> +/* fwd. decl */
> +struct of_overlay;
> +struct of_overlay_info;
> +
> +/* an attribute for each fragment */
> +struct fragment_attribute {
> +	struct attribute attr;
> +	ssize_t (*show)(struct kobject *kobj, struct fragment_attribute *fattr,
> +			char *buf);
> +	ssize_t (*store)(struct kobject *kobj, struct fragment_attribute *fattr,
> +			 const char *buf, size_t count);
> +	struct of_overlay_info *ovinfo;
> +};
> +
>  /**
>   * struct of_overlay_info - Holds a single overlay info
> + * @info:	info node that contains the target and overlay
>   * @target:	target of the overlay operation
>   * @overlay:	pointer to the overlay contents node
>   *
> @@ -34,8 +49,13 @@
>   * records.
>   */
>  struct of_overlay_info {
> +	struct of_overlay *ov;
> +	struct device_node *info;
>  	struct device_node *target;
>  	struct device_node *overlay;
> +	struct attribute_group attr_group;
> +	struct attribute *attrs[2];
> +	struct fragment_attribute target_attr;
>  };
>  
>  /**
> @@ -52,6 +72,7 @@ struct of_overlay {
>  	struct list_head node;
>  	int count;
>  	struct of_overlay_info *ovinfo_tab;
> +	const struct attribute_group **attr_groups;
>  	struct of_changeset cset;
>  	struct kobject kobj;
>  };
> @@ -252,6 +273,8 @@ static int of_fill_overlay_info(struct of_overlay *ov,
>  	if (ovinfo->target == NULL)
>  		goto err_fail;
>  
> +	ovinfo->info = of_node_get(info_node);
> +
>  	return 0;
>  
>  err_fail:
> @@ -262,6 +285,17 @@ err_fail:
>  	return -EINVAL;
>  }
>  
> +static ssize_t target_show(struct kobject *kobj,
> +		struct fragment_attribute *fattr, char *buf)
> +{
> +	struct of_overlay_info *ovinfo = fattr->ovinfo;
> +
> +	return snprintf(buf, PAGE_SIZE, "%s\n",
> +			of_node_full_name(ovinfo->target));

Same minor nit here, but really not a big deal, nice job overall with
this, sorry working with 'raw' kobjects is so messy.

Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
