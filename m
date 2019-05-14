From: Yurii Pavlovskyi <yurii.pavlovskyi@gmail.com>
Subject: [PATCH v4 12/13] platform/x86: asus-wmi: Switch fan boost mode
Date: Tue, 14 May 2019 21:07:05 +0200
Message-ID: <6f651bf4-cf3d-2ba5-fe11-85c45d2f111d@gmail.com>
References: <c8cdb347-e206-76b2-0d43-546ef660ffb7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c8cdb347-e206-76b2-0d43-546ef660ffb7@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
Cc: Corentin Chary <corentin.chary@gmail.com>, Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Daniel Drake <drake@endlessm.com>, Chris Chiu <chiu@endlessm.com>, acpi4asus-user@lists.sourceforge.net, platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The WMI exposes a write-only device ID where up to three fan modes can be
switched on some laptops (TUF Gaming FX505GM). There is a hotkey
combination Fn-F5 that does have a fan icon, which is designed to toggle
between fan modes. The DSTS of the device ID returns information about the
presence of this capability and the presence of each of the two additional
fan modes as a bitmask (0x01 - overboost present, 0x02 - silent present)
[1].

Add a SysFS entry that reads the last written value and updates value in
WMI on write and a hotkey handler that toggles the modes taking into
account their availability according to DSTS.

Modes:
* 0x00 - normal or balanced,
* 0x01 - overboost, increased fan RPM,
* 0x02 - silent, decreased fan RPM

[1] Link: https://lkml.org/lkml/2019/4/12/110

Signed-off-by: Yurii Pavlovskyi <yurii.pavlovskyi@gmail.com>
Suggested-by: Daniel Drake <drake@endlessm.com>
---
 .../ABI/testing/sysfs-platform-asus-wmi       |  10 ++
 drivers/platform/x86/asus-wmi.c               | 151 +++++++++++++++++-
 include/linux/platform_data/x86/asus-wmi.h    |   1 +
 3 files changed, 154 insertions(+), 8 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-platform-asus-wmi b/Documentation/ABI/testing/sysfs-platform-asus-wmi
index 019e1e29370e..87ae5cc983bf 100644
--- a/Documentation/ABI/testing/sysfs-platform-asus-wmi
+++ b/Documentation/ABI/testing/sysfs-platform-asus-wmi
@@ -36,3 +36,13 @@ KernelVersion:	3.5
 Contact:	"AceLan Kao" <acelan.kao@canonical.com>
 Description:
 		Resume on lid open. 1 means on, 0 means off.
+
+What:		/sys/devices/platform/<platform>/fan_mode
+Date:		Apr 2019
+KernelVersion:	5.2
+Contact:	"Yurii Pavlovskyi" <yurii.pavlovskyi@gmail.com>
+Description:
+		Fan boost mode:
+			* 0 - normal,
+			* 1 - overboost,
+			* 2 - silent
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index ffb4e2530ea4..feb8d72fc3c5 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -70,6 +70,7 @@ MODULE_LICENSE("GPL");
 #define NOTIFY_KBD_BRTUP		0xc4
 #define NOTIFY_KBD_BRTDWN		0xc5
 #define NOTIFY_KBD_BRTTOGGLE		0xc7
+#define NOTIFY_KBD_FBM			0x99
 
 #define ASUS_WMI_FNLOCK_BIOS_DISABLED	BIT(0)
 
@@ -80,6 +81,13 @@ MODULE_LICENSE("GPL");
 #define ASUS_FAN_CTRL_MANUAL		1
 #define ASUS_FAN_CTRL_AUTO		2
 
+#define ASUS_FAN_MODE_NORMAL		0
+#define ASUS_FAN_MODE_OVERBOOST		1
+#define ASUS_FAN_MODE_OVERBOOST_MASK	0x01
+#define ASUS_FAN_MODE_SILENT		2
+#define ASUS_FAN_MODE_SILENT_MASK	0x02
+#define ASUS_FAN_MODES_MASK		0x03
+
 #define USB_INTEL_XUSB2PR		0xD0
 #define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_XHCI	0x9c31
 
@@ -187,6 +195,10 @@ struct asus_wmi {
 	int asus_hwmon_num_fans;
 	int asus_hwmon_pwm;
 
+	bool fan_mode_available;
+	u8 fan_mode_mask;
+	u8 fan_mode;
+
 	struct hotplug_slot hotplug_slot;
 	struct mutex hotplug_lock;
 	struct mutex wmi_lock;
@@ -1483,6 +1495,116 @@ static int asus_wmi_fan_init(struct asus_wmi *asus)
 	return 0;
 }
 
+/* Fan mode *******************************************************************/
+
+static int fan_mode_check_present(struct asus_wmi *asus)
+{
+	u32 result;
+	int err;
+
+	asus->fan_mode_available = false;
+
+	err = asus_wmi_get_devstate(asus, ASUS_WMI_DEVID_FAN_MODE, &result);
+	if (err) {
+		if (err == -ENODEV)
+			return 0;
+		else
+			return err;
+	}
+
+	if ((result & ASUS_WMI_DSTS_PRESENCE_BIT) &&
+			(result & ASUS_FAN_MODES_MASK)) {
+		asus->fan_mode_available = true;
+		asus->fan_mode_mask = result & ASUS_FAN_MODES_MASK;
+	}
+
+	return 0;
+}
+
+static int fan_mode_write(struct asus_wmi *asus)
+{
+	int err;
+	u8 value;
+	u32 retval;
+
+	value = asus->fan_mode;
+
+	pr_info("Set fan mode: %u\n", value);
+	err = asus_wmi_set_devstate(ASUS_WMI_DEVID_FAN_MODE, value, &retval);
+
+	if (err) {
+		pr_warn("Failed to set fan mode: %d\n", err);
+		return err;
+	}
+
+	if (retval != 1) {
+		pr_warn("Failed to set fan mode (retval): 0x%x\n", retval);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int fan_mode_switch_next(struct asus_wmi *asus)
+{
+	if (asus->fan_mode == ASUS_FAN_MODE_NORMAL) {
+		if (asus->fan_mode_mask & ASUS_FAN_MODE_OVERBOOST_MASK)
+			asus->fan_mode = ASUS_FAN_MODE_OVERBOOST;
+		else if (asus->fan_mode_mask & ASUS_FAN_MODE_SILENT_MASK)
+			asus->fan_mode = ASUS_FAN_MODE_SILENT;
+	} else if (asus->fan_mode == ASUS_FAN_MODE_OVERBOOST) {
+		if (asus->fan_mode_mask & ASUS_FAN_MODE_SILENT_MASK)
+			asus->fan_mode = ASUS_FAN_MODE_SILENT;
+		else
+			asus->fan_mode = ASUS_FAN_MODE_NORMAL;
+	} else {
+		asus->fan_mode = ASUS_FAN_MODE_NORMAL;
+	}
+
+	return fan_mode_write(asus);
+}
+
+static ssize_t fan_mode_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct asus_wmi *asus = dev_get_drvdata(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", asus->fan_mode);
+}
+
+static ssize_t fan_mode_store(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	int result;
+	u8 new_mode;
+
+	struct asus_wmi *asus = dev_get_drvdata(dev);
+
+	result = kstrtou8(buf, 10, &new_mode);
+	if (result < 0) {
+		pr_warn("Trying to store invalid value\n");
+		return result;
+	}
+
+	if (new_mode == ASUS_FAN_MODE_OVERBOOST) {
+		if (!(asus->fan_mode_mask & ASUS_FAN_MODE_OVERBOOST_MASK))
+			return -EINVAL;
+	} else if (new_mode == ASUS_FAN_MODE_SILENT) {
+		if (!(asus->fan_mode_mask & ASUS_FAN_MODE_SILENT_MASK))
+			return -EINVAL;
+	} else if (new_mode != ASUS_FAN_MODE_NORMAL) {
+		return -EINVAL;
+	}
+
+	asus->fan_mode = new_mode;
+	fan_mode_write(asus);
+
+	return result;
+}
+
+// Fan mode: 0 - normal, 1 - overboost, 2 - silent
+static DEVICE_ATTR_RW(fan_mode);
+
 /* Backlight ******************************************************************/
 
 static int read_backlight_power(struct asus_wmi *asus)
@@ -1761,6 +1883,11 @@ static void asus_wmi_handle_event_code(int code, struct asus_wmi *asus)
 		return;
 	}
 
+	if (asus->fan_mode_available && code == NOTIFY_KBD_FBM) {
+		fan_mode_switch_next(asus);
+		return;
+	}
+
 	if (is_display_toggle(code) && asus->driver->quirks->no_display_toggle)
 		return;
 
@@ -1917,6 +2044,7 @@ static struct attribute *platform_attributes[] = {
 	&dev_attr_touchpad.attr,
 	&dev_attr_lid_resume.attr,
 	&dev_attr_als_enable.attr,
+	&dev_attr_fan_mode.attr,
 	NULL
 };
 
@@ -1938,6 +2066,8 @@ static umode_t asus_sysfs_is_visible(struct kobject *kobj,
 		devid = ASUS_WMI_DEVID_LID_RESUME;
 	else if (attr == &dev_attr_als_enable.attr)
 		devid = ASUS_WMI_DEVID_ALS_ENABLE;
+	else if (attr == &dev_attr_fan_mode.attr)
+		ok = asus->fan_mode_available;
 
 	if (devid != -1)
 		ok = !(asus_wmi_get_devstate_simple(asus, devid) < 0);
@@ -2037,12 +2167,7 @@ static int asus_wmi_platform_init(struct asus_wmi *asus)
 		asus_wmi_set_devstate(ASUS_WMI_DEVID_CWAP,
 				      asus->driver->quirks->wapf, NULL);
 
-	return asus_wmi_sysfs_init(asus->platform_device);
-}
-
-static void asus_wmi_platform_exit(struct asus_wmi *asus)
-{
-	asus_wmi_sysfs_exit(asus->platform_device);
+	return 0;
 }
 
 /* debugfs ********************************************************************/
@@ -2221,6 +2346,14 @@ static int asus_wmi_add(struct platform_device *pdev)
 	if (err)
 		goto fail_platform;
 
+	err = fan_mode_check_present(asus);
+	if (err)
+		goto fail_fan_mode;
+
+	err = asus_wmi_sysfs_init(asus->platform_device);
+	if (err)
+		goto fail_sysfs;
+
 	err = asus_wmi_input_init(asus);
 	if (err)
 		goto fail_input;
@@ -2302,7 +2435,9 @@ static int asus_wmi_add(struct platform_device *pdev)
 fail_hwmon:
 	asus_wmi_input_exit(asus);
 fail_input:
-	asus_wmi_platform_exit(asus);
+	asus_wmi_sysfs_exit(asus->platform_device);
+fail_sysfs:
+fail_fan_mode:
 fail_platform:
 	kfree(asus);
 	return err;
@@ -2319,7 +2454,7 @@ static int asus_wmi_remove(struct platform_device *device)
 	asus_wmi_led_exit(asus);
 	asus_wmi_rfkill_exit(asus);
 	asus_wmi_debugfs_exit(asus);
-	asus_wmi_platform_exit(asus);
+	asus_wmi_sysfs_exit(asus->platform_device);
 	asus_hwmon_fan_set_auto(asus);
 
 	kfree(asus);
diff --git a/include/linux/platform_data/x86/asus-wmi.h b/include/linux/platform_data/x86/asus-wmi.h
index 0668f76df921..8551156b8dca 100644
--- a/include/linux/platform_data/x86/asus-wmi.h
+++ b/include/linux/platform_data/x86/asus-wmi.h
@@ -57,6 +57,7 @@
 #define ASUS_WMI_DEVID_KBD_BACKLIGHT	0x00050021
 #define ASUS_WMI_DEVID_LIGHT_SENSOR	0x00050022 /* ?? */
 #define ASUS_WMI_DEVID_LIGHTBAR		0x00050025
+#define ASUS_WMI_DEVID_FAN_MODE		0x00110018
 
 /* Misc */
 #define ASUS_WMI_DEVID_CAMERA		0x00060013
-- 
2.17.1
