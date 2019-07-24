From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 04/12] fpga: dfl: afu: add AFU state related sysfs
 interfaces
Date: Wed, 24 Jul 2019 11:41:10 +0200
Message-ID: <20190724094110.GD29532@kroah.com>
References: <1563857495-26692-1-git-send-email-hao.wu@intel.com>
 <1563857495-26692-5-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1563857495-26692-5-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, atull@kernel.org, Ananda Ravuri <ananda.ravuri@intel.com>, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 23, 2019 at 12:51:27PM +0800, Wu Hao wrote:
> This patch introduces more sysfs interfaces for Accelerated
> Function Unit (AFU). These interfaces allow users to read
> current AFU Power State (APx), read / clear AFU Power (APx)
> events which are sticky to identify transient APx state,
> and manage AFU's LTR (latency tolerance reporting).
> 
> Signed-off-by: Ananda Ravuri <ananda.ravuri@intel.com>
> Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
> Acked-by: Alan Tull <atull@kernel.org>
> Signed-off-by: Moritz Fischer <mdf@kernel.org>
> ---
> v2: rebased, and remove DRV/MODULE_VERSION modifications
> v3: update kernel version and date in sysfs doc
> ---
>  Documentation/ABI/testing/sysfs-platform-dfl-port |  30 +++++
>  drivers/fpga/dfl-afu-main.c                       | 137 ++++++++++++++++++++++
>  drivers/fpga/dfl.h                                |  11 ++
>  3 files changed, 178 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-platform-dfl-port b/Documentation/ABI/testing/sysfs-platform-dfl-port
> index 6a92dda..5961fb2 100644
> --- a/Documentation/ABI/testing/sysfs-platform-dfl-port
> +++ b/Documentation/ABI/testing/sysfs-platform-dfl-port
> @@ -14,3 +14,33 @@ Description:	Read-only. User can program different PR bitstreams to FPGA
>  		Accelerator Function Unit (AFU) for different functions. It
>  		returns uuid which could be used to identify which PR bitstream
>  		is programmed in this AFU.
> +
> +What:		/sys/bus/platform/devices/dfl-port.0/power_state
> +Date:		July 2019
> +KernelVersion:	5.4
> +Contact:	Wu Hao <hao.wu@intel.com>
> +Description:	Read-only. It reports the APx (AFU Power) state, different APx
> +		means different throttling level. When reading this file, it
> +		returns "0" - Normal / "1" - AP1 / "2" - AP2 / "6" - AP6.
> +
> +What:		/sys/bus/platform/devices/dfl-port.0/ap1_event
> +Date:		July 2019
> +KernelVersion:	5.4
> +Contact:	Wu Hao <hao.wu@intel.com>
> +Description:	Read-write. Read or set 1 to clear AP1 (AFU Power State 1)
> +		event. It's used to indicate transient AP1 state.

So reading the value changes the state of the system?  That's almost
always never a good idea.

Force userspace to write the value to change something.  Otherwise all
libraries that use sysfs will be accidentally changing the state of your
system without you ever knowing it.



> +
> +What:		/sys/bus/platform/devices/dfl-port.0/ap2_event
> +Date:		July 2019
> +KernelVersion:	5.4
> +Contact:	Wu Hao <hao.wu@intel.com>
> +Description:	Read-write. Read or set 1 to clear AP2 (AFU Power State 2)
> +		event. It's used to indicate transient AP2 state.
> +
> +What:		/sys/bus/platform/devices/dfl-port.0/ltr
> +Date:		July 2019
> +KernelVersion:	5.4
> +Contact:	Wu Hao <hao.wu@intel.com>
> +Description:	Read-write. Read and set AFU latency tolerance reporting value.
> +		Set ltr to 1 if the AFU can tolerate latency >= 40us or set it
> +		to 0 if it is latency sensitive.
> diff --git a/drivers/fpga/dfl-afu-main.c b/drivers/fpga/dfl-afu-main.c
> index 68b4d08..cb3f73e 100644
> --- a/drivers/fpga/dfl-afu-main.c
> +++ b/drivers/fpga/dfl-afu-main.c
> @@ -141,8 +141,145 @@ static int port_get_id(struct platform_device *pdev)
>  }
>  static DEVICE_ATTR_RO(id);
>  
> +static ssize_t
> +ltr_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct dfl_feature_platform_data *pdata = dev_get_platdata(dev);
> +	void __iomem *base;
> +	u64 v;
> +
> +	base = dfl_get_feature_ioaddr_by_id(dev, PORT_FEATURE_ID_HEADER);
> +
> +	mutex_lock(&pdata->lock);
> +	v = readq(base + PORT_HDR_CTRL);
> +	mutex_unlock(&pdata->lock);

Why do you need a lock to call readq()?  What are you protecting here?


> +
> +	return sprintf(buf, "%x\n", (u8)FIELD_GET(PORT_CTRL_LATENCY, v));
> +}
> +
> +static ssize_t
> +ltr_store(struct device *dev, struct device_attribute *attr,
> +	  const char *buf, size_t count)
> +{
> +	struct dfl_feature_platform_data *pdata = dev_get_platdata(dev);
> +	void __iomem *base;
> +	u8 ltr;
> +	u64 v;
> +
> +	if (kstrtou8(buf, 0, &ltr) || ltr > 1)
> +		return -EINVAL;

Are you doing anything with this value?  If not, how about just using
the sysfs boolean read function and if it is 1, then do the clearing?

Same for all other show/store functions in here.

thanks,

greg k-h
