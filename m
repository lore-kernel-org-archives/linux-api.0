Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795489527;
	b=fC9B9teq9lzm7dxASN+Z3l957oBIzYZlmEcnuArF8iW7oEy4PvKzfrW+m+dP56YLTcoJ
	 lO/q1QQp4FnGeukaYBQmpYSjPEasgWm0v+A3SjK1KaX+rlYCMN9oct4oEN60oXZ5Xabxj
	 KKZc+kQt1MxVRRaPmOGVC10eBKw4ixnuPT7yc3S0FkFBkeXGxny6LMoncr25upU28GF4Q
	 Q43kSxiSRjdCQmdIy/G/y06RuFLBgvU2z54t7uV+07lbmQXTt0/Y7arbwz+kq01290PgJ
	 tNH7HjMurQUZ0JPaWDo7O4JbDlkpV/NsEvBmVDScPYdoULOX7Tk5uQg9DoXpaPfrBDg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795489527;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=/66ZT/dtaYsuRf8nTR/blnZFJ83u7SaIwJVmUMg4ilw=;
	b=JYY3wMwWW53HPcpZILaNQ/r1XSoJmI9g/rocBzA/MWLdy5gFWm3y9sPHzOcU3ojLUYjc
	 6jdscXcYKJgg0aPycF+EflIXt8uICKU7ElO297r6tKb0+PXq85AasCQyyvHc2fBwA1q1M
	 gD7dBeMTbLlla4dZYSEHJspu5agmYW7p6x3VlvtCqDZ3lFwjeNDNJtbW+3OmrJw45li1R
	 1NnkMwO7z34RGfbIYlxTrh8jHU1oa1y64IniuvgGI4gs8dSSLRRiD5yrFmkV91dEeoXT3
	 0GWm4FumaZ6h0blfiS7ZRGEWNTsm6tcYLJ5l6iDWSHYiRa+G2hi8sX9dgsGnEWYakeA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Foas2n68;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C37606A334;
	Tue, 24 Nov 2026 03:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Foas2n68
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795489526;
	b=y4v3PCy/+IMrV3fNS/v1qeM7J4DUhJZeqc0PdIabF/AyUlDNvmrG3M03n56xRrkscIec
	 Vl4VfArz2PRhcyhEiSoRug7Kl5prySH9cIvOFoL1CQfLPoueCISRUnzwSMgafVmmpTMSW
	 WKw0l1fTWsFKHD77bAvvGd0JjuAv1/9QNKLWpFXFnSTYO/Q1uPNr2/y6iRaNFY6pW9GX0
	 xLAGDIO10tJdq7YRbPlVSm2h+V1MjYbcUbEruZCYHlx0NdtDNyhomeGY7yuZLPDtqb5CM
	 u9npSSyl7RU00z9zFbTOEnVnO44v5OhEt8pVXnHKHpAJDk5Ijka6KMbDpl+AvjUVGoQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795489526;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=/66ZT/dtaYsuRf8nTR/blnZFJ83u7SaIwJVmUMg4ilw=;
	b=EHbIY2Pky2TCiqaNKhXvb9Gc824xhZoFlqgQhb4Bq8PyeYN3oFL0Wap4WwX3WhPMjB4D
	 WPRHRA4uI3W//RQy4QCf16+mYsGtNEaSg04IcYz7K5D02ovl2Gjokmok5MIpNIaRlX+KB
	 5YrLO7uQ9VUZiuyksjCGjKFqxjQLz0d9MvbBAbjHAioSvPlIbugG1dskmAZGfZfILpwyJ
	 voSm49TjTT1rrcMAC05oSXZab45k5CzxG4m8wxC0zkBclfW6nCcbrNM/ci8rosPEVt1UA
	 VnPeTX1yivUKnUPimElvOLpxm1qW+rg3t7MG6h70kdI0PbRe1cC56Suw7yJ7cr4m/wA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2E71E1F0093E;
	Tue, 24 Nov 2026 03:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795489526;
	bh=/66ZT/dtaYsuRf8nTR/blnZFJ83u7SaIwJVmUMg4ilw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Foas2n68ySsN7xnNlZcaJEXRN88nvaZkgQxdZMM+8xjCMgEDElonFLkg44vlrUMqW
	 g8oEDjHgDftRZTKKQizwgE3lZpKf5YrrVmO/rUQHUc3BNh2jHdpEdwDa+FI3rx4qKp
	 k+wVW8+OWCDpb0DDbLQb4ogX0u6CwFxpxXe2Qjfbcacm3VMnOIG/6nJBTw1UDoBayG
	 dKCf1U/XtCjq8DtJJoReiGq858QmLDk/5ClCJHNc42z0TWoUXgcN0iGZJ9vqPrKxe8
	 g7YMmtfk0HVWLw4aQB4NKY+s74J4EzfVOCou2924PJgQ3ie8e7UtpbvIX3ZZXYEcHY
	 bLJB2zwXVnQ7Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 897A84C877;
	Tue, 24 Nov 2026 03:05:09 +0000 (UTC)
From: Hermes Wu via B4 Relay <devnull+Hermes.wu.ite.com.tw@kernel.org>
Date: Tue, 24 Nov 2026 11:04:45 +0800
Subject: [PATCH v2 8/9] media: i2c: it6625: use the standard audio rate and
 present controls
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
Message-Id: <20261124-upstream-it6625-alsa-i2s-v2-8-a154685f6989@ite.com.tw>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795489507; l=2258;
 i=Hermes.wu@ite.com.tw; s=20241230; h=from:subject:message-id;
 bh=SkAsbIaGVKIQpu4PLBLiScjWzS60ulmPXbGK1gIyRUA=;
 b=EPbz+eQZU6tQGZRrbCgRMkp8ivgUZYY5P8FGOY6g9e0F+V3KkoRsD9/ltJ90X8Yl7jMFe83oB
 G10+fy1PBn/AWdsVWLQe9nNvvZuKi28ly/qh8iR877j7afI3F82AfVG
X-Developer-Key: i=Hermes.wu@ite.com.tw; a=ed25519;
 pk=qho5Dawp2WWj9CGyjtJ6/Y10xH8odjRdS6SXDaDAerU=
X-Endpoint-Received: by B4 Relay for Hermes.wu@ite.com.tw/20241230 with
 auth_id=310
X-Original-From: Hermes Wu <Hermes.wu@ite.com.tw>
Reply-To: Hermes.wu@ite.com.tw
Content-Transfer-Encoding: 7bit

From: Hermes Wu <Hermes.wu@ite.com.tw>

The driver reports the HDMI audio sampling rate and whether audio is
present through the driver-specific controls
V4L2_CID_IT6625_AUDIO_SAMPLING_RATE and V4L2_CID_IT6625_AUDIO_PRESENT.
There are now standard controls for both.

Report V4L2_CID_DV_RX_AUDIO_SAMPLING_RATE and
V4L2_CID_DV_RX_AUDIO_PRESENT instead, with the same range and the same
values. The driver-specific control IDs are no longer used.
---
 drivers/media/i2c/it6625.c | 30 ++++--------------------------
 1 file changed, 4 insertions(+), 26 deletions(-)

diff --git a/drivers/media/i2c/it6625.c b/drivers/media/i2c/it6625.c
index 72ca1d4ecdc932609f1a38129bfa1e188a024ddf..e4487e8111b94b2fa9f599e37ecd2b8a11425862 100644
--- a/drivers/media/i2c/it6625.c
+++ b/drivers/media/i2c/it6625.c
@@ -2127,28 +2127,6 @@ static const struct v4l2_subdev_internal_ops it6625_internal_ops = {
 	.init_state = it6625_init_state,
 };
 
-static const struct v4l2_ctrl_config it6625_ctrl_audio_sampling_rate = {
-	.id = V4L2_CID_IT6625_AUDIO_SAMPLING_RATE,
-	.name = "Audio Sampling Rate",
-	.type = V4L2_CTRL_TYPE_INTEGER,
-	.min = 0,
-	.max = 1536000,
-	.step = 1,
-	.def = 0,
-	.flags = V4L2_CTRL_FLAG_READ_ONLY,
-};
-
-static const struct v4l2_ctrl_config it6625_ctrl_audio_present = {
-	.id = V4L2_CID_IT6625_AUDIO_PRESENT,
-	.name = "Audio Present",
-	.type = V4L2_CTRL_TYPE_BOOLEAN,
-	.min = 0,
-	.max = 1,
-	.step = 1,
-	.def = 0,
-	.flags = V4L2_CTRL_FLAG_READ_ONLY,
-};
-
 static int it6625_v4l2_init_controls(struct v4l2_subdev *sd)
 {
 	struct it6625 *it6625 = sd_to_6625(sd);
@@ -2163,11 +2141,11 @@ static int it6625_v4l2_init_controls(struct v4l2_subdev *sd)
 				  0, 1, 0, 0);
 
 	it6625->ctrl_audio_sampling_rate =
-		v4l2_ctrl_new_custom(hdl,
-				     &it6625_ctrl_audio_sampling_rate,
-				     NULL);
+		v4l2_ctrl_new_std(hdl, NULL, V4L2_CID_DV_RX_AUDIO_SAMPLING_RATE,
+				  0, 1536000, 1, 0);
 	it6625->ctrl_audio_present =
-		v4l2_ctrl_new_custom(hdl, &it6625_ctrl_audio_present, NULL);
+		v4l2_ctrl_new_std(hdl, NULL, V4L2_CID_DV_RX_AUDIO_PRESENT,
+				  0, 1, 1, 0);
 	it6625->ctrl_audio_type =
 		v4l2_ctrl_new_std_menu(hdl, NULL, V4L2_CID_DV_RX_AUDIO_TYPE,
 				       V4L2_DV_RX_AUDIO_TYPE_ONE_BIT, 0,

-- 
2.34.1


