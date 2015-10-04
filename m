From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v5 3/4] of: overlay: add per overlay sysfs attributes
Date: Sun, 4 Oct 2015 20:23:11 +0100
Message-ID: <20151004192311.GE9649@kroah.com>
References: <1442419751-4846-1-git-send-email-pantelis.antoniou@konsulko.com>
 <1442419751-4846-4-git-send-email-pantelis.antoniou@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1442419751-4846-4-git-send-email-pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Cc: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Sep 16, 2015 at 07:09:10PM +0300, Pantelis Antoniou wrote:
> The two default overlay attributes are:
> 
> * A targets sysfs attribute listing the targets of the installed
> overlay. The targets list the path on the kernel's device tree
> where each overlay fragment is applied to
> 
> * A per overlay can_remove sysfs attribute that reports whether
> the overlay can be removed or not due to another overlapping overlay.
> 
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/of/overlay.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
> 
> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
> index 62cfb99..cff3c05 100644
> --- a/drivers/of/overlay.c
> +++ b/drivers/of/overlay.c
> @@ -373,8 +373,61 @@ static const struct attribute *overlay_global_attrs[] = {
>  	NULL
>  };
>  
> +static ssize_t can_remove_show(struct kobject *kobj,
> +		struct kobj_attribute *attr, char *buf)
> +{
> +	struct of_overlay *ov = kobj_to_overlay(kobj);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n", overlay_removal_is_ok(ov));
> +}
> +
> +static ssize_t targets_show(struct kobject *kobj,
> +		struct kobj_attribute *attr, char *buf)
> +{
> +	struct of_overlay *ov = kobj_to_overlay(kobj);
> +	struct of_overlay_info *ovinfo;
> +	char *s, *e;
> +	ssize_t ret;
> +	int i, len;
> +
> +	s = buf;
> +	e = buf + PAGE_SIZE;
> +
> +	mutex_lock(&of_mutex);
> +
> +	/* targets */
> +	for (i = 0; i < ov->count; i++) {
> +		ovinfo = &ov->ovinfo_tab[i];
> +
> +		len = snprintf(s, e - s, "%s\n",
> +				of_node_full_name(ovinfo->target));
> +		if (len == 0) {
> +			ret = -ENOSPC;
> +			goto err;
> +		}
> +		s += len;
> +	}

Multiple values per sysfs file?  Not ok, this is not going to work,
sorry, please fix.

greg k-h
