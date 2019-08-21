From: Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH v5 2/9] fpga: dfl: fme: convert platform_driver to use
 dev_groups
Date: Tue, 20 Aug 2019 20:28:47 -0700
Message-ID: <20190821032847.GB28625@archbox>
References: <1565578204-13969-1-git-send-email-hao.wu@intel.com>
 <1565578204-13969-3-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1565578204-13969-3-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: gregkh@linuxfoundation.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, atull@kernel.org
List-Id: linux-api@vger.kernel.org

Hi Hao,

On Mon, Aug 12, 2019 at 10:49:57AM +0800, Wu Hao wrote:
> This patch takes advantage of driver core which helps to create
> and remove sysfs attribute files, so there is no need to register
> sysfs entries manually in dfl-fme platform river code.
Nit: s/river/driver
> 
> Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Moritz Fischer <mdf@kernel.org>
> ---
>  drivers/fpga/dfl-fme-main.c | 29 ++---------------------------
>  1 file changed, 2 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/fpga/dfl-fme-main.c b/drivers/fpga/dfl-fme-main.c
> index f033f1c..bf8114d 100644
> --- a/drivers/fpga/dfl-fme-main.c
> +++ b/drivers/fpga/dfl-fme-main.c
> @@ -129,30 +129,6 @@ static ssize_t socket_id_show(struct device *dev,
>  };
>  ATTRIBUTE_GROUPS(fme_hdr);
>  
> -static int fme_hdr_init(struct platform_device *pdev,
> -			struct dfl_feature *feature)
> -{
> -	void __iomem *base = feature->ioaddr;
> -	int ret;
> -
> -	dev_dbg(&pdev->dev, "FME HDR Init.\n");
> -	dev_dbg(&pdev->dev, "FME cap %llx.\n",
> -		(unsigned long long)readq(base + FME_HDR_CAP));
> -
> -	ret = device_add_groups(&pdev->dev, fme_hdr_groups);
> -	if (ret)
> -		return ret;
> -
> -	return 0;
> -}
> -
> -static void fme_hdr_uinit(struct platform_device *pdev,
> -			  struct dfl_feature *feature)
> -{
> -	dev_dbg(&pdev->dev, "FME HDR UInit.\n");
> -	device_remove_groups(&pdev->dev, fme_hdr_groups);
> -}
> -
>  static long fme_hdr_ioctl_release_port(struct dfl_feature_platform_data *pdata,
>  				       unsigned long arg)
>  {
> @@ -199,8 +175,6 @@ static long fme_hdr_ioctl(struct platform_device *pdev,
>  };
>  
>  static const struct dfl_feature_ops fme_hdr_ops = {
> -	.init = fme_hdr_init,
> -	.uinit = fme_hdr_uinit,
>  	.ioctl = fme_hdr_ioctl,
>  };
>  
> @@ -361,7 +335,8 @@ static int fme_remove(struct platform_device *pdev)
>  
>  static struct platform_driver fme_driver = {
>  	.driver	= {
> -		.name    = DFL_FPGA_FEATURE_DEV_FME,
> +		.name       = DFL_FPGA_FEATURE_DEV_FME,
> +		.dev_groups = fme_hdr_groups,
>  	},
>  	.probe   = fme_probe,
>  	.remove  = fme_remove,
> -- 
> 1.8.3.1
> 
Thanks,
Moritz
