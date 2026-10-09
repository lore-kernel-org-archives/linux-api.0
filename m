Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E7A4E9C00
	for <linux-api@vger.kernel.org>; Fri,  9 Oct 2026 15:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791560367; cv=none; b=C5G1y9yat0uwigs3PncTKjczddX0xknQbTe3yh9QbB0dmOEku58iFhyxKdVdWTyMMoI2iFQgE2vffewcNH/1kd4gqOvRsbBoi7Z2rvHy9z7BQ8IYK00FWr2YUzSbG+/mhohQpg+0abI6WYQ8u8cxVY/ybFoE44xc2cIfBf/Jm/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791560367; c=relaxed/simple;
	bh=7KQOT4/YmaGTqbBEFf/jux4/hF/llbFyRPtq++sAfS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwAc2RKKDKgoJPpv/fYFQp8u+WDxYDsADHDc4cxq1YCqnOfykOW9xTEv/IquRL8km98/RiF4wyMXWJRF4gO42cQV8FmnrPhrvbffcFD/vVc0HOhzqT67V/zdWIBzR7thovKmzD7d7GeU77ND0LaH67YxnfROS+8q+1BMAxbODkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MfRm3k1G; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MfRm3k1G"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e8455755f3so4653705ad.0
        for <linux-api@vger.kernel.org>; Fri, 09 Oct 2026 08:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791560362; x=1792165162; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QCWuqJzkl7WxbzU0hxEOW4t98SL56glPEqj/2QQfXyk=;
        b=MfRm3k1Gurq5irLB6I1YCyEttfZSKz2kGuhEAWHa+hiJpeBCrkVwoHLenFn0WWqJfy
         i4kryNpyG6CIPw24s11vdNDm3LbwogVKQ0yj2w0+OvACB0jZIjF3EqKiDqpgq1YiWbnt
         QH4Jx7RxcRGzeGICrbB4JTeQlZYF2iWdv0tPsieMmV6HkT1WPWDwhtRgJCvt6nBTC+3G
         gLQFQ2fgZmqismVRiZLfzSdDHj+Je+bQKLjNz550VbLh0rrl6+oaPj3IEQGfnkgy0s1B
         6K1t+pZUg7ceYG7mxBSOWK7hsQ4yVDNzeD4YE2kzAtfYxIKMfgi2+k/Z30ITnndRd/03
         XlnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791560362; x=1792165162;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QCWuqJzkl7WxbzU0hxEOW4t98SL56glPEqj/2QQfXyk=;
        b=OEJarhlhGvyXXrSsfBkakY0o5IA/n50Jtsz0XwzErlDLFCD7byr/6wJqY+F8pyKGWs
         7EsbUxMxYRrDV/6MCOevvau7x0NvNeNgd5T47iG2JdZ8WEO36zMK0+70Z9tSkQsdSdVu
         BO0Q89Ky2QkJh2u86MdH6Qfq+EqiIPthTyDH8ZK1doaxbuDKsttd0SdlciM1biRQfL9X
         9+Hl4+fcD24pJKhLOSV8rWxzrLNv5bzrl2Jedkcalt7qdCmOhmAx8PeoCNqSDGPPPXQa
         S16E3A1tcnh3AiJzP/ZDCTW3AUhvLZdkVX5Hnbrs9QrDWex3vrKXOwltdG28yETsOGce
         GO5A==
X-Forwarded-Encrypted: i=1; AKwUvBzfnN8XIC3KtQyfRMa+3AGG/KlyChyfq2vT2PV2LPgCAOjHdJWe7uCdQ9fDohC4aCk1uiA5gAbpsYo=@vger.kernel.org
X-Gm-Message-State: AFq9FYJx0JLZjWeHxry/HhRddfxvpNsrktIpae7dwp11OVgDzB8LAgG+
	OiXAlSlzMPm+m2nOGJMEg7lMNKjdivAf+4gUwE6UX2g0UyulPbz05490
X-Gm-Gg: AYBFou1lgXRNfbna5PzNxZz5D9BmquJQUg/w09W/J3tZm9qpihbFyshix2ImCr0pbiu
	DAuGsLkU7tjZ95HXnz6reiapfjSj9PJoOiQBgbdoqz7qJ/ucOOBr2mQA338Cl/x/bh+dvWrjtww
	lnoAnLLrNiJw4Q/P5knftXrIuj+uCGB6ZOwPB+okISL7KR2DQTycCplEC1XJ4RCF34EyWUtnx8v
	QXfcI4n92rAjvmD0gafWSZWv3jg5YYcW/ZF/WdU9I+baO53pC1UPc080FmHunfYUhTBdHKMx5Fd
	CE8pu7pjcji/U38b5upjy81YpxYt7XrEtf4A4UHvd62ggc/GBQSATILhA6YFXyrqXhCmaS63zNI
	MXdggmEFCvxeBC2xVZHbqhXMOPWgbTahVxes4OSPm4kntHv1AEc8Jv1jtXGDt03bMu9bEYvqv0d
	pvkjlURlBoSAbOGUTMiiRmXtJct/1NLtKaguaCHJhHb3QClULaFEJJZ1sIHKFSfO3wYw6u
X-Received: by 2002:a17:903:2a8b:b0:2e8:3d48:4d82 with SMTP id d9443c01a7336-2e842dfd143mr19132405ad.60.1791560361898;
        Fri, 09 Oct 2026 08:39:21 -0700 (PDT)
Received: from mincom1 ([14.67.155.18])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421ae999sm11847705ad.31.2026.10.09.08.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 08:39:20 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>,
	linux-hwmon@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] hwmon: Expose attribute validation and string helpers
Date: Sat, 10 Oct 2026 00:38:41 +0900
Message-ID: <c0e04710f5a3a555e9d7b42b8f9ee369311cca4c.1791559095.git.hurryman2212@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791531025.git.hurryman2212@gmail.com>
References: <cover.1791531025.git.hurryman2212@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose the core's string classification and sysfs template validation
through the kernel hwmon API. Let drivers query these properties without
maintaining separate attribute tables.

Reuse the helpers when creating attributes.

Assisted-by: Codex:gpt-6-astra
Signed-off-by: Jihong Min <hurryman2212@gmail.com>
---
 drivers/hwmon/hwmon.c | 30 +++++++++++++++++++++++++-----
 include/linux/hwmon.h |  3 +++
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 10d2df3efdfa..bed16cfd4f1c 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -502,7 +502,14 @@ static ssize_t hwmon_attr_store(struct device *dev,
 	return count;
 }
 
-static bool is_string_attr(enum hwmon_sensor_types type, u32 attr)
+/**
+ * hwmon_is_string_attr - test whether an attribute returns a string
+ * @type: sensor type
+ * @attr: attribute identifier
+ *
+ * Return: true for string attributes, false otherwise.
+ */
+bool hwmon_is_string_attr(enum hwmon_sensor_types type, u32 attr)
 {
 	return (type == hwmon_temp && attr == hwmon_temp_label) ||
 	       (type == hwmon_in && attr == hwmon_in_label) ||
@@ -513,6 +520,7 @@ static bool is_string_attr(enum hwmon_sensor_types type, u32 attr)
 	       (type == hwmon_humidity && attr == hwmon_humidity_label) ||
 	       (type == hwmon_fan && attr == hwmon_fan_label);
 }
+EXPORT_SYMBOL_GPL(hwmon_is_string_attr);
 
 static const struct attribute *hwmon_genattr(const void *drvdata,
 					     enum hwmon_sensor_types type,
@@ -526,7 +534,7 @@ static const struct attribute *hwmon_genattr(const void *drvdata,
 	struct attribute *a;
 	umode_t mode;
 	const char *name;
-	bool is_string = is_string_attr(type, attr);
+	bool is_string = hwmon_is_string_attr(type, attr);
 
 	mode = hwmon_is_visible(ops, drvdata, type, attr, index);
 	if (!mode)
@@ -776,6 +784,20 @@ static const int __templates_size[] = {
 	[hwmon_intrusion] = ARRAY_SIZE(hwmon_intrusion_attr_templates),
 };
 
+/**
+ * hwmon_is_valid_attr - test whether an attribute has a sysfs template
+ * @type: sensor type
+ * @attr: attribute identifier
+ *
+ * Return: true for supported sysfs attributes, false otherwise.
+ */
+bool hwmon_is_valid_attr(enum hwmon_sensor_types type, u32 attr)
+{
+	return (unsigned int)type < ARRAY_SIZE(__templates) &&
+	       attr < __templates_size[type] && __templates[type][attr];
+}
+EXPORT_SYMBOL_GPL(hwmon_is_valid_attr);
+
 int hwmon_notify_event(struct device *dev, enum hwmon_sensor_types type,
 		       u32 attr, int channel)
 {
@@ -843,14 +865,12 @@ static int hwmon_genattrs(const void *drvdata,
 			  const struct hwmon_channel_info *info)
 {
 	const char * const *templates;
-	int template_size;
 	int i, aindex = 0;
 
 	if (info->type >= ARRAY_SIZE(__templates))
 		return -EINVAL;
 
 	templates = __templates[info->type];
-	template_size = __templates_size[info->type];
 
 	for (i = 0; info->config[i]; i++) {
 		u32 attr_mask = info->config[i];
@@ -861,7 +881,7 @@ static int hwmon_genattrs(const void *drvdata,
 
 			attr = __ffs(attr_mask);
 			attr_mask &= ~BIT(attr);
-			if (attr >= template_size || !templates[attr])
+			if (!hwmon_is_valid_attr(info->type, attr))
 				continue;	/* attribute is invisible */
 			a = hwmon_genattr(drvdata, info->type, attr, i,
 					  templates[attr], ops);
diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
index d48e0aa82bc5..b026aa317630 100644
--- a/include/linux/hwmon.h
+++ b/include/linux/hwmon.h
@@ -138,6 +138,9 @@ devm_hwmon_device_register_with_info(struct device *dev,
 
 void hwmon_device_unregister(struct device *dev);
 
+bool hwmon_is_valid_attr(enum hwmon_sensor_types type, u32 attr);
+bool hwmon_is_string_attr(enum hwmon_sensor_types type, u32 attr);
+
 int hwmon_notify_event(struct device *dev, enum hwmon_sensor_types type,
 		       u32 attr, int channel);
 
