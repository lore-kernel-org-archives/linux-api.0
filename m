From: Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH v4 08/12] fpga: dfl: make uinit callback optional
Date: Fri, 9 Aug 2019 12:51:49 -0700
Message-ID: <20190809195149.GA2788@archbox>
References: <1564914022-3710-1-git-send-email-hao.wu@intel.com>
 <1564914022-3710-9-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1564914022-3710-9-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: gregkh@linuxfoundation.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, atull@kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, Aug 04, 2019 at 06:20:18PM +0800, Wu Hao wrote:
> This patch makes uinit callback of sub features optional. With
> this change, people don't need to prepare any empty uinit callback.
> 
> Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Moritz Fischer <mdf@kernel.org>
> ---
>  drivers/fpga/dfl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
> index 87eaef6..c0512af 100644
> --- a/drivers/fpga/dfl.c
> +++ b/drivers/fpga/dfl.c
> @@ -259,7 +259,8 @@ void dfl_fpga_dev_feature_uinit(struct platform_device *pdev)
>  
>  	dfl_fpga_dev_for_each_feature(pdata, feature)
>  		if (feature->ops) {
> -			feature->ops->uinit(pdev, feature);
> +			if (feature->ops->uinit)
> +				feature->ops->uinit(pdev, feature);
>  			feature->ops = NULL;
>  		}
>  }
> -- 
> 1.8.3.1
> 
