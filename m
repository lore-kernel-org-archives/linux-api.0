Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795489521;
	b=qljsk1nSqls9u6r5g1tJwGTEf2x5TzSKIrvi9Hh6VoOhKD323+xDsYQg9iCzMoE8lOsp
	 ct/G4k2zAOFOa10owk6O6soaXAMapTYekTRRWZiOa/RnuZ+GjLvM7hzUUK6NzV9JNlRse
	 AyGzCB89UhuuFawzi/FwFeLNyqCxPve1vWJcX4KO9RdoRBnKL7qN1P8fkj8zJntGiv8gP
	 GPDZF7mpJjX0dAkgY5opMN0i5wQOuJOSVINS377GQp9xFGIqJAaxMDqn2pA6rnn2wFNP+
	 KBGTUt/EFmN6xTNX4wxYUFsPmXxmj4IWUI1tdNwjrz45cI9qJYYgn/tDU+0HMVNjiSg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795489521;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Mqlgsq/0gNI0SAnZqOmpQVrR5kBkM5B8oSZ/hn/LhS8=;
	b=waNCljsguADnL3GYUjzwLT0RmSToP/kCAfJk+SQohU5OvCQqNcBpgRARnLXQY+LeWVyJ
	 0tVF6N5sNdrCpSsGoRLqeJboaHyDihp0Hri9joDZdoWiTiAJaEuB6lQObitdAlCzKTfK9
	 C+c8Dlcq0Qh6YF1XIvMPuupVS3bssDpCyI5VBEGq4+dH0FSr2SAIU8KQ9tZY24xARGNIL
	 MDZ0JC+XB6rJIFmVsBJqwcmDkZg3ED5s51CKJQeP6UwLotvgOKDaJkx2G9E5GvxqQI2C4
	 xBaeK5eryAoB728qDgHUPb43PlD9KjPYmVTmvEjVk9dlNHMStQllcGs4bJXQWBxfnjw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Rz/3uFYX";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84338606A32A;
	Tue, 24 Nov 2026 03:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rz/3uFYX
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795489520;
	b=k432tn16ORtQFllp/mIb8yH7nuJKm7XTxhPyy4NhDBhz/nHlj+R4t+bX0p5VtIbsM4vl
	 ibZpnQPKgyTOFtxumC8CY66pIzvZJC3YC1vwNCGvTc0oZzuXULdAgGUPLsHIatqzx79nW
	 jN7xGaQt5k3K2Tlvi1lLNpzbOucTyr/HjerziySsmzGol9S1rvsGmm3YKttOR5pb6VhQy
	 eOkzyNtAzCjaf7U9mWuAamtcpSRq2rloSHNndH0xrVXXV/dxIG6x8GWm9aYgyIk8340MM
	 zhLhrdeikcf+eJJcx5wahQBE1R3aglIIE+PnkHqfCBPx5el0ihgjPyuPEP/zS8+rz2g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795489520;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Mqlgsq/0gNI0SAnZqOmpQVrR5kBkM5B8oSZ/hn/LhS8=;
	b=JTonsQKOabAzM0EpBSGH4rcHXnW5YlbWJUsMtwmXiTOc7HWsthFToZmePXIjtHwP1Hji
	 6KwzhDT/HxFg93c8smvyYiBuLZH0OMWDXxz1aU6fthtjYoQvvfkg28nRSabFQhi67bxF8
	 YZq5sw3ftOzcK1HJd/+eTMDMEvkG2LfTGTieQSnLDGtF5jyPTgnnYsU0B3/BeDeyp+BYe
	 55zAeHu0P78fxbf0EGIhxNrRBks8yxPTv3dhlMg9b0e84OGp901k6AWciDuEaMguNXRnv
	 FOZpv7drMAzGIHL2vj1uw+uejglknVvnf4EZNP3yqZoXAvAzwDec2xCjyhbuFXZZ+mg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5ECBD1F000D0;
	Tue, 24 Nov 2026 03:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795489520;
	bh=Mqlgsq/0gNI0SAnZqOmpQVrR5kBkM5B8oSZ/hn/LhS8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Rz/3uFYXw3h6JBu0ZFBsXPBlZ+YEvR3OhFmpMJgRs9E1+7H+D3ORLe09TCXcX9aJ1
	 0ppGZfYBvmgOXDn8MYEgTmxdjo5KevIFgCqryf/gT45RM2K1Xq5vXRuS6qAnZz42P7
	 N6uKGVx0xUs/r5jIQ2LV/N6ejvuOjB0f2fZbf00bGQMjRgBCIm7nV+jeyh8Q/ZJwuf
	 UHNRZxue9IjFME/Y0vcSZp2XjEdHYe9nT5p4LBRFBy8FjgXGm254AQS2q3d/Sq2vaj
	 6VHeosLxnrOidnMX5NA+PPWkzRrJ6Hmj2N7nFz3HxDIYipWjIvQM9LuP2Eo2RbBVvJ
	 WEnWHdgeT5zDg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id DEEDA4C863;
	Tue, 24 Nov 2026 03:05:08 +0000 (UTC)
From: Hermes Wu via B4 Relay <devnull+Hermes.wu.ite.com.tw@kernel.org>
Date: Tue, 24 Nov 2026 11:04:40 +0800
Subject: [PATCH v2 3/9] media: i2c: tc358743: also report the standard
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
Message-Id: <20261124-upstream-it6625-alsa-i2s-v2-3-a154685f6989@ite.com.tw>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795489507; l=2928;
 i=Hermes.wu@ite.com.tw; s=20241230; h=from:subject:message-id;
 bh=ytAWsRiTLVmmRHZAGjnaMocH6hwobSFfACvLY218tdQ=;
 b=BnHBczbCbD+LslyqMcoasYmBx2keRAWAlGqCe6IkPyA5Hc7lHHNsvbu5vepYBiXKS1Qxnz8pB
 RktmPmNFtXACZLYLpscicbJDFrfQMARx+bAXMYDDB+R+25Qee4YWGo3
X-Developer-Key: i=Hermes.wu@ite.com.tw; a=ed25519;
 pk=qho5Dawp2WWj9CGyjtJ6/Y10xH8odjRdS6SXDaDAerU=
X-Endpoint-Received: by B4 Relay for Hermes.wu@ite.com.tw/20241230 with
 auth_id=310
X-Original-From: Hermes Wu <Hermes.wu@ite.com.tw>
Reply-To: Hermes.wu@ite.com.tw
Content-Transfer-Encoding: 7bit

From: Hermes Wu <Hermes.wu@ite.com.tw>

The driver reports the HDMI audio sampling rate and whether audio is
present through its custom controls TC358743_CID_AUDIO_SAMPLING_RATE and
TC358743_CID_AUDIO_PRESENT. There are now standard controls for both:
V4L2_CID_DV_RX_AUDIO_SAMPLING_RATE and V4L2_CID_DV_RX_AUDIO_PRESENT.

Add the standard controls and set them together with the custom ones,
from the same values. The custom controls are kept, since userspace may
already use them.
---
 drivers/media/i2c/tc358743.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index d9cd0563d50b62e90387397210e80a8b10f0988f..873fc22d030a3cc87c79e35eb57579eba902432f 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -95,6 +95,8 @@ struct tc358743_state {
 	struct v4l2_ctrl *detect_tx_5v_ctrl;
 	struct v4l2_ctrl *audio_sampling_rate_ctrl;
 	struct v4l2_ctrl *audio_present_ctrl;
+	struct v4l2_ctrl *audio_sampling_rate_std_ctrl;
+	struct v4l2_ctrl *audio_present_std_ctrl;
 
 	struct delayed_work delayed_work_enable_hotplug;
 
@@ -589,17 +591,27 @@ static int tc358743_s_ctrl_detect_tx_5v(struct v4l2_subdev *sd)
 static int tc358743_s_ctrl_audio_sampling_rate(struct v4l2_subdev *sd)
 {
 	struct tc358743_state *state = to_state(sd);
+	int rate = get_audio_sampling_rate(sd);
+	int ret;
 
-	return v4l2_ctrl_s_ctrl(state->audio_sampling_rate_ctrl,
-			get_audio_sampling_rate(sd));
+	ret = v4l2_ctrl_s_ctrl(state->audio_sampling_rate_ctrl, rate);
+	if (ret)
+		return ret;
+
+	return v4l2_ctrl_s_ctrl(state->audio_sampling_rate_std_ctrl, rate);
 }
 
 static int tc358743_s_ctrl_audio_present(struct v4l2_subdev *sd)
 {
 	struct tc358743_state *state = to_state(sd);
+	bool present = audio_present(sd);
+	int ret;
 
-	return v4l2_ctrl_s_ctrl(state->audio_present_ctrl,
-			audio_present(sd));
+	ret = v4l2_ctrl_s_ctrl(state->audio_present_ctrl, present);
+	if (ret)
+		return ret;
+
+	return v4l2_ctrl_s_ctrl(state->audio_present_std_ctrl, present);
 }
 
 static int tc358743_update_controls(struct v4l2_subdev *sd)
@@ -2217,11 +2229,20 @@ static int tc358743_probe(struct i2c_client *client)
 	}
 
 	/* control handlers */
-	v4l2_ctrl_handler_init(&state->hdl, 3);
+	v4l2_ctrl_handler_init(&state->hdl, 5);
 
 	state->detect_tx_5v_ctrl = v4l2_ctrl_new_std(&state->hdl, NULL,
 			V4L2_CID_DV_RX_POWER_PRESENT, 0, 1, 0, 0);
 
+	state->audio_sampling_rate_std_ctrl =
+		v4l2_ctrl_new_std(&state->hdl, NULL,
+				  V4L2_CID_DV_RX_AUDIO_SAMPLING_RATE,
+				  0, 768000, 1, 0);
+
+	state->audio_present_std_ctrl =
+		v4l2_ctrl_new_std(&state->hdl, NULL,
+				  V4L2_CID_DV_RX_AUDIO_PRESENT, 0, 1, 1, 0);
+
 	/* custom controls */
 	state->audio_sampling_rate_ctrl = v4l2_ctrl_new_custom(&state->hdl,
 			&tc358743_ctrl_audio_sampling_rate, NULL);

-- 
2.34.1


