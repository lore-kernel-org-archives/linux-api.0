From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v6 23/29] fpga: dfl: add FPGA Accelerated Function Unit driver
 basic framework
Date: Tue, 12 Jun 2018 08:27:49 -0700
Message-ID: <6f4b06a1-65e1-e3b6-960c-e6eb38ad12b8@infradead.org>
References: <1528798243-2029-1-git-send-email-hao.wu@intel.com>
 <1528798243-2029-24-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528798243-2029-24-git-send-email-hao.wu@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>, atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

Hi,

On 06/12/2018 03:10 AM, Wu Hao wrote:
> 
> diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> index a0aa163..e3b140e 100644
> --- a/drivers/fpga/Kconfig
> +++ b/drivers/fpga/Kconfig
> @@ -174,6 +174,15 @@ config FPGA_DFL_FME_REGION
>  	help
>  	  Say Y to enable FPGA Region driver for FPGA Management Engine.
>  
> +config FPGA_DFL_AFU
> +	tristate "FPGA DFL AFU Driver"
> +	depends on FPGA_DFL
> +	help
> +	  This is the driver for FPGA Accelerated Function Unit (AFU) which
> +	  implements AFU and Port management features. A User AFU connects
> +	  to the FPGA infrastructure via a Port. There may be more than 1

better:
	                                                      more than one

> +	  Port/AFU per DFL based FPGA device.
> +
>  config FPGA_DFL_PCI
>  	tristate "FPGA DFL PCIe Device Driver"
>  	depends on PCI && FPGA_DFL


-- 
~Randy
