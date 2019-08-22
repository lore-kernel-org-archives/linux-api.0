From: Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH v5 3/9] fpga: dfl: afu: convert platform_driver to use
 dev_groups
Date: Thu, 22 Aug 2019 08:07:01 -0700
Message-ID: <20190822150701.GB22556@archbox>
References: <1565578204-13969-1-git-send-email-hao.wu@intel.com>
 <1565578204-13969-4-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1565578204-13969-4-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: gregkh@linuxfoundation.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, atull@kernel.org
List-Id: linux-api@vger.kernel.org

Hi Hao,

On Mon, Aug 12, 2019 at 10:49:58AM +0800, Wu Hao wrote:
> This patch takes advantage of driver core which helps to create
> and remove sysfs attribute files, so there is no need to register
> sysfs entries manually in dfl-afu platform river code.
Same nit: s/river/driver
> 
> Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Moritz Fischer <mdf@kernel.org>
> ---
>  drivers/fpga/dfl-afu-main.c | 69 +++++++++++++++++++++++----------------------
>  1 file changed, 36 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/fpga/dfl-afu-main.c b/drivers/fpga/dfl-afu-main.c
> index e50c45e..e955149 100644
> --- a/drivers/fpga/dfl-afu-main.c
> +++ b/drivers/fpga/dfl-afu-main.c
> @@ -282,24 +282,17 @@ static int port_get_id(struct platform_device *pdev)
>  	&dev_attr_power_state.attr,
>  	NULL,
>  };
> -ATTRIBUTE_GROUPS(port_hdr);
> +
> +static const struct attribute_group port_hdr_group = {
> +	.attrs = port_hdr_attrs,
> +};
>  
>  static int port_hdr_init(struct platform_device *pdev,
>  			 struct dfl_feature *feature)
>  {
> -	dev_dbg(&pdev->dev, "PORT HDR Init.\n");
> -
>  	port_reset(pdev);
>  
> -	return device_add_groups(&pdev->dev, port_hdr_groups);
> -}
> -
> -static void port_hdr_uinit(struct platform_device *pdev,
> -			   struct dfl_feature *feature)
> -{
> -	dev_dbg(&pdev->dev, "PORT HDR UInit.\n");
> -
> -	device_remove_groups(&pdev->dev, port_hdr_groups);
> +	return 0;
>  }
>  
>  static long
> @@ -330,7 +323,6 @@ static void port_hdr_uinit(struct platform_device *pdev,
>  
>  static const struct dfl_feature_ops port_hdr_ops = {
>  	.init = port_hdr_init,
> -	.uinit = port_hdr_uinit,
>  	.ioctl = port_hdr_ioctl,
>  };
>  
> @@ -361,32 +353,37 @@ static void port_hdr_uinit(struct platform_device *pdev,
>  	&dev_attr_afu_id.attr,
>  	NULL
>  };
> -ATTRIBUTE_GROUPS(port_afu);
>  
> -static int port_afu_init(struct platform_device *pdev,
> -			 struct dfl_feature *feature)
> +static umode_t port_afu_attrs_visible(struct kobject *kobj,
> +				      struct attribute *attr, int n)
>  {
> -	struct resource *res = &pdev->resource[feature->resource_index];
> -	int ret;
> -
> -	dev_dbg(&pdev->dev, "PORT AFU Init.\n");
> +	struct device *dev = kobj_to_dev(kobj);
>  
> -	ret = afu_mmio_region_add(dev_get_platdata(&pdev->dev),
> -				  DFL_PORT_REGION_INDEX_AFU, resource_size(res),
> -				  res->start, DFL_PORT_REGION_READ |
> -				  DFL_PORT_REGION_WRITE | DFL_PORT_REGION_MMAP);
> -	if (ret)
> -		return ret;
> +	/*
> +	 * sysfs entries are visible only if related private feature is
> +	 * enumerated.
> +	 */
> +	if (!dfl_get_feature_by_id(dev, PORT_FEATURE_ID_AFU))
> +		return 0;
>  
> -	return device_add_groups(&pdev->dev, port_afu_groups);
> +	return attr->mode;
>  }
>  
> -static void port_afu_uinit(struct platform_device *pdev,
> -			   struct dfl_feature *feature)
> +static const struct attribute_group port_afu_group = {
> +	.attrs      = port_afu_attrs,
> +	.is_visible = port_afu_attrs_visible,
> +};
> +
> +static int port_afu_init(struct platform_device *pdev,
> +			 struct dfl_feature *feature)
>  {
> -	dev_dbg(&pdev->dev, "PORT AFU UInit.\n");
Thanks.
> +	struct resource *res = &pdev->resource[feature->resource_index];
>  
> -	device_remove_groups(&pdev->dev, port_afu_groups);
> +	return afu_mmio_region_add(dev_get_platdata(&pdev->dev),
> +				   DFL_PORT_REGION_INDEX_AFU,
> +				   resource_size(res), res->start,
> +				   DFL_PORT_REGION_MMAP | DFL_PORT_REGION_READ |
> +				   DFL_PORT_REGION_WRITE);
>  }
>  
>  static const struct dfl_feature_id port_afu_id_table[] = {
> @@ -396,7 +393,6 @@ static void port_afu_uinit(struct platform_device *pdev,
>  
>  static const struct dfl_feature_ops port_afu_ops = {
>  	.init = port_afu_init,
> -	.uinit = port_afu_uinit,
>  };
>  
>  static struct dfl_feature_driver port_feature_drvs[] = {
> @@ -748,9 +744,16 @@ static int afu_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static const struct attribute_group *afu_dev_groups[] = {
> +	&port_hdr_group,
> +	&port_afu_group,
> +	NULL
> +};
> +
>  static struct platform_driver afu_driver = {
>  	.driver	= {
> -		.name    = DFL_FPGA_FEATURE_DEV_PORT,
> +		.name	    = DFL_FPGA_FEATURE_DEV_PORT,
> +		.dev_groups = afu_dev_groups,
>  	},
>  	.probe   = afu_probe,
>  	.remove  = afu_remove,
> -- 
> 1.8.3.1
> 

Thanks,
Moritz
