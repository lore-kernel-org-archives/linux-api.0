Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793530038;
	b=bejY0BmhqI7Hu+woeeIhJrsqUk8eLsHRG3e+H2Drki5sFbAMnxC/umVEen+4R9RTg18/
	 qhlEaiAXkMPrMJbe7vdJ/chbn4wePCRju5fdND8DYUzcfeedG/r7znFQ3CbrhSB9azDzi
	 3qprlbKqoEGEonbuNnqa2U2EPfZPcrlUa93V+dlxTCL631CLsXpG2UqCAJ2iv0WYgsDDn
	 c+4IegYUm/7Mz7N+oXkigFs8xYPpa4qHpKJliRmIzA6GDCzxkYOBKU8djWQqJnUuuMTXk
	 hAjSwm89q/te52JjWCHySJ3uZvjMqkULQbqQvfmHZ4buupqQ/nrUFIGDHcveqRXdZEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793530038;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=wqCydl85UFhEEn7IQH/DuLIDXb3/DdiyuBh1Pu5ZGaQ=;
	b=g0xjMCAGB1KwPZ1qzLMY3q4eApFL0vpGpPaMGIYxq31c3vwCbBZq+9Z18CQuFB0ELu/4
	 eU7VM3jkdbrdGUZPbw3gfS7eeJATheTaCI8W9Q4/VtXtdfjR+vBoMtR8bclE/NlcRSDrf
	 WjdBPNQYw1v4h90/dxWH94WGZXqJWdMBRSx9Fvbg51Ukn/O+1uZnCE4vjUqTMmQ9CJQFo
	 Cud31rURTkKwNvmx/+3vz8JOPyr9ZzpFkuZfLsUqgAswIESqzkAVYnjgY6WCFyLYPUCKq
	 ePGOITFNVlneXZ2ar50ryxZ9V3LQC2lyXy3YrJtY1QrGEFgrT8Dc9FJ9te4bO1s3dbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=v85B9AXW;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC83606A338
	for <linux-api@vger.kernel.org>; Sun,  1 Nov 2026 10:47:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FC83606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=v85B9AXW
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a214af2076so15424445e9.0
        for <linux-api@vger.kernel.org>; Sun, 01 Nov 2026 02:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793530036; x=1794134836; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wqCydl85UFhEEn7IQH/DuLIDXb3/DdiyuBh1Pu5ZGaQ=;
        b=v85B9AXW/oSBNu83YCRh+CKObKuOXbOyUrvGdrWnB9OaCC77W+PoOYvCLORsPDQvYr
         aOrxacKUuJJN6h8aP1We0cdanaUDICl3tDAqEBSpr2SY32WzBs5eLSLhPR+uUd8tPKCr
         SKLnhR2ZAprPa6v1md+4btuPIZCr/7T1lnFILXg/P0dp9ek0xo+9/8b69XKYBh049wRa
         0HsP912s2iiN3saZJbQBhqSVuNlCHNgm7A31iD/teeGSuvQbNNCNo2zQOyzfEDiQ9A/Z
         UlnkNO9zCu7G+4DVfod53Ulmdhm0jwj5RszFTfzGhShcO1wc+GZ4OEifLeUAiovIdV8I
         qeDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793530036; x=1794134836;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wqCydl85UFhEEn7IQH/DuLIDXb3/DdiyuBh1Pu5ZGaQ=;
        b=tkelCY1OuqL1xkBwooSySaDwOcndhXalb+NJtmOtRXvvovtqsnAMdluoMUxYHNFToI
         woDLN2WU8OOUMv5wa2Uv7ZH3Z59YE6PS4TLtOkrq4mdu4lQ+z6Pbq/L5ZHW1+VeAOHYp
         hDjuXD6KnzL4ylwUG9U4DAKOqMQnAiRa0jcybIReDRhl+ZGV5CnIEdNBvMKnGEQxzOwo
         5RQ+86/ERIltlzwA91ab1TH6CrcbhmI1HDFjKB1IXTm+VQoZHDoE7ha039iATK1VWhEa
         VVsUeKgTl+ISr3IMRmgoRXVVKb43dST4WPwFFy3JMvFxRaNm9hCCDwFXVpn2vt06Mr3R
         KqOg==
X-Forwarded-Encrypted: i=1; AKwUvBy3ttylwLjTNwuf1IRDrWoAa3lwxk+oNWFdiWYS2v39TUWX+gphUUZtzFk5QRDSWJtUDq4MJ8PzCKE=@vger.kernel.org
X-Gm-Message-State: AFq9FYIMrJvxlSlD2K7/KWaa0bVQ9jVsBq6DLe9qJDLBYPt0UltVptNt
	GMgglZyrxJ/SjvsYvyKkfOiiJcbCkumflrMaolO0c5AJry1wlrPZuHX6
X-Gm-Gg: AYBFou12EPCR+eczh5IPf8yWQA8d+efIHHbsUrEyRWXdIvthA2PiFKn9N3o1Q3tpwTn
	6CFBcKx5mZoJCjCn2uXrqvlkRW3kkLkRX3kQvgkomewdNHUJeyxgauv9aVD+s+o8DAQApDvxyI4
	WPfsxWu6NIRq0505Ha6+xfTIslPQr0uKZy7uCNVQDnxBV+lGjuEu1Evhye8TZGaiEG0jKGqpjYX
	gMgOxtMt8q1pvnOtAq6U3m98mcOqr0aQacOmV5W2z9MCsPDkeCZleMVXLfEE1GvAm2AHSmIiSXx
	YnkQcssCv4VUn1Ip+LSTdwf+sOZVjrQVP9yw+IgDGKSNPaQnfImLRPPGtM6QXtxZvRi1SZNDFHT
	Q7vvkY3WL0Iy8Ai2bQtCpfXVQVV1ZSl/BAA16Rqr14BU88T2xRV0x+GwgDlKz+wX83L7t3STycI
	XHv4Q7h12ZF7Hn5zZC7fepCQVH2MRCFfqYFD2Sh5KWBrh4F2tUxfQnAhgBLHwJLq+MI38M434ng
	OH4qkQ5bX5EPlJQpm9xbxgEd5EYJvNreKqx/OxSQdMdcztgRv2Lie9/30aApFv+UzNON3Oxxoaa
	gDCBPloaMCpfbYt7BQi16oYMALQ=
X-Received: by 2002:a05:600d:a:b0:4ac:aae6:6400 with SMTP id 5b1f17b1804b1-4acaae665a6mr115662105e9.13.1793530036364;
        Sun, 01 Nov 2026 02:47:16 -0800 (PST)
Received: from [127.0.1.1] ([85.105.252.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f322c46sm255602715e9.2.2026.11.01.02.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 02:47:16 -0800 (PST)
From: Bartu Alev <bartualev@gmail.com>
Date: Sun, 01 Nov 2026 13:46:46 +0300
Subject: [PATCH 6/7] platform/x86: asus-wmi: expose the fan floor tables
 via hwmon
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
Message-Id: <20261101-asus-fan-floors-v4-v1-6-b8d1c31a99a9@gmail.com>
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

Firmware enforces minimum duties on fan curves without updating the
reported curve buffers, leaving userspace unable to determine which
duty ranges are unreachable.

Export read-only pwm[1-3]_auto_point[1-8]_floor_pwm attributes on the
hwmon device.  Each file returns the minimum duty (0-255 PWM) enforced
for that curve point.  The attributes are registered for every
supported fan curve and return -ENODATA when firmware provides no
floor table.

Standard hwmon curve attributes (pwmY_auto_pointZ_pwm) assume
writable points and cannot represent a separate, hardware enforced
floor.  Dedicated read-only floor attributes provide these values
while adhering to the one value per file rule.

Document these attributes in
Documentation/ABI/testing/sysfs-platform-asus-wmi.

Signed-off-by: Bartu Alev <bartualev@gmail.com>
---
 Documentation/ABI/testing/sysfs-platform-asus-wmi |  23 ++++
 drivers/platform/x86/asus-wmi.c                   | 141 +++++++++++++++++++++-
 2 files changed, 163 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-platform-asus-wmi b/Documentation/ABI/testing/sysfs-platform-asus-wmi
index 775ea88625c0d..24931cc97ca86 100644
--- a/Documentation/ABI/testing/sysfs-platform-asus-wmi
+++ b/Documentation/ABI/testing/sysfs-platform-asus-wmi
@@ -297,3 +297,26 @@ Contact:	Luke D. Jones <luke@ljones.dev>, Denis Benato <denis.benato@linux.dev>,
 Description:
 		Same as the pwm1 and pwm2 curve points, for the mid fan
 		(pwm3) of laptops whose firmware exposes a third fan curve.
+
+What:		/sys/class/hwmon/hwmonX/pwm[1-3]_auto_point[1-8]_floor_pwm
+Date:		Nov 2026
+KernelVersion:	7.5
+Contact:	Bartu Alev <bartualev@gmail.com>
+Description:
+		Read-only minimum duty, in pwm units (0-255), that the
+		embedded controller enforces for curve point Z of fan Y.
+		The firmware reports the floor as a percentage; the driver
+		converts it with DIV_ROUND_UP(255 * percent, 100), which maps
+		every 0-100 percentage back to itself.
+		Point Z (Z = 1..8) is bound to the temperature decade
+		[30 + 10 * (Z - 1), 39 + 10 * (Z - 1)] degrees Celsius and
+		the value is the floor of that decade.  The controller applies
+		max(curve, floor) for every point on each thermal tick, so
+		the floor is a hardware limit on top of the curve written
+		through pwmY_auto_pointZ_pwm.
+
+		The attribute exists for every fan with a custom fan curve.
+		Reading it returns -ENODATA when the firmware of that fan
+		does not provide a floor table.  A zero value is a real
+		floor: the controller then enforces no minimum duty for that
+		point.
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index dc1e69b964c99..74476904cb99c 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -3868,6 +3868,23 @@ static ssize_t fan_curve_show(struct device *dev,
 	return sysfs_emit(buf, "%d\n", value);
 }
 
+static ssize_t fan_curve_floor_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct sensor_device_attribute_2 *dev_attr = to_sensor_dev_attr_2(attr);
+	struct asus_wmi *asus = dev_get_drvdata(dev);
+	struct fan_curve_data *data = &asus->custom_fan_curves[dev_attr->nr];
+	u8 floor;
+
+	guard(mutex)(&asus->fan_curve_lock);
+	if (!data->floors_valid)
+		return -ENODATA;
+
+	floor = data->floors[dev_attr->index];
+
+	return sysfs_emit(buf, "%u\n", floor);
+}
+
 /*
  * "fan_dev" is the related WMI method such as ASUS_WMI_DEVID_CPU_FAN_CURVE.
  */
@@ -4153,6 +4170,58 @@ static SENSOR_DEVICE_ATTR_2_RW(pwm3_auto_point7_pwm, fan_curve,
 static SENSOR_DEVICE_ATTR_2_RW(pwm3_auto_point8_pwm, fan_curve,
 			       FAN_CURVE_DEV_MID | FAN_CURVE_PWM_MASK, 7);
 
+/* Firmware enforced minimum duty of each point, read-only */
+static SENSOR_DEVICE_ATTR_2_RO(pwm1_auto_point1_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_CPU, 0);
+static SENSOR_DEVICE_ATTR_2_RO(pwm1_auto_point2_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_CPU, 1);
+static SENSOR_DEVICE_ATTR_2_RO(pwm1_auto_point3_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_CPU, 2);
+static SENSOR_DEVICE_ATTR_2_RO(pwm1_auto_point4_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_CPU, 3);
+static SENSOR_DEVICE_ATTR_2_RO(pwm1_auto_point5_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_CPU, 4);
+static SENSOR_DEVICE_ATTR_2_RO(pwm1_auto_point6_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_CPU, 5);
+static SENSOR_DEVICE_ATTR_2_RO(pwm1_auto_point7_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_CPU, 6);
+static SENSOR_DEVICE_ATTR_2_RO(pwm1_auto_point8_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_CPU, 7);
+
+static SENSOR_DEVICE_ATTR_2_RO(pwm2_auto_point1_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_GPU, 0);
+static SENSOR_DEVICE_ATTR_2_RO(pwm2_auto_point2_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_GPU, 1);
+static SENSOR_DEVICE_ATTR_2_RO(pwm2_auto_point3_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_GPU, 2);
+static SENSOR_DEVICE_ATTR_2_RO(pwm2_auto_point4_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_GPU, 3);
+static SENSOR_DEVICE_ATTR_2_RO(pwm2_auto_point5_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_GPU, 4);
+static SENSOR_DEVICE_ATTR_2_RO(pwm2_auto_point6_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_GPU, 5);
+static SENSOR_DEVICE_ATTR_2_RO(pwm2_auto_point7_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_GPU, 6);
+static SENSOR_DEVICE_ATTR_2_RO(pwm2_auto_point8_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_GPU, 7);
+
+static SENSOR_DEVICE_ATTR_2_RO(pwm3_auto_point1_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_MID, 0);
+static SENSOR_DEVICE_ATTR_2_RO(pwm3_auto_point2_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_MID, 1);
+static SENSOR_DEVICE_ATTR_2_RO(pwm3_auto_point3_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_MID, 2);
+static SENSOR_DEVICE_ATTR_2_RO(pwm3_auto_point4_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_MID, 3);
+static SENSOR_DEVICE_ATTR_2_RO(pwm3_auto_point5_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_MID, 4);
+static SENSOR_DEVICE_ATTR_2_RO(pwm3_auto_point6_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_MID, 5);
+static SENSOR_DEVICE_ATTR_2_RO(pwm3_auto_point7_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_MID, 6);
+static SENSOR_DEVICE_ATTR_2_RO(pwm3_auto_point8_floor_pwm, fan_curve_floor,
+			       FAN_CURVE_DEV_MID, 7);
+
 static struct attribute *asus_fan_curve_attr[] = {
 	/* CPU */
 	&sensor_dev_attr_pwm1_enable.dev_attr.attr,
@@ -4211,6 +4280,37 @@ static struct attribute *asus_fan_curve_attr[] = {
 	NULL
 };
 
+static struct attribute *asus_fan_curve_floor_attr[] = {
+	/* CPU */
+	&sensor_dev_attr_pwm1_auto_point1_floor_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm1_auto_point2_floor_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm1_auto_point3_floor_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm1_auto_point4_floor_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm1_auto_point5_floor_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm1_auto_point6_floor_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm1_auto_point7_floor_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm1_auto_point8_floor_pwm.dev_attr.attr,
+	/* GPU */
+	&sensor_dev_attr_pwm2_auto_point1_floor_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm2_auto_point2_floor_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm2_auto_point3_floor_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm2_auto_point4_floor_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm2_auto_point5_floor_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm2_auto_point6_floor_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm2_auto_point7_floor_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm2_auto_point8_floor_pwm.dev_attr.attr,
+	/* MID */
+	&sensor_dev_attr_pwm3_auto_point1_floor_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm3_auto_point2_floor_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm3_auto_point3_floor_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm3_auto_point4_floor_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm3_auto_point5_floor_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm3_auto_point6_floor_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm3_auto_point7_floor_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm3_auto_point8_floor_pwm.dev_attr.attr,
+	NULL
+};
+
 static umode_t asus_fan_curve_is_visible(struct kobject *kobj,
 					 struct attribute *attr, int idx)
 {
@@ -4233,11 +4333,50 @@ static umode_t asus_fan_curve_is_visible(struct kobject *kobj,
 	return 0;
 }
 
+static bool fan_curve_available(struct asus_wmi *asus, int fan_idx)
+{
+	switch (fan_idx) {
+	case FAN_CURVE_DEV_CPU:
+		return asus->cpu_fan_curve_available;
+	case FAN_CURVE_DEV_GPU:
+		return asus->gpu_fan_curve_available;
+	case FAN_CURVE_DEV_MID:
+		return asus->mid_fan_curve_available;
+	default:
+		return false;
+	}
+}
+
+static umode_t asus_fan_curve_floor_is_visible(struct kobject *kobj,
+					       struct attribute *attr, int idx)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct asus_wmi *asus = dev_get_drvdata(dev->parent);
+	struct device_attribute *dattr =
+		container_of(attr, struct device_attribute, attr);
+	int fan = to_sensor_dev_attr_2(dattr)->nr;
+
+	if (!fan_curve_available(asus, fan))
+		return 0;
+
+	return 0444;
+}
+
 static const struct attribute_group asus_fan_curve_attr_group = {
 	.is_visible = asus_fan_curve_is_visible,
 	.attrs = asus_fan_curve_attr,
 };
-__ATTRIBUTE_GROUPS(asus_fan_curve_attr);
+
+static const struct attribute_group asus_fan_curve_floor_attr_group = {
+	.is_visible = asus_fan_curve_floor_is_visible,
+	.attrs = asus_fan_curve_floor_attr,
+};
+
+static const struct attribute_group *asus_fan_curve_attr_groups[] = {
+	&asus_fan_curve_attr_group,
+	&asus_fan_curve_floor_attr_group,
+	NULL,
+};
 
 /*
  * Must be initialised after throttle_thermal_policy_dev is set as

-- 
2.56.0

