From: Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH 12/17] fpga: dfl: afu: add STP (SignalTap) support
Date: Tue, 2 Apr 2019 08:07:19 -0700
Message-ID: <20190402150719.GB15773@archbook>
References: <1553483264-5379-1-git-send-email-hao.wu@intel.com>
 <1553483264-5379-13-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1553483264-5379-13-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

Hi Wu,

On Mon, Mar 25, 2019 at 11:07:39AM +0800, Wu Hao wrote:
> STP (SignalTap) is one of the private features under the port for
> debugging. This patch adds private feature driver support for it
> to allow userspace applications to mmap related mmio region and
> provide STP service.
> 
> Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Moritz Fischer <mdf@kernel.org>
> ---
>  drivers/fpga/dfl-afu-main.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/drivers/fpga/dfl-afu-main.c b/drivers/fpga/dfl-afu-main.c
> index 754729e..14970a4 100644
> --- a/drivers/fpga/dfl-afu-main.c
> +++ b/drivers/fpga/dfl-afu-main.c
> @@ -518,6 +518,36 @@ static const struct dfl_feature_ops port_afu_ops = {
>  	.uinit = port_afu_uinit,
>  };
>  
> +static int port_stp_init(struct platform_device *pdev,
> +			 struct dfl_feature *feature)
> +{
> +	struct resource *res = &pdev->resource[feature->resource_index];
> +
> +	dev_dbg(&pdev->dev, "PORT STP Init.\n");
> +
> +	return afu_mmio_region_add(dev_get_platdata(&pdev->dev),
> +				   DFL_PORT_REGION_INDEX_STP,
> +				   resource_size(res), res->start,
> +				   DFL_PORT_REGION_MMAP | DFL_PORT_REGION_READ |
> +				   DFL_PORT_REGION_WRITE);
> +}
> +
> +static void port_stp_uinit(struct platform_device *pdev,
> +			   struct dfl_feature *feature)
> +{
> +	dev_dbg(&pdev->dev, "PORT STP UInit.\n");
> +}
> +
> +static const struct dfl_feature_id port_stp_id_table[] = {
> +	{.id = PORT_FEATURE_ID_STP,},
> +	{0,}
> +};
> +
> +static const struct dfl_feature_ops port_stp_ops = {
> +	.init = port_stp_init,
> +	.uinit = port_stp_uinit,
> +};
> +
>  static struct dfl_feature_driver port_feature_drvs[] = {
>  	{
>  		.id_table = port_hdr_id_table,
> @@ -532,6 +562,10 @@ static struct dfl_feature_driver port_feature_drvs[] = {
>  		.ops = &port_err_ops,
>  	},
>  	{
> +		.id_table = port_stp_id_table,
> +		.ops = &port_stp_ops,
> +	},
> +	{
>  		.ops = NULL,
>  	}
>  };
> -- 
> 2.7.4
> 

Thanks,
Moritz
