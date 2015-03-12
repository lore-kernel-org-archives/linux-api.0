From: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v6 1/3] scsi: ufs: add ioctl interface for query request
Date: Thu, 12 Mar 2015 22:30:36 +0900
Message-ID: <CAC5umyiry3OEJGeZ2=U21v7gAjsC7XHZVyiZN8UgQusX2KmvpQ@mail.gmail.com>
References: <1426163262-22014-1-git-send-email-gbroner@codeaurora.org>
	<1426163262-22014-2-git-send-email-gbroner@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426163262-22014-2-git-send-email-gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gilad Broner <gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Jej B <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Santosh Y <santoshsy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-scsi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Noa Rubens <noag-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Raviv Shvili <rshvili-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

2015-03-12 21:27 GMT+09:00 Gilad Broner <gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>:
> From: Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>
> This patch exposes the ioctl interface for UFS driver via SCSI device
> ioctl interface. As of now UFS driver would provide the ioctl for query
> interface to connected UFS device.
>
> Signed-off-by: Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Signed-off-by: Noa Rubens <noag-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Signed-off-by: Raviv Shvili <rshvili-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Signed-off-by: Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

Sorry to bother you again.  Could you read two comments below?

> +/**
> + * ufshcd_ioctl - ufs ioctl callback registered in scsi_host
> + * @dev: scsi device required for per LUN queries
> + * @cmd: command opcode
> + * @buffer: user space buffer for transferring data
> + *
> + * Supported commands:
> + * UFS_IOCTL_QUERY
> + */
> +static int ufshcd_ioctl(struct scsi_device *dev, int cmd, void __user *buffer)
> +{
> +       struct ufs_hba *hba = shost_priv(dev->host);
> +       int err = 0;
> +
> +       BUG_ON(!hba);
> +       if (!buffer) {
> +               dev_err(hba->dev, "%s: User buffer is NULL!\n", __func__);
> +               return -EINVAL;
> +       }
> +

Should we remove this check or move it into ufshcd_query_ioctl()?
For example, BLKFLS ioctl without argument is correct usage, but
it always triggers this message. (blkdev_ioctl -> __blkdev_driver_ioctl
-> sd_ioctl -> scsi_ioctl -> ufshcd_ioctl)

> +       switch (cmd) {
> +       case UFS_IOCTL_QUERY:
> +               pm_runtime_get_sync(hba->dev);
> +               err = ufshcd_query_ioctl(hba, ufshcd_scsi_to_upiu_lun(dev->lun),
> +                               buffer);
> +               pm_runtime_put_sync(hba->dev);
> +               break;
> +       case UFS_IOCTL_BLKROSET:
> +               err = -ENOIOCTLCMD;
> +               break;
> +       default:
> +               err = -EINVAL;
> +               dev_err(hba->dev, "%s: Illegal ufs-IOCTL cmd %d\n", __func__,
> +                               cmd);
> +               break;
> +       }
> +
> +       return err;
> +}
> +
>  static struct scsi_host_template ufshcd_driver_template = {
>         .module                 = THIS_MODULE,
>         .name                   = UFSHCD,
> @@ -4213,6 +4433,7 @@ static struct scsi_host_template ufshcd_driver_template = {
>         .eh_abort_handler       = ufshcd_abort,
>         .eh_device_reset_handler = ufshcd_eh_device_reset_handler,
>         .eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
> +       .ioctl                  = ufshcd_ioctl,
>         .this_id                = -1,
>         .sg_tablesize           = SG_ALL,
>         .cmd_per_lun            = UFSHCD_CMD_PER_LUN,

...

> diff --git a/include/uapi/scsi/ufs/ioctl.h b/include/uapi/scsi/ufs/ioctl.h
> new file mode 100644
> index 0000000..bc4eed7
> --- /dev/null
> +++ b/include/uapi/scsi/ufs/ioctl.h
> @@ -0,0 +1,57 @@
> +#ifndef UAPI_UFS_IOCTL_H_
> +#define UAPI_UFS_IOCTL_H_
> +
> +#include <linux/types.h>
> +
> +/*
> + *  IOCTL opcode for ufs queries has the following opcode after
> + *  SCSI_IOCTL_GET_PCI
> + */
> +#define UFS_IOCTL_QUERY                        0x5388

Should we also need some comments near SCSI_IOCTL_GET_PCI in
include/scsi/scsi.h in order to avoid someone trying to define
the same ioctl code in the future?
