Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358883F3262
	for <linux-api@vger.kernel.org>; Sat, 10 Oct 2026 10:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791627419; cv=none; b=Cr9zxOngYcZ9PTHIfIML5EL8um/TUrF7brD7zh6C2OFTvYtNndvfukgzLo8DtQlFzPfRnOXPZFhYJ2h6ZPecvw3nd6yZnSZ4WgBH0o/5p3cjN6+K+jVIGxzjy8jeg1hCaorjX2cip4ZO+V/F8iKwPESmbkf6NvtTY7/Z2y9AizQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791627419; c=relaxed/simple;
	bh=53zzevfhLRfzp4Pi+BoUZp7QMN9Kqtv9gHxdKvhhKmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FF3jXFS8VKSkpPMpv6+yLBPqIXOOtheEFnVGoLtyIQIzcdcQdiWk8AlWOJh43FYBnqsqF5uhtJP2WWegeAnKyJmkBjv30+r5LumC48NeV+n23jo6e21KQiNH0bSEb0eobXurhauUTwjd3fi4TF3QyrIWXBYXYkn0FXdkuxKbS7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IiyH0bkp; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IiyH0bkp"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48c5358fc28so381616f8f.0
        for <linux-api@vger.kernel.org>; Sat, 10 Oct 2026 03:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791627414; x=1792232214; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Vv7xplMcNA/1o71Kg6dyTzLFviywObxA6/BxiVUK+X4=;
        b=IiyH0bkpIt+lgACHYDOAxRKrlJvt3T7aw272CCsbEIT/U5A9OtAeZTLz79tXZU0iqY
         0LzQGL0FxHqpWHvVIUUYWBz6oCF0YGHgdc7/essNyhmxoWbdjv5xB94mBdzhit7Ew3R1
         9Wu0aaHg75X8cR5FhWfdY4RocIOjBaw9grk1nuXlbjTN5/9Fl9RXIY4AmFaz84tKo/gQ
         wcw6yf3o3DtW3W4Ip4l+H7YrBEmehMWhdl0A0SOf7RQpJoELqdYa5jkbaV1xuvS/xWdY
         wOXsi9toohVwS8DsoD3UlWQUJBJsZS4ARaPZb3tZMr8bHJLkYP4R1IFGRNzvlrKqQEcF
         VSKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791627414; x=1792232214;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vv7xplMcNA/1o71Kg6dyTzLFviywObxA6/BxiVUK+X4=;
        b=eYWDl6qSm/YAt3aPfSvNLl55zhhrMCuXhstrhBgR5nss/VPkuxnqOQ8cCC85Fwd1UK
         pbndoWD5B90hSnADCXplelnVu0HjVktrq+k2gR20AHhenMaIRs1W0LFahdHj0Ev642VS
         b0wPLYDyj2Cq+tODMRwLHqAmbsOLsR7IyHEIjqVfRezAR1Z1bWUtX29lcN1m9eyJD7x7
         QSVQNDD9kbBUlNkUqT/TtwGKfURBzhNDug403JwAuMVDPqpBAT1WnH16nIMLziqbp0hw
         y7x/EKtdbYh8FTKrhcfFGe9ApYcplQV51QTVa08u9234gjcB2EnCm8iM54dRQTz/yNhw
         W3IA==
X-Forwarded-Encrypted: i=1; AKwUvBy4N3AWYG96vtXOVIm9BzJTxXkRQWrT5tEYnYEGdQh2YEd5WOT+bq53Pi77UBYVDCQgTSzV1xl3uVw=@vger.kernel.org
X-Gm-Message-State: AFq9FYIv049VBRaDcRDIAEVrwgoFf4T338e7H7lFmj/gx+0lvjofc7VU
	9CZe6NWHu4JjBrmhCMgl3Iqv6lwrDen+/8odO363oBrEN2rgI5eEKKX4
X-Gm-Gg: AYBFou0UosJPEbYdwVEPhlRj6DKODE6erJCVHtWics5N22h6Qa+DEMWQtGZRRNJyOz4
	F/EkYN3dStlfK2obWi9AeLskSpQxfaCIZS1MicRJj+iLZuTgzMmrbPq+0T87KCDyqRvBK+05p/t
	zZp4niV9p7RnpWdKFAqIvJAXWUXuClWHR/zmATRdlCAi1ilAm4w+YcUZRdBXQt2/H1vPEykiXkk
	PWufxA++J/0gh2cqmPi/Q+WFFsZFYpeV6azfs/BlQDkth9Xh9qZVnC/2GwOXwc79atxqItUY/mv
	Pd93I00skozBZmfAqH5v886wZWGvla5p3ufWT8z7anXkHz9lHog6apuN6iY4tyXiuqUlXoz9hm9
	sYIngfCiyx1qSvYYcIRygJexchvS9q2JO3oJmw8A+0WGdJXHl5CR3IKoiAu/nE6KuQhu6JqIrqE
	uVeBcEv37wpyNZgBJ7ihI9IyfSkUwGjv+pkH0o6MoJFRy8Ee+bQ5Nsd4eylww=
X-Received: by 2002:a05:6000:29c3:b0:48b:948:c720 with SMTP id ffacd0b85a97d-48dbaadc125mr5307079f8f.11.1791627414059;
        Sat, 10 Oct 2026 03:16:54 -0700 (PDT)
Received: from ASUS ([85.105.252.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db98c38f4sm9417856f8f.27.2026.10.10.03.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 03:16:53 -0700 (PDT)
From: Bartu Alev <bartualev@gmail.com>
To: platform-driver-x86@vger.kernel.org
Cc: ilpo.jarvinen@linux.intel.com,
	hansg@kernel.org,
	luke@ljones.dev,
	denis.benato@linux.dev,
	benato.denis96@gmail.com,
	corentin.chary@gmail.com,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bartu Alev <bartualev@gmail.com>
Subject: [PATCH v3 3/5] platform/x86: asus-wmi: name the TUF keyboard RGB state and speed codes
Date: Sat, 10 Oct 2026 13:15:59 +0300
Message-ID: <20261010101601.888709-4-bartualev@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261010101601.888709-1-bartualev@gmail.com>
References: <20261010101601.888709-1-bartualev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The TUF keyboard RGB attributes encode four power-state flags and three
animation speeds as bare BIT() and hex literals inside their store
handlers.  The speed codes in particular read as arbitrary hex until
one knows they are EC firmware conventions: 0xe1, 0xeb and 0xf5 select
animation step thresholds of 30, 20 and 10 ticks per phase, which the
EC derives from the stored byte through a lookup table.

Give the seven values names and use them in kbd_rgb_mode_store() and
kbd_rgb_state_store(), so the handlers state what they mean without a
decoding comment.  No behavior change.

Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bartu Alev <bartualev@gmail.com>
---
 drivers/platform/x86/asus-wmi.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 5cc71bfac841..c5c0fe92cea0 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1047,6 +1047,10 @@ static DEVICE_ATTR_RW(gpu_mux_mode);
 #endif /* IS_ENABLED(CONFIG_ASUS_WMI_DEPRECATED_ATTRS) */
 
 /* TUF Laptop Keyboard RGB Modes **********************************************/
+
+#define TUF_KBD_RGB_SPEED_SLOW		0xe1
+#define TUF_KBD_RGB_SPEED_NORMAL	0xeb
+#define TUF_KBD_RGB_SPEED_FAST		0xf5
 static ssize_t kbd_rgb_mode_store(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
@@ -1080,16 +1084,16 @@ static ssize_t kbd_rgb_mode_store(struct device *dev,
 
 	switch (speed) {
 	case 0:
-		speed = 0xe1;
+		speed = TUF_KBD_RGB_SPEED_SLOW;
 		break;
 	case 1:
-		speed = 0xeb;
+		speed = TUF_KBD_RGB_SPEED_NORMAL;
 		break;
 	case 2:
-		speed = 0xf5;
+		speed = TUF_KBD_RGB_SPEED_FAST;
 		break;
 	default:
-		speed = 0xeb;
+		speed = TUF_KBD_RGB_SPEED_NORMAL;
 	}
 
 	err = asus_wmi_evaluate_method3(ASUS_WMI_METHODID_DEVS, asus->kbd_rgb_dev,
@@ -1115,6 +1119,11 @@ static const struct attribute_group kbd_rgb_mode_group = {
 };
 
 /* TUF Laptop Keyboard RGB State **********************************************/
+
+#define TUF_KBD_RGB_STATE_BOOT		BIT(1)
+#define TUF_KBD_RGB_STATE_AWAKE		BIT(3)
+#define TUF_KBD_RGB_STATE_SLEEP		BIT(5)
+#define TUF_KBD_RGB_STATE_SHUTDOWN	BIT(7)
 static ssize_t kbd_rgb_state_store(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
@@ -1130,13 +1139,13 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
 
 	flags = 0;
 	if (boot)
-		flags |= BIT(1);
+		flags |= TUF_KBD_RGB_STATE_BOOT;
 	if (awake)
-		flags |= BIT(3);
+		flags |= TUF_KBD_RGB_STATE_AWAKE;
 	if (sleep)
-		flags |= BIT(5);
+		flags |= TUF_KBD_RGB_STATE_SLEEP;
 	if (shutdown)
-		flags |= BIT(7);
+		flags |= TUF_KBD_RGB_STATE_SHUTDOWN;
 
 	/* 0xbd is the required default arg0 for the method. Nothing happens otherwise */
 	err = asus_wmi_evaluate_method3(ASUS_WMI_METHODID_DEVS,
-- 
2.56.0

