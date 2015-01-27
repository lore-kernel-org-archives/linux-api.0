From: Julijonas Kikutis <julijonas.kikutis-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] samsung-laptop: enable better lid handling
Date: Tue, 27 Jan 2015 13:26:06 +0000
Message-ID: <1422365168-2428-1-git-send-email-julijonas.kikutis@gmail.com>
References: <1418332715-10547-1-git-send-email-julijonas.kikutis@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418332715-10547-1-git-send-email-julijonas.kikutis-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Julijonas Kikutis <julijonas.kikutis-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Corentin Chary <corentin.chary-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:SAMSUNG LAPTOP DR..." <platform-driver-x86-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Some Samsung laptops with SABI3 delay the sleep for 10 seconds after
the lid is closed and do not wake up from sleep after the lid is opened.
A SABI command is needed to enable the better behavior.

Command = 0x6e, d0 = 0x81 enables this behavior. Returns d0 = 0x01.
Command = 0x6e, d0 = 0x80 disables this behavior. Returns d0 = 0x00.

Command = 0x6d and any d0 queries the state. This returns:
d0 = 0x00000*01, d1 = 0x00, d2 = 0x00, d3 = 0x0* when it is enabled.
d0 = 0x00000*00, d1 = 0x00, d2 = 0x00, d3 = 0x0* when it is disabled.
Where * is 0 - laptop has never slept or hibernated after switch on,
           1 - laptop has hibernated just before,
           2 - laptop has slept just before.

Patch addresses bug https://bugzilla.kernel.org/show_bug.cgi?id=75901 .
It adds a sysfs attribute lid_handling with a description and also an
addition to the quirks structure to enable the mode by default.

A user with another laptop in the bug report says that "power button has
to be pressed twice to wake the machine" when he or she enabled the mode
manually using the SABI command. Therefore, it is enabled by default
only for the single laptop that I have tested.

Signed-off-by: Julijonas Kikutis <julijonas.kikutis-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 .../ABI/testing/sysfs-driver-samsung-laptop        |   8 ++
 drivers/platform/x86/samsung-laptop.c              | 120 ++++++++++++++++++++-
 2 files changed, 127 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-samsung-laptop b/Documentation/ABI/testing/sysfs-driver-samsung-laptop
index 678819a..63c1ad0 100644
--- a/Documentation/ABI/testing/sysfs-driver-samsung-laptop
+++ b/Documentation/ABI/testing/sysfs-driver-samsung-laptop
@@ -35,3 +35,11 @@ Contact:	Corentin Chary <corentin.chary-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 Description:	Use your USB ports to charge devices, even
 		when your laptop is powered off.
 		1 means enabled, 0 means disabled.
+
+What:		/sys/devices/platform/samsung/lid_handling
+Date:		December 11, 2014
+KernelVersion:	3.19
+Contact:	Julijonas Kikutis <julijonas.kikutis-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+Description:	Some Samsung laptops handle lid closing quicker and
+		only handle lid opening with this mode enabled.
+		1 means enabled, 0 means disabled.
diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index ff765d8..fad928a 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -124,6 +124,10 @@ struct sabi_commands {
 	u16 get_wireless_status;
 	u16 set_wireless_status;
 
+	/* 0x80 is off, 0x81 is on */
+	u16 get_lid_handling;
+	u16 set_lid_handling;
+
 	/* 0x81 to read, (0x82 | level << 8) to set, 0xaabb to enable */
 	u16 kbd_backlight;
 
@@ -194,6 +198,9 @@ static const struct sabi_config sabi_configs[] = {
 			.get_wireless_status = 0xFFFF,
 			.set_wireless_status = 0xFFFF,
 
+			.get_lid_handling = 0xFFFF,
+			.set_lid_handling = 0xFFFF,
+
 			.kbd_backlight = 0xFFFF,
 
 			.set_linux = 0x0a,
@@ -254,6 +261,9 @@ static const struct sabi_config sabi_configs[] = {
 			.get_wireless_status = 0x69,
 			.set_wireless_status = 0x6a,
 
+			.get_lid_handling = 0x6d,
+			.set_lid_handling = 0x6e,
+
 			.kbd_backlight = 0x78,
 
 			.set_linux = 0xff,
@@ -353,6 +363,7 @@ struct samsung_quirks {
 	bool broken_acpi_video;
 	bool four_kbd_backlight_levels;
 	bool enable_kbd_backlight;
+	bool lid_handling;
 };
 
 static struct samsung_quirks samsung_unknown = {};
@@ -366,6 +377,10 @@ static struct samsung_quirks samsung_np740u3e = {
 	.enable_kbd_backlight = true,
 };
 
+static struct samsung_quirks samsung_lid_handling = {
+	.lid_handling = true,
+};
+
 static bool force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force,
@@ -830,10 +845,76 @@ static ssize_t set_usb_charge(struct device *dev,
 static DEVICE_ATTR(usb_charge, S_IWUSR | S_IRUGO,
 		   get_usb_charge, set_usb_charge);
 
+static int read_lid_handling(struct samsung_laptop *samsung)
+{
+	const struct sabi_commands *commands = &samsung->config->commands;
+	struct sabi_data data;
+	int retval;
+
+	if (commands->get_lid_handling == 0xFFFF)
+		return -ENODEV;
+
+	memset(&data, 0, sizeof(data));
+	retval = sabi_command(samsung, commands->get_lid_handling,
+			      &data, &data);
+
+	if (retval)
+		return retval;
+
+	return data.data[0] & 0x1;
+}
+
+static int write_lid_handling(struct samsung_laptop *samsung,
+			      int enabled)
+{
+	const struct sabi_commands *commands = &samsung->config->commands;
+	struct sabi_data data;
+
+	memset(&data, 0, sizeof(data));
+	data.data[0] = 0x80 | enabled;
+	return sabi_command(samsung, commands->set_lid_handling,
+			    &data, NULL);
+}
+
+static ssize_t get_lid_handling(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct samsung_laptop *samsung = dev_get_drvdata(dev);
+	int ret;
+
+	ret = read_lid_handling(samsung);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%d\n", ret);
+}
+
+static ssize_t set_lid_handling(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct samsung_laptop *samsung = dev_get_drvdata(dev);
+	int ret, value;
+
+	if (!count || sscanf(buf, "%i", &value) != 1)
+		return -EINVAL;
+
+	ret = write_lid_handling(samsung, !!value);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static DEVICE_ATTR(lid_handling, S_IWUSR | S_IRUGO,
+		   get_lid_handling, set_lid_handling);
+
 static struct attribute *platform_attributes[] = {
 	&dev_attr_performance_level.attr,
 	&dev_attr_battery_life_extender.attr,
 	&dev_attr_usb_charge.attr,
+	&dev_attr_lid_handling.attr,
 	NULL
 };
 
@@ -956,6 +1037,22 @@ static int __init samsung_rfkill_init(struct samsung_laptop *samsung)
 	return 0;
 }
 
+static void samsung_lid_handling_exit(struct samsung_laptop *samsung)
+{
+	if (samsung->quirks->lid_handling)
+		write_lid_handling(samsung, 0);
+}
+
+static int __init samsung_lid_handling_init(struct samsung_laptop *samsung)
+{
+	int retval = 0;
+
+	if (samsung->quirks->lid_handling)
+		retval = write_lid_handling(samsung, 1);
+
+	return retval;
+}
+
 static int kbd_backlight_enable(struct samsung_laptop *samsung)
 {
 	const struct sabi_commands *commands = &samsung->config->commands;
@@ -1111,7 +1208,7 @@ static int __init samsung_backlight_init(struct samsung_laptop *samsung)
 }
 
 static umode_t samsung_sysfs_is_visible(struct kobject *kobj,
-				       struct attribute *attr, int idx)
+					struct attribute *attr, int idx)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct platform_device *pdev = to_platform_device(dev);
@@ -1124,6 +1221,8 @@ static umode_t samsung_sysfs_is_visible(struct kobject *kobj,
 		ok = !!(read_battery_life_extender(samsung) >= 0);
 	if (attr == &dev_attr_usb_charge.attr)
 		ok = !!(read_usb_charge(samsung) >= 0);
+	if (attr == &dev_attr_lid_handling.attr)
+		ok = !!(read_lid_handling(samsung) >= 0);
 
 	return ok ? attr->mode : 0;
 }
@@ -1436,6 +1535,9 @@ static int samsung_pm_notification(struct notifier_block *nb,
 	    samsung->quirks->enable_kbd_backlight)
 		kbd_backlight_enable(samsung);
 
+	if (val == PM_POST_HIBERNATION && samsung->quirks->lid_handling)
+		write_lid_handling(samsung, 1);
+
 	return 0;
 }
 
@@ -1578,6 +1680,15 @@ static struct dmi_system_id __initdata samsung_dmi_table[] = {
 		},
 	 .driver_data = &samsung_np740u3e,
 	},
+	{
+	 .callback = samsung_dmi_matched,
+	 .ident = "300V3Z/300V4Z/300V5Z",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "300V3Z/300V4Z/300V5Z"),
+		},
+	 .driver_data = &samsung_lid_handling,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(dmi, samsung_dmi_table);
@@ -1648,6 +1759,10 @@ static int __init samsung_init(void)
 	if (ret)
 		goto error_leds;
 
+	ret = samsung_lid_handling_init(samsung);
+	if (ret)
+		goto error_lid_handling;
+
 	ret = samsung_debugfs_init(samsung);
 	if (ret)
 		goto error_debugfs;
@@ -1659,6 +1774,8 @@ static int __init samsung_init(void)
 	return ret;
 
 error_debugfs:
+	samsung_lid_handling_exit(samsung);
+error_lid_handling:
 	samsung_leds_exit(samsung);
 error_leds:
 	samsung_rfkill_exit(samsung);
@@ -1683,6 +1800,7 @@ static void __exit samsung_exit(void)
 	unregister_pm_notifier(&samsung->pm_nb);
 
 	samsung_debugfs_exit(samsung);
+	samsung_lid_handling_exit(samsung);
 	samsung_leds_exit(samsung);
 	samsung_rfkill_exit(samsung);
 	samsung_backlight_exit(samsung);
-- 
2.2.2
