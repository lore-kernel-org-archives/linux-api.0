From: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/5] of: overlay: Master enable switch
Date: Wed, 25 Mar 2015 00:25:26 -0500
Message-ID: <CAL_JsqKZZW=Vq9Mry9H0yjnv=TW8P=xzyX3EjQP+B15U0roaBA@mail.gmail.com>
References: <1426624257-23003-1-git-send-email-pantelis.antoniou@konsulko.com> <1426624257-23003-4-git-send-email-pantelis.antoniou@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426624257-23003-4-git-send-email-pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Cc: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Porter <matt.porter-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 17, 2015 at 3:30 PM, Pantelis Antoniou
<pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org> wrote:
> Implement a throw once master enable switch to protect against any
> further overlay applications if the administrator desires so.

sysfs documentation?

> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/of/overlay.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 65 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
> index f17f5ef..6688797 100644
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
> @@ -55,6 +56,9 @@ struct of_overlay {
>         struct kobject kobj;
>  };
>
> +/* master enable switch; once set to 0 can't be re-enabled */
> +static atomic_t ov_enable = ATOMIC_INIT(1);
> +
>  static int of_overlay_apply_one(struct of_overlay *ov,
>                 struct device_node *target, const struct device_node *overlay);
>
> @@ -345,6 +349,60 @@ static struct kobj_type of_overlay_ktype = {
>
>  static struct kset *ov_kset;
>
> +static ssize_t enable_read(struct file *filp, struct kobject *kobj,
> +               struct bin_attribute *bin_attr, char *buf,
> +               loff_t offset, size_t count)
> +{
> +       char tbuf[3];
> +
> +       if (offset < 0)
> +               return -EINVAL;
> +
> +       if (offset >= sizeof(tbuf))
> +               return 0;
> +
> +       if (count > sizeof(tbuf) - offset)
> +               count = sizeof(tbuf) - offset;
> +
> +       /* fill in temp */
> +       tbuf[0] = '0' + atomic_read(&ov_enable);
> +       tbuf[1] = '\n';
> +       tbuf[2] = '\0';
> +
> +       /* copy to buffer */
> +       memcpy(buf, tbuf + offset, count);
> +
> +       return count;
> +}
> +
> +static ssize_t enable_write(struct file *filp, struct kobject *kobj,
> +               struct bin_attribute *bin_attr, char *buf,
> +               loff_t off, size_t count)
> +{
> +       int new_enable;
> +
> +       if (off != 0 || (buf[0] != '0' && buf[1] != '1'))

Is buf[1] correct here?

> +               return -EINVAL;
> +
> +       new_enable = buf[0] - '0';
> +       if (new_enable != 0 && new_enable != 1)

Make unsigned just "if (new_enable > 1)".

> +               return -EINVAL;
> +
> +       /* NOP for same value */
> +       if (new_enable == atomic_read(&ov_enable))
> +               return count;
> +
> +       /* if we've disabled it, no going back */
> +       if (atomic_read(&ov_enable) == 0)
> +               return -EPERM;
> +
> +       atomic_set(&ov_enable, new_enable);
> +       return count;
> +}
> +
> +/* just a single char + '\n' + '\0' */
> +static BIN_ATTR_RW(enable, 3);
> +
>  /**
>   * of_overlay_create() - Create and apply an overlay
>   * @tree:      Device node containing all the overlays
> @@ -360,6 +418,10 @@ int of_overlay_create(struct device_node *tree)
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
> @@ -596,5 +658,7 @@ int of_overlay_init(void)
>         if (!ov_kset)
>                 return -ENOMEM;
>
> -       return 0;
> +       rc = sysfs_create_bin_file(&ov_kset->kobj, &bin_attr_enable);
> +       WARN(rc, "%s: error adding enable attribute\n", __func__);
> +       return rc;
>  }
> --
> 1.7.12
>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
