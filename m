From: Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 2/5] i8k: Drop all labels
Date: Sat, 21 Jun 2014 08:08:09 -0700
Message-ID: <1403363304-22358-2-git-send-email-linux@roeck-us.net>
References: <1403363304-22358-1-git-send-email-linux@roeck-us.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1403363304-22358-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Guenter Roeck <linux@roeck-us.net>
List-Id: linux-api@vger.kernel.org

Labels are known to be wrong for several Dell laptops.
For example, a single fan may be shown as right fan when in reality
it sits on the left side of the chassis. Drop all labels to avoid
such inaccuracies. Users can select labels in the sensors configuration
file instead if desired.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/char/i8k.c | 47 +++++++++++++----------------------------------
 1 file changed, 13 insertions(+), 34 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 93dcad0..14ca8f0 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -544,20 +544,6 @@ static ssize_t i8k_hwmon_set_pwm(struct device *dev,
 	return err < 0 ? -EIO : count;
 }
 
-static ssize_t i8k_hwmon_show_label(struct device *dev,
-				    struct device_attribute *devattr,
-				    char *buf)
-{
-	static const char *labels[3] = {
-		"CPU",
-		"Left Fan",
-		"Right Fan",
-	};
-	int index = to_sensor_dev_attr(devattr)->index;
-
-	return sprintf(buf, "%s\n", labels[index]);
-}
-
 static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, i8k_hwmon_show_temp, NULL, 0);
 static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO, i8k_hwmon_show_temp, NULL, 1);
 static SENSOR_DEVICE_ATTR(temp3_input, S_IRUGO, i8k_hwmon_show_temp, NULL, 2);
@@ -570,41 +556,34 @@ static SENSOR_DEVICE_ATTR(fan2_input, S_IRUGO, i8k_hwmon_show_fan, NULL,
 			  I8K_FAN_RIGHT);
 static SENSOR_DEVICE_ATTR(pwm2, S_IRUGO | S_IWUSR, i8k_hwmon_show_pwm,
 			  i8k_hwmon_set_pwm, I8K_FAN_RIGHT);
-static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, i8k_hwmon_show_label, NULL, 0);
-static SENSOR_DEVICE_ATTR(fan1_label, S_IRUGO, i8k_hwmon_show_label, NULL, 1);
-static SENSOR_DEVICE_ATTR(fan2_label, S_IRUGO, i8k_hwmon_show_label, NULL, 2);
 
 static struct attribute *i8k_attrs[] = {
 	&sensor_dev_attr_temp1_input.dev_attr.attr,	/* 0 */
-	&sensor_dev_attr_temp1_label.dev_attr.attr,	/* 1 */
-	&sensor_dev_attr_temp2_input.dev_attr.attr,	/* 2 */
-	&sensor_dev_attr_temp3_input.dev_attr.attr,	/* 3 */
-	&sensor_dev_attr_temp4_input.dev_attr.attr,	/* 4 */
-	&sensor_dev_attr_fan1_input.dev_attr.attr,	/* 5 */
-	&sensor_dev_attr_pwm1.dev_attr.attr,		/* 6 */
-	&sensor_dev_attr_fan1_label.dev_attr.attr,	/* 7 */
-	&sensor_dev_attr_fan2_input.dev_attr.attr,	/* 8 */
-	&sensor_dev_attr_pwm2.dev_attr.attr,		/* 9 */
-	&sensor_dev_attr_fan2_label.dev_attr.attr,	/* 10 */
+	&sensor_dev_attr_temp2_input.dev_attr.attr,	/* 1 */
+	&sensor_dev_attr_temp3_input.dev_attr.attr,	/* 2 */
+	&sensor_dev_attr_temp4_input.dev_attr.attr,	/* 3 */
+	&sensor_dev_attr_fan1_input.dev_attr.attr,	/* 4 */
+	&sensor_dev_attr_pwm1.dev_attr.attr,		/* 5 */
+	&sensor_dev_attr_fan2_input.dev_attr.attr,	/* 6 */
+	&sensor_dev_attr_pwm2.dev_attr.attr,		/* 7 */
 	NULL
 };
 
 static umode_t i8k_is_visible(struct kobject *kobj, struct attribute *attr,
 			      int index)
 {
-	if ((index == 0 || index == 1) &&
-	    !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP1))
+	if (index == 0 && !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP1))
 		return 0;
-	if (index == 2 && !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP2))
+	if (index == 1 && !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP2))
 		return 0;
-	if (index == 3 && !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP3))
+	if (index == 2 && !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP3))
 		return 0;
-	if (index == 4 && !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP4))
+	if (index == 3 && !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP4))
 		return 0;
-	if (index >= 5 && index <= 7 &&
+	if (index >= 4 && index <= 5 &&
 	    !(i8k_hwmon_flags & I8K_HWMON_HAVE_FAN1))
 		return 0;
-	if (index >= 8 && index <= 10 &&
+	if (index >= 6 && index <= 7 &&
 	    !(i8k_hwmon_flags & I8K_HWMON_HAVE_FAN2))
 		return 0;
 
-- 
1.9.1
