From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v6 1/3] Documentation: fpga: dfl: add descriptions for
 thermal/power management interfaces
Date: Tue, 10 Sep 2019 12:29:17 -0700
Message-ID: <20190910192917.GA1566@roeck-us.net>
References: <1568094640-4920-1-git-send-email-hao.wu@intel.com>
 <1568094640-4920-2-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1568094640-4920-2-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-hwmon@vger.kernel.org, jdelvare@suse.com, gregkh@linuxfoundation.org, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 10, 2019 at 01:50:38PM +0800, Wu Hao wrote:
> From: Xu Yilun <yilun.xu@intel.com>
> 
> This patch add introductions to thermal/power interfaces. They are
> implemented as hwmon sysfs interfaces by thermal/power private
> feature drivers.
> 
> Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>

Acked-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  Documentation/fpga/dfl.rst | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/fpga/dfl.rst b/Documentation/fpga/dfl.rst
> index 6fa483f..094fc8a 100644
> --- a/Documentation/fpga/dfl.rst
> +++ b/Documentation/fpga/dfl.rst
> @@ -108,6 +108,16 @@ More functions are exposed through sysfs
>       error reporting sysfs interfaces allow user to read errors detected by the
>       hardware, and clear the logged errors.
>  
> + Power management (dfl_fme_power hwmon)
> +     power management hwmon sysfs interfaces allow user to read power management
> +     information (power consumption, thresholds, threshold status, limits, etc.)
> +     and configure power thresholds for different throttling levels.
> +
> + Thermal management (dfl_fme_thermal hwmon)
> +     thermal management hwmon sysfs interfaces allow user to read thermal
> +     management information (current temperature, thresholds, threshold status,
> +     etc.).
> +
>  
>  FIU - PORT
>  ==========
> -- 
> 1.8.3.1
> 
