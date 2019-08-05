From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 06/12] fpga: dfl: afu: export __port_enable/disable
 function.
Date: Mon, 5 Aug 2019 17:52:40 +0200
Message-ID: <20190805155240.GB8107@kroah.com>
References: <1564914022-3710-1-git-send-email-hao.wu@intel.com>
 <1564914022-3710-7-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1564914022-3710-7-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, atull@kernel.org, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Sun, Aug 04, 2019 at 06:20:16PM +0800, Wu Hao wrote:
> As these two functions are used by other private features. e.g.
> in error reporting private feature, it requires to check port status
> and reset port for error clearing.
> 
> Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
> Acked-by: Moritz Fischer <mdf@kernel.org>
> Acked-by: Alan Tull <atull@kernel.org>
> Signed-off-by: Moritz Fischer <mdf@kernel.org>
> ---
> v2: rebased
> ---
>  drivers/fpga/dfl-afu-main.c | 25 ++++++++++++++-----------
>  drivers/fpga/dfl-afu.h      |  3 +++
>  2 files changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/fpga/dfl-afu-main.c b/drivers/fpga/dfl-afu-main.c
> index e013afb..e312179 100644
> --- a/drivers/fpga/dfl-afu-main.c
> +++ b/drivers/fpga/dfl-afu-main.c
> @@ -22,14 +22,16 @@
>  #include "dfl-afu.h"
>  
>  /**
> - * port_enable - enable a port
> + * __port_enable - enable a port
>   * @pdev: port platform device.
>   *
>   * Enable Port by clear the port soft reset bit, which is set by default.
>   * The AFU is unable to respond to any MMIO access while in reset.
> - * port_enable function should only be used after port_disable function.
> + * __port_enable function should only be used after __port_disable function.
> + *
> + * The caller needs to hold lock for protection.
>   */
> -static void port_enable(struct platform_device *pdev)
> +void __port_enable(struct platform_device *pdev)

worst global function name ever.

Don't polute the global namespace like this for a single driver.  If you
REALLY need it, then use a prefix that shows it is your individual
dfl_special_sauce_platform_device_only type thing.

thanks,

greg k-h
