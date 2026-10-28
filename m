Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793231572;
	b=KmsjhNxhHTR4gNgCykaqZ8z6PN7ucTF93hpFPz76/RvhNQRG6fg4pmBE6ttNEnk2EZkJ
	 DHzwT9d3y8TYzcSh1FAkghk19+VJh7yNUyT+M2PATeFwgCauXRhghl4eRHxUvdVZekrIc
	 9NHfMZwyqXUVU8p+aDT/UecZt4VNlYLvO48KXyk7ENoisu4cqZXKm3ItJ90SU2VWge4fp
	 6cFATGYknjNSDtS2xSYxJnqeRU7c/OIOS1+5D5dMy2ClnFcsyb8T1lHBYp4lO86lvCdjt
	 aSNnoHg+Wi/inl9z4SA6/4bCQ8v/wImQPAfJSuUTE++XoCdObq5fVfhbnabibJl+dqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793231572;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=Af/thxHkdC33DwjakI5xWjPNHFxWjZZYhh+Bu6x+bIY=;
	b=JSk8x7ci6jXx6lw8W0ZzhNuxgkcQ7+C2gu1PhSk2A8S/YaXcEMjIN6VCroemDPSLIrOV
	 dJ1RZ45/0jpY2PYOgV1hWllxG4bxAOmJ3BMC7L3+IV+aVb0hdRdaNMOmfcxkrPsfUyBqr
	 muOs1qFH5qNSDAXORqa7S11W/eHLuZ1TevFtKiqIQMArj79f1JptdufJKpd9FVFGsfG/U
	 5nohDiOAcMXOxtdSUh8CygILSlpSDHhfVliQ1YUTFIeBmisf4ZnQESv6ol4hGVlBaUGVf
	 86NRM3ZK+QL04L1fgSDpQslPGDiVdXsUFAcp1daT8LXsiCmEejbdQvhkBGk98wrAV7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="tz3/ZhqO";
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF23D606A31D
	for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 23:52:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF23D606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tz3/ZhqO
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso11740475e9.2
        for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 16:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793231570; x=1793836370; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Af/thxHkdC33DwjakI5xWjPNHFxWjZZYhh+Bu6x+bIY=;
        b=tz3/ZhqOSq/4R96dJeMcTZkaw+Vc/rO4vrKCwX8tmlE1VkQHb7ISJg4vu4UgrGrSWN
         HR2qTFgXP+BZMukXElx0qveSAehKEU7QfyZxw8uLICrEr0fuZq7mVt713Wge1mviC6ce
         z5DqakgxpAMIhIfbg3KPHm3m6f5LOFDhxZ+zGeMFV2MzwHVTLdP78tBelA8fGOOe5BQX
         OHJR5u9KCi0KNhngnNRuyo16vpr0DkBLrS2gu6FUYCIYOrcP3dBng9iA/uhkdbU3TQCD
         kWKuxAwDaOtz5UPdKvrfn2139sgAvMVHxUBs3ARODIpcXmF67dRNPDucjak9nxAXhwpZ
         Fclg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793231570; x=1793836370;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Af/thxHkdC33DwjakI5xWjPNHFxWjZZYhh+Bu6x+bIY=;
        b=nxQCzE1mJnPpABZm6Nhh/EhYRtssOVqMstWnTdxc7sKZuD92r8idJPoGCB3o2+FZ9U
         I7ORlLBuKHQOYt1tdFNNxrylGcelxF88piw0sVL/ZwYJmh6RrIapkYot408t8gxOW/lf
         v890BZ4f51JSCEIxhO2FvJuoPxOgUnchfg5jG1TQ9RxDkUPHzSeod5Tcr4GW7nIyJg12
         x3ynrBYfFlOPnz37FF7UbsH68KAbK46yrFsLAATpipHEzcWBFdkSMjW0d0imJP94N1mg
         cuTfLWReKRTEjr+0XNQv1PnrcxRNtgIDxvxtFC7AV1aQf9d2p07HLXOBKuxTJLYpr0ro
         lA7w==
X-Forwarded-Encrypted: i=1; AKwUvByfRhVSoqbu/kxSkXNYbdmlqTUunqILR+uBT0fk4vitcdGGDOLXh9k9XdUPiWlq53nB2tLh6MtrhgA=@vger.kernel.org
X-Gm-Message-State: AFq9FYJEQC/kgSGiX/OE8onBjnOR9PzxruK1fepnomI4lpvBptS12X4F
	8ZWdwRj78tnaxz0jAUqj2Z0NFUgLHrQbxnvMmpIuAHgKqxSRJfL3vU0Y
X-Gm-Gg: AYBFou2iTTMkXmJ0fQsyyVAJYj+yf/h1frNIMcvXzFF6vX2vVx01N8wVfqaBQWY/unT
	1t8NOIiodVaPhQRWb3t5mynMDm6GoUoGdXh1VWPxsPn9ztoq7GJR4cwlzSSg0r/WQHXsoSKe/mi
	OP0tV2DYXA/tyv0DwuPO1mn56bHPvMRptYvkqZfbghIvci/rqp89jOrJmt6Utghd6TFGN57OJdB
	mWFo/tZX3D5HJoV6PrrAdJXinBOTt2jUk9HL/y2t4JeQDIJbx9v21HtFJhqjySNC5JWYjzIQMev
	dITxh9viBfQ+OmjEO/aY/8gZFIX5sqv25azeeHKhEJJq/e//61OJeg1NgcqmpWU17BxEOXXuVSI
	6ncCfeczcSdwIu0oRXQZEeX6BxeMjbz1VIZj0kygjtTUBsLP3+qfzDpC3GJFxUtMPO0ZOBLttRJ
	ZHQ676ht3qoCH6da1SEpQ/cjydm9SuB15ZBpilxVbhrbikyPLIccJ5NwqlfK2eNWA3c1xqYBe3k
	+/AqYfaKY/77V1697I2dFu914kn/O07U6RaGFltRka8+vHPqTjr1QIpiTYEU/Skidkgl0GE0m+z
	lgbk7gfSvictPR0Vxq+y+tCxfuw=
X-Received: by 2002:a05:600c:3115:b0:4a1:f7f4:7cf2 with SMTP id 5b1f17b1804b1-4a966774db9mr87067605e9.17.1793231570159;
        Wed, 28 Oct 2026 16:52:50 -0700 (PDT)
Received: from [127.0.1.1] ([85.105.252.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa80f04785sm23669055e9.4.2026.10.28.16.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 16:52:49 -0700 (PDT)
From: Bartu Alev <bartualev@gmail.com>
Date: Thu, 29 Oct 2026 02:48:51 +0300
Subject: [PATCH v4 1/2] platform/x86: asus-wmi: add TUF keyboard RGB
 readback support
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
Message-Id: <20261029-asus-tuf-rgb-v4-v4-1-0d3b877d2c30@gmail.com>
References: <20261029-asus-tuf-rgb-v4-v4-0-0d3b877d2c30@gmail.com>
In-Reply-To: <20261029-asus-tuf-rgb-v4-v4-0-0d3b877d2c30@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>, 
 "Luke D. Jones" <luke@ljones.dev>, Denis Benato <denis.benato@linux.dev>, 
 Hans de Goede <hansg@kernel.org>, 
 =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-api@vger.kernel.org, Denis Benato <benato.denis96@gmail.com>, 
 Bartu Alev <bartualev@gmail.com>
X-Mailer: b4 0.15.2

The TUF keyboard RGB attributes kbd_rgb_mode and kbd_rgb_state are
write-only, so userspace tools keep their own copy of the lighting
configuration and lose track of it whenever the EC changes state on its
own: after a firmware reset or a boot into another operating system the
tools show a stale configuration until the user rewrites every field.

DSTS device 0x0010005B evaluates the DSDT method EC0.KBLS(), which
snapshots the EC's host-visible keyboard state into a 16-byte buffer:
lighting mode, red, green and blue levels, animation speed, and the
four power-state flags.  The first byte is a constant 1 written by the
AML, which distinguishes a KBLS reply from any other object the method
could return.

Add kbd_rgb_read_status() to evaluate and validate that buffer, parse
it through a packed struct, and convert both attributes to
DEVICE_ATTR_RW.  The read returns the write format with "n/a" in the
command position: the command word belongs to the write verb (apply
now or save to flash) and both verbs update the EC mirror the same
way, so there is no state to report there.  The three EC speed codes
map back to the sysfs indices 0 to 2.

Readback was verified against the EC firmware: the status bytes mirror
EC RAM at 0x0B22 to 0x0B2E, and the speed codes 0xe1, 0xeb and 0xf5
select animation step thresholds of 30, 20 and 10 ticks per phase,
which matches the slow, normal and fast labels.  Tested on a TUF
Gaming A15 (FA507NV).

Suggested-by: Denis Benato <denis.benato@linux.dev>
Signed-off-by: Bartu Alev <bartualev@gmail.com>
---
 drivers/platform/x86/asus-wmi.c            | 83 +++++++++++++++++++++++++++++-
 include/linux/platform_data/x86/asus-wmi.h |  3 ++
 2 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index b33ebdb21aa2..054d1d684bb0 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1062,6 +1062,65 @@ static DEVICE_ATTR_RW(gpu_mux_mode);
 #define TUF_KBD_RGB_SPEED_SLOW		0xe1
 #define TUF_KBD_RGB_SPEED_NORMAL	0xeb
 #define TUF_KBD_RGB_SPEED_FAST		0xf5
+/* TUF keyboard RGB status readback *******************************************/
+struct asus_wmi_kbd_rgb_status {
+	u8 signature;
+	u8 mode;
+	u8 red;
+	u8 green;
+	u8 blue;
+	u8 speed;
+	u8 state;
+	u8 unused[9];
+} __packed;
+
+static int kbd_rgb_read_status(struct asus_wmi_kbd_rgb_status *status)
+{
+	int err;
+
+	err = asus_wmi_evaluate_method_buf(ASUS_WMI_METHODID_DSTS,
+					   ASUS_WMI_DEVID_TUF_RGB_READ_STATUS,
+					   0, (u8 *)status, sizeof(*status));
+	if (err)
+		return err < 0 ? err : -ENODEV;
+
+	/* The AML writes a constant 1 here; anything else is not a KBLS reply */
+	if (status->signature != 1)
+		return -ENODEV;
+
+	return 0;
+}
+
+static ssize_t kbd_rgb_mode_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct asus_wmi_kbd_rgb_status status = {};
+	u32 speed;
+	int err;
+
+	err = kbd_rgb_read_status(&status);
+	if (err)
+		return err;
+
+	switch (status.speed) {
+	case TUF_KBD_RGB_SPEED_SLOW:
+		speed = 0;
+		break;
+	case TUF_KBD_RGB_SPEED_FAST:
+		speed = 2;
+		break;
+	case TUF_KBD_RGB_SPEED_NORMAL:
+	default:
+		speed = 1;
+		break;
+	}
+
+	/* The command word belongs to the write verb, so report n/a. */
+	return sysfs_emit(buf, "n/a %d %d %d %d %d\n",
+			  status.mode, status.red, status.green, status.blue,
+			  speed);
+}
+
 static ssize_t kbd_rgb_mode_store(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
@@ -1114,7 +1173,7 @@ static ssize_t kbd_rgb_mode_store(struct device *dev,
 
 	return count;
 }
-static DEVICE_ATTR_WO(kbd_rgb_mode);
+static DEVICE_ATTR_RW(kbd_rgb_mode);
 
 static DEVICE_STRING_ATTR_RO(kbd_rgb_mode_index, 0444,
 			     "cmd mode red green blue speed");
@@ -1135,6 +1194,26 @@ static const struct attribute_group kbd_rgb_mode_group = {
 #define TUF_KBD_RGB_STATE_AWAKE		BIT(3)
 #define TUF_KBD_RGB_STATE_SLEEP		BIT(5)
 #define TUF_KBD_RGB_STATE_SHUTDOWN	BIT(7)
+static ssize_t kbd_rgb_state_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct asus_wmi_kbd_rgb_status status = {};
+	u8 state;
+	int err;
+
+	err = kbd_rgb_read_status(&status);
+	if (err)
+		return err;
+
+	state = status.state;
+
+	return sysfs_emit(buf, "n/a %d %d %d %d\n",
+			  !!(state & TUF_KBD_RGB_STATE_BOOT),
+			  !!(state & TUF_KBD_RGB_STATE_AWAKE),
+			  !!(state & TUF_KBD_RGB_STATE_SLEEP),
+			  !!(state & TUF_KBD_RGB_STATE_SHUTDOWN));
+}
+
 static ssize_t kbd_rgb_state_store(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
@@ -1166,7 +1245,7 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
 
 	return count;
 }
-static DEVICE_ATTR_WO(kbd_rgb_state);
+static DEVICE_ATTR_RW(kbd_rgb_state);
 
 static DEVICE_STRING_ATTR_RO(kbd_rgb_state_index, 0444,
 			     "cmd boot awake sleep shutdown");
diff --git a/include/linux/platform_data/x86/asus-wmi.h b/include/linux/platform_data/x86/asus-wmi.h
index 66c7ab35d6c8..393fd3c5949a 100644
--- a/include/linux/platform_data/x86/asus-wmi.h
+++ b/include/linux/platform_data/x86/asus-wmi.h
@@ -166,6 +166,9 @@
 /* TUF laptop RGB power/state */
 #define ASUS_WMI_DEVID_TUF_RGB_CMD	0x00100057
 
+/* TUF laptop RGB keyboard status readback */
+#define ASUS_WMI_DEVID_TUF_RGB_READ_STATUS	0x0010005B
+
 /* Bootup sound control */
 #define ASUS_WMI_DEVID_BOOT_SOUND	0x00130022
 

-- 
2.56.0

