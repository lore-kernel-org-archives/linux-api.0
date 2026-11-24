Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795489531;
	b=2lf78QJc/Jn88UwBacLXVKvq/vmOT/0UqR1i0OhsazJXfW27gOJaos/PlVXuTae5z1JV
	 m5WxBZ5w+mCOXPnXUw7CgZzVLJRK+uqulIeBAdR+cmJP/Ye2ynPaVIaZ8nVmatv+Q2fv0
	 d2gGVKfQfOGMHFXT6HQS/plPStawaW3kRqYeUFDTex385Zqa00cSoBWgVNb8QEg3rlOU5
	 zBq28LOsT2qmQVZV3HwbezoxmBfuRssnL2kO1g1TpelXZmVvkM5b5+uQK6aijIm5w7Jwx
	 udSoSYSriRMOBJPeHvNFx9W1HZX1woASqI6OIo7k9ZdELlmXqiipw3a35p/qOHfrPKg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795489531;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=oJimokr8Sp2/3i9x2zohOQKTJnD9o9zUGU0QqCS/4V8=;
	b=E4SAwMV5FauBaA4yvZxBoXYxOj6vsKhmaKLH9O1AQ4DSz5HiQTtE2gm6w55SLMz5sgpg
	 lAqTQIYVtdgzHZhDlj5eRsPnu6v2Vix8tR/1qu/p+LbFjfrcV+5PKOxpsB36EjuTjEBs4
	 U31kNQ8ZT1Pvq7AD/6kFabH43BivYiXTMFQNeFe5wy3euR2rI9SDkV4Rf2TryAhIrIMck
	 j18Y7ndWCG8+vzU7QMgKFjfxiYspj/RBV1J8zHWHqmNzuadcBMdnvAWbKfkkQXHsS7Epr
	 cpDN46Ib5ZVynXOPc9QxAU3NCb2oBAnTGOHK42gkX4IMu2RWADNTkflSLeiYHSWR7Nw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F9AsrRFG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00E9606A326;
	Tue, 24 Nov 2026 03:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F9AsrRFG
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795489531;
	b=VVOeshE1cIUkrC0gLt9AeY8375gKbl63Te1dKRM4212RmYuZyY/C6TZAbQDmgLY2ccnA
	 ceEIZAoTkZ0fkb7Ki/PPPSI3XRwMUmIDzQye2q8VB2sKv9+KnYmtC9hUewU/ZadIFd50b
	 HSo4p9uU2viw4nTseix93OI/IniZTAX1M7XNERKkCy/xggpfgX1tW82AEkXDfkY0I75J8
	 QJvDIJsfdwSSvtJcE2OYBSlpyP6iTIQBWLH0fG3HknO8PD6zvRw9gpp97/YrDT2pM2rFQ
	 XXPMb5VLFyipTbI5c5cjEDMf825wa9lTIKL0Y0h25boYR4U/RCxrfIdyzzqCNluv0Ag==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795489531;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=oJimokr8Sp2/3i9x2zohOQKTJnD9o9zUGU0QqCS/4V8=;
	b=fn61a9tPXaSkVU8HpJokDRcq39yibzCwC1xn8ZhZT8ES7aA9+GtJ+EzsGospjHbUmG8D
	 9hZZ6DP9kvlgn1BE9JVKCNqq+WRcYhTOUBlGjaMT615U6Y5fVjpFvMVTYb9JhedJOHzdz
	 dxzOCaNeT9ZJ4T/AkXyQapiVuLUsM/ZTtZo5NlOfxvaXwj5p1SLBngKKthpc+CZCAwfln
	 9Q9Mn0Y8GyB4tdyspUBRJitarvqnLuiUEfho/LJfUxIG+wZMibCul5LB+9DH/eFWy63Bn
	 xNUE0ZCSnAYpcVaoeovWx4XXowQEw+bXIxTgVtGFEdptOlYS/9npDxKrAa/cOlr461A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E05BC1F000EB;
	Tue, 24 Nov 2026 03:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795489531;
	bh=oJimokr8Sp2/3i9x2zohOQKTJnD9o9zUGU0QqCS/4V8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=F9AsrRFGDSjkpSXLHdy0HaZHnykT0JAyjCZChNpJmcbsYlDYeQ74uCslHBKMYOljd
	 8/oMq9nXktgFGmhHLL6SRX2RQLtcvCbN88nHSNxI6dfe/qFZ1Lsz9+iOOUGxZugQ1s
	 0DNl2rZucvLfEMQ+JazABVOFNWkXjK0g7aGkBlYbYHbKalF2d5l4EY5BsSHuar4pwy
	 Mb1oQJLdyZ3jJhQCjInA0dkDi3JIgtU26DM5NQS4FmXhUnUY20kdeJl+dYZKXCcTi1
	 PLDb330WEEb12PK1TBgv7GmNHGRQoJ79AVJvMeA6A1vVQDFkltcSIRw8HPb3RDYcSF
	 1x3Rnv+J2Mh+w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A69AC4C87B;
	Tue, 24 Nov 2026 03:05:09 +0000 (UTC)
From: Hermes Wu via B4 Relay <devnull+Hermes.wu.ite.com.tw@kernel.org>
Date: Tue, 24 Nov 2026 11:04:46 +0800
Subject: [PATCH v2 9/9] media: uapi: it6625: remove the driver-specific
 audio controls
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
Message-Id: <20261124-upstream-it6625-alsa-i2s-v2-9-a154685f6989@ite.com.tw>
References: <20261124-upstream-it6625-alsa-i2s-v2-0-a154685f6989@ite.com.tw>
In-Reply-To: <20261124-upstream-it6625-alsa-i2s-v2-0-a154685f6989@ite.com.tw>
To: Hermes Wu <Hermes.Wu@ite.com.tw>, 
 Mauro Carvalho Chehab <mchehab@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Hans Verkuil <hverkuil+cisco@kernel.org>, 
 Hans Verkuil <hverkuil@kernel.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>, 
 Liam Girdwood <lgirdwood@gmail.com>, linux-sound@vger.kernel.org, 
 linux-api@vger.kernel.org, Hermes Wu <Hermes.wu@ite.com.tw>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795489507; l=3311;
 i=Hermes.wu@ite.com.tw; s=20241230; h=from:subject:message-id;
 bh=6SaU9xnFrmm0KhiPbAskmhGNEZNumQBEu9u4f3AH160=;
 b=BAF4d0WKa6m7EEPENgMldLYWOoxoUUZsbvuud3OlhwNDeSnAPzjoGBpI2m/N8+abxbK/7agEh
 ZsMZNFek1jeCXHiX9vqtH7Te2rsnLkPE3Z23g4WUhyuhc3PRbxfeAFd
X-Developer-Key: i=Hermes.wu@ite.com.tw; a=ed25519;
 pk=qho5Dawp2WWj9CGyjtJ6/Y10xH8odjRdS6SXDaDAerU=
X-Endpoint-Received: by B4 Relay for Hermes.wu@ite.com.tw/20241230 with
 auth_id=310
X-Original-From: Hermes Wu <Hermes.wu@ite.com.tw>
Reply-To: Hermes.wu@ite.com.tw
Content-Transfer-Encoding: 7bit

From: Hermes Wu <Hermes.wu@ite.com.tw>

V4L2_CID_IT6625_AUDIO_SAMPLING_RATE and V4L2_CID_IT6625_AUDIO_PRESENT
have been replaced by the standard V4L2_CID_DV_RX_AUDIO_SAMPLING_RATE
and V4L2_CID_DV_RX_AUDIO_PRESENT controls, and the driver no longer uses
them. They were added together with the driver and are not part of any
released kernel yet.

Remove the uAPI header and the V4L2_CID_USER_IT6625_BASE reservation.
---
 MAINTAINERS                        |  1 -
 drivers/media/i2c/it6625.c         |  1 -
 include/uapi/linux/it6625.h        | 25 -------------------------
 include/uapi/linux/v4l2-controls.h |  6 ------
 4 files changed, 33 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f4456f4589a1b86b140ab578d149884d46a3320a..a7a315f0e80585be26fe2b52a62c19e469cb5703 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14271,7 +14271,6 @@ S:	Maintained
 T:	git git://linuxtv.org/media.git
 F:	Documentation/devicetree/bindings/media/i2c/ite,it6625.yaml
 F:	drivers/media/i2c/it6625.c
-F:	include/uapi/linux/it6625.h
 
 IVTV VIDEO4LINUX DRIVER
 M:	Andy Walls <awalls@md.metrocast.net>
diff --git a/drivers/media/i2c/it6625.c b/drivers/media/i2c/it6625.c
index e4487e8111b94b2fa9f599e37ecd2b8a11425862..64c1cec26edfcb0e0105e00e1b7ba5960252aae7 100644
--- a/drivers/media/i2c/it6625.c
+++ b/drivers/media/i2c/it6625.c
@@ -33,7 +33,6 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <uapi/linux/it6625.h>
 
 static int debug;
 module_param(debug, int, 0644);
diff --git a/include/uapi/linux/it6625.h b/include/uapi/linux/it6625.h
deleted file mode 100644
index a895658aaf6a80d3fb624cdece33c5135161c72d..0000000000000000000000000000000000000000
--- a/include/uapi/linux/it6625.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
-/*
- * Controls header for IT6625/IT6626 driver
- */
-
-#ifndef _UAPI_LINUX_IT6625_H
-#define _UAPI_LINUX_IT6625_H
-
-#include <linux/v4l2-controls.h>
-
-/*
- * Currently detected HDMI audio sampling rate, in Hz. Read-only.
- * 0 means the rate is unavailable/unknown: no audio is currently
- * present on the input, the hardware reported a sample-rate id this
- * driver doesn't recognize, or the status read itself failed. Never a
- * literal 0 Hz sample rate.
- */
-#define V4L2_CID_IT6625_AUDIO_SAMPLING_RATE	(V4L2_CID_USER_IT6625_BASE + 0)
-
-/*
- * Whether HDMI audio is currently present on the input. Read-only.
- */
-#define V4L2_CID_IT6625_AUDIO_PRESENT		(V4L2_CID_USER_IT6625_BASE + 1)
-
-#endif /* _UAPI_LINUX_IT6625_H */
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 942a1df3057e3e49c9111f6a27ec1883d964bf64..a2d4ea909e01f9b705d30b680ef382f5fcd39714 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -249,12 +249,6 @@ enum v4l2_colorfx {
  */
 #define V4L2_CID_USER_DCMIPP_BASE		(V4L2_CID_USER_BASE + 0x1240)
 
-/*
- * The base for IT6625/IT6626 driver controls.
- * We reserve 16 controls for this driver.
- */
-#define V4L2_CID_USER_IT6625_BASE		(V4L2_CID_USER_BASE + 0x1250)
-
 /* MPEG-class control IDs */
 /* The MPEG controls are applicable to all codec controls
  * and the 'MPEG' part of the define is historical */

-- 
2.34.1


