From: Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH v6 22/29] fpga: dfl: fme-region: add support for compat_id
Date: Wed, 13 Jun 2018 07:18:56 -0700
Message-ID: <20180613141856.GD3866@archbook>
References: <1528798243-2029-1-git-send-email-hao.wu@intel.com>
 <1528798243-2029-23-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1528798243-2029-23-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com
List-Id: linux-api@vger.kernel.org

On Tue, Jun 12, 2018 at 06:10:36PM +0800, Wu Hao wrote:
> This patch adds compat_id support, it reuses fme manager's
> compat id, as the per region compat id is actually from the
> fme manager's register.
> 
> Signed-off-by: Wu Hao <hao.wu@intel.com>
> Acked-by: Alan Tull <atull@kernel.org>
Acked-by: Moritz Fischer <mdf@kernel.org>
> ---
> v5: reuse fme manager's compat_id as per region compat_id
> v6: rebase, fix copyright time and add Acked-by from Alan.
> ---
>  drivers/fpga/dfl-fme-region.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/fpga/dfl-fme-region.c b/drivers/fpga/dfl-fme-region.c
> index a6e0bde..0b7e19c 100644
> --- a/drivers/fpga/dfl-fme-region.c
> +++ b/drivers/fpga/dfl-fme-region.c
> @@ -45,6 +45,7 @@ static int fme_region_probe(struct platform_device *pdev)
>  	}
>  
>  	region->priv = pdata;
> +	region->compat_id = mgr->compat_id;
>  	platform_set_drvdata(pdev, region);
>  
>  	ret = fpga_region_register(region);
> -- 
> 1.8.3.1
> 
