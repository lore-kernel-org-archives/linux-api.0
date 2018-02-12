From: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 18/21] fpga: dfl: afu: add header sub feature support
Date: Mon, 12 Feb 2018 11:43:28 -0600
Message-ID: <CANk1AXT0s1W99cRvWmT80nB+Buivt9xmjziDAz6pyxY-EJF2Fw@mail.gmail.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com> <1511764948-20972-19-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1511764948-20972-19-git-send-email-hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 27, 2017 at 12:42 AM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

Hi Hao,

Thanks for documenting the reset.  Please add this documentation to
the function header that is in fpga-dfl.h.

One question for clarification below.

This patch looks good.

> The port header register set is always present for port, it is mainly
> for capability, control and status of the ports that AFU connected to.
>
> This patch implements header sub feature support. Below user interfaces
> are created by this patch.
>
> Sysfs interface:
> * /sys/class/fpga_region/<regionX>/<fpga-dfl-port.x>/id
>   Read-only. Port ID.
>
> Ioctl interface:
> * FPGA_PORT_RESET
>   Reset the FPGA Port and its AFU.
>
> Signed-off-by: Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Acked-by: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

> ----
> v3: rename driver name to fpga-dfl-afu
>     add more description for reset ioctl.
>     fix some checkpatch issues.
> ---
>  .../ABI/testing/sysfs-platform-fpga-dfl-afu        |  7 ++++
>  drivers/fpga/dfl-afu-main.c                        | 44 +++++++++++++++++++++-
>  include/uapi/linux/fpga-dfl.h                      | 17 +++++++++
>  3 files changed, 67 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-platform-fpga-dfl-afu
>
> diff --git a/Documentation/ABI/testing/sysfs-platform-fpga-dfl-afu b/Documentation/ABI/testing/sysfs-platform-fpga-dfl-afu
> new file mode 100644
> index 0000000..f4bcd94
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-platform-fpga-dfl-afu
> @@ -0,0 +1,7 @@
> +What:          /sys/bus/platform/devices/fpga-dfl-port.0/id
> +Date:          November 2017
> +KernelVersion:  4.15
> +Contact:       Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> +Description:   Read-only. It returns id of this port. One DFL FPGA device
> +               may have more than one port. Userspace could use this id to
> +               distinguish different ports under same FPGA device.

Potentially >1 port per FPGA, but only one port per fpga-region, right?

> diff --git a/drivers/fpga/dfl-afu-main.c b/drivers/fpga/dfl-afu-main.c
> index d9f4b81..b01376c 100644
> --- a/drivers/fpga/dfl-afu-main.c
> +++ b/drivers/fpga/dfl-afu-main.c
> @@ -18,25 +18,66 @@
>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/fpga-dfl.h>
>
>  #include "fpga-dfl.h"
>
> +static ssize_t
> +id_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +       int id = fpga_port_id(to_platform_device(dev));
> +
> +       return scnprintf(buf, PAGE_SIZE, "%d\n", id);
> +}
> +static DEVICE_ATTR_RO(id);
> +
> +static const struct attribute *port_hdr_attrs[] = {
> +       &dev_attr_id.attr,
> +       NULL,
> +};
> +
>  static int port_hdr_init(struct platform_device *pdev, struct feature *feature)
>  {
>         dev_dbg(&pdev->dev, "PORT HDR Init.\n");
>
> -       return 0;
> +       fpga_port_reset(pdev);
> +
> +       return sysfs_create_files(&pdev->dev.kobj, port_hdr_attrs);
>  }
>
>  static void port_hdr_uinit(struct platform_device *pdev,
>                            struct feature *feature)
>  {
>         dev_dbg(&pdev->dev, "PORT HDR UInit.\n");
> +
> +       sysfs_remove_files(&pdev->dev.kobj, port_hdr_attrs);
> +}
> +
> +static long
> +port_hdr_ioctl(struct platform_device *pdev, struct feature *feature,
> +              unsigned int cmd, unsigned long arg)
> +{
> +       long ret;
> +
> +       switch (cmd) {
> +       case FPGA_PORT_RESET:
> +               if (!arg)
> +                       ret = fpga_port_reset(pdev);
> +               else
> +                       ret = -EINVAL;
> +               break;
> +       default:
> +               dev_dbg(&pdev->dev, "%x cmd not handled", cmd);
> +               ret = -ENODEV;
> +       }
> +
> +       return ret;
>  }
>
>  static const struct feature_ops port_hdr_ops = {
>         .init = port_hdr_init,
>         .uinit = port_hdr_uinit,
> +       .ioctl = port_hdr_ioctl,
>  };
>
>  static struct feature_driver port_feature_drvs[] = {
> @@ -76,6 +117,7 @@ static int afu_release(struct inode *inode, struct file *filp)
>
>         dev_dbg(&pdev->dev, "Device File Release\n");
>
> +       fpga_port_reset(pdev);
>         feature_dev_use_end(pdata);
>
>         return 0;
> diff --git a/include/uapi/linux/fpga-dfl.h b/include/uapi/linux/fpga-dfl.h
> index 75bdf88..9bf273d 100644
> --- a/include/uapi/linux/fpga-dfl.h
> +++ b/include/uapi/linux/fpga-dfl.h
> @@ -30,8 +30,11 @@
>  #define FPGA_MAGIC 0xB6
>
>  #define FPGA_BASE 0
> +#define PORT_BASE 0x40
>  #define FME_BASE 0x80
>
> +/* Common IOCTLs for both FME and AFU file descriptor */
> +
>  /**
>   * FPGA_GET_API_VERSION - _IO(FPGA_MAGIC, FPGA_BASE + 0)
>   *
> @@ -50,6 +53,20 @@
>
>  #define FPGA_CHECK_EXTENSION   _IO(FPGA_MAGIC, FPGA_BASE + 1)
>
> +/* IOCTLs for AFU file descriptor */
> +
> +/**
> + * FPGA_PORT_RESET - _IO(FPGA_MAGIC, PORT_BASE + 0)
> + *
> + * Reset the FPGA Port and its AFU. No parameters are supported.
> + * Userspace can do Port reset at any time, e.g during DMA or PR. But
> + * it should never cause any system level issue, only functional failure
> + * (e.g DMA or PR operation failure) and be recoverable from the failure.
> + * Return: 0 on success, -errno of failure
> + */
> +
> +#define FPGA_PORT_RESET                _IO(FPGA_MAGIC, PORT_BASE + 0)
> +
>  /* IOCTLs for FME file descriptor */
>
>  /**
> --
> 1.8.3.1
>
