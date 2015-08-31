From: Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2] watchdog: Add watchdog device control through sysfs attributes
Date: Mon, 31 Aug 2015 12:04:18 +0530
Message-ID: <5417c42a93ef68062c4bfdbcf1d1253ea5ce9e08.1441000946.git.panand@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org
Cc: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-watchdog-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Wim Van Sebroeck <wim-IQzOog9fTRqzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch adds following attributes to watchdog device's sysfs interface.

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
Changes since V1(RFC):
* Removed keepalive and start ABI
* timeout is read only now
* state returns text
* only supported ABI visible
* ABI contact changed to MAINTAINER
* unnecessary mutex removed
* aligned continuation with '('
* unnecessary initialization of status (= 0) corrected
* unnecessary else removed
* used __ATTRIBUTE_GROUPS
* removed watchdog_device_create and added functionality in
watchdog_dev_register.
* optimized nowayout_show
* Now no -EOPNOTSUPP return for timeout read in case of wdd->timeout = 0.

 Documentation/ABI/testing/sysfs-class-watchdog |  51 ++++++++++
 drivers/watchdog/watchdog_core.c               |  16 +--
 drivers/watchdog/watchdog_core.h               |   3 +-
 drivers/watchdog/watchdog_dev.c                | 132 ++++++++++++++++++++++++-
 4 files changed, 183 insertions(+), 19 deletions(-)
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
index 1a8059455413..3f9eb13b2023 100644
--- a/drivers/watchdog/watchdog_core.c
+++ b/drivers/watchdog/watchdog_core.c
@@ -139,7 +139,7 @@ EXPORT_SYMBOL_GPL(watchdog_init_timeout);
 
 static int __watchdog_register_device(struct watchdog_device *wdd)
 {
-	int ret, id, devno;
+	int ret, id;
 
 	if (wdd == NULL || wdd->info == NULL || wdd->ops == NULL)
 		return -EINVAL;
@@ -162,7 +162,7 @@ static int __watchdog_register_device(struct watchdog_device *wdd)
 		return id;
 	wdd->id = id;
 
-	ret = watchdog_dev_register(wdd);
+	ret = watchdog_dev_register(wdd, watchdog_class);
 	if (ret) {
 		ida_simple_remove(&watchdog_ida, id);
 		if (!(id == 0 && ret == -EBUSY))
@@ -174,23 +174,13 @@ static int __watchdog_register_device(struct watchdog_device *wdd)
 			return id;
 		wdd->id = id;
 
-		ret = watchdog_dev_register(wdd);
+		ret = watchdog_dev_register(wdd, watchdog_class);
 		if (ret) {
 			ida_simple_remove(&watchdog_ida, id);
 			return ret;
 		}
 	}
 
-	devno = wdd->cdev.dev;
-	wdd->dev = device_create(watchdog_class, wdd->parent, devno,
-					NULL, "watchdog%d", wdd->id);
-	if (IS_ERR(wdd->dev)) {
-		watchdog_dev_unregister(wdd);
-		ida_simple_remove(&watchdog_ida, id);
-		ret = PTR_ERR(wdd->dev);
-		return ret;
-	}
-
 	return 0;
 }
 
diff --git a/drivers/watchdog/watchdog_core.h b/drivers/watchdog/watchdog_core.h
index 6c951418fca7..38a9a2c6e7a2 100644
--- a/drivers/watchdog/watchdog_core.h
+++ b/drivers/watchdog/watchdog_core.h
@@ -31,7 +31,8 @@
 /*
  *	Functions/procedures to be called by the core
  */
-extern int watchdog_dev_register(struct watchdog_device *);
+extern int watchdog_dev_register(struct watchdog_device *,
+					struct class *);
 extern int watchdog_dev_unregister(struct watchdog_device *);
 extern int __init watchdog_dev_init(void);
 extern void __exit watchdog_dev_exit(void);
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 6aaefbad303e..4bbf022534c1 100644
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
@@ -514,13 +623,15 @@ static struct miscdevice watchdog_miscdev = {
 /*
  *	watchdog_dev_register: register a watchdog device
  *	@watchdog: watchdog device
+ *	@watchdog_class: watchdog class with which created device is associated
  *
  *	Register a watchdog device including handling the legacy
  *	/dev/watchdog node. /dev/watchdog is actually a miscdevice and
  *	thus we set it up like that.
  */
 
-int watchdog_dev_register(struct watchdog_device *watchdog)
+int watchdog_dev_register(struct watchdog_device *watchdog,
+				struct class *watchdog_class)
 {
 	int err, devno;
 
@@ -549,11 +660,22 @@ int watchdog_dev_register(struct watchdog_device *watchdog)
 	if (err) {
 		pr_err("watchdog%d unable to add device %d:%d\n",
 			watchdog->id,  MAJOR(watchdog_devt), watchdog->id);
-		if (watchdog->id == 0) {
-			misc_deregister(&watchdog_miscdev);
-			old_wdd = NULL;
-		}
+	} else {
+		watchdog->dev = device_create_with_groups(watchdog_class,
+							watchdog->parent,
+							watchdog->cdev.dev,
+							watchdog, wdt_groups,
+							"watchdog%d",
+							watchdog->id);
+		if (IS_ERR(watchdog->dev))
+			err = PTR_ERR(watchdog->dev);
+	}
+
+	if (err && watchdog->id == 0) {
+		misc_deregister(&watchdog_miscdev);
+		old_wdd = NULL;
 	}
+
 	return err;
 }
 
-- 
2.4.3
