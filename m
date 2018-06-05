From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v5 09/28] fpga: dfl: add feature device infrastructure
Date: Tue, 5 Jun 2018 16:14:43 -0500
Message-ID: <CANk1AXRyqn_Y26HZiYkFQUoWUVzc89F-znVNWQXGAk+arNB6XA@mail.gmail.com>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com> <1525229431-3087-10-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525229431-3087-10-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, May 1, 2018 at 9:50 PM, Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

Some minor things, otherwise looks fine.

> From: Xiao Guangrong <guangrong.xiao@linux.intel.com>
>
> This patch abstracts the common operations of the sub features, and defines
> the feature_ops data structure, including init, uinit and ioctl function
> pointers. And this patch adds some common helper functions for FME and AFU
> drivers, e.g dfl_feature_dev_use_begin/end which are used to ensure
> exclusive usage of the feature device file.
>
> Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> Signed-off-by: Kang Luwei <luwei.kang@intel.com>
> Signed-off-by: Zhang Yi <yi.z.zhang@intel.com>
> Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Alan Tull <atull@kernel.org>

> ---
> v2: rebased
> v3: use const for feature_ops.
>     replace pci related function.
> v4: rebase and add more comments in code.
> v5: remove useless WARN_ON().
>     reorder declarations in functions per suggestion from Moritz.
>     add "dfl_" prefix to functions and data structure.
> ---
>  drivers/fpga/dfl.c | 57 +++++++++++++++++++++++++++++++++++++
>  drivers/fpga/dfl.h | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 138 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
> index 1e06efb..c4c47d6 100644
> --- a/drivers/fpga/dfl.c
> +++ b/drivers/fpga/dfl.c
> @@ -74,6 +74,63 @@ static enum dfl_id_type feature_dev_id_type(struct platform_device *pdev)
>         return DFL_ID_MAX;
>  }
>
> +void dfl_fpga_dev_feature_uinit(struct platform_device *pdev)
> +{
> +       struct dfl_feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
> +       struct dfl_feature *feature;
> +
> +       dfl_fpga_dev_for_each_feature(pdata, feature)
> +               if (feature->ops) {
> +                       feature->ops->uinit(pdev, feature);
> +                       feature->ops = NULL;
> +               }
> +}
> +EXPORT_SYMBOL_GPL(dfl_fpga_dev_feature_uinit);

Please add kernel-doc for functions that are exported to recommend and
guide their usage.

> +
> +static int dfl_feature_instance_init(struct platform_device *pdev,
> +                                    struct dfl_feature_platform_data *pdata,
> +                                    struct dfl_feature *feature,
> +                                    struct dfl_feature_driver *drv)
> +{
> +       int ret;
> +
> +       ret = drv->ops->init(pdev, feature);
> +       if (ret)
> +               return ret;
> +
> +       feature->ops = drv->ops;
> +
> +       return ret;
> +}
> +
> +int dfl_fpga_dev_feature_init(struct platform_device *pdev,
> +                             struct dfl_feature_driver *feature_drvs)
> +{
> +       struct dfl_feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
> +       struct dfl_feature_driver *drv = feature_drvs;
> +       struct dfl_feature *feature;
> +       int ret;
> +
> +       while (drv->ops) {
> +               dfl_fpga_dev_for_each_feature(pdata, feature) {
> +                       /* match feature and drv using id */
> +                       if (feature->id == drv->id) {
> +                               ret = dfl_feature_instance_init(pdev, pdata,
> +                                                               feature, drv);
> +                               if (ret)
> +                                       goto exit;
> +                       }
> +               }
> +               drv++;
> +       }
> +
> +       return 0;
> +exit:
> +       dfl_fpga_dev_feature_uinit(pdev);
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(dfl_fpga_dev_feature_init);
> +
>  struct dfl_chardev_info {
>         const char *name;
>         dev_t devt;
> diff --git a/drivers/fpga/dfl.h b/drivers/fpga/dfl.h
> index 2b6aaef..27f7a74 100644
> --- a/drivers/fpga/dfl.h
> +++ b/drivers/fpga/dfl.h
> @@ -132,6 +132,17 @@
>  #define PORT_CTRL_SFTRST_ACK   BIT_ULL(4)              /* HW ack for reset */
>
>  /**
> + * struct dfl_feature_driver - sub feature's driver
> + *
> + * @id: sub feature id.
> + * @ops: ops of this sub feature.
> + */
> +struct dfl_feature_driver {
> +       u64 id;
> +       const struct dfl_feature_ops *ops;
> +};
> +
> +/**
>   * struct dfl_feature - sub feature of the feature devices
>   *
>   * @id: sub feature id.
> @@ -139,13 +150,17 @@
>   *                 this index is used to find its mmio resource from the
>   *                 feature dev (platform device)'s reources.
>   * @ioaddr: mapped mmio resource address.
> + * @ops: ops of this sub feature.
>   */
>  struct dfl_feature {
>         u64 id;
>         int resource_index;
>         void __iomem *ioaddr;
> +       const struct dfl_feature_ops *ops;
>  };
>
> +#define DEV_STATUS_IN_USE      0
> +
>  /**
>   * struct dfl_feature_platform_data - platform data for feature devices
>   *
> @@ -156,6 +171,8 @@ struct dfl_feature {
>   * @dfl_cdev: ptr to container device.
>   * @disable_count: count for port disable.
>   * @num: number for sub features.
> + * @dev_status: dev status (e.g DEV_STATUS_IN_USE).
> + * @private: ptr to feature dev private data.
>   * @features: sub features of this feature dev.
>   */
>  struct dfl_feature_platform_data {
> @@ -165,11 +182,49 @@ struct dfl_feature_platform_data {
>         struct platform_device *dev;
>         struct dfl_fpga_cdev *dfl_cdev;
>         unsigned int disable_count;
> -
> +       unsigned long dev_status;
> +       void *private;
>         int num;
>         struct dfl_feature features[0];
>  };
>
> +static inline
> +int dfl_feature_dev_use_begin(struct dfl_feature_platform_data *pdata)
> +{
> +       /* Test and set IN_USE flags to ensure file is exclusively used */
> +       if (test_and_set_bit_lock(DEV_STATUS_IN_USE, &pdata->dev_status))
> +               return -EBUSY;
> +
> +       return 0;
> +}
> +
> +static inline
> +void dfl_feature_dev_use_end(struct dfl_feature_platform_data *pdata)
> +{
> +       clear_bit_unlock(DEV_STATUS_IN_USE, &pdata->dev_status);
> +}
> +
> +static inline
> +void dfl_fpga_pdata_set_private(struct dfl_feature_platform_data *pdata,
> +                               void *private)
> +{
> +       pdata->private = private;
> +}
> +
> +static inline
> +void *dfl_fpga_pdata_get_private(struct dfl_feature_platform_data *pdata)
> +{
> +       return pdata->private;
> +}
> +
> +struct dfl_feature_ops {
> +       int (*init)(struct platform_device *pdev, struct dfl_feature *feature);
> +       void (*uinit)(struct platform_device *pdev,
> +                     struct dfl_feature *feature);
> +       long (*ioctl)(struct platform_device *pdev, struct dfl_feature *feature,
> +                     unsigned int cmd, unsigned long arg);
> +};
> +
>  #define DFL_FPGA_FEATURE_DEV_FME               "dfl-fme"
>  #define DFL_FPGA_FEATURE_DEV_PORT              "dfl-port"

Please move these to the same place as other things that will need to
be added to as feature devices are added as noted in the other reviews
today.

>
> @@ -179,6 +234,10 @@ static inline int dfl_feature_platform_data_size(const int num)
>                 num * sizeof(struct dfl_feature);
>  }
>
> +void dfl_fpga_dev_feature_uinit(struct platform_device *pdev);
> +int dfl_fpga_dev_feature_init(struct platform_device *pdev,
> +                             struct dfl_feature_driver *feature_drvs);
> +
>  enum dfl_fpga_devt_type {
>         DFL_FPGA_DEVT_FME,
>         DFL_FPGA_DEVT_PORT,
> @@ -190,6 +249,16 @@ int dfl_fpga_register_dev_ops(struct platform_device *pdev,
>                               struct module *owner);
>  void dfl_fpga_unregister_dev_ops(struct platform_device *pdev);
>
> +static inline
> +struct platform_device *dfl_fpga_inode_to_feature_dev(struct inode *inode)
> +{
> +       struct dfl_feature_platform_data *pdata;
> +
> +       pdata = container_of(inode->i_cdev, struct dfl_feature_platform_data,
> +                            cdev);
> +       return pdata->dev;
> +}
> +
>  #define dfl_fpga_dev_for_each_feature(pdata, feature)                      \
>         for ((feature) = (pdata)->features;                                 \
>            (feature) < (pdata)->features + (pdata)->num; (feature)++)
> @@ -219,6 +288,17 @@ void __iomem *dfl_get_feature_ioaddr_by_id(struct device *dev, u64 id)
>         return NULL;
>  }
>
> +static inline bool is_dfl_feature_present(struct device *dev, u64 id)
> +{
> +       return !!dfl_get_feature_ioaddr_by_id(dev, id);
> +}
> +
> +static inline
> +struct device *dfl_fpga_pdata_to_parent(struct dfl_feature_platform_data *pdata)
> +{
> +       return pdata->dev->dev.parent->parent;
> +}
> +
>  static inline bool dfl_feature_is_fme(void __iomem *base)
>  {
>         u64 v = readq(base + DFH);
> --
> 1.8.3.1
>
