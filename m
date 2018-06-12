From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v6 14/29] fpga: dfl: add FPGA Management Engine driver basic
 framework
Date: Tue, 12 Jun 2018 08:27:37 -0700
Message-ID: <5c9f36f7-74f2-acd1-a3e0-f56238cf85a7@infradead.org>
References: <1528798243-2029-1-git-send-email-hao.wu@intel.com>
 <1528798243-2029-15-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528798243-2029-15-git-send-email-hao.wu@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>, atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

Hi,

On 06/12/2018 03:10 AM, Wu Hao wrote:
> From: Kang Luwei <luwei.kang@intel.com>
> 
> 
> diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> index 5faab48..45e9220 100644
> --- a/drivers/fpga/Kconfig
> +++ b/drivers/fpga/Kconfig
> @@ -146,6 +146,16 @@ config FPGA_DFL
>  	  Gate Array (FPGA) solutions which implement Device Feature List.
>  	  It provides enumeration APIs, and feature device infrastructure.
>  
> +config FPGA_DFL_FME
> +	tristate "FPGA DFL FME Driver"
> +	depends on FPGA_DFL
> +	help
> +	  The FPGA Management Engine (FME) is a feature device implemented
> +	  under Device Feature List (DFL) framework. Select this option to
> +	  enable the platform device driver for FME which implements all
> +	  FPGA platform level management features. There shall be 1 FME

better:
	                                                       be one FME

> +	  per DFL based FPGA device.
> +
>  config FPGA_DFL_PCI
>  	tristate "FPGA DFL PCIe Device Driver"
>  	depends on PCI && FPGA_DFL


-- 
~Randy
