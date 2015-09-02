From: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 2/4] of: overlay: global sysfs enable attribute
Date: Tue, 1 Sep 2015 21:43:43 -0500
Message-ID: <CAL_Jsq+b8DvZOTxecug+0s4y694jqTTAu9y4kLKHqUn=kvNEfg@mail.gmail.com>
References: <1434137896-13806-1-git-send-email-pantelis.antoniou@konsulko.com> <1434137896-13806-3-git-send-email-pantelis.antoniou@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434137896-13806-3-git-send-email-pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 12, 2015 at 2:38 PM, Pantelis Antoniou
<pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org> wrote:
> A throw once master enable switch to protect against any
> further overlay applications if the administrator desires so.
>
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>

I had some questioning whether we want more states than just on/off
like "only add sub-trees", but I've convinced myself it is better to
keep the kill switch simple. So I'm okay with patches 1 and 2 (and the
relevant part of 4 if you want to split it). I think #3 needs to be
part of how we expect userspace to interact with overlays.

Please respin and I will queue at least the kill switch for 4.4 unless
there are further comments.

Rob


> ---
>  drivers/of/overlay.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 42 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
> index f17f5ef..37ec858 100644
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
>         struct kobject kobj;
>  };
>
> +/* master enable switch; once set to 0 can't be re-enabled */
> +static atomic_t ov_enable = ATOMIC_INIT(1);
> +
>  static int of_overlay_apply_one(struct of_overlay *ov,
>                 struct device_node *target, const struct device_node *overlay);
> +static int overlay_removal_is_ok(struct of_overlay *ov);
>
>  static int of_overlay_apply_single_property(struct of_overlay *ov,
>                 struct device_node *target, struct property *prop)
> @@ -339,6 +344,35 @@ void of_overlay_release(struct kobject *kobj)
>         kfree(ov);
>  }
>
> +static ssize_t enable_show(struct kobject *kobj,
> +               struct kobj_attribute *attr, char *buf)
> +{
> +       return snprintf(buf, PAGE_SIZE, "%d\n", atomic_read(&ov_enable));
> +}
> +
> +static ssize_t enable_store(struct kobject *kobj,
> +               struct kobj_attribute *attr, const char *buf, size_t count)
> +{
> +       int ret;
> +       bool new_enable;
> +
> +       ret = strtobool(buf, &new_enable);
> +       if (ret != 0)
> +               return ret;
> +       /* if we've disabled it, no going back */
> +       if (atomic_read(&ov_enable) == 0)
> +               return -EPERM;
> +       atomic_set(&ov_enable, (int)new_enable);
> +       return count;
> +}
> +
> +static struct kobj_attribute enable_attr = __ATTR_RW(enable);
> +
> +static const struct attribute *overlay_global_attrs[] = {
> +       &enable_attr.attr,
> +       NULL
> +};
> +
>  static struct kobj_type of_overlay_ktype = {
>         .release = of_overlay_release,
>  };
> @@ -360,6 +394,10 @@ int of_overlay_create(struct device_node *tree)
>         struct of_overlay *ov;
>         int err, id;
>
> +       /* administratively disabled */
> +       if (!atomic_read(&ov_enable))
> +               return -EPERM;
> +
>         /* allocate the overlay structure */
>         ov = kzalloc(sizeof(*ov), GFP_KERNEL);
>         if (ov == NULL)
> @@ -596,5 +634,8 @@ int of_overlay_init(void)
>         if (!ov_kset)
>                 return -ENOMEM;
>
> -       return 0;
> +       rc = sysfs_create_files(&ov_kset->kobj, overlay_global_attrs);
> +       WARN(rc, "%s: error adding global attributes\n", __func__);
> +
> +       return rc;
>  }
> --
> 1.7.12
>
