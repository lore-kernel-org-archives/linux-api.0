Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793530034;
	b=NqEnxrFMudqnriwQJxMBJjwCQ9GouJDS2fmjkoUqwKZXAyCWgUFm3R/OudQH0lpYqlAP
	 0wmN6XfUhmeM3h+iu0oQot193IIcZcpMLVL7pIXdI7t6MzcqepPUbcqfyCNr8TO7ujXZr
	 yKOy0njY8zbsHsDO2zFW+3eRrCtQzqLLC4qAvhHBdxHT3moGh6mpL5kPT0AYYzfQR4Dtc
	 ma28Ns6xrthCUQlpxwD7c+6fce1k7YbWzRtc3M10nJKxZ7rESZFLcGxkD1kC9KBxOgGSn
	 +Ulocr7IWCH0FTpvkGtDDxdapSlLiMldXV3JzKYLagtoOU4Li+GlRzwKpIC1aKv1hwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793530034;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=qFSdRjnuTS0M+h5Ev17ib7+0XkEHH0B3YdujUMLD5y8=;
	b=zp4JqIAC1LnzEoByvAsLcjsuhmAsfOmuvyKXZ5EZmyEm8Wut29lv8gLQ5RZr4VaL/1OX
	 DwbvLJSdT5ySa46Eh9Vvsi2jMnXEkf2XF3QSswTPT9COvTk4j84FoY1xrz0LLXdAjcVEa
	 ECojGcP0/OLJya82F59d7Ov6bonjmCw2+Am543iz0Mfe/x6QPlnI1Dic3/iwk4I9FDgvW
	 BLgjo0YXXCwT5+awrtPZ9ZC7H5AlfrnqCytcuadzwyXQOuE+rQf7t1q0BvgHy3lBO007t
	 CJQudY+8cTkfynIcXTDafrYHK0I4+mml1P9dRn9zL6yCXMS6Z4dMm/+Tr2QOocTIylA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xXmtwACC;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84514606A32E
	for <linux-api@vger.kernel.org>; Sun,  1 Nov 2026 10:47:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84514606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xXmtwACC
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a2084d62cdso18123945e9.1
        for <linux-api@vger.kernel.org>; Sun, 01 Nov 2026 02:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793530033; x=1794134833; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qFSdRjnuTS0M+h5Ev17ib7+0XkEHH0B3YdujUMLD5y8=;
        b=xXmtwACC42P9UiDFQGQH/f5u5ShBdLxb45g3Kut3u3uyd2Wp/E5GKjV/6nmKGOFcGE
         WwP2eFp1eLc7wwdwH0IzSHaNa3nhEite/NxAMWrpgskgiS4UEf8xe/vSI2aA+772Jt+q
         5kWg2NSHTtOZbCxE1Rr2Jz1z2O2n8EKP4MkV9ktnN5cNmlfxxrhYn18CKzjTJSsgaQbj
         gRDQnz0L5I+y4l4F7RE+c9SWMiGs5uV78TLxObgU8qy1FSisOVikcmrSqXrzlHmztd+9
         kyOGmOrkD7X0sg0LBfIabJ7ueX8vqzBdMUY2okQI3fAnNfXLh4S1tu+iyt9KnLx4Lw/0
         8J3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793530033; x=1794134833;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qFSdRjnuTS0M+h5Ev17ib7+0XkEHH0B3YdujUMLD5y8=;
        b=z8W9xN32guDPqH9HXKJiImQpSUfoHgXf+YbpKidEC2Bjohypu82WH35QPl8nRkqLPm
         2MLOtzNMeABQsOq46mCqxwWgsnOsB8Wz64uHoE/pXrhPhL97trnF042ZQ5O5mgS+8F86
         c4rqIS/u1a0anuIrwSMeXXmgoo8mH9CmG5FNUUBSZZA3djVIfqZ69nlG+v8Kuypzd+RL
         g8ddlxGgVnR2Iz2OMmHeHRjLBAXD8TzOCF+j+jY4W76YMPJKIJ5aI9aEB9D+Fgb7os6H
         2337AKXXxYmgrrHPeAvDnf8mZc6D0p2IdpGKx7RWIE4H1muMbJWrs7fOdd2JjTUr9zQ3
         zCeQ==
X-Forwarded-Encrypted: i=1; AKwUvBz64dTzd6BppIQ5fOKqe5XfK/FzPjWDeCUnefCF8EtmZf+Ht3U0JD1DJKT7gXpRVHzPXuEOPWbrbaE=@vger.kernel.org
X-Gm-Message-State: AFq9FYJe8grPrFT7rSGwQz57T5+sJQ+SgwdaTa2UhCkEExbVRxfb9S3A
	EnUccFcirs0FHWolHLdsNOt03iBfW/qJExOnCmvAfWyI2MHXbPYbI7KM
X-Gm-Gg: AYBFou2oH8eehPIo/y2OXJ5HBnQt3fK8tSzPHCYUMF78BmNNYyLUS5aDM6VJ3PdTSH1
	xPXB1Y1XpNZ6SAKLkfdktN8GyDzqip0jtjip4PNa7cnD+RaOUHKmwPSp7wbDMwRrmzmYsqj5+hD
	TWsDKsHss0FI/RfTrTwPhMLjyzmktorkVeIosGCHDc1B4kFGS2vPeERNbD/rLStIfWkiGFApQ5M
	z5rw4eIrAxSTxzRZYx8asjPf5uc2AYNA+golE1fRChZ2JY1La0aVy4ssin0IzStQPNZfqPJ1OVS
	VBloMyavB0/AA53txzF0ufFbHnyCPjQpt8Q3NreE/68hdmRhvvilVEISG0jgeeXLtvVDut726Ks
	rwNaU0W0dx75qqwrhp+oT4bxaJ5Jrklnfh/GLSumuXNDYIr0+80loa9NQhnI4bpYwnbAZPm3A8r
	BYxY+cdokdZSV7n/k78wLQVQnFfU5HI2ltSriNkP8MyZrh+QljVsYzwacYcwwpspEKpflCxcKB7
	ALTY456N7/hoHxlT6gkdH/aMZsPUO3espIqr8R03QPSae1aYbRMg6wDflB9NRR5qhPXN6xtq62b
	+c/oSPsFW60oHSqWN5yHddGFFYI=
X-Received: by 2002:a05:600c:4454:b0:4a3:5a7b:6002 with SMTP id 5b1f17b1804b1-4ac17d19777mr157538465e9.28.1793530032871;
        Sun, 01 Nov 2026 02:47:12 -0800 (PST)
Received: from [127.0.1.1] ([85.105.252.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f322c46sm255602715e9.2.2026.11.01.02.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 02:47:11 -0800 (PST)
From: Bartu Alev <bartualev@gmail.com>
Date: Sun, 01 Nov 2026 13:46:45 +0300
Subject: [PATCH 5/7] platform/x86: asus-wmi: reject short fan curve replies
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
Message-Id: <20261101-asus-fan-floors-v4-v1-5-b8d1c31a99a9@gmail.com>
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

fan_curve_get_factory_default() passes a 32-byte stack buffer to
asus_wmi_evaluate_method_buf() and copies the first 16 bytes into the
curve without checking the returned length.  Because the helper only
copies obj->buffer.length bytes, a shorter firmware reply leaves the
tail of the buffer uninitialized, populating the curve with stack
garbage.

Zero-initialize the buffer and reject replies shorter than the 16
bytes required for the curve.  Known curve getters return 32 bytes,
well above this threshold.

Signed-off-by: Bartu Alev <bartualev@gmail.com>
---
 drivers/platform/x86/asus-wmi.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index b6541183d4568..dc1e69b964c99 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -3631,7 +3631,8 @@ static void fan_curve_copy_from_buf(struct fan_curve_data *data, u8 *buf)
 static int fan_curve_get_factory_default(struct asus_wmi *asus, u32 fan_dev)
 {
 	struct fan_curve_data *curves;
-	u8 buf[FAN_CURVE_BUF_LEN];
+	u8 buf[FAN_CURVE_BUF_LEN] = {};
+	size_t len;
 	int err, fan_idx;
 	u8 mode = 0;
 
@@ -3644,12 +3645,18 @@ static int fan_curve_get_factory_default(struct asus_wmi *asus, u32 fan_dev)
 		mode = 2;
 
 	err = asus_wmi_evaluate_method_buf(asus->dsts_id, fan_dev, mode, buf,
-					   FAN_CURVE_BUF_LEN, NULL);
+					   FAN_CURVE_BUF_LEN, &len);
 	if (err) {
 		pr_warn("%s (0x%08x) failed: %d\n", __func__, fan_dev, err);
 		return err;
 	}
 
+	if (len < 2 * FAN_CURVE_POINTS) {
+		pr_debug("%s (0x%08x): short reply of %zu bytes\n",
+			 __func__, fan_dev, len);
+		return -ENODATA;
+	}
+
 	fan_idx = FAN_CURVE_DEV_CPU;
 	if (fan_dev == ASUS_WMI_DEVID_GPU_FAN_CURVE)
 		fan_idx = FAN_CURVE_DEV_GPU;

-- 
2.56.0

