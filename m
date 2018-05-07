From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v5 05/28] fpga: region: add compat_id support
Date: Mon, 7 May 2018 16:09:58 -0500
Message-ID: <CANk1AXQ91JVPB4p+VbVv+1GssT9sP9XF6_7fwZ9kH6oFYESjyQ@mail.gmail.com>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com> <1525229431-3087-6-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525229431-3087-6-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, May 1, 2018 at 9:50 PM, Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

Thanks for making the requested changes.  Looks good.

> This patch introduces a compat_id pointer member and sysfs interface
> for each fpga region, similar as compat_id for fpga manager, it allows
> applications to read the per region compat_id for compatibility
> checking before other actions on this fpga-region (e.g PR).
>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Alan Tull <atull@kernel.org>

> ---
> v5: use pointer for compat_id as it's optional to implement.
> ---
>  Documentation/ABI/testing/sysfs-class-fpga-region |  9 +++++++++
>  drivers/fpga/fpga-region.c                        | 22 ++++++++++++++++++++++
>  include/linux/fpga/fpga-region.h                  |  2 ++
>  3 files changed, 33 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-fpga-region
>
> diff --git a/Documentation/ABI/testing/sysfs-class-fpga-region b/Documentation/ABI/testing/sysfs-class-fpga-region
> new file mode 100644
> index 0000000..9618f74
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-fpga-region
> @@ -0,0 +1,9 @@
> +What:          /sys/class/fpga_region/<region>/compat_id
> +Date:          May 2018
> +KernelVersion: 4.17
> +Contact:       Wu Hao <hao.wu@intel.com>
> +Description:   FPGA region id for compatibility check, e.g compatibility
> +               of the FPGA reconfiguration hardware and image. This value
> +               is defined or calculated by the layer that is creating the
> +               FPGA region. This interface returns the compat_id value or
> +               just error code -ENOENT in case compat_id is not used.
> diff --git a/drivers/fpga/fpga-region.c b/drivers/fpga/fpga-region.c
> index d6a9dd2..6929178 100644
> --- a/drivers/fpga/fpga-region.c
> +++ b/drivers/fpga/fpga-region.c
> @@ -162,6 +162,27 @@ int fpga_region_program_fpga(struct fpga_region *region)
>  }
>  EXPORT_SYMBOL_GPL(fpga_region_program_fpga);
>
> +static ssize_t compat_id_show(struct device *dev,
> +                             struct device_attribute *attr, char *buf)
> +{
> +       struct fpga_region *region = to_fpga_region(dev);
> +
> +       if (!region->compat_id)
> +               return -ENOENT;
> +
> +       return sprintf(buf, "%016llx%016llx\n",
> +                      (unsigned long long)region->compat_id->id_h,
> +                      (unsigned long long)region->compat_id->id_l);
> +}
> +
> +static DEVICE_ATTR_RO(compat_id);
> +
> +static struct attribute *fpga_region_attrs[] = {
> +       &dev_attr_compat_id.attr,
> +       NULL,
> +};
> +ATTRIBUTE_GROUPS(fpga_region);
> +
>  /**
>   * fpga_region_create - alloc and init a struct fpga_region
>   * @dev: device parent
> @@ -262,6 +283,7 @@ static int __init fpga_region_init(void)
>         if (IS_ERR(fpga_region_class))
>                 return PTR_ERR(fpga_region_class);
>
> +       fpga_region_class->dev_groups = fpga_region_groups;
>         fpga_region_class->dev_release = fpga_region_dev_release;
>
>         return 0;
> diff --git a/include/linux/fpga/fpga-region.h b/include/linux/fpga/fpga-region.h
> index f2e215b..e8ad979 100644
> --- a/include/linux/fpga/fpga-region.h
> +++ b/include/linux/fpga/fpga-region.h
> @@ -12,6 +12,7 @@
>   * @bridge_list: list of FPGA bridges specified in region
>   * @mgr: FPGA manager
>   * @info: FPGA image info
> + * @compat_id: FPGA region id for compatibility check.
>   * @priv: private data
>   * @get_bridges: optional function to get bridges to a list
>   */
> @@ -21,6 +22,7 @@ struct fpga_region {
>         struct list_head bridge_list;
>         struct fpga_manager *mgr;
>         struct fpga_image_info *info;
> +       struct fpga_compat_id *compat_id;
>         void *priv;
>         int (*get_bridges)(struct fpga_region *region);
>  };
> --
> 1.8.3.1
>
