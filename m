From: Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V3 2/2] watchdog: Read device status through sysfs attributes
Date: Thu,  3 Sep 2015 08:52:03 +0530
Message-ID: <20b1ed49430632e1de8f266fe6daaccb590ef571.1441249584.git.panand@redhat.com>
References: <cover.1441249584.git.panand@redhat.com>
Return-path: <linux-watchdog-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1441249584.git.panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-watchdog-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org
Cc: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-watchdog-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Wim Van Sebroeck <wim-IQzOog9fTRqzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch adds following attributes to watchdog device's sysfs interface
to read its different status.

* state - reads whether device is active or not
* identity - reads Watchdog device's identity string.
* timeout - reads current timeout.
* timeleft - reads timeleft before watchdog generates a reset
* bootstatus - reads status of the watchdog device at boot
* status - reads watchdog device's  internal status bits
* nowayout - reads whether nowayout feature was set or not

Testing with iTCO_wdt:
 # cd /sys/class/watchdog/watchdog1/
 # ls
bootstatus  dev  device  identity  nowayout  power  state
subsystem  timeleft  timeout  uevent
 # cat identity
iTCO_wdt
 # cat timeout
30
 # cat state
inactive
 # echo > /dev/watchdog1
 # cat timeleft
26
 # cat state
active
 # cat bootstatus
0
 # cat nowayout
0

Signed-off-by: Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-class-watchdog |  51 ++++++++++++
 drivers/watchdog/watchdog_core.c               |   2 +-
 drivers/watchdog/watchdog_dev.c                | 110 +++++++++++++++++++++++++
 3 files changed, 162 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-watchdog

diff --git a/Documentation/ABI/testing/sysfs-class-watchdog b/Documentation/ABI/testing/sysfs-class-watchdog
new file mode 100644
index 000000000000..736046b33040
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-watchdog
@@ -0,0 +1,51 @@
+What:		/sys/class/watchdog/watchdogn/bootstatus
+Date:		August 2015
+Contact:	Wim Van Sebroeck <wim-IQzOog9fTRqzQB+pC5nmwQ@public.gmane.org>
+Description:
+		It is a read only file. It contains status of the watchdog
+		device at boot. It is equivalent to WDIOC_GETBOOTSTATUS of
+		ioctl interface.
+
+What:		/sys/class/watchdog/watchdogn/identity
+Date:		August 2015
+Contact:	Wim Van Sebroeck <wim-IQzOog9fTRqzQB+pC5nmwQ@public.gmane.org>
+Description:
+		It is a read only file. It contains identity string of
+		watchdog device.
+
+What:		/sys/class/watchdog/watchdogn/nowayout
+Date:		August 2015
+Contact:	Wim Van Sebroeck <wim-IQzOog9fTRqzQB+pC5nmwQ@public.gmane.org>
+Description:
+		It is a read only file. While reading, it gives '1' if that
+		device supports nowayout feature else, it gives '0'.
+
+What:		/sys/class/watchdog/watchdogn/state
+Date:		August 2015
+Contact:	Wim Van Sebroeck <wim-IQzOog9fTRqzQB+pC5nmwQ@public.gmane.org>
+Description:
+		It is a read only file. It gives active/inactive status of
+		watchdog device.
+
+What:		/sys/class/watchdog/watchdogn/status
+Date:		August 2015
+Contact:	Wim Van Sebroeck <wim-IQzOog9fTRqzQB+pC5nmwQ@public.gmane.org>
+Description:
+		It is a read only file. It contains watchdog device's
+		internal status bits. It is equivalent to WDIOC_GETSTATUS
+		of ioctl interface.
+
+What:		/sys/class/watchdog/watchdogn/timeleft
+Date:		August 2015
+Contact:	Wim Van Sebroeck <wim-IQzOog9fTRqzQB+pC5nmwQ@public.gmane.org>
+Description:
+		It is a read only file. It contains value of time left for
+		reset generation. It is equivalent to WDIOC_GETTIMELEFT of
+		ioctl interface.
+
+What:		/sys/class/watchdog/watchdogn/timeout
+Date:		August 2015
+Contact:	Wim Van Sebroeck <wim-IQzOog9fTRqzQB+pC5nmwQ@public.gmane.org>
+Description:
+		It is a read only file. It is read to know about current
+		value of timeout programmed.
diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
index 47d38c5c3f9a..62666f021762 100644
--- a/drivers/watchdog/watchdog_core.c
+++ b/drivers/watchdog/watchdog_core.c
@@ -183,7 +183,7 @@ static int __watchdog_register_device(struct watchdog_device *wdd)
 
 	devno = wdd->cdev.dev;
 	wdd->dev = device_create(watchdog_class, wdd->parent, devno,
-					NULL, "watchdog%d", wdd->id);
+					wdd, "watchdog%d", wdd->id);
 	if (IS_ERR(wdd->dev)) {
 		watchdog_dev_unregister(wdd);
 		ida_simple_remove(&watchdog_ida, id);
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 986282d44b90..cbac8f88f390 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -248,6 +248,115 @@ out_timeleft:
 	return err;
 }
 
+static ssize_t nowayout_show(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	struct watchdog_device *wdd = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", !!test_bit(WDOG_NO_WAY_OUT, &wdd->status));
+}
+static DEVICE_ATTR_RO(nowayout);
+
+static ssize_t status_show(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	struct watchdog_device *wdd = dev_get_drvdata(dev);
+	ssize_t status;
+	unsigned int val;
+
+	status = watchdog_get_status(wdd, &val);
+	if (!status)
+		status = sprintf(buf, "%u\n", val);
+
+	return status;
+}
+static DEVICE_ATTR_RO(status);
+
+static ssize_t bootstatus_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct watchdog_device *wdd = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%u\n", wdd->bootstatus);
+}
+static DEVICE_ATTR_RO(bootstatus);
+
+static ssize_t timeleft_show(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	struct watchdog_device *wdd = dev_get_drvdata(dev);
+	ssize_t status;
+	unsigned int val;
+
+	status = watchdog_get_timeleft(wdd, &val);
+	if (!status)
+		status = sprintf(buf, "%u\n", val);
+
+	return status;
+}
+static DEVICE_ATTR_RO(timeleft);
+
+static ssize_t timeout_show(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	struct watchdog_device *wdd = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%u\n", wdd->timeout);
+}
+static DEVICE_ATTR_RO(timeout);
+
+static ssize_t identity_show(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	struct watchdog_device *wdd = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%s\n", wdd->info->identity);
+}
+static DEVICE_ATTR_RO(identity);
+
+static ssize_t state_show(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	struct watchdog_device *wdd = dev_get_drvdata(dev);
+
+	if (watchdog_active(wdd))
+		return sprintf(buf, "active\n");
+
+	return sprintf(buf, "inactive\n");
+}
+static DEVICE_ATTR_RO(state);
+
+static umode_t wdt_is_visible(struct kobject *kobj, struct attribute *attr,
+				int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct watchdog_device *wdd = dev_get_drvdata(dev);
+	umode_t mode = attr->mode;
+
+	if (attr == &dev_attr_status.attr && !wdd->ops->status)
+		mode = 0;
+	else if (attr == &dev_attr_timeleft.attr && !wdd->ops->get_timeleft)
+		mode = 0;
+
+	return mode;
+}
+static struct attribute *wdt_attrs[] = {
+	&dev_attr_state.attr,
+	&dev_attr_identity.attr,
+	&dev_attr_timeout.attr,
+	&dev_attr_timeleft.attr,
+	&dev_attr_bootstatus.attr,
+	&dev_attr_status.attr,
+	&dev_attr_nowayout.attr,
+	NULL,
+};
+
+static const struct attribute_group wdt_group = {
+	.attrs = wdt_attrs,
+	.is_visible = wdt_is_visible,
+};
+__ATTRIBUTE_GROUPS(wdt);
+
 /*
  *	watchdog_ioctl_op: call the watchdog drivers ioctl op if defined
  *	@wddev: the watchdog device to do the ioctl on
@@ -581,6 +690,7 @@ int watchdog_dev_unregister(struct watchdog_device *watchdog)
 static struct class watchdog_class = {
 	.name =		"watchdog",
 	.owner =	THIS_MODULE,
+	.dev_groups = 	wdt_groups,
 };
 
 /*
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
