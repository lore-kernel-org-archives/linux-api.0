Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793530030;
	b=j6GOvqsmfr+Qs/PLR681skjifGvwKY03H7LUWzK9XQ46najC4s6ino6zD3mlFzIIiWSk
	 AcYwqRnRJ+kAkcKhpw084kmn3AkFvjfmcHHRL9YlSKcczBmmX96XRyYi75+1OaEBixapy
	 fIB7ZHGVDj9rm3fdmC2Wr2I6AgwtxEVCahjvGJO+5a+g8SamZtB/AW7aAgef3LVOOnQri
	 OdmqCrqIj8ukhKbpyeK+LqjDTwS/kdkkB3PmdGlSTKgfqZRgEWnpF+ggymZseAH897xmR
	 fdr6eNers7dXKmpP7q2wN1p+QSBcU5bP3hRPeqcmRAKp0tWo6ySt4CrbucjmcLQjd4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793530030;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=i+tGExvsLQMos73zJAXbiW+8Oyn+dJjevDARLNaWL/Q=;
	b=1aoEp+bopTer4MbiZQ0497i5RV9gLe+ZZiHuj0E/3NErM4HlyAkCsclgHRhZJk7dmWyw
	 SxtUIz0xyMa7qWbJKg4XYOpV/8EoPhb4hmbkIivr84GYHqGFeqYRKG72Z2FG+FtaEht9g
	 ZLH0fMD7GuP4JpV2WTW8p7UMFOehMWRHEIqhslPt9GEWduJlSoZDf8V0netsGnjBZyDaV
	 JHao+hj/rRgeYgft6E3th+eRjBP/VqZZqTuxi/8o2CMPC/7IQt2useSB4EoRl0TTZsaow
	 7HyQajEQxsRNbxJWaJOHzizF48/XZ3VWHyB6Fh48ucEUFk0zG2UpXNg1+l1OHTliWww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0pMF00oJ;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110B3606A330
	for <linux-api@vger.kernel.org>; Sun,  1 Nov 2026 10:47:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 110B3606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0pMF00oJ
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a5720b0a57so16219025e9.0
        for <linux-api@vger.kernel.org>; Sun, 01 Nov 2026 02:47:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793530028; x=1794134828; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i+tGExvsLQMos73zJAXbiW+8Oyn+dJjevDARLNaWL/Q=;
        b=0pMF00oJ0TJFm1D78GNc6EB/G/VxzgICoCuLAgZD2LePQYx36FPTqyOonV/DfNBD7n
         uLKxvgvCt0TrClL2+p6qOY+Bx0ECM17gO1aTTxYh25DBecAahl1qi1/TDY8HWEY3rVtv
         hNHPYwtIJmiT/dXg74K2u/oqOUp8VZSsX0QzWYBfvG0sPCi8BUFPNJgypHaI6eQY/z0P
         RKmkapfgdXi7jigtfBZXCpfgA2fExrdRuFkRFX9NkRI00s3iBrls11sU2ZIMLM6obcv4
         XOIpeVR/8vxBBufyZ82qlQAEkNx92AjqNrA4L83NiejVgu+KtuF7WH1Fp1DGwa9hkc5o
         loCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793530028; x=1794134828;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i+tGExvsLQMos73zJAXbiW+8Oyn+dJjevDARLNaWL/Q=;
        b=V/wE/2oLY05tWTUY+v615/0kXeRyZw0kJ1vRS+fqZXyVWpNy9CmlsBLX3B19Tk3Oup
         KIrt37C1Ij4fu4Y/KqcOatCRGBxe78MwcMYkmNuxd3lYvjNNM7ILulTwSBfPeC1TNw3n
         nR52BalOmYAYKpbriNAKn5dlehA75+B8netkaR/NLG4r+ciASfg73XA2ti4wqpqfnGXB
         87+avf53yhNWiESCgL8CK0HTHyROSv1rdOi5bb6H6AKpR2D2blbmZRG8aHE60Js67DRc
         R6WhZRTCV4hw8rak/00y/VlxY8rgJBEB1bccQdrK2FxitvP3A3V2B8WpoeZRGc8zzzNT
         DF8g==
X-Forwarded-Encrypted: i=1; AKwUvBwBD1NmjKWYAi/dxud5gcpYSOd9Zw9ZsCytwaS0xo8RBLR5w5HYEC3ReO1Ezl/6dY/FO6nNge4aZs0=@vger.kernel.org
X-Gm-Message-State: AFq9FYLxkASGEHggYgqZCXUVLCZFh2JLs+DIfRBtLyYwIA/deAc4B4DH
	UD7iBUjEc7RRAOiGOzEX5KzOZ32mSLl4BIjZlxshMHW2bLaRIWdCpNLQ
X-Gm-Gg: AYBFou2mhOzVzVVS3r9rdV0EQGr+klxq/jvQSBrMFQAqRSTulZ/8g0crbQOAtzXY1fF
	U3tXyAL3ffQYiZkMtRKMhn6phg0slqrgZURkTWxMvv0c7o1aKq9ZnfqspnhgfT0FcIDeaBSpZkH
	aV6xEMgJeFUE/MWMaRDhYEpdvsGDA6UAxg7gb86QEWWOmwVmH9YxFRF8NYey1vEuzkEDDoXNYBB
	6wstiW5LnP3ANUhHZEQq8w2UK4VMti+1Gbsiyj0Q9RSPmPRlZItEbmLFXzTEovvdU5fEpDkgmgQ
	xdcgx5TU4PXgxmnO2uwRsNuttOECbda6gI/if5A0P5VPJJaBDaovslFr8s7uAy2ec7yTO2L6+Bb
	cyFcHm9AveM414BeHmIEEuNCiJW+PUGZGJgAnS1ZhFXSMVkcAGHWI16ooYvlHA6jvtRceIU+M7O
	cXgbNyVwyDFpcVWubWvGQbLJwbHKK/e9PBksJ1AcuDzjEYsPVnKJq8auXY+2q14ghAY371Xqb4o
	YVodd3mukrGQusVh90AT9aZehXDL3YzkJBU0j0TEwJH74FVDbOC1z2P1uiNqWr9DrbfvjD9lbQv
	3ZlRIM8mSsPkbFki25hkv44orqE=
X-Received: by 2002:a05:600c:37c8:b0:4a2:18c4:61a5 with SMTP id 5b1f17b1804b1-4ac16acd93cmr169842665e9.6.1793530028408;
        Sun, 01 Nov 2026 02:47:08 -0800 (PST)
Received: from [127.0.1.1] ([85.105.252.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f322c46sm255602715e9.2.2026.11.01.02.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 02:47:08 -0800 (PST)
From: Bartu Alev <bartualev@gmail.com>
Date: Sun, 01 Nov 2026 13:46:44 +0300
Subject: [PATCH 4/7] platform/x86: asus-wmi: read the firmware fan floor
 tables
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261101-asus-fan-floors-v4-v1-4-b8d1c31a99a9@gmail.com>
References: <20261101-asus-fan-floors-v4-v1-0-b8d1c31a99a9@gmail.com>
In-Reply-To: <20261101-asus-fan-floors-v4-v1-0-b8d1c31a99a9@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>, 
 "Luke D. Jones" <luke@ljones.dev>, Denis Benato <denis.benato@linux.dev>, 
 Hans de Goede <hansg@kernel.org>, 
 =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-hwmon@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>, 
 linux-api@vger.kernel.org, Bartu Alev <bartualev@gmail.com>
X-Mailer: b4 0.15.2

On some ASUS laptops, the embedded controller enforces minimum fan
duties on top of custom fan curves written via CPU_FAN_CURVE
(0x00110024), GPU_FAN_CURVE (0x00110025), and the mid fan curve
methods. The floors are exposed via read-only DSTS methods 0x00110026,
0x00110027, and 0x00110033.

The floor table is indexed by curve point: entry i (0-based, sysfs
point i + 1) provides the minimum duty for that point. The EC maps
each point to a temperature decade [30 + 10 * i, 39 + 10 * i] degrees
Celsius, stepping between points with 5 degrees Celsius of hysteresis
without interpolation on TUF series.

EC firmware dumps from an FA507 show floor tables of {0, 0, 0, 0, 25,
48, 58, 74}% for the CPU fan and {0, 0, 0, 0, 26, 57, 68, 91}% for the
GPU fan, verified via live DSTS reads on an FA507NV.

Read the tables at probe and refresh them after power profile changes
or curve resets, as the EC can reload defaults when operating modes
change.  Profile switches did not alter table bytes on the FA507, so
this refresh is precautionary.

Export the floors without altering user curves, rejecting replies
shorter than eight bytes or containing values exceeding 100%.  If a
table contains decreasing values along its points, warn once but still
export it so userspace can inspect what firmware enforces.  When
firmware returns 0xFFFFFFFE, mark the table unsupported for that fan
to avoid repeating failed WMI calls on future refreshes; unreadable
tables remain zeroed.

Protect the cached floor tables with a mutex against concurrent sysfs
reads.

Also fix the stale comment claiming that firmware interpolates between
curve points.

Signed-off-by: Bartu Alev <bartualev@gmail.com>
---
 drivers/platform/x86/asus-wmi.c | 170 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 165 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index c55f469cb03dc..b6541183d4568 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -239,6 +239,10 @@ struct fan_curve_data {
 	u32 device_id;
 	u8 temps[FAN_CURVE_POINTS];
 	u8 percents[FAN_CURVE_POINTS];
+	/* EC minimum duty per point, pwm 0-255, not percent */
+	u8 floors[FAN_CURVE_POINTS];
+	bool floors_valid;
+	bool floors_unsupported;
 };
 
 struct asus_wmi {
@@ -320,6 +324,9 @@ struct asus_wmi {
 	bool gpu_fan_curve_available;
 	bool mid_fan_curve_available;
 	struct fan_curve_data custom_fan_curves[3];
+	/* protects custom_fan_curves[].floors */
+	struct mutex fan_curve_lock;
+	struct device *fan_curve_hwmon;
 
 	struct device *ppdev;
 
@@ -466,7 +473,8 @@ static int asus_wmi_evaluate_method5(u32 method_id,
  * means that the method called is unsupported.
  */
 static int asus_wmi_evaluate_method_buf(u32 method_id,
-		u32 arg0, u32 arg1, u8 *ret_buffer, size_t size)
+		u32 arg0, u32 arg1, u8 *ret_buffer, size_t size,
+		size_t *ret_len)
 {
 	struct bios_args args = {
 		.arg0 = arg0,
@@ -479,6 +487,9 @@ static int asus_wmi_evaluate_method_buf(u32 method_id,
 	union acpi_object *obj;
 	int err = 0;
 
+	if (ret_len)
+		*ret_len = 0;
+
 	status = asus_wmi_evaluate_method_locked(method_id, &input, &output);
 
 	pr_debug("%s called (0x%08x) with args: 0x%08x, 0x%08x\n",
@@ -503,6 +514,8 @@ static int asus_wmi_evaluate_method_buf(u32 method_id,
 		}
 
 		memcpy(ret_buffer, obj->buffer.pointer, obj->buffer.length);
+		if (ret_len)
+			*ret_len = obj->buffer.length;
 		break;
 	case ACPI_TYPE_INTEGER:
 		err = (u32)obj->integer.value;
@@ -3631,7 +3644,7 @@ static int fan_curve_get_factory_default(struct asus_wmi *asus, u32 fan_dev)
 		mode = 2;
 
 	err = asus_wmi_evaluate_method_buf(asus->dsts_id, fan_dev, mode, buf,
-					   FAN_CURVE_BUF_LEN);
+					   FAN_CURVE_BUF_LEN, NULL);
 	if (err) {
 		pr_warn("%s (0x%08x) failed: %d\n", __func__, fan_dev, err);
 		return err;
@@ -3651,7 +3664,136 @@ static int fan_curve_get_factory_default(struct asus_wmi *asus, u32 fan_dev)
 	return 0;
 }
 
-/* Check if capability exists, and populate defaults */
+/*
+ * Read the firmware fan floor table. The EC enforces a minimum duty per
+ * curve point on top of the custom curve. Reading is best effort: at
+ * probe time a failed read leaves the table zeroed and invalid, and a
+ * failed refresh keeps the last table that was read.
+ */
+static int fan_curve_load_floors(struct asus_wmi *asus, u32 fan_dev)
+{
+	struct fan_curve_data *curves;
+	u8 buf[FAN_CURVE_BUF_LEN] = {};
+	size_t len;
+	int err, fan_idx, i;
+
+	switch (fan_dev) {
+	case ASUS_WMI_DEVID_CPU_FAN_CURVE:
+		fan_idx = FAN_CURVE_DEV_CPU;
+		fan_dev = ASUS_WMI_DEVID_CPU_FAN_FLOOR;
+		break;
+	case ASUS_WMI_DEVID_GPU_FAN_CURVE:
+		fan_idx = FAN_CURVE_DEV_GPU;
+		fan_dev = ASUS_WMI_DEVID_GPU_FAN_FLOOR;
+		break;
+	case ASUS_WMI_DEVID_MID_FAN_CURVE:
+		fan_idx = FAN_CURVE_DEV_MID;
+		fan_dev = ASUS_WMI_DEVID_MID_FAN_FLOOR;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	curves = &asus->custom_fan_curves[fan_idx];
+	if (curves->floors_unsupported)
+		return -ENODEV;
+
+	err = asus_wmi_evaluate_method_buf(asus->dsts_id, fan_dev, 0, buf,
+					   FAN_CURVE_BUF_LEN, &len);
+	if (err) {
+		pr_debug("%s (0x%08x) failed: %d\n", __func__, fan_dev, err);
+		/* 0xFFFFFFFE means the firmware has no such method */
+		if (err == -ENODEV)
+			curves->floors_unsupported = true;
+		return err;
+	}
+
+	if (len < FAN_CURVE_POINTS) {
+		pr_debug("%s (0x%08x): short reply of %zu bytes\n",
+			 __func__, fan_dev, len);
+		return -ENODATA;
+	}
+
+	/* A percentage above 100 would overflow the pwm scale below */
+	for (i = 0; i < FAN_CURVE_POINTS; i++) {
+		if (buf[i] > 100) {
+			pr_debug("%s (0x%08x): implausible floor table\n",
+				 __func__, fan_dev);
+			return -EINVAL;
+		}
+	}
+
+	/*
+	 * The floors observed so far do not decrease along the points, but
+	 * that is only proven on the FA507.  Do not reject a table that
+	 * does: the values are still usable as per-point minimums, and
+	 * hiding them would leave userspace no way to see what the
+	 * firmware enforces.
+	 */
+	for (i = 1; i < FAN_CURVE_POINTS; i++) {
+		if (buf[i] < buf[i - 1]) {
+			dev_warn_once(&asus->platform_device->dev,
+				      "fan curve (0x%08x): floor table decreases at point %d\n",
+				      fan_dev, i + 1);
+			break;
+		}
+	}
+
+	guard(mutex)(&asus->fan_curve_lock);
+	for (i = 0; i < FAN_CURVE_POINTS; i++)
+		curves->floors[i] = DIV_ROUND_UP(255 * buf[i], 100);
+	curves->floors_valid = true;
+
+	return 0;
+}
+
+static void fan_curve_notify_floors(struct asus_wmi *asus)
+{
+	struct device *hwmon = asus->fan_curve_hwmon;
+	bool valid[ARRAY_SIZE(asus->custom_fan_curves)];
+	char name[32];
+	int fan, point;
+
+	if (!hwmon)
+		return;
+
+	scoped_guard(mutex, &asus->fan_curve_lock) {
+		for (fan = 0; fan < ARRAY_SIZE(valid); fan++)
+			valid[fan] = asus->custom_fan_curves[fan].floors_valid;
+	}
+
+	for (fan = 0; fan < ARRAY_SIZE(valid); fan++) {
+		if (!valid[fan])
+			continue;
+
+		for (point = 0; point < FAN_CURVE_POINTS; point++) {
+			snprintf(name, sizeof(name),
+				 "pwm%d_auto_point%d_floor_pwm",
+				 fan + 1, point + 1);
+			sysfs_notify(&hwmon->kobj, NULL, name);
+		}
+	}
+}
+
+/*
+ * The EC re-runs its defaults reload when the mode byte it keys on
+ * changes, which a thermal profile switch can do.  Re-read the tables
+ * so that the exported values follow the firmware; on the FA507 the
+ * tables are profile independent, so this is defensive.
+ */
+static void fan_curve_refresh_floors(struct asus_wmi *asus)
+{
+	if (asus->cpu_fan_curve_available)
+		fan_curve_load_floors(asus, ASUS_WMI_DEVID_CPU_FAN_CURVE);
+	if (asus->gpu_fan_curve_available)
+		fan_curve_load_floors(asus, ASUS_WMI_DEVID_GPU_FAN_CURVE);
+	if (asus->mid_fan_curve_available)
+		fan_curve_load_floors(asus, ASUS_WMI_DEVID_MID_FAN_CURVE);
+
+	fan_curve_notify_floors(asus);
+}
+
+/* Check if the capability exists, populate its defaults and read its floor table */
 static int fan_curve_check_present(struct asus_wmi *asus, bool *available,
 				   u32 fan_dev)
 {
@@ -3668,6 +3810,16 @@ static int fan_curve_check_present(struct asus_wmi *asus, bool *available,
 	}
 
 	*available = true;
+
+	err = fan_curve_load_floors(asus, fan_dev);
+	if (err == -ENODEV)
+		dev_dbg(&asus->platform_device->dev,
+			"fan curve (0x%08x): no floor table\n", fan_dev);
+	else if (err)
+		dev_warn(&asus->platform_device->dev,
+			 "fan curve (0x%08x): unusable floor table (%d)\n",
+			 fan_dev, err);
+
 	return 0;
 }
 
@@ -3738,8 +3890,9 @@ static int fan_curve_write(struct asus_wmi *asus,
 }
 
 /*
- * A fan curve is a set of points the firmware interpolates between, so it
- * only makes sense if neither temperature nor PWM ever decreases along it.
+ * A fan curve is a set of points the firmware steps through, without
+ * interpolating between them, so it only makes sense if neither temperature
+ * nor PWM ever decreases along it.
  */
 static int fan_curve_validate(struct device *dev, struct fan_curve_data *data)
 {
@@ -3870,6 +4023,7 @@ static ssize_t fan_curve_enable_store(struct device *dev,
 			err = asus_fan_set_auto(asus);
 			if (err)
 				return err;
+			fan_curve_refresh_floors(asus);
 		} else {
 			/* Safeguard against fautly ACPI tables */
 			err = fan_curve_get_factory_default(asus, data->device_id);
@@ -3878,6 +4032,7 @@ static ssize_t fan_curve_enable_store(struct device *dev,
 			err = fan_curve_write(asus, data);
 			if (err)
 				return err;
+			fan_curve_refresh_floors(asus);
 		}
 	}
 	return count;
@@ -4125,6 +4280,8 @@ static int asus_wmi_custom_fan_curve_init(struct asus_wmi *asus)
 		return PTR_ERR(hwmon);
 	}
 
+	asus->fan_curve_hwmon = hwmon;
+
 	return 0;
 }
 
@@ -4195,6 +4352,8 @@ static int throttle_thermal_policy_write(struct asus_wmi *asus)
 	if (asus->mid_fan_curve_available)
 		asus->custom_fan_curves[FAN_CURVE_DEV_MID].enabled = false;
 
+	fan_curve_refresh_floors(asus);
+
 	return 0;
 }
 
@@ -5202,6 +5361,7 @@ static int asus_wmi_add(struct platform_device *pdev)
 	asus->platform_device = pdev;
 	wdrv->platform_device = pdev;
 	platform_set_drvdata(asus->platform_device, asus);
+	mutex_init(&asus->fan_curve_lock);
 
 	if (wdrv->detect_quirks)
 		wdrv->detect_quirks(asus->driver);

-- 
2.56.0

