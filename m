From: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 3/4] of: overlay: add per overlay sysfs attributes
Date: Tue, 1 Sep 2015 21:35:18 -0500
Message-ID: <CAL_JsqK0oqqj6D-GOj0H32krUtGMg=-dK+c_uzqYt-wD7sY8qw@mail.gmail.com>
References: <1434137896-13806-1-git-send-email-pantelis.antoniou@konsulko.com> <1434137896-13806-4-git-send-email-pantelis.antoniou@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434137896-13806-4-git-send-email-pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Cc: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 12, 2015 at 2:38 PM, Pantelis Antoniou
<pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org> wrote:
> The two default overlay attributes are:
>
> * A targets sysfs attribute listing the targets of the installed
> overlay. The targets list the path on the kernel's device tree
> where each overlay fragment is applied to
>
> * A per overlay can_remove sysfs attribute that reports whether
> the overlay can be removed or not due to another overlapping overlay.

What will a user do with this information? Can this just be debugfs?
Don't we already have the targets in the overlay itself? If we are
going to provide some overlay info, shouldn't we provide all of it
(i.e. the FDT). For example, what do we do on a kexec?

Rob

> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/of/overlay.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
>
> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
> index 37ec858..747568f 100644
> --- a/drivers/of/overlay.c
> +++ b/drivers/of/overlay.c
> @@ -373,8 +373,61 @@ static const struct attribute *overlay_global_attrs[] = {
>         NULL
>  };
>
> +static ssize_t can_remove_show(struct kobject *kobj,
> +               struct kobj_attribute *attr, char *buf)
> +{
> +       struct of_overlay *ov = kobj_to_overlay(kobj);
> +
> +       return snprintf(buf, PAGE_SIZE, "%d\n", overlay_removal_is_ok(ov));
> +}
> +
> +static ssize_t targets_show(struct kobject *kobj,
> +               struct kobj_attribute *attr, char *buf)
> +{
> +       struct of_overlay *ov = kobj_to_overlay(kobj);
> +       struct of_overlay_info *ovinfo;
> +       char *s, *e;
> +       ssize_t ret;
> +       int i, len;
> +
> +       s = buf;
> +       e = buf + PAGE_SIZE;
> +
> +       mutex_lock(&of_mutex);
> +
> +       /* targets */
> +       for (i = 0; i < ov->count; i++) {
> +               ovinfo = &ov->ovinfo_tab[i];
> +
> +               len = snprintf(s, e - s, "%s\n",
> +                               of_node_full_name(ovinfo->target));
> +               if (len == 0) {
> +                       ret = -ENOSPC;
> +                       goto err;
> +               }
> +               s += len;
> +       }
> +
> +       /* the buffer is zero terminated */
> +       ret = s - buf;
> +err:
> +       mutex_unlock(&of_mutex);
> +       return ret;
> +}
> +
> +static struct kobj_attribute can_remove_attr = __ATTR_RO(can_remove);
> +static struct kobj_attribute targets_attr = __ATTR_RO(targets);
> +
> +static struct attribute *overlay_attrs[] = {
> +       &can_remove_attr.attr,
> +       &targets_attr.attr,
> +       NULL
> +};
> +
>  static struct kobj_type of_overlay_ktype = {
>         .release = of_overlay_release,
> +       .sysfs_ops = &kobj_sysfs_ops,   /* default kobj sysfs ops */
> +       .default_attrs = overlay_attrs,
>  };
>
>  static struct kset *ov_kset;
> --
> 1.7.12
>
