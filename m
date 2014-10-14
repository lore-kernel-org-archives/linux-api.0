From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [RFC PATCH v2 3/3] i2c: show and change bus frequency via sysfs
Date: Tue, 14 Oct 2014 17:48:14 +0300
Message-ID: <1413298094-9276-4-git-send-email-octavian.purdila@intel.com>
References: <1413298094-9276-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1413298094-9276-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: wsa@the-dreams.de
Cc: linux@roeck-us.net, johan@kernel.org, linux-i2c@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Octavian Purdila <octavian.purdila@intel.com>
List-Id: linux-api@vger.kernel.org

This patch adds three new sysfs files: bus_frequency,
bus_min_frequency and bus_max_frequency which allows the user to view
or change the bus frequency on a per bus level.

This is required for the case where multiple busses have the same
adapter driver and where a module parameter does not allow controlling
the bus speed individually (e.g. USB I2C adapters).

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-i2c | 30 +++++++++++
 drivers/i2c/i2c-core.c                  | 94 +++++++++++++++++++++++++++++++++
 include/linux/i2c.h                     | 16 ++++++
 3 files changed, 140 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-i2c b/Documentation/ABI/testing/sysfs-bus-i2c
index 8075585..4a7f8e7 100644
--- a/Documentation/ABI/testing/sysfs-bus-i2c
+++ b/Documentation/ABI/testing/sysfs-bus-i2c
@@ -43,3 +43,33 @@ Contact:	linux-i2c@vger.kernel.org
 Description:
 		An i2c device attached to bus X that is enumerated via
 		ACPI. Y is the ACPI device name and its format is "%s".
+
+What:		/sys/bus/i2c/devices/i2c-X/bus_frequency
+KernelVersion:	3.19
+Contact:	linux-i2c@vger.kernel.org
+Description:
+		The current bus frequency for bus X. Can be updated if
+		the bus supports it. The unit is HZ and format is
+		"%d\n".
+		If the bus does not support changing the frequency
+		then this entry will be read-only.
+		If the bus does not support showing the frequency than
+		this entry will not be visible.
+		When updating the bus frequency that value must be in
+		the range defined by bus_frequency_min and
+		bus_frequency_max otherwise writing to this entry will
+		fail with -EINVAL.
+		The bus may not support all of the frequencies in the
+		min-max range and may round the frequency to the
+		closest supported one. The user must read the entry
+		after writing it to retrieve the actual set frequency.
+
+What:		/sys/bus/i2c/devices/i2c-X/bus_min_frequency
+What:		/sys/bus/i2c/devices/i2c-X/bus_max_frequency
+KernelVersion:	3.19
+Contact:	linux-i2c@vger.kernel.org
+Description:
+		Minimum and maximum frequencies for bus X. The unit is
+		HZ and format is "%d\n".
+		If the bus does not support changing the frequency
+		these entries will not be visible.
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 632057a..ab77f7f 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -940,15 +940,101 @@ static DEVICE_ATTR(new_device, S_IWUSR, NULL, i2c_sysfs_new_device);
 static DEVICE_ATTR_IGNORE_LOCKDEP(delete_device, S_IWUSR, NULL,
 				   i2c_sysfs_delete_device);
 
+static ssize_t
+i2c_sysfs_freq_show(struct device *dev, struct device_attribute *attr,
+		    char *buf)
+{
+	struct i2c_adapter *adap = to_i2c_adapter(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", adap->freq);
+}
+
+static ssize_t
+i2c_sysfs_freq_store(struct device *dev, struct device_attribute *attr,
+		     const char *buf, size_t count)
+{
+	struct i2c_adapter *adap = to_i2c_adapter(dev);
+	unsigned int freq;
+	int ret;
+
+	if (kstrtouint(buf, 0, &freq) || freq < adap->min_freq ||
+	    freq > adap->max_freq)
+		return -EINVAL;
+
+	i2c_lock_adapter(adap);
+	ret = adap->set_freq(adap, &freq);
+	i2c_unlock_adapter(adap);
+
+	if (ret)
+		return ret;
+
+	adap->freq = freq;
+
+	return count;
+}
+
+static DEVICE_ATTR(bus_frequency, S_IRUGO, i2c_sysfs_freq_show,
+		   i2c_sysfs_freq_store);
+
+
+static ssize_t
+i2c_sysfs_min_freq_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct i2c_adapter *adap = to_i2c_adapter(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", adap->min_freq);
+}
+
+static DEVICE_ATTR(bus_min_frequency, S_IRUGO, i2c_sysfs_min_freq_show, NULL);
+
+static ssize_t
+i2c_sysfs_max_freq_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct i2c_adapter *adap = to_i2c_adapter(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", adap->max_freq);
+}
+
+static DEVICE_ATTR(bus_max_frequency, S_IRUGO, i2c_sysfs_max_freq_show, NULL);
+
+umode_t i2c_adapter_visible_attr(struct kobject *kobj,
+				 struct attribute *attr, int idx)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct i2c_adapter *adap = to_i2c_adapter(dev);
+	umode_t mode = attr->mode;
+
+	if (attr == &dev_attr_bus_min_frequency.attr)
+		return adap->min_freq ? mode : 0;
+
+	if (attr == &dev_attr_bus_max_frequency.attr)
+		return adap->max_freq ? mode : 0;
+
+	if (attr == &dev_attr_bus_frequency.attr) {
+		if (adap->set_freq)
+			mode |= S_IWUSR;
+		return adap->freq ? mode : 0;
+	}
+
+	return mode;
+}
+
+
 static struct attribute *i2c_adapter_attrs[] = {
 	&dev_attr_name.attr,
 	&dev_attr_new_device.attr,
 	&dev_attr_delete_device.attr,
+	&dev_attr_bus_frequency.attr,
+	&dev_attr_bus_min_frequency.attr,
+	&dev_attr_bus_max_frequency.attr,
 	NULL
 };
 
 static struct attribute_group i2c_adapter_attr_group = {
 	.attrs		= i2c_adapter_attrs,
+	.is_visible	= i2c_adapter_visible_attr,
 };
 
 static const struct attribute_group *i2c_adapter_attr_groups[] = {
@@ -1262,6 +1348,14 @@ int i2c_add_adapter(struct i2c_adapter *adapter)
 	struct device *dev = &adapter->dev;
 	int id;
 
+	if (adapter->set_freq) {
+		if (!adapter->freq || !adapter->min_freq || !adapter->max_freq)
+			return -EINVAL;
+	} else {
+		if (adapter->min_freq || adapter->max_freq)
+			return -EINVAL;
+	}
+
 	if (dev->of_node) {
 		id = of_alias_get_id(dev->of_node, "i2c");
 		if (id >= 0) {
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 36041e2..3482b09 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -431,6 +431,17 @@ int i2c_generic_scl_recovery(struct i2c_adapter *adap);
  *	usb->interface->dev, platform_device->dev etc.)
  * @name: name of this i2c bus
  * @bus_recovery_info: see struct i2c_bus_recovery_info. Optional.
+ * @set_freq: set the bus frequency (in HZ) and returns the actual set
+ * 	value. Since not all the freqeuncies in the min - max interval
+ * 	may be valid the driver may round the frequency to the closest
+ * 	supported one. Optional but must be set if min_freq or
+ * 	max_freq is set.
+ * @min_freq: minimum bus frequency. Optional but must be set if
+ *	set_freq is set.
+ * @max_freq: maximum bus frequency. Optional but must be set if
+ *	set_freq is set.
+ * @freq: initial bus frequency. Optional but must be set if set_freq
+ *	is set.
  */
 struct i2c_adapter {
 	struct module *owner;
@@ -438,6 +449,11 @@ struct i2c_adapter {
 	const struct i2c_algorithm *algo; /* the algorithm to access the bus */
 	void *algo_data;
 
+	unsigned int freq;
+	unsigned int min_freq;
+	unsigned int max_freq;
+	int (*set_freq)(struct i2c_adapter *a, unsigned int *freq);
+
 	/* data fields that are valid for all devices	*/
 	struct rt_mutex bus_lock;
 
-- 
1.9.1
