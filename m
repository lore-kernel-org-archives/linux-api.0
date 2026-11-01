Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793530022;
	b=fvXnszsA1bnoibU+XbmuLmLebTiJrPTL1vLnQKKE1gGFFuXi47xxmCLmpEt0RbR2c+yq
	 M/aNTdhQ6TbzvEN7H5jeqJAahcR8niYH3MvwGlBNHvP0Iv9VbGljWY0ZtwJ2gX0cDLZ47
	 BPJf97ops2k3fZC8TsjtVU/o6y/zadCpUnpyGCe50g49QGXxl15Ch3PqWTnv4hkk4Ci1M
	 90+rmlrJI3httNiWSbJUVuZoNcSqhyQzlmTyKfjP2M0B/KgGlL8JnMM02YwgXw7eXGscE
	 /YRhfHGZN4iH5vbRpCOgJEfBlslUSFSEbHMiTyz4Dew/ERDzvGWGFfF2h941aC5A5mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793530022;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=hqMFp7OoaihnU8SvIdhdeXnsjyjS2fMQMMOIfDJThPc=;
	b=eUq37KPmw+QHA3m4uv6wgjspZVbbj/gr181iCPdmB9z4mRwfkkxDDRm6KEskl6iNveug
	 YRh60ccW3lo5xMeWA7uI1TYd5i7N+3aXP5D0ECpNYhRkWPVVzb+VdVUJ1gvKJHRmqlVrZ
	 KZhGAZAIL9WULomVdNlkCPMyrZ0AC3baWHnQDY8SruCagLtfPtfIPjhsqTAsrTTNSM+w3
	 kYYHzQYPn+LT8+VzS2+IO8Rd+FkbOrGgIo0vF6PR9Kt28JU2yRPGD5asUTWq2MY2QZi7n
	 CUfYTwyGAS25ecI7c/jiFaMvQYbkea3EThjqR3a6x27Pby6rxufKvTuwQa1A+ozfRsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dMyzMMgo;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DCA606A327
	for <linux-api@vger.kernel.org>; Sun,  1 Nov 2026 10:47:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21DCA606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dMyzMMgo
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a215e64962so19504665e9.1
        for <linux-api@vger.kernel.org>; Sun, 01 Nov 2026 02:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793530020; x=1794134820; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hqMFp7OoaihnU8SvIdhdeXnsjyjS2fMQMMOIfDJThPc=;
        b=dMyzMMgoxz7oJACKph8xEWuaqrJKYCGA9WlXHE/rkVINGGmcpWoadzTxxGpjROCj8y
         m0o5xGih1eEtO7+IydlNA6ibzyL3dnkR9y5pGuNn4W/3MuOLzLrlRTswTRGPHwUuQ33P
         wxjiRMozLBjqwe5Ayk1dydUutBzLTPRMwjB6eEKu/vTNcNatIZ8gAJMmFa+etbwFwjLf
         NjWmXTdy5RIfpfj76FlRgqqRII4zS1j1AJkhlh+ehpej7x4SJrpAi67Dl3hv1pHytrTV
         KEoNeZJwAyM0koJaEVsl6TpYOBp5hQVNuOClY/A8qCEBZnvnSW4dXWMjFFVMD/2UScLc
         sehg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793530020; x=1794134820;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hqMFp7OoaihnU8SvIdhdeXnsjyjS2fMQMMOIfDJThPc=;
        b=zIhs9zTkzzVu3RysCx3YG+hBp+ZbiibM+49HPzzTUuCkATrR9pf7dTNajNPUFmbo3h
         3uy+WlexkrhX1wNlUAkpO7ra/Fb3b4FEaheJliOXDTqxfRAiZNljPaeAWo7Oeyb+PE+m
         Kk8X3Xz80GN9SdQXu2AxbGhMrLFzQU81MEDrp5syqySmQ4G5ZssYy0yn9sWYFF8tKl4t
         +LvdF4SFTCAdurB6gSO4ng6653+NoSLJt7tOLScd4mdv8BmNJA4NGYzJpG7jFdDKR7wJ
         sWLcORWj9VLVGLi06Y8yiizmlvJW93slDJ4rrSKJiKHX2CV8jNFUXoSd0Wuv9srmWHEy
         j+Iw==
X-Forwarded-Encrypted: i=1; AKwUvBxDl9eiUG2sOd8hdaneaFRrsA/TfeOQOqRjhAnm0SA5YDxZLS6/4u8DgXESS0QyU41o39KY3gkZ5Ds=@vger.kernel.org
X-Gm-Message-State: AFq9FYI0xOyVnFn8pi7yvPMFRHrg3CNWNwfQhQt+LmhaQ3H9qLt5fC/u
	polN1RKuVCv45Q8IHYiohmh1qiopBlUn7wz8CnjSykPMpDpjLtFY8kro
X-Gm-Gg: AYBFou1wEsIuEh22WT0/Gk/fyGBMx4SYeqwpI4MB454REDNnOjA4GmMfBu9gd/3bTvK
	625D4kaOgPtBozRrrSZ8mHGtM4jpaG2AxL98Pi12x3TCUo01qenEHHLJaCU1iAebVVV4NkEm7A7
	WW+oGNOc9BYKqtY3oetItBYaELDVgLw16R6Agl5ztf1UGSSd5MZ68majU+DkxoaMjl/L/cMQW6Y
	ArBjgyCHrKLgZuqf/cxN6PaGN11MnPJQ3fFVeyblM5a+qPBp67r0ihJxqdaiw/HMIOZ5QV2YFhE
	MEB92CctzMTQbDhGEwH4rE265yrHs7CImnPiG+odTf6rYTQdBXOEvQvp3d5EUQV8FmX0zWmDhHI
	roLtu2IXuo4sJSQkSgE7rTsy+G4gBYtikS9N1xanAb7yQdarsipePbt/LWnI2jwOcwVMzeP2hSR
	V3wJhy0vZrI5NKTvZ7UJW+j0ho/McQ7qdW8SjuiVFmXZw7ZcpJbh4UR1SIJjspbPQQjcknUYmVU
	fD9x+FA0tvueBfZtyML3aILZyfOh4NdXLJJ8b3tDk3r+La+18KFcKdnYXjPvgbzhQKtEUqPTTOG
	mnTV3y814s3eTaupC71tIs46nss=
X-Received: by 2002:a05:600c:1f93:b0:4a0:1fb9:2f51 with SMTP id 5b1f17b1804b1-4ac182dbc34mr156760555e9.14.1793530020382;
        Sun, 01 Nov 2026 02:47:00 -0800 (PST)
Received: from [127.0.1.1] ([85.105.252.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f322c46sm255602715e9.2.2026.11.01.02.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 02:47:00 -0800 (PST)
From: Bartu Alev <bartualev@gmail.com>
Date: Sun, 01 Nov 2026 13:46:42 +0300
Subject: [PATCH 2/7] Documentation: ABI: document the ASUS custom fan curve
 attributes
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
Message-Id: <20261101-asus-fan-floors-v4-v1-2-b8d1c31a99a9@gmail.com>
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

asus-wmi has exposed custom fan curve attributes since 5.17 for CPU
and GPU fans, and since 6.6 for the mid fan, but the sysfs ABI was
never documented.  Document the existing attributes before adding the
firmware fan floor tables.

This includes several embedded controller quirks: point Z is limited
to the temperature decade [30 + 10 * (Z - 1), 39 + 10 * (Z - 1)]
degrees Celsius, the EC clamps uploaded thresholds to that decade
while reads return the raw byte written, fan speeds step without
interpolation, and downward transitions use 5 degrees Celsius of
hysteresis.

Signed-off-by: Bartu Alev <bartualev@gmail.com>
---
 Documentation/ABI/testing/sysfs-platform-asus-wmi | 59 +++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-platform-asus-wmi b/Documentation/ABI/testing/sysfs-platform-asus-wmi
index f9825c6150b5c..775ea88625c0d 100644
--- a/Documentation/ABI/testing/sysfs-platform-asus-wmi
+++ b/Documentation/ABI/testing/sysfs-platform-asus-wmi
@@ -238,3 +238,62 @@ Description:
 		Set if the MCU can go in to low-power mode on system sleep
 			* 0 - False,
 			* 1 - True
+
+What:		/sys/class/hwmon/hwmonX/pwm[12]_enable
+Date:		Oct 2026
+KernelVersion:	5.17
+Contact:	Luke D. Jones <luke@ljones.dev>, Denis Benato <denis.benato@linux.dev>, Bartu Alev <bartualev@gmail.com>
+Description:
+		Enable or disable the custom fan curve of the CPU fan (pwm1)
+		or the GPU fan (pwm2).  Reads return 1 while the custom curve
+		is enabled and 2 while the firmware controls the fan.  Writes:
+
+		    * 1 - enable the stored curve,
+		    * 2 - disable the curve and let the firmware control the
+		      fan again,
+		    * 3 - reset the stored curve to the firmware defaults and
+		      disable it.
+
+		Enabling validates the curve: temperatures and duties must
+		not decrease from point to point, otherwise the write fails
+		with -EINVAL and the curve stays disabled.  Writing any
+		writable pwmY_auto_pointZ_temp or pwmY_auto_pointZ_pwm
+		attribute disables the curve, so a changed curve has to be
+		enabled again.
+
+What:		/sys/class/hwmon/hwmonX/pwm3_enable
+Date:		Oct 2026
+KernelVersion:	6.6
+Contact:	Luke D. Jones <luke@ljones.dev>, Denis Benato <denis.benato@linux.dev>, Bartu Alev <bartualev@gmail.com>
+Description:
+		Same as pwm1_enable and pwm2_enable, for the mid fan (pwm3)
+		of laptops whose firmware exposes a third fan curve.
+
+What:		/sys/class/hwmon/hwmonX/pwm[12]_auto_point[1-8]_temp
+What:		/sys/class/hwmon/hwmonX/pwm[12]_auto_point[1-8]_pwm
+Date:		Oct 2026
+KernelVersion:	5.17
+Contact:	Luke D. Jones <luke@ljones.dev>, Denis Benato <denis.benato@linux.dev>, Bartu Alev <bartualev@gmail.com>
+Description:
+		One point of the custom fan curve of the CPU fan (pwm1) or
+		the GPU fan (pwm2).  _temp is the temperature threshold of the
+		point in degrees Celsius, _pwm is its duty in pwm units
+		(0-255); the driver scales the duty to the percentage the
+		firmware expects when the curve is enabled.
+
+		The embedded controller binds point Z (Z = 1..8) to the
+		temperature decade [30 + 10 * (Z - 1), 39 + 10 * (Z - 1)]
+		degrees Celsius and silently clamps the threshold into that
+		decade when the curve is applied, while reads return the
+		value that was written.  On TUF series, the controller steps
+		from one point to the next without interpolating, and a point
+		is left downwards with 5 degrees Celsius of hysteresis.
+
+What:		/sys/class/hwmon/hwmonX/pwm3_auto_point[1-8]_temp
+What:		/sys/class/hwmon/hwmonX/pwm3_auto_point[1-8]_pwm
+Date:		Oct 2026
+KernelVersion:	6.6
+Contact:	Luke D. Jones <luke@ljones.dev>, Denis Benato <denis.benato@linux.dev>, Bartu Alev <bartualev@gmail.com>
+Description:
+		Same as the pwm1 and pwm2 curve points, for the mid fan
+		(pwm3) of laptops whose firmware exposes a third fan curve.

-- 
2.56.0

