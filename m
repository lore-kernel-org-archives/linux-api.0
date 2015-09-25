From: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
Subject: [PATCH v7 14/15] power: bq24257: Add platform data based initialization
Date: Fri, 25 Sep 2015 10:54:19 -0500
Message-ID: <1443196460-26156-15-git-send-email-dannenberg@ti.com>
References: <1443196460-26156-1-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443196460-26156-1-git-send-email-dannenberg-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The patch adds a way to setup and initialize the device through the use
of platform data with configuration options equivalent to when using
device firmware (DT or ACPI) for systems where this is not available.

Signed-off-by: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
---
 drivers/power/bq24257_charger.c       | 39 +++++++++++++++++++++++++++++++++--
 include/linux/power/bq24257_charger.h | 25 ++++++++++++++++++++++
 2 files changed, 62 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/power/bq24257_charger.h

diff --git a/drivers/power/bq24257_charger.c b/drivers/power/bq24257_charger.c
index 19a0962..3b1a3b6 100644
--- a/drivers/power/bq24257_charger.c
+++ b/drivers/power/bq24257_charger.c
@@ -27,10 +27,13 @@
 #include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/gpio.h>
 
 #include <linux/acpi.h>
 #include <linux/of.h>
 
+#include <linux/power/bq24257_charger.h>
+
 #define BQ24257_REG_1			0x00
 #define BQ24257_REG_2			0x01
 #define BQ24257_REG_3			0x02
@@ -885,6 +888,36 @@ static void bq24257_pg_gpio_probe(struct bq24257_device *bq)
 		dev_dbg(bq->dev, "probed PG pin = %d\n", desc_to_gpio(bq->pg));
 }
 
+static void bq24257_pdata_probe(struct bq24257_device *bq,
+				struct bq24257_platform_data *pdata)
+{
+	bq->init_data.ichg = bq24257_find_idx(pdata->ichg,
+					      bq24257_ichg_map,
+					      BQ24257_ICHG_MAP_SIZE);
+
+	bq->init_data.vbat = bq24257_find_idx(pdata->vbat,
+					      bq24257_vbat_map,
+					      BQ24257_VBAT_MAP_SIZE);
+
+	bq->init_data.iterm = bq24257_find_idx(pdata->iterm,
+					       bq24257_iterm_map,
+					       BQ24257_ITERM_MAP_SIZE);
+
+	bq->init_data.iilimit = bq24257_find_idx(pdata->iilimit,
+						 bq24257_iilimit_map,
+						 BQ24257_IILIMIT_MAP_SIZE);
+
+	bq->init_data.vovp = bq24257_find_idx(pdata->vovp,
+					      bq24257_vovp_map,
+					      BQ24257_VOVP_MAP_SIZE);
+
+	bq->init_data.vindpm = bq24257_find_idx(pdata->vindpm,
+						bq24257_vindpm_map,
+						BQ24257_VINDPM_MAP_SIZE);
+
+	bq->iilimit_autoset_enable = pdata->iilimit_autoset_enable;
+}
+
 static int bq24257_fw_probe(struct bq24257_device *bq)
 {
 	int ret;
@@ -960,6 +993,7 @@ static int bq24257_probe(struct i2c_client *client,
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	struct device *dev = &client->dev;
 	const struct acpi_device_id *acpi_id;
+	struct bq24257_platform_data *pdata = client->dev.platform_data;
 	struct bq24257_device *bq;
 	int ret;
 	int i;
@@ -1009,14 +1043,15 @@ static int bq24257_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, bq);
 
-	if (!dev->platform_data) {
+	if (!pdata) {
 		ret = bq24257_fw_probe(bq);
 		if (ret < 0) {
 			dev_err(dev, "Cannot read device properties.\n");
 			return ret;
 		}
 	} else {
-		return -ENODEV;
+		dev_dbg(dev, "init using platform data\n");
+		bq24257_pdata_probe(bq, pdata);
 	}
 
 	/*
diff --git a/include/linux/power/bq24257_charger.h b/include/linux/power/bq24257_charger.h
new file mode 100644
index 0000000..c131c5d
--- /dev/null
+++ b/include/linux/power/bq24257_charger.h
@@ -0,0 +1,25 @@
+/*
+ * Platform data for the TI bq24257 battery charger driver.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _BQ24257_CHARGER_H_
+#define _BQ24257_CHARGER_H_
+
+#include <asm/types.h>
+#include <linux/types.h>
+
+struct bq24257_platform_data {
+	u32 ichg;				       /* charge current (uA) */
+	u32 vbat;				   /* regulation voltage (uV) */
+	u32 iterm;				  /* termination current (uA) */
+	u32 iilimit;				  /* input current limit (uA) */
+	u32 vovp;		      /* over voltage protection voltage (uV) */
+	u32 vindpm;			 /* VDMP input threshold voltage (uV) */
+	bool iilimit_autoset_enable;	/* auto-detect of input current limit */
+};
+
+#endif /* _BQ24257_CHARGER_H_ */
-- 
1.9.1
