From: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
Subject: [PATCH v6 10/14] power: bq24257: Add input DPM voltage threshold setting support
Date: Thu, 24 Sep 2015 22:26:54 -0500
Message-ID: <1443151618-29742-11-git-send-email-dannenberg@ti.com>
References: <1443151618-29742-1-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443151618-29742-1-git-send-email-dannenberg-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

A new optional device property called "ti,in-dpm-voltage" is introduced
to allow configuring the input voltage threshold for the devices'
dynamic power path management (DPM) feature. In short, it can be used to
prevent the input voltage from dropping below a certain value as current
is drawn to charge the battery or supply the system.

Signed-off-by: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
---
 drivers/power/bq24257_charger.c | 43 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/power/bq24257_charger.c b/drivers/power/bq24257_charger.c
index b5acbc5..146ef8b 100644
--- a/drivers/power/bq24257_charger.c
+++ b/drivers/power/bq24257_charger.c
@@ -79,6 +79,7 @@ struct bq24257_init_data {
 	u8 iterm;	/* termination current */
 	u8 iilimit;	/* input current limit */
 	u8 vovp;	/* over voltage protection voltage */
+	u8 vindpm;	/* VDMP input threshold voltage */
 };
 
 struct bq24257_state {
@@ -208,6 +209,13 @@ static const u32 bq24257_vovp_map[] = {
 
 #define BQ24257_VOVP_MAP_SIZE		ARRAY_SIZE(bq24257_vovp_map)
 
+static const u32 bq24257_vindpm_map[] = {
+	4200000, 4280000, 4360000, 4440000, 4520000, 4600000, 4680000,
+	4760000
+};
+
+#define BQ24257_VINDPM_MAP_SIZE		ARRAY_SIZE(bq24257_vindpm_map)
+
 static int bq24257_field_read(struct bq24257_device *bq,
 			      enum bq24257_fields field_id)
 {
@@ -434,6 +442,17 @@ enum bq24257_vovp {
 	VOVP_10500
 };
 
+enum bq24257_vindpm {
+	VINDPM_4200,
+	VINDPM_4280,
+	VINDPM_4360,
+	VINDPM_4440,
+	VINDPM_4520,
+	VINDPM_4600,
+	VINDPM_4680,
+	VINDPM_4760
+};
+
 enum bq24257_port_type {
 	PORT_TYPE_DCP,		/* Dedicated Charging Port */
 	PORT_TYPE_CDP,		/* Charging Downstream Port */
@@ -604,6 +623,7 @@ static int bq24257_hw_init(struct bq24257_device *bq)
 		{F_VBAT, bq->init_data.vbat},
 		{F_ITERM, bq->init_data.iterm},
 		{F_VOVP, bq->init_data.vovp},
+		{F_VINDPM, bq->init_data.vindpm},
 	};
 
 	/*
@@ -684,10 +704,23 @@ static ssize_t bq24257_show_ovp_voltage(struct device *dev,
 			 bq24257_vovp_map[bq->init_data.vovp]);
 }
 
+static ssize_t bq24257_show_in_dpm_voltage(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct bq24257_device *bq = power_supply_get_drvdata(psy);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n",
+			 bq24257_vindpm_map[bq->init_data.vindpm]);
+}
+
 static DEVICE_ATTR(ovp_voltage, S_IRUGO, bq24257_show_ovp_voltage, NULL);
+static DEVICE_ATTR(in_dpm_voltage, S_IRUGO, bq24257_show_in_dpm_voltage, NULL);
 
 static struct attribute *bq24257_charger_attr[] = {
 	&dev_attr_ovp_voltage.attr,
+	&dev_attr_in_dpm_voltage.attr,
 	NULL,
 };
 
@@ -782,6 +815,16 @@ static int bq24257_fw_probe(struct bq24257_device *bq)
 						      bq24257_vovp_map,
 						      BQ24257_VOVP_MAP_SIZE);
 
+	ret = device_property_read_u32(bq->dev, "ti,in-dpm-voltage",
+				       &property);
+	if (ret < 0)
+		bq->init_data.vindpm = VINDPM_4360;
+	else
+		bq->init_data.vindpm =
+				bq24257_find_idx(property,
+						 bq24257_vindpm_map,
+						 BQ24257_VINDPM_MAP_SIZE);
+
 	return 0;
 }
 
-- 
1.9.1
