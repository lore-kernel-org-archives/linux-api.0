From: Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH v6 05/29] fpga: region: add compat_id support
Date: Wed, 13 Jun 2018 07:44:35 -0700
Message-ID: <20180613144435.GE3866@archbook>
References: <1528798243-2029-1-git-send-email-hao.wu@intel.com>
 <1528798243-2029-6-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1528798243-2029-6-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com
List-Id: linux-api@vger.kernel.org

On Tue, Jun 12, 2018 at 06:10:19PM +0800, Wu Hao wrote:
> This patch introduces a compat_id pointer member and sysfs interface
> for each fpga region, similar as compat_id for fpga manager, it allows
> applications to read the per region compat_id for compatibility
> checking before other actions on this fpga-region (e.g PR).
> 
> Signed-off-by: Wu Hao <hao.wu@intel.com>
> Acked-by: Alan Tull <atull@kernel.org>
Acked-by: Moritz Fischer <mdf@kernel.org>
> ---
> v5: use pointer for compat_id as it's optional to implement.
> v6: add Acked-by from Alan.
> ---
>  Documentation/ABI/testing/sysfs-class-fpga-region |  9 +++++++++
>  drivers/fpga/fpga-region.c                        | 22 ++++++++++++++++++++++
>  include/linux/fpga/fpga-region.h                  |  2 ++
>  3 files changed, 33 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-fpga-region
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-fpga-region b/Documentation/ABI/testing/sysfs-class-fpga-region
> new file mode 100644
> index 0000000..ffdc853
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-fpga-region
> @@ -0,0 +1,9 @@
> +What:		/sys/class/fpga_region/<region>/compat_id
> +Date:		June 2018
> +KernelVersion:	4.18
> +Contact:	Wu Hao <hao.wu@intel.com>
> +Description:	FPGA region id for compatibility check, e.g compatibility
> +		of the FPGA reconfiguration hardware and image. This value
> +		is defined or calculated by the layer that is creating the
> +		FPGA region. This interface returns the compat_id value or
> +		just error code -ENOENT in case compat_id is not used.
> diff --git a/drivers/fpga/fpga-region.c b/drivers/fpga/fpga-region.c
> index 6d214d7..0d65220 100644
> --- a/drivers/fpga/fpga-region.c
> +++ b/drivers/fpga/fpga-region.c
> @@ -158,6 +158,27 @@ int fpga_region_program_fpga(struct fpga_region *region)
>  }
>  EXPORT_SYMBOL_GPL(fpga_region_program_fpga);
>  
> +static ssize_t compat_id_show(struct device *dev,
> +			      struct device_attribute *attr, char *buf)
> +{
> +	struct fpga_region *region = to_fpga_region(dev);
> +
> +	if (!region->compat_id)
> +		return -ENOENT;
> +
> +	return sprintf(buf, "%016llx%016llx\n",
> +		       (unsigned long long)region->compat_id->id_h,
> +		       (unsigned long long)region->compat_id->id_l);
> +}
> +
> +static DEVICE_ATTR_RO(compat_id);
> +
> +static struct attribute *fpga_region_attrs[] = {
> +	&dev_attr_compat_id.attr,
> +	NULL,
> +};
> +ATTRIBUTE_GROUPS(fpga_region);
> +
>  /**
>   * fpga_region_create - alloc and init a struct fpga_region
>   * @dev: device parent
> @@ -258,6 +279,7 @@ static int __init fpga_region_init(void)
>  	if (IS_ERR(fpga_region_class))
>  		return PTR_ERR(fpga_region_class);
>  
> +	fpga_region_class->dev_groups = fpga_region_groups;
>  	fpga_region_class->dev_release = fpga_region_dev_release;
>  
>  	return 0;
> diff --git a/include/linux/fpga/fpga-region.h b/include/linux/fpga/fpga-region.h
> index d7071cd..0521b7f 100644
> --- a/include/linux/fpga/fpga-region.h
> +++ b/include/linux/fpga/fpga-region.h
> @@ -14,6 +14,7 @@
>   * @bridge_list: list of FPGA bridges specified in region
>   * @mgr: FPGA manager
>   * @info: FPGA image info
> + * @compat_id: FPGA region id for compatibility check.
>   * @priv: private data
>   * @get_bridges: optional function to get bridges to a list
>   */
> @@ -23,6 +24,7 @@ struct fpga_region {
>  	struct list_head bridge_list;
>  	struct fpga_manager *mgr;
>  	struct fpga_image_info *info;
> +	struct fpga_compat_id *compat_id;
>  	void *priv;
>  	int (*get_bridges)(struct fpga_region *region);
>  };
> -- 
> 1.8.3.1
> 
Thanks,
Moritz
