From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v6 06/29] fpga: add device feature list support
Date: Tue, 12 Jun 2018 08:27:09 -0700
Message-ID: <e4e6c6b4-bf85-64e0-5d4b-f0816c2f941c@infradead.org>
References: <1528798243-2029-1-git-send-email-hao.wu@intel.com>
 <1528798243-2029-7-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528798243-2029-7-git-send-email-hao.wu@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>, atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

Hi,

On 06/12/2018 03:10 AM, Wu Hao wrote:

> 
> diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> index ee9c542..4052532 100644
> --- a/drivers/fpga/Kconfig
> +++ b/drivers/fpga/Kconfig
> @@ -130,4 +130,20 @@ config OF_FPGA_REGION
>  	  Support for loading FPGA images by applying a Device Tree
>  	  overlay.
>  
> +config FPGA_DFL
> +	tristate "FPGA Device Feature List (DFL) support"
> +	select FPGA_BRIDGE
> +	select FPGA_REGION
> +	help
> +	  Device Feature List (DFL) defines a feature list structure that
> +	  creates a link list of feature headers within the MMIO space

	          a linked list

> +	  to provide an extensible way of adding features for FPGA.
> +	  Driver can walk through the feature headers to enumerate feature
> +	  devices (e.g FPGA Management Engine, Port and Accelerator

	          (e.g.

> +	  Function Unit) and their private features for target FPGA devices.
> +
> +	  Select this option to enable common support for Field-Programmable
> +	  Gate Array (FPGA) solutions which implement Device Feature List.
> +	  It provides enumeration APIs, and feature device infrastructure.

	                              ^no comma

> +
>  endif # FPGA


-- 
~Randy
