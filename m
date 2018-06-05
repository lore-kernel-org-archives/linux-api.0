From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v5 07/28] fpga: dfl: add chardev support for feature devices
Date: Tue, 5 Jun 2018 15:21:48 -0500
Message-ID: <CANk1AXRQx=QtwmSKuWiGprMcfjNnUWcBHNy-hTfP+JaQZsJLLA@mail.gmail.com>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com> <1525229431-3087-8-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525229431-3087-8-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, May 1, 2018 at 9:50 PM, Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

> For feature devices drivers, both the FPGA Management Engine (FME) and
> Accelerated Function Unit (AFU) driver need to expose user interfaces via
> the device file, for example, mmap and ioctls.
>
> This patch adds chardev support in the dfl driver for feature devices,
> FME and AFU. It reserves the chardev regions for FME and AFU, and provide
> interfaces for FME and AFU driver to register their device file operations.
>
> Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> Signed-off-by: Zhang Yi <yi.z.zhang@intel.com>
> Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
> ---
> v2: rebased
> v3: move chardev support to fpga-dfl framework
> v4: rebase, and add more comments in code.
> v5: rebase, and add dfl_ prefix to APIs and data structures.
> ---
>  drivers/fpga/dfl.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/fpga/dfl.h |  14 ++++++++
>  2 files changed, 117 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
> index c1462e9..18aba02 100644
> --- a/drivers/fpga/dfl.c
> +++ b/drivers/fpga/dfl.c
> @@ -74,6 +74,96 @@ static enum dfl_id_type feature_dev_id_type(struct platform_device *pdev)
>         return DFL_ID_MAX;
>  }
>
> +struct dfl_chardev_info {
> +       const char *name;
> +       dev_t devt;
> +};
> +
> +/* indexed by enum dfl_fpga_devt_type */
> +struct dfl_chardev_info dfl_chrdevs[] = {
> +       {.name = DFL_FPGA_FEATURE_DEV_FME},     /* DFL_FPGA_DEVT_FME */
> +       {.name = DFL_FPGA_FEATURE_DEV_PORT},    /* DFL_FPGA_DEVT_AFU */
> +};

If this were added in the initial dfl.c patch, it could be used by
build_info_create_dev to get the name.

> +
> +static void dfl_chardev_uinit(void)
> +{
> +       int i;
> +
> +       for (i = 0; i < DFL_FPGA_DEVT_MAX; i++)
> +               if (MAJOR(dfl_chrdevs[i].devt)) {
> +                       unregister_chrdev_region(dfl_chrdevs[i].devt,
> +                                                MINORMASK);
> +                       dfl_chrdevs[i].devt = MKDEV(0, 0);
> +               }
> +}
> +
> +static int dfl_chardev_init(void)
> +{
> +       int i, ret;
> +
> +       for (i = 0; i < DFL_FPGA_DEVT_MAX; i++) {
> +               ret = alloc_chrdev_region(&dfl_chrdevs[i].devt, 0, MINORMASK,
> +                                         dfl_chrdevs[i].name);
> +               if (ret)
> +                       goto exit;
> +       }
> +
> +       return 0;
> +
> +exit:
> +       dfl_chardev_uinit();
> +       return ret;
> +}
> +
> +static dev_t dfl_get_devt(enum dfl_fpga_devt_type type, int id)
> +{
> +       WARN_ON(type >= DFL_FPGA_DEVT_MAX);
> +
> +       return MKDEV(MAJOR(dfl_chrdevs[type].devt), id);
> +}
> +
> +/**
> + * dfl_fpga_register_dev_ops - register cdev ops for feature dev
> + *
> + * @pdev: feature dev.
> + * @fops: file operations for feature dev's cdev.
> + * @owner: owning module/driver.
> + *
> + * Return: 0 on success, negative error code otherwise.
> + */
> +int dfl_fpga_register_dev_ops(struct platform_device *pdev,
> +                             const struct file_operations *fops,
> +                             struct module *owner)
> +{
> +       struct dfl_feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
> +
> +       cdev_init(&pdata->cdev, fops);
> +       pdata->cdev.owner = owner;
> +
> +       /*
> +        * set parent to the feature device so that its refcount is
> +        * decreased after the last refcount of cdev is gone, that
> +        * makes sure the feature device is valid during device
> +        * file's life-cycle.
> +        */
> +       pdata->cdev.kobj.parent = &pdev->dev.kobj;
> +
> +       return cdev_add(&pdata->cdev, pdev->dev.devt, 1);
> +}
> +EXPORT_SYMBOL_GPL(dfl_fpga_register_dev_ops);
> +
> +/**
> + * dfl_fpga_unregister_dev_ops - unregister cdev ops for feature dev
> + * @pdev: feature dev.
> + */
> +void dfl_fpga_unregister_dev_ops(struct platform_device *pdev)
> +{
> +       struct dfl_feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
> +
> +       cdev_del(&pdata->cdev);
> +}
> +EXPORT_SYMBOL_GPL(dfl_fpga_unregister_dev_ops);
> +
>  /**
>   * struct build_feature_devs_info - info collected during feature dev build.
>   *
> @@ -208,9 +298,13 @@ static int build_info_commit_dev(struct build_feature_devs_info *binfo)
>                       enum dfl_id_type type, const char *name,
>                       void __iomem *ioaddr)
>  {
> +       enum dfl_fpga_devt_type devt_type = DFL_FPGA_DEVT_FME;
>         struct platform_device *fdev;
>         int ret;
>
> +       if (type == PORT_ID)
> +               devt_type = DFL_FPGA_DEVT_PORT;
> +
>         /* we will create a new device, commit current device first */
>         ret = build_info_commit_dev(binfo);
>         if (ret)
> @@ -234,6 +328,7 @@ static int build_info_commit_dev(struct build_feature_devs_info *binfo)
>                 return fdev->id;
>
>         fdev->dev.parent = &binfo->cdev->region->dev;
> +       fdev->dev.devt = dfl_get_devt(devt_type, fdev->id);
>
>         return 0;
>  }
> @@ -702,13 +797,20 @@ void dfl_fpga_remove_feature_devs(struct dfl_fpga_cdev *cdev)
>
>  static int __init dfl_fpga_init(void)
>  {
> +       int ret;
> +
>         dfl_ids_init();
>
> -       return 0;
> +       ret = dfl_chardev_init();
> +       if (ret)
> +               dfl_ids_destroy();
> +
> +       return ret;
>  }
>
>  static void __exit dfl_fpga_exit(void)
>  {
> +       dfl_chardev_uinit();
>         dfl_ids_destroy();
>  }
>
> diff --git a/drivers/fpga/dfl.h b/drivers/fpga/dfl.h
> index 2ede915..5fcb1a1 100644
> --- a/drivers/fpga/dfl.h
> +++ b/drivers/fpga/dfl.h
> @@ -15,6 +15,7 @@
>  #define __FPGA_DFL_H
>
>  #include <linux/bitfield.h>
> +#include <linux/cdev.h>
>  #include <linux/delay.h>
>  #include <linux/fs.h>
>  #include <linux/iopoll.h>
> @@ -150,6 +151,7 @@ struct dfl_feature {
>   *
>   * @node: node to link feature devs to container device's port_dev_list.
>   * @lock: mutex to protect platform data.
> + * @cdev: cdev of feature dev.
>   * @dev: ptr to platform device linked with this platform data.
>   * @dfl_cdev: ptr to container device.
>   * @disable_count: count for port disable.
> @@ -159,6 +161,7 @@ struct dfl_feature {
>  struct dfl_feature_platform_data {
>         struct list_head node;
>         struct mutex lock;
> +       struct cdev cdev;
>         struct platform_device *dev;
>         struct dfl_fpga_cdev *dfl_cdev;
>         unsigned int disable_count;
> @@ -176,6 +179,17 @@ static inline int dfl_feature_platform_data_size(const int num)
>                 num * sizeof(struct dfl_feature);
>  }
>
> +enum dfl_fpga_devt_type {
> +       DFL_FPGA_DEVT_FME,
> +       DFL_FPGA_DEVT_PORT,
> +       DFL_FPGA_DEVT_MAX,
> +};

Could you move this enum to be close to other similar enums (like
dfl_id_type)?  The dfl code has a few enums that are similar, and may
need updating (or not) as feature are added.  Putting them close
together with appropriate comments would be helpful to keep them all
straight.

> +
> +int dfl_fpga_register_dev_ops(struct platform_device *pdev,
> +                             const struct file_operations *fops,
> +                             struct module *owner);
> +void dfl_fpga_unregister_dev_ops(struct platform_device *pdev);
> +
>  #define dfl_fpga_dev_for_each_feature(pdata, feature)                      \
>         for ((feature) = (pdata)->features;                                 \
>            (feature) < (pdata)->features + (pdata)->num; (feature)++)
> --
> 1.8.3.1
>
