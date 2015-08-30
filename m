From: Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] watchdog: Add watchdog device control through sysfs
 attributes
Date: Sun, 30 Aug 2015 19:46:50 +0530
Message-ID: <20150830141650.GA31158@dhcp-0-82.del.redhat.com>
References: <d9ac417a3bc1c6846f1ddfcd3cd07e5a92865c19.1440179209.git.panand@redhat.com>
 <20150829165124.GA22494@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150829165124.GA22494-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Cc: linux-watchdog-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Wim Van Sebroeck <wim-IQzOog9fTRqzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Guenter,

Thanks for review.

On 29/08/2015:09:51:24 AM, Guenter Roeck wrote:
> On Fri, Aug 21, 2015 at 11:18:12PM +0530, Pratyush Anand wrote:
> > This patch adds following attributes to watchdog device's sysfs interface.
> > 
> > * start - writes non zero value to start and zero to stop
> 
> I would suggest to drop this attribute, as well as 'keepalive'.
> Both will make keeping the internal state very difficult, especially
> when we add support for heartbeats triggered by the watchdog core.
> 

OK.

> > * state - reads whether device is active or not(1 for active and 0 for
> > inactive)
> 
> How about reporting the state as text ?

Will change

> 
> > * identity - reads Watchdog device's identity string.
> > * keepalive - writes to ping a watchdog device
> > * timeout - reads current timeout and writes to program a new timeout.
> > * timeleft - reads timeleft before watchdog generates a reset
> > * bootstatus - reads status of the watchdog device at boot
> > * status - reads watchdog device's  internal status bits
> > * nowayout - reads whether nowayout feature was set or not
> > 
> > Testing with iTCO_wdt:
> >  # cd /sys/class/watchdog/watchdog1/
> >  # ls
> > bootstatus  dev  device  identity  keepalive  nowayout  power  start  state
> > status  subsystem  timeleft  timeout  uevent
> >  # cat identity
> > iTCO_wdt
> >  # cat timeout
> > 30
> >  # echo 1 > start
> >  # cat timeleft
> > 26
> >  # echo 120 > timeout
> >  # cat timeleft
> > 116
> >  # echo > keepalive
> >  # cat timeleft
> > 118
> >  # cat state
> > 1
> >  # echo 0 > start
> >  # cat state
> > 0
> >  # cat bootstatus
> > 0
> >  # cat nowayout
> > 0
> >  # cat status
> > cat: status: Operation not supported
> > 
> Unsupported attributes should not appear in the first place.
> Please use is_visible to determine if an attribute should
> be there or not.

Thanks :-).. Will modify.

> 
> > Signed-off-by: Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  Documentation/ABI/testing/sysfs-class-watchdog |  74 +++++++++
> >  drivers/watchdog/watchdog_core.c               |   6 +-
> >  drivers/watchdog/watchdog_core.h               |   2 +
> >  drivers/watchdog/watchdog_dev.c                | 206 +++++++++++++++++++++++++
> >  4 files changed, 284 insertions(+), 4 deletions(-)
> >  create mode 100644 Documentation/ABI/testing/sysfs-class-watchdog
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-class-watchdog b/Documentation/ABI/testing/sysfs-class-watchdog
> > new file mode 100644
> > index 000000000000..31e7be53edf8
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-class-watchdog
> > @@ -0,0 +1,74 @@
> > +What:		/sys/class/watchdog/watchdogn/bootstatus
> > +Date:		August 2015
> > +Contact:	Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Who is normally listed here ? Shouldn't it be the maintainer ?

I am not sure.. Will be happy to change it to
Wim Van Sebroeck <wim-IQzOog9fTRqzQB+pC5nmwQ@public.gmane.org>.

> 
> >  static int __watchdog_register_device(struct watchdog_device *wdd)
> >  {
> > -	int ret, id, devno;
> > +	int ret, id;
> >  
> >  	if (wdd == NULL || wdd->info == NULL || wdd->ops == NULL)
> >  		return -EINVAL;
> > @@ -181,9 +181,7 @@ static int __watchdog_register_device(struct watchdog_device *wdd)
> >  		}
> >  	}
> >  
> > -	devno = wdd->cdev.dev;
> > -	wdd->dev = device_create(watchdog_class, wdd->parent, devno,
> > -					NULL, "watchdog%d", wdd->id);
> > +	wdd->dev = watchdog_device_create(watchdog_class, wdd);
> 
> Can we do this in watchdog_dev_register() ?
> Seems to make more sense than adding another callback into watchdog_dev.c.

I had thought of this, but then will have to change prototype of
watchdog_dev_register() to accept struct class *wdc and which in turn will cause
to change all users of watchdog_dev_register().
Other option could be to add struct class *wdc in struct watchdog_device, but it
did not look nice to me.

> 
> >  	if (IS_ERR(wdd->dev)) {
> > +static ssize_t nowayout_show(struct device *dev,
> > +		struct device_attribute *attr, char *buf)
> > +{
> > +	struct watchdog_device *wdd = dev_get_drvdata(dev);
> > +	bool nowayout = false;
> > +
> > +	mutex_lock(&wdd->lock);
> > +	if (test_bit(WDOG_NO_WAY_OUT, &wdd->status))
> > +		nowayout = true;
> > +	mutex_unlock(&wdd->lock);
> > +
> > +	return sprintf(buf, "%d\n", nowayout);
> 
> 	return sprintf(buf, "%d\n", !!test_bit(WDOG_NO_WAY_OUT, &wdd->status));
> 
> should do it, and the lock doesn't seem to be very helpful,
> as it doesn't make a difference when the flag is evaluated.

OK.

> 
> > +}
> > +static DEVICE_ATTR_RO(nowayout);
> > +
> > +static ssize_t status_show(struct device *dev,
> > +		struct device_attribute *attr, char *buf)
> 
> Please align continuation lines with '('.

OK.

> 
> > +{
> > +	struct watchdog_device *wdd = dev_get_drvdata(dev);
> > +	ssize_t status;
> > +	unsigned int val;
> > +
> > +	status = watchdog_get_status(wdd, &val);
> > +	if (!status)
> > +		status = sprintf(buf, "%u\n", val);
> > +
> 
> This attribute should only be visible if supported.

yes.

> 
> > +	return status;
> > +}
> > +static DEVICE_ATTR_RO(status);
> > +
> > +static ssize_t bootstatus_show(struct device *dev,
> > +		struct device_attribute *attr, char *buf)
> > +{
> > +	struct watchdog_device *wdd = dev_get_drvdata(dev);
> > +	ssize_t status;
> > +
> > +	mutex_lock(&wdd->lock);
> > +	status = sprintf(buf, "%u\n", wdd->bootstatus);
> > +	mutex_unlock(&wdd->lock);
> > +
> Useless lock.

yes.

> 
> > +static ssize_t timeleft_show(struct device *dev,
> > +		struct device_attribute *attr, char *buf)
> > +{
> > +	struct watchdog_device *wdd = dev_get_drvdata(dev);
> > +	ssize_t status;
> > +	unsigned int val;
> > +
> > +	status = watchdog_get_timeleft(wdd, &val);
> > +
> > +	if (!status)
> > +		status = sprintf(buf, "%u\n", val);
> > +
> This attribute should only be visible if supported.

yes
> 
> > +	return status;
> > +}
> > +static DEVICE_ATTR_RO(timeleft);
> > +
> > +static ssize_t timeout_store(struct device *dev,
> > +		struct device_attribute *attr, const char *buf, size_t size)
> > +{
> > +	struct watchdog_device *wdd = dev_get_drvdata(dev);
> > +	unsigned int val;
> > +	ssize_t status = 0;
> 
> Unnecessary initialization.

will correct.

> 
> > +
> > +	status = kstrtouint(buf, 0, &val);
> > +	if (!status) {
> > +		status = watchdog_set_timeout(wdd, val);
> > +		if (status >= 0)
> > +			status = watchdog_ping(wdd);
> > +	}
> > +
> > +	if (status < 0)
> > +		return status;
> > +	else
> 
> Unnecessary else.


ok

> 
> > +		return size;
> > +}
> > +
> > +static ssize_t timeout_show(struct device *dev,
> > +		struct device_attribute *attr, char *buf)
> > +{
> > +	struct watchdog_device *wdd = dev_get_drvdata(dev);
> > +	ssize_t status;
> > +
> > +	mutex_lock(&wdd->lock);
> > +	if (wdd->timeout == 0)
> > +		status = -EOPNOTSUPP;
> 
> Why ?

It has been copied from case WDIOC_GETTIMEOUT: which says:
timeout == 0 means that we don't know the timeout.

> > +
> > +static const struct attribute_group wdt_group = {
> > +	.attrs = wdt_attrs,
> > +};
> > +
> > +static const struct attribute_group *wdt_groups[] = {
> > +	&wdt_group,
> > +	NULL
> > +};
> 
> You should be able to use ATTRIBUTE_GROUPS or __ATTRIBUTE_GROUPS.

Yes, with is_visible __ATTRIBUTE_GROUPS can still be used.

~Pratyush
