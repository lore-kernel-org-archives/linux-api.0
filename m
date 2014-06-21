From: Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3/5] i8k: Add support for configurable maximum fan speed value
Date: Sat, 21 Jun 2014 08:08:10 -0700
Message-ID: <1403363304-22358-3-git-send-email-linux@roeck-us.net>
References: <1403363304-22358-1-git-send-email-linux@roeck-us.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1403363304-22358-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Guenter Roeck <linux@roeck-us.net>
List-Id: linux-api@vger.kernel.org

Newer Dell systems provide more granular fan speed selection.
Add support for it.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/char/i8k.c | 49 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 42 insertions(+), 7 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 14ca8f0..0b69da0 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -65,6 +65,8 @@ static char bios_version[4];
 static struct device *i8k_hwmon_dev;
 static u32 i8k_hwmon_flags;
 static int i8k_fan_mult;
+static int i8k_pwm_mult;
+static int i8k_fan_max = I8K_FAN_HIGH;
 
 #define I8K_HWMON_HAVE_TEMP1	(1 << 0)
 #define I8K_HWMON_HAVE_TEMP2	(1 << 1)
@@ -97,6 +99,10 @@ static int fan_mult = I8K_FAN_MULT;
 module_param(fan_mult, int, 0);
 MODULE_PARM_DESC(fan_mult, "Factor to multiply fan speed with");
 
+static int fan_max = I8K_FAN_HIGH;
+module_param(fan_max, int, 0);
+MODULE_PARM_DESC(fan_max, "Maximum configurable fan speed");
+
 static int i8k_open_fs(struct inode *inode, struct file *file);
 static long i8k_ioctl(struct file *, unsigned int, unsigned long);
 
@@ -276,7 +282,7 @@ static int i8k_set_fan(int fan, int speed)
 {
 	struct smm_regs regs = { .eax = I8K_SMM_SET_FAN, };
 
-	speed = (speed < 0) ? 0 : ((speed > I8K_FAN_MAX) ? I8K_FAN_MAX : speed);
+	speed = (speed < 0) ? 0 : ((speed > i8k_fan_max) ? i8k_fan_max : speed);
 	regs.ebx = (fan & 0xff) | (speed << 8);
 
 	return i8k_smm(&regs) ? : i8k_get_fan_status(fan);
@@ -521,7 +527,7 @@ static ssize_t i8k_hwmon_show_pwm(struct device *dev,
 	status = i8k_get_fan_status(index);
 	if (status < 0)
 		return -EIO;
-	return sprintf(buf, "%d\n", clamp_val(status * 128, 0, 255));
+	return sprintf(buf, "%d\n", clamp_val(status * i8k_pwm_mult, 0, 255));
 }
 
 static ssize_t i8k_hwmon_set_pwm(struct device *dev,
@@ -535,7 +541,7 @@ static ssize_t i8k_hwmon_set_pwm(struct device *dev,
 	err = kstrtoul(buf, 10, &val);
 	if (err)
 		return err;
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 128), 0, 2);
+	val = clamp_val(DIV_ROUND_CLOSEST(val, i8k_pwm_mult), 0, i8k_fan_max);
 
 	mutex_lock(&i8k_mutex);
 	err = i8k_set_fan(index, val);
@@ -638,6 +644,27 @@ static int __init i8k_init_hwmon(void)
 	return 0;
 }
 
+struct i8k_config_data {
+	int fan_mult;
+	int fan_max;
+};
+
+enum i8k_configs {
+	DELL_STUDIO,
+	DELL_XPS_M140,
+};
+
+static const struct i8k_config_data i8k_config_data[] = {
+	[DELL_STUDIO] = {
+		.fan_mult = 1,
+		.fan_max = I8K_FAN_HIGH,
+	},
+	[DELL_XPS_M140] = {
+		.fan_mult = 1,
+		.fan_max = I8K_FAN_HIGH,
+	},
+};
+
 static struct dmi_system_id i8k_dmi_table[] __initdata = {
 	{
 		.ident = "Dell Inspiron",
@@ -708,7 +735,7 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Studio"),
 		},
-		.driver_data = (void *)1,	/* fan multiplier override */
+		.driver_data = (void *)&i8k_config_data[DELL_STUDIO],
 	},
 	{
 		.ident = "Dell XPS M140",
@@ -716,7 +743,7 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "MXC051"),
 		},
-		.driver_data = (void *)1,	/* fan multiplier override */
+		.driver_data = (void *)&i8k_config_data[DELL_XPS_M140],
 	},
 	{ }
 };
@@ -756,9 +783,17 @@ static int __init i8k_probe(void)
 	}
 
 	i8k_fan_mult = fan_mult;
+	i8k_fan_max = fan_max ? : I8K_FAN_HIGH;	/* Must not be 0 */
 	id = dmi_first_match(i8k_dmi_table);
-	if (id && fan_mult == I8K_FAN_MULT && id->driver_data)
-		i8k_fan_mult = (unsigned long)id->driver_data;
+	if (id && id->driver_data) {
+		const struct i8k_config_data *conf = id->driver_data;
+
+		if (fan_mult == I8K_FAN_MULT && conf->fan_mult)
+			i8k_fan_mult = conf->fan_mult;
+		if (fan_max == I8K_FAN_HIGH && conf->fan_max)
+			i8k_fan_max = conf->fan_max;
+	}
+	i8k_pwm_mult = DIV_ROUND_UP(255, i8k_fan_max);
 
 	return 0;
 }
-- 
1.9.1
