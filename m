From: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [RFC] watchdog: Add watchdog device control through sysfs
 attributes
Date: Sat, 29 Aug 2015 09:51:24 -0700
Message-ID: <20150829165124.GA22494@roeck-us.net>
References: <d9ac417a3bc1c6846f1ddfcd3cd07e5a92865c19.1440179209.git.panand@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d9ac417a3bc1c6846f1ddfcd3cd07e5a92865c19.1440179209.git.panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-watchdog-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Wim Van Sebroeck <wim-IQzOog9fTRqzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 21, 2015 at 11:18:12PM +0530, Pratyush Anand wrote:
> This patch adds following attributes to watchdog device's sysfs interface.
> 
> * start - writes non zero value to start and zero to stop

I would suggest to drop this attribute, as well as 'keepalive'.
Both will make keeping the internal state very difficult, especially
when we add support for heartbeats triggered by the watchdog core.

> * state - reads whether device is active or not(1 for active and 0 for
> inactive)

How about reporting the state as text ?

> * identity - reads Watchdog device's identity string.
> * keepalive - writes to ping a watchdog device
> * timeout - reads current timeout and writes to program a new timeout.
> * timeleft - reads timeleft before watchdog generates a reset
> * bootstatus - reads status of the watchdog device at boot
> * status - reads watchdog device's  internal status bits
> * nowayout - reads whether nowayout feature was set or not
> 
> Testing with iTCO_wdt:
>  # cd /sys/class/watchdog/watchdog1/
>  # ls
> bootstatus  dev  device  identity  keepalive  nowayout  power  start  state
> status  subsystem  timeleft  timeout  uevent
>  # cat identity
> iTCO_wdt
>  # cat timeout
> 30
>  # echo 1 > start
>  # cat timeleft
> 26
>  # echo 120 > timeout
>  # cat timeleft
> 116
>  # echo > keepalive
>  # cat timeleft
> 118
>  # cat state
> 1
>  # echo 0 > start
>  # cat state
> 0
>  # cat bootstatus
> 0
>  # cat nowayout
> 0
>  # cat status
> cat: status: Operation not supported
> 
Unsupported attributes should not appear in the first place.
Please use is_visible to determine if an attribute should
be there or not.

> Signed-off-by: Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/ABI/testing/sysfs-class-watchdog |  74 +++++++++
>  drivers/watchdog/watchdog_core.c               |   6 +-
>  drivers/watchdog/watchdog_core.h               |   2 +
>  drivers/watchdog/watchdog_dev.c                | 206 +++++++++++++++++++++++++
>  4 files changed, 284 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-watchdog
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-watchdog b/Documentation/ABI/testing/sysfs-class-watchdog
> new file mode 100644
> index 000000000000..31e7be53edf8
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-watchdog
> @@ -0,0 +1,74 @@
> +What:		/sys/class/watchdog/watchdogn/bootstatus
> +Date:		August 2015
> +Contact:	Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Who is normally listed here ? Shouldn't it be the maintainer ?

> +Description:
> +		It is a read only file. It contains status of the watchdog
> +		device at boot. It is equivalent to WDIOC_GETBOOTSTATUS of
> +		ioctl interface.
> +
> +What:		/sys/class/watchdog/watchdogn/identity
> +Date:		August 2015
> +Contact:	Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> +Description:
> +		It is a read only file. It contains identity string of
> +		watchdog device.
> +
> +What:		/sys/class/watchdog/watchdogn/keepalive
> +Date:		August 2015
> +Contact:	Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> +Description:
> +		It is a write only file. It is written to ping a watchdog
> +		device to keep it alive. It is equivalent to
> +		WDIOC_KEEPALIVE of ioctl interface.
> +
> +What:		/sys/class/watchdog/watchdogn/nowayout
> +Date:		August 2015
> +Contact:	Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> +Description:
> +		It is a read only file. While reading, it gives '1' if that
> +		device supports nowayout feature else, it gives '0'.
> +
> +What:		/sys/class/watchdog/watchdogn/start
> +Date:		August 2015
> +Contact:	Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> +Description:
> +		It is a write only file. Writing '1' will trigger that
> +		watchdog device and writing '0' will stop it. These are
> +		equivalent to WDIOS_ENABLECARD and WDIOS_DISABLECARD of ioctl
> +		interface. If a device has nowayout programmed, then that
> +		can not be stopped. Therefore, it is recommended to read
> +		state file to insure that whether watchdog device was
> +		stopped or not after writing '0'.
> +
> +What:		/sys/class/watchdog/watchdogn/state
> +Date:		August 2015
> +Contact:	Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> +Description:
> +		It is a read only file. If it is read as '1' then a watchdog
> +		device is active. If it is read as '0' then a watchdog
> +		device is inactive.
> +
> +What:		/sys/class/watchdog/watchdogn/status
> +Date:		August 2015
> +Contact:	Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> +Description:
> +		It is a read only file. It contains watchdog device's
> +		internal status bits. It is equivalent to WDIOC_GETSTATUS
> +		of ioctl interface.
> +
> +What:		/sys/class/watchdog/watchdogn/timeleft
> +Date:		August 2015
> +Contact:	Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> +Description:
> +		It is a read only file. It contains value of time left for
> +		reset generation. It is equivalent to WDIOC_GETTIMELEFT of
> +		ioctl interface.
> +
> +What:		/sys/class/watchdog/watchdogn/timeout
> +Date:		August 2015
> +Contact:	Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> +Description:
> +		It is a read/write file. It is read to know about current
> +		timeout and written to program a new timeout value. These
> +		are equivalent to WDIOC_SETTIMEOUT and WDIOC_GETTIMEOUT of
> +		ioctl interface.
> diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
> index 1a8059455413..703ff7b23f31 100644
> --- a/drivers/watchdog/watchdog_core.c
> +++ b/drivers/watchdog/watchdog_core.c
> @@ -139,7 +139,7 @@ EXPORT_SYMBOL_GPL(watchdog_init_timeout);
>  
>  static int __watchdog_register_device(struct watchdog_device *wdd)
>  {
> -	int ret, id, devno;
> +	int ret, id;
>  
>  	if (wdd == NULL || wdd->info == NULL || wdd->ops == NULL)
>  		return -EINVAL;
> @@ -181,9 +181,7 @@ static int __watchdog_register_device(struct watchdog_device *wdd)
>  		}
>  	}
>  
> -	devno = wdd->cdev.dev;
> -	wdd->dev = device_create(watchdog_class, wdd->parent, devno,
> -					NULL, "watchdog%d", wdd->id);
> +	wdd->dev = watchdog_device_create(watchdog_class, wdd);

Can we do this in watchdog_dev_register() ?
Seems to make more sense than adding another callback into watchdog_dev.c.

>  	if (IS_ERR(wdd->dev)) {
>  		watchdog_dev_unregister(wdd);
>  		ida_simple_remove(&watchdog_ida, id);
> diff --git a/drivers/watchdog/watchdog_core.h b/drivers/watchdog/watchdog_core.h
> index 6c951418fca7..36abd15ffcea 100644
> --- a/drivers/watchdog/watchdog_core.h
> +++ b/drivers/watchdog/watchdog_core.h
> @@ -31,6 +31,8 @@
>  /*
>   *	Functions/procedures to be called by the core
>   */
> +struct device * watchdog_device_create(struct class *,
> +				struct watchdog_device *);
>  extern int watchdog_dev_register(struct watchdog_device *);
>  extern int watchdog_dev_unregister(struct watchdog_device *);
>  extern int __init watchdog_dev_init(void);
> diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
> index 6aaefbad303e..1186b5a918e9 100644
> --- a/drivers/watchdog/watchdog_dev.c
> +++ b/drivers/watchdog/watchdog_dev.c
> @@ -248,6 +248,212 @@ out_timeleft:
>  	return err;
>  }
>  
> +static ssize_t nowayout_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct watchdog_device *wdd = dev_get_drvdata(dev);
> +	bool nowayout = false;
> +
> +	mutex_lock(&wdd->lock);
> +	if (test_bit(WDOG_NO_WAY_OUT, &wdd->status))
> +		nowayout = true;
> +	mutex_unlock(&wdd->lock);
> +
> +	return sprintf(buf, "%d\n", nowayout);

	return sprintf(buf, "%d\n", !!test_bit(WDOG_NO_WAY_OUT, &wdd->status));

should do it, and the lock doesn't seem to be very helpful,
as it doesn't make a difference when the flag is evaluated.

> +}
> +static DEVICE_ATTR_RO(nowayout);
> +
> +static ssize_t status_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)

Please align continuation lines with '('.

> +{
> +	struct watchdog_device *wdd = dev_get_drvdata(dev);
> +	ssize_t status;
> +	unsigned int val;
> +
> +	status = watchdog_get_status(wdd, &val);
> +	if (!status)
> +		status = sprintf(buf, "%u\n", val);
> +

This attribute should only be visible if supported.

> +	return status;
> +}
> +static DEVICE_ATTR_RO(status);
> +
> +static ssize_t bootstatus_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct watchdog_device *wdd = dev_get_drvdata(dev);
> +	ssize_t status;
> +
> +	mutex_lock(&wdd->lock);
> +	status = sprintf(buf, "%u\n", wdd->bootstatus);
> +	mutex_unlock(&wdd->lock);
> +
Useless lock.

> +	return status;
> +}
> +static DEVICE_ATTR_RO(bootstatus);
> +
> +static ssize_t timeleft_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct watchdog_device *wdd = dev_get_drvdata(dev);
> +	ssize_t status;
> +	unsigned int val;
> +
> +	status = watchdog_get_timeleft(wdd, &val);
> +
> +	if (!status)
> +		status = sprintf(buf, "%u\n", val);
> +
This attribute should only be visible if supported.

> +	return status;
> +}
> +static DEVICE_ATTR_RO(timeleft);
> +
> +static ssize_t timeout_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	struct watchdog_device *wdd = dev_get_drvdata(dev);
> +	unsigned int val;
> +	ssize_t status = 0;

Unnecessary initialization.

> +
> +	status = kstrtouint(buf, 0, &val);
> +	if (!status) {
> +		status = watchdog_set_timeout(wdd, val);
> +		if (status >= 0)
> +			status = watchdog_ping(wdd);
> +	}
> +
> +	if (status < 0)
> +		return status;
> +	else

Unnecessary else.

> +		return size;
> +}
> +
> +static ssize_t timeout_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct watchdog_device *wdd = dev_get_drvdata(dev);
> +	ssize_t status;
> +
> +	mutex_lock(&wdd->lock);
> +	if (wdd->timeout == 0)
> +		status = -EOPNOTSUPP;

Why ?

> +	else
> +		status = sprintf(buf, "%u\n", wdd->timeout);
> +	mutex_unlock(&wdd->lock);
> +
Unnecessary lock.

> +	return status;
> +}
> +static DEVICE_ATTR_RW(timeout);
> +
> +static ssize_t keepalive_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	struct watchdog_device *wdd = dev_get_drvdata(dev);
> +	ssize_t status = 0;
> +
> +	mutex_lock(&wdd->lock);
> +	if (!(wdd->info->options & WDIOF_KEEPALIVEPING))
> +		status = -EOPNOTSUPP;

In that case the attribute should not be there to start with.

Anyway, I would prefer if this attribute would not be there.
Otherwise you'd at least have to check the current state to see
if the watchdog is running in the first place, and you would have
to define what to do if it isn't. Lots of complexity for no clear gain.

> +	mutex_unlock(&wdd->lock);
> +
The lock is unnecessary.

> +	if (!status)
> +		status = watchdog_ping(wdd);
> +
> +	if (status < 0)
> +		return status;
> +	else
> +		return size;
> +}
> +static DEVICE_ATTR_WO(keepalive);
> +
> +static ssize_t identity_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct watchdog_device *wdd = dev_get_drvdata(dev);
> +	ssize_t status;
> +
> +	mutex_lock(&wdd->lock);
> +	status = sprintf(buf, "%s\n", wdd->info->identity);
> +	mutex_unlock(&wdd->lock);
> +
Unnecessary lock.

> +	return status;
> +}
> +static DEVICE_ATTR_RO(identity);
> +
> +static ssize_t state_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct watchdog_device *wdd = dev_get_drvdata(dev);
> +	bool active;
> +
> +	mutex_lock(&wdd->lock);
> +	active = watchdog_active(wdd);
> +	mutex_unlock(&wdd->lock);
> +
Unnecessary lock.

> +	return sprintf(buf, "%d\n", active);
> +}
> +static DEVICE_ATTR_RO(state);
> +
> +static ssize_t start_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{

I would prefer not to have this attribute.

> +	struct watchdog_device *wdd = dev_get_drvdata(dev);
> +	ssize_t status = 0;
> +	unsigned int val;
> +
> +	status = kstrtouint(buf, 0, &val);
> +	if (status)
> +		return status;
> +	if (val)
> +		status = watchdog_start(wdd);
> +	else
> +		status = watchdog_stop(wdd);
> +
> +	if (status < 0)
> +		return status;
> +	else
> +		return size;
> +}
> +static DEVICE_ATTR_WO(start);
> +
> +static struct attribute *wdt_attrs[] = {
> +	&dev_attr_start.attr,
> +	&dev_attr_state.attr,
> +	&dev_attr_identity.attr,
> +	&dev_attr_keepalive.attr,
> +	&dev_attr_timeout.attr,
> +	&dev_attr_timeleft.attr,
> +	&dev_attr_bootstatus.attr,
> +	&dev_attr_status.attr,
> +	&dev_attr_nowayout.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group wdt_group = {
> +	.attrs = wdt_attrs,
> +};
> +
> +static const struct attribute_group *wdt_groups[] = {
> +	&wdt_group,
> +	NULL
> +};

You should be able to use ATTRIBUTE_GROUPS or __ATTRIBUTE_GROUPS.

> +
> +/*
> + *	watchdog_device_create: create a struct device for a given watchdog
> + *	device
> + *	@wdc: watchdog class with which created device is associated
> + *	@wdd: watchdog device
> + *
> + *	Creates a struct device corresponding to given watchdog device and
> + *	associates a device attribute_group with it.
> + */
> +struct device * watchdog_device_create(struct class *wdc,
> +					struct watchdog_device *wdd)
> +{
> +	return device_create_with_groups(wdc, wdd->parent, wdd->cdev.dev,
> +			wdd, wdt_groups, "watchdog%d", wdd->id);
> +}
> +
>  /*
>   *	watchdog_ioctl_op: call the watchdog drivers ioctl op if defined
>   *	@wddev: the watchdog device to do the ioctl on
