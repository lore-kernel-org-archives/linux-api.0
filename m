From: Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH v5 1/9] fpga: dfl: make init callback optional
Date: Tue, 20 Aug 2019 20:24:06 -0700
Message-ID: <20190821032406.GA28625@archbox>
References: <1565578204-13969-1-git-send-email-hao.wu@intel.com>
 <1565578204-13969-2-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1565578204-13969-2-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: gregkh@linuxfoundation.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, atull@kernel.org
List-Id: linux-api@vger.kernel.org

Hi,

On Mon, Aug 12, 2019 at 10:49:56AM +0800, Wu Hao wrote:
> This patch makes init callback of sub features optional. With
> this change, people don't need to prepare any empty init callback.
> 
> Signed-off-by: Wu Hao <hao.wu@intel.com>

Acked-by: Moritz Fischer <mdf@kernel.org>
> ---
>  drivers/fpga/dfl.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
> index c0512af..96a2b82 100644
> --- a/drivers/fpga/dfl.c
> +++ b/drivers/fpga/dfl.c
> @@ -271,11 +271,13 @@ static int dfl_feature_instance_init(struct platform_device *pdev,
>  				     struct dfl_feature *feature,
>  				     struct dfl_feature_driver *drv)
>  {
> -	int ret;
> +	int ret = 0;
>  
> -	ret = drv->ops->init(pdev, feature);
> -	if (ret)
> -		return ret;
> +	if (drv->ops->init) {
> +		ret = drv->ops->init(pdev, feature);
> +		if (ret)
> +			return ret;
> +	}
>  
>  	feature->ops = drv->ops;

You could swap it around maybe like so:

int dfl_feature_instance_init() ...
{
	feature->ops = drv->ops;
	if (drv->ops->init)
		return drv->ops->init(pdev, feature);

	return 0;
}

With the caveat that feature->ops gets always set ...

Your call.

Thanks,
Moritz
