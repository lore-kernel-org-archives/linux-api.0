From: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
Subject: [PATCH v8 12/14] power: bq24257: Add various device-specific sysfs properties
Date: Mon, 28 Sep 2015 17:34:00 -0500
Message-ID: <1443479642-23712-13-git-send-email-dannenberg@ti.com>
References: <1443479642-23712-1-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443479642-23712-1-git-send-email-dannenberg-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch adds support for enabling/disabling optional device specific
features through sysfs properties at runtime.

* High-impedance mode enable/disable
* Sysoff enable/disable

Refer to the respective device datasheets for more information:

http://www.ti.com/product/bq24250
http://www.ti.com/product/bq24251
http://www.ti.com/product/bq24257

Signed-off-by: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
---
 drivers/power/bq24257_charger.c | 53 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/power/bq24257_charger.c b/drivers/power/bq24257_charger.c
index db719bf..1fea2c7 100644
--- a/drivers/power/bq24257_charger.c
+++ b/drivers/power/bq24257_charger.c
@@ -791,12 +791,65 @@ static ssize_t bq24257_show_in_dpm_voltage(struct device *dev,
 			 bq24257_vindpm_map[bq->init_data.vindpm]);
 }
 
+static ssize_t bq24257_sysfs_show_enable(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct bq24257_device *bq = power_supply_get_drvdata(psy);
+	int ret;
+
+	if (strcmp(attr->attr.name, "high_impedance_enable") == 0)
+		ret = bq24257_field_read(bq, F_HZ_MODE);
+	else if (strcmp(attr->attr.name, "sysoff_enable") == 0)
+		ret = bq24257_field_read(bq, F_SYSOFF);
+	else
+		return -EINVAL;
+
+	if (ret < 0)
+		return ret;
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", ret);
+}
+
+static ssize_t bq24257_sysfs_set_enable(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf,
+					size_t count)
+{
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct bq24257_device *bq = power_supply_get_drvdata(psy);
+	long val;
+	int ret;
+
+	if (kstrtol(buf, 10, &val) < 0)
+		return -EINVAL;
+
+	if (strcmp(attr->attr.name, "high_impedance_enable") == 0)
+		ret = bq24257_field_write(bq, F_HZ_MODE, (bool)val);
+	else if (strcmp(attr->attr.name, "sysoff_enable") == 0)
+		ret = bq24257_field_write(bq, F_SYSOFF, (bool)val);
+	else
+		return -EINVAL;
+
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
 static DEVICE_ATTR(ovp_voltage, S_IRUGO, bq24257_show_ovp_voltage, NULL);
 static DEVICE_ATTR(in_dpm_voltage, S_IRUGO, bq24257_show_in_dpm_voltage, NULL);
+static DEVICE_ATTR(high_impedance_enable, S_IWUSR | S_IRUGO,
+		   bq24257_sysfs_show_enable, bq24257_sysfs_set_enable);
+static DEVICE_ATTR(sysoff_enable, S_IWUSR | S_IRUGO,
+		   bq24257_sysfs_show_enable, bq24257_sysfs_set_enable);
 
 static struct attribute *bq24257_charger_attr[] = {
 	&dev_attr_ovp_voltage.attr,
 	&dev_attr_in_dpm_voltage.attr,
+	&dev_attr_high_impedance_enable.attr,
+	&dev_attr_sysoff_enable.attr,
 	NULL,
 };
 
-- 
1.9.1
