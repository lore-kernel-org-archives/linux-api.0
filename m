From: Yurii Pavlovskyi <yurii.pavlovskyi@gmail.com>
Subject: [PATCH 10/11] platform/x86: asus-wmi: Switch fan boost mode
Date: Wed, 10 Apr 2019 22:34:55 +0200
Message-ID: <72b3e0aa-d53a-8a82-1505-f4f00aa2bb46@gmail.com>
References: <a8dd77f3-1e28-6416-5f04-aff44d5bb6d6@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a8dd77f3-1e28-6416-5f04-aff44d5bb6d6@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
Cc: Corentin Chary <corentin.chary@gmail.com>, Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Daniel Drake <drake@endlessm.com>, acpi4asus-user@lists.sourceforge.net, platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The WMI exposes a write-only device ID where three modes can be switched
on some laptops (TUF Gaming FX505GM). There is a hotkey combination Fn-F5
that does have a fan icon which is designed to toggle between these 3
modes.

Add a SysFS entry that reads the last written value and updates value in
WMI on write and a hotkey handler that toggles the modes. The
corresponding DEVS device handler does obviously take 3 possible
argument values.

Method (SFBM, 1, NotSerialized)
{
    If ((Arg0 == Zero) { .. }
    If ((Arg0 == One)) { .. }
    If ((Arg0 == 0x02)) { .. }
}

... // DEVS
If ((IIA0 == 0x00110018))
{
   SFBM (IIA1)
   Return (One)
}

* 0x00 - is normal,
* 0x01 - is obviously turbo by the amount of noise, might be useful to
avoid CPU frequency throttling on high load,
* 0x02 - the meaning is unknown at the time as modes are not named
in the vendor documentation, but it does look like a quiet mode as CPU
temperature does increase about 10 degrees on maximum load.

Signed-off-by: Yurii Pavlovskyi <yurii.pavlovskyi@gmail.com>
---
 .../ABI/testing/sysfs-platform-asus-wmi       |  10 ++
 drivers/platform/x86/asus-wmi.c               | 119 ++++++++++++++++--
 include/linux/platform_data/x86/asus-wmi.h    |   1 +
 3 files changed, 117 insertions(+), 13 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-platform-asus-wmi b/Documentation/ABI/testing/sysfs-platform-asus-wmi
index 300a40519695..2b3184e297a7 100644
--- a/Documentation/ABI/testing/sysfs-platform-asus-wmi
+++ b/Documentation/ABI/testing/sysfs-platform-asus-wmi
@@ -97,3 +97,13 @@ Description:
 		Write changed RGB keyboard backlight parameters:
 			* 1 - permanently,
 			* 2 - temporarily.
+
+What:		/sys/devices/platform/<platform>/fan_mode
+Date:		Apr 2019
+KernelVersion:	5.1
+Contact:	"Yurii Pavlovskyi" <yurii.pavlovskyi@gmail.com>
+Description:
+		Fan boost mode:
+			* 0 - normal,
+			* 1 - turbo,
+			* 2 - quiet?
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index f4323a57f22f..941c628945ac 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -69,6 +69,7 @@ MODULE_LICENSE("GPL");
 #define NOTIFY_KBD_BRTUP		0xc4
 #define NOTIFY_KBD_BRTDWN		0xc5
 #define NOTIFY_KBD_BRTTOGGLE		0xc7
+#define NOTIFY_KBD_FBM			0x99
 
 #define ASUS_FAN_DESC			"cpu_fan"
 #define ASUS_FAN_MFUN			0x13
@@ -77,6 +78,8 @@ MODULE_LICENSE("GPL");
 #define ASUS_FAN_CTRL_MANUAL		1
 #define ASUS_FAN_CTRL_AUTO		2
 
+#define ASUS_FAN_MODE_COUNT		3
+
 #define USB_INTEL_XUSB2PR		0xD0
 #define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_XHCI	0x9c31
 
@@ -196,6 +199,9 @@ struct asus_wmi {
 	int asus_hwmon_num_fans;
 	int asus_hwmon_pwm;
 
+	bool fan_mode_available;
+	u8 fan_mode;
+
 	bool kbbl_rgb_available;
 	struct asus_kbbl_rgb kbbl_rgb;
 
@@ -1833,6 +1839,87 @@ static int asus_wmi_fan_init(struct asus_wmi *asus)
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
+	if (result & ASUS_WMI_DSTS_PRESENCE_BIT)
+		asus->fan_mode_available = true;
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
+	value = asus->fan_mode % ASUS_FAN_MODE_COUNT;
+	pr_info(PR "Set fan mode: %u\n", value);
+	err = asus_wmi_set_devstate(ASUS_WMI_DEVID_FAN_MODE, value, &retval);
+
+	if (err) {
+		pr_warn(PR "Failed to set fan mode: %d\n", err);
+		return err;
+	}
+
+	if (retval != 1) {
+		pr_warn(PR "Failed to set fan mode (retval): 0x%x\n", retval);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int fan_mode_switch_next(struct asus_wmi *asus)
+{
+	asus->fan_mode = (asus->fan_mode + 1) % ASUS_FAN_MODE_COUNT;
+	return fan_mode_write(asus);
+}
+
+static ssize_t fan_mode_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct asus_wmi *asus = dev_get_drvdata(dev);
+
+	return show_u8(asus->fan_mode, buf);
+}
+
+static ssize_t fan_mode_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int result;
+	u8 new_mode;
+
+	struct asus_wmi *asus = dev_get_drvdata(dev);
+
+	result = store_u8(&new_mode, buf, count);
+	if (result < 0)
+		return result;
+
+	asus->fan_mode = new_mode % ASUS_FAN_MODE_COUNT;
+	fan_mode_write(asus);
+
+	return result;
+}
+
+// Fan mode: 0 - normal, 1 - turbo, 2 - quiet?
+static DEVICE_ATTR_RW(fan_mode);
+
 /* Backlight ******************************************************************/
 
 static int read_backlight_power(struct asus_wmi *asus)
@@ -2084,6 +2171,9 @@ static void asus_wmi_handle_notify(int code, struct asus_wmi *asus)
 		return;
 	}
 
+	if (asus->fan_mode_available && code == NOTIFY_KBD_FBM)
+		fan_mode_switch_next(asus);
+
 	if (is_display_toggle(code) && asus->driver->quirks->no_display_toggle)
 		return;
 
@@ -2237,6 +2327,7 @@ static struct attribute *platform_attributes[] = {
 	&dev_attr_touchpad.attr,
 	&dev_attr_lid_resume.attr,
 	&dev_attr_als_enable.attr,
+	&dev_attr_fan_mode.attr,
 	NULL
 };
 
@@ -2258,6 +2349,8 @@ static umode_t asus_sysfs_is_visible(struct kobject *kobj,
 		devid = ASUS_WMI_DEVID_LID_RESUME;
 	else if (attr == &dev_attr_als_enable.attr)
 		devid = ASUS_WMI_DEVID_ALS_ENABLE;
+	else if (attr == &dev_attr_fan_mode.attr)
+		ok = asus->fan_mode_available;
 
 	if (devid != -1)
 		ok = !(asus_wmi_get_devstate_simple(asus, devid) < 0);
@@ -2282,7 +2375,7 @@ static int asus_wmi_sysfs_init(struct platform_device *device)
 
 /* Platform device ************************************************************/
 
-static int asus_wmi_platform_init(struct asus_wmi *asus)
+static void asus_wmi_platform_init(struct asus_wmi *asus)
 {
 	int rv;
 
@@ -2334,13 +2427,6 @@ static int asus_wmi_platform_init(struct asus_wmi *asus)
 	if (asus->driver->quirks->wapf >= 0)
 		asus_wmi_set_devstate(ASUS_WMI_DEVID_CWAP,
 				      asus->driver->quirks->wapf, NULL);
-
-	return asus_wmi_sysfs_init(asus->platform_device);
-}
-
-static void asus_wmi_platform_exit(struct asus_wmi *asus)
-{
-	asus_wmi_sysfs_exit(asus->platform_device);
 }
 
 /* debugfs ********************************************************************/
@@ -2515,9 +2601,15 @@ static int asus_wmi_add(struct platform_device *pdev)
 	if (wdrv->detect_quirks)
 		wdrv->detect_quirks(asus->driver);
 
-	err = asus_wmi_platform_init(asus);
+	asus_wmi_platform_init(asus);
+
+	err = fan_mode_check_present(asus);
 	if (err)
-		goto fail_platform;
+		goto fail_fan_mode;
+
+	err = asus_wmi_sysfs_init(asus->platform_device);
+	if (err)
+		goto fail_sysfs;
 
 	err = asus_wmi_input_init(asus);
 	if (err)
@@ -2612,8 +2704,9 @@ static int asus_wmi_add(struct platform_device *pdev)
 fail_hwmon:
 	asus_wmi_input_exit(asus);
 fail_input:
-	asus_wmi_platform_exit(asus);
-fail_platform:
+	asus_wmi_sysfs_exit(asus->platform_device);
+fail_sysfs:
+fail_fan_mode:
 	kfree(asus);
 	return err;
 }
@@ -2630,7 +2723,7 @@ static int asus_wmi_remove(struct platform_device *device)
 	kbbl_rgb_exit(asus);
 	asus_wmi_rfkill_exit(asus);
 	asus_wmi_debugfs_exit(asus);
-	asus_wmi_platform_exit(asus);
+	asus_wmi_sysfs_exit(asus->platform_device);
 	asus_wmi_hwmon_exit(asus);
 
 	kfree(asus);
diff --git a/include/linux/platform_data/x86/asus-wmi.h b/include/linux/platform_data/x86/asus-wmi.h
index 25b7b653e6d2..0f3654b7b8a8 100644
--- a/include/linux/platform_data/x86/asus-wmi.h
+++ b/include/linux/platform_data/x86/asus-wmi.h
@@ -59,6 +59,7 @@
 #define ASUS_WMI_DEVID_LIGHTBAR		0x00050025
 #define ASUS_WMI_DEVID_KBD_RGB		0x00100056
 #define ASUS_WMI_DEVID_KBD_RGB2		0x00100057
+#define ASUS_WMI_DEVID_FAN_MODE		0x00110018
 
 /* Misc */
 #define ASUS_WMI_DEVID_CAMERA		0x00060013
-- 
2.17.1
