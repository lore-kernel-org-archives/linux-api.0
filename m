Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795489529;
	b=EBE61dq0/2vXBfKqoeQZP35/umojVvPufU5CGi39WgGHeRwBWANs3QD6WG5Z4/DbEze+
	 QClzkTAUnaISBjVHcsYsvtU+w9EeiQOpqitIYESVBaxy8yZnQzn5fHce7vYJ6dmao+L8u
	 cBM6I5tKeb/7Bd/AJakQH/PgTnim0ALyzjLgGqb94lK2GJ40XFBOeJrB2R9vGMa+sKYl5
	 ypIrwfHnXztaRWL8YJxGcujxNrifxT2aCkipVe1oPHbOC1qZQ5QIH0XcuSUAupumv44Q7
	 ztZco87LvsPbScUr72HXmBHPaZtkMqCk2xRRmeFxwONp5690CADSLeB3w3g3f6cYtAg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795489529;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=5UtVNDy3703XnlAZ+7W2/WQ6dpIQQzv6TBWFjI9UL0Y=;
	b=RmPqwqRpazo/GV7kxNtqa4AxBxJUpzV5GK4lg16nPZz2YFuTk2Eg0O8hwkvdCk3ze1+Q
	 pv8P5pWgtn+fQVCG4EQjbnHK/MmDySZ/P0ao0150YdeqibGVffj9Z4JQt5r86YBFrxlXZ
	 AlsptuzxB14b6sXL9F/ENDLyv4a8vQYNhNyWcJK0vyf+zSc+B4KnuJ63f3cn6+OCBeY8E
	 hh4X64T67EnrIjQToXQN7OJZufFiGgAoCqKJNuOQSFKJj8eY8GzAee9asv3XxLfE2O9Ix
	 0Q65m5oea/VnhY37rPgguHtfNc4WO7jL4cGs29hbv+ojNW6hqAu939Kp3BqgPR8y8Mg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WxULXwHy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2E0606A6B8;
	Tue, 24 Nov 2026 03:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WxULXwHy
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795489529;
	b=kcN4ISuHwaxQjZVzp5IzlLtmwWGnnANwE84wyLjRhNEQsD1sUFL4vWBORQm2mckieeOP
	 94UOHv+vybpkNTJT15nCi9v2LFcCSshvZPPJIh+g6ppQaNmu5xDLqel1gvelqOKnDugZD
	 lf4LHa8/OsjP7DCT2xJV/huSxVlIEvr9+Naedbv9bKMZS7a/KOww73/lDToJLELR4rDsW
	 z2hM8nhD85RnN1F1UotuRiZkGtcmiTk0xU3y/c+ntzhthp8JqaSWmbuGT8hOuAjCGOWss
	 ir16m25OyrNpq67o/fyhDPu3bpQg20VZIvM6e1S2ZwjUt7W8hRZf+lkJ1Ny9angyl/Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795489529;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=5UtVNDy3703XnlAZ+7W2/WQ6dpIQQzv6TBWFjI9UL0Y=;
	b=A+YPUC2TZFp9y9yZnU3PGhL4RHbzcVqb6f0CfmgciGuBDkKxw5mVbJRgLoluYG7/KP30
	 3t9gwYSN/mm6cZrl6h7e+jVymKo5jA0v5qBitld+EBOagQzWiOfV0Kh80o3iJ515bMF3T
	 9owS+Tjkx7U6nQdjxQYJ6y2s5XjQF5b/r95xYh9/wd0v3Qu65iwsDZIkGplUBHSdAz2QD
	 +QJT1AVTskMFEG06TzwoQ6ZHItVukheXlcuCiCYPrc4PlGlRLY8PCy9fB2EqdaZp9BjXk
	 Jf/d8Yoar0XfKntB5x8Fixbu2qtvdEF/yVEUJ8sHFq9ZllS45rEsVuYVMCvHTWShmoA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2B0C31F0093C;
	Tue, 24 Nov 2026 03:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795489529;
	bh=5UtVNDy3703XnlAZ+7W2/WQ6dpIQQzv6TBWFjI9UL0Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=WxULXwHyuwJS+/u3ZD/3LE+vGJvg4wORPMaTCq93qqZS32D7XHAnsqB3NMm49AUFB
	 9DsC1Z+STR/930WMz/9f+78G9auIqVduA6bJ8WZ9W+bEudNj5648XfMKxcTXo6wBoV
	 u7t22Q3hjDaenK6w5W2of7QZCSfsVwYAx1Im7sZKPPfRIw1Nlzs96QBmKZGJHd7Tra
	 mYa64+nxIUTR8yPsLUuJtJwfCjfNOWUPweV7utjgOEp4i2kJdr0cnzU1QHbnfWYc8O
	 TrKe7thIj9gcvtoH6lDMlAl1JlVagcHiEtrZdraIvfcTK/JWa13lD4E4Gb2WXxiooK
	 9uTD84JUIlomQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 635074C873;
	Tue, 24 Nov 2026 03:05:09 +0000 (UTC)
From: Hermes Wu via B4 Relay <devnull+Hermes.wu.ite.com.tw@kernel.org>
Date: Tue, 24 Nov 2026 11:04:44 +0800
Subject: [PATCH v2 7/9] media: i2c: it6625: capture compressed and HBR
 audio, not just LPCM
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
Message-Id: <20261124-upstream-it6625-alsa-i2s-v2-7-a154685f6989@ite.com.tw>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795489507; l=9188;
 i=Hermes.wu@ite.com.tw; s=20241230; h=from:subject:message-id;
 bh=vfR3wi4Sj1lgyTacMXk/A4Np+NZCoiTxtEXqzw0T+4M=;
 b=t8K2v2/jH0kt0GseN/BD2sfsEl+Uq44WEFLpZL9V3xx9Hme8s2uEMj+EjydapPwnW/oaGwkBU
 j9XFq4CpwueDnCaRpBtOoF0/ibPJGbdKZF3s/f8oFpPJTHjBHNPGJkq
X-Developer-Key: i=Hermes.wu@ite.com.tw; a=ed25519;
 pk=qho5Dawp2WWj9CGyjtJ6/Y10xH8odjRdS6SXDaDAerU=
X-Endpoint-Received: by B4 Relay for Hermes.wu@ite.com.tw/20241230 with
 auth_id=310
X-Original-From: Hermes Wu <Hermes.wu@ite.com.tw>
Reply-To: Hermes.wu@ite.com.tw
Content-Transfer-Encoding: 7bit

From: Hermes Wu <Hermes.wu@ite.com.tw>

The capture DAI accepts only LPCM. The bridge also outputs compressed
IEC 61937 streams (AC-3, DTS, ...) and high bit rate (HBR) streams
(Dolby TrueHD/MAT, DTS-HD Master Audio) on the same I2S interface, but
these are rejected.

Add it6625_audio_xport(), which derives the I2S frame rate and slot
count from the stream's coding type and sampling rate. LPCM is
unchanged. A compressed stream is carried in 2 slots at its own
sampling rate, except at the HBR rates of 768 kHz and 705.6 kHz, where
one IEC 61937 stream is spread over 8 slots on 4 data lines at a quarter
of that rate. The bridge firmware also reports the HBR coding type for
some compressed streams at ordinary rates, such as 48 kHz DTS, so the
sampling rate, not the coding type, selects the layout. A compressed
stream at 768 kHz or 705.6 kHz is rejected when fewer than 4 data lines
are connected.

Use the derived rate and channel count in the eligibility check, the
startup constraints and the hw_params comparison. DSD is still
rejected. The driver does not parse the compressed data: userspace
receives the IEC 61937 words as they are.

Report the stream's type through the standard V4L2_CID_DV_RX_AUDIO_TYPE
control, so that userspace can tell LPCM, compressed, HBR and one-bit
streams apart without parsing the audio InfoFrame.

Signed-off-by: Hermes Wu <Hermes.wu@ite.com.tw>
---
 drivers/media/i2c/it6625.c | 109 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 93 insertions(+), 16 deletions(-)

diff --git a/drivers/media/i2c/it6625.c b/drivers/media/i2c/it6625.c
index 4a6ab00f04013b874e9af13f26e88f90fcbc3989..72ca1d4ecdc932609f1a38129bfa1e188a024ddf 100644
--- a/drivers/media/i2c/it6625.c
+++ b/drivers/media/i2c/it6625.c
@@ -101,6 +101,9 @@ MODULE_PARM_DESC(debug, "debug level (0-3)");
 #define REG_HDMI_AUDIO_INFO3 0x6D
 #define M_AUD_TYPE  GENMASK(1, 0)
 #define AUD_TYPE_LPCM 0
+#define AUD_TYPE_NLPCM 1
+#define AUD_TYPE_HBR 2
+#define AUD_TYPE_DSD 3
 #define B_AUD_MS  BIT(2)
 #define B_AUD_3D  BIT(3)
 
@@ -119,6 +122,9 @@ MODULE_PARM_DESC(debug, "debug level (0-3)");
 #define IT6625_AUDIO_MAX_LANES 8
 #define IT6625_AUDIO_MAX_CHANNELS 8
 #define IT6625_AUDIO_MAX_RATE 192000
+/* HBR: one IEC 61937 stream spread over 4 lanes (8 slots) per frame */
+#define IT6625_AUDIO_HBR_LANES 4
+#define IT6625_AUDIO_HBR_CHANNELS 8
 /* status re-check period while a capture stream is open */
 #define IT6625_AUDIO_REFRESH_MS 200
 /* re-checks after an event that left present audio without a valid rate */
@@ -327,6 +333,7 @@ struct it6625 {
 	struct v4l2_ctrl *ctrl_5v_detect;
 	struct v4l2_ctrl *ctrl_audio_sampling_rate;
 	struct v4l2_ctrl *ctrl_audio_present;
+	struct v4l2_ctrl *ctrl_audio_type;
 	struct v4l2_ctrl *ctrl_link_freq;
 
 	struct delayed_work hpd_delayed_work;
@@ -1065,6 +1072,14 @@ static void it6625_audio_refresh(struct it6625 *it6625)
 	spin_unlock_irqrestore(&it6625->audio_lock, flags);
 }
 
+/* AUD_TYPE (2 bits) to V4L2_CID_DV_RX_AUDIO_TYPE */
+static const u8 it6625_audio_type_to_v4l2[] = {
+	[AUD_TYPE_LPCM] = V4L2_DV_RX_AUDIO_TYPE_LPCM,
+	[AUD_TYPE_NLPCM] = V4L2_DV_RX_AUDIO_TYPE_IEC61937,
+	[AUD_TYPE_HBR] = V4L2_DV_RX_AUDIO_TYPE_HBR,
+	[AUD_TYPE_DSD] = V4L2_DV_RX_AUDIO_TYPE_ONE_BIT,
+};
+
 /*
  * Selecting the published sample and writing both controls happen under
  * the control handler lock, so a stale sample never overwrites a newer one.
@@ -1086,6 +1101,9 @@ static int it6625_audio_update_ctrls(struct it6625 *it6625)
 	if (!ret)
 		ret = __v4l2_ctrl_s_ctrl(it6625->ctrl_audio_present,
 					 info.present);
+	if (!ret)
+		ret = __v4l2_ctrl_s_ctrl(it6625->ctrl_audio_type,
+					 it6625_audio_type_to_v4l2[info.stream.type]);
 
 	v4l2_ctrl_unlock(it6625->ctrl_audio_present);
 
@@ -2138,7 +2156,7 @@ static int it6625_v4l2_init_controls(struct v4l2_subdev *sd)
 	bool cphy_3trio = it6625->bus_type == V4L2_MBUS_CSI2_CPHY &&
 			   it6625->csi_lanes == 3;
 
-	v4l2_ctrl_handler_init(hdl, 4);
+	v4l2_ctrl_handler_init(hdl, 5);
 
 	it6625->ctrl_5v_detect =
 		v4l2_ctrl_new_std(hdl, NULL, V4L2_CID_DV_RX_POWER_PRESENT,
@@ -2150,6 +2168,10 @@ static int it6625_v4l2_init_controls(struct v4l2_subdev *sd)
 				     NULL);
 	it6625->ctrl_audio_present =
 		v4l2_ctrl_new_custom(hdl, &it6625_ctrl_audio_present, NULL);
+	it6625->ctrl_audio_type =
+		v4l2_ctrl_new_std_menu(hdl, NULL, V4L2_CID_DV_RX_AUDIO_TYPE,
+				       V4L2_DV_RX_AUDIO_TYPE_ONE_BIT, 0,
+				       V4L2_DV_RX_AUDIO_TYPE_LPCM);
 	it6625->ctrl_link_freq =
 		v4l2_ctrl_new_int_menu(hdl, NULL, V4L2_CID_LINK_FREQ, 0, 0,
 				       cphy_3trio ? it6626_cphy_3trio_link_freq :
@@ -2193,26 +2215,74 @@ static unsigned int it6625_audio_max_channels(const struct it6625 *it6625)
 	return min(2U * it6625->audio_lanes, IT6625_AUDIO_MAX_CHANNELS);
 }
 
+/*
+ * I2S frame rate and slot count that carry this stream. Pure, callable in
+ * atomic context; returns -ENODEV for a stream the I2S output can't carry.
+ *
+ * LPCM goes out as is. A compressed IEC 61937 stream at up to 192 kHz
+ * takes 2 slots at its own sampling rate, whatever channel count the
+ * source signals. An HBR stream (AUD_FS 768 or 705.6 kHz) is one IEC 61937
+ * stream at 4x the frame rate spread over 4 lanes: 8 slots at a quarter of
+ * that rate.
+ *
+ * The firmware doesn't keep AUD_TYPE to its documented meaning: it reports
+ * HBR for a plain 48 kHz DTS stream too. So the rate, not NLPCM vs. HBR,
+ * selects the layout of a compressed stream.
+ */
+static int it6625_audio_xport(const struct it6625 *it6625,
+			      const struct it6625_audio_stream *s,
+			      u32 *rate, unsigned int *channels)
+{
+	u32 fs = it6625_audio_fs_to_rate(s->fs_code);
+
+	if (!fs)
+		return -ENODEV;
+
+	switch (s->type) {
+	case AUD_TYPE_LPCM:
+		*rate = fs;
+		*channels = s->channels;
+		break;
+	case AUD_TYPE_NLPCM:
+	case AUD_TYPE_HBR:
+		if (fs == 768000 || fs == 705600) {
+			*rate = fs / IT6625_AUDIO_HBR_LANES;
+			*channels = IT6625_AUDIO_HBR_CHANNELS;
+		} else {
+			*rate = fs;
+			*channels = 2;
+		}
+		break;
+	default:
+		return -ENODEV;
+	}
+
+	if (*rate > IT6625_AUDIO_MAX_RATE)
+		return -ENODEV;
+
+	if (*channels < 2 || *channels % 2 ||
+	    *channels > it6625_audio_max_channels(it6625))
+		return -ENODEV;
+
+	return 0;
+}
+
 /* can this audio status be captured? Pure check, callable in atomic context. */
 static int it6625_audio_check(const struct it6625 *it6625,
 			      const struct it6625_audio_info *info)
 {
 	const struct it6625_audio_stream *s = &info->stream;
-	u32 rate = it6625_audio_fs_to_rate(s->fs_code);
+	unsigned int channels;
+	u32 rate;
 
 	if (!info->read_ok || !info->vid_stable || !info->present ||
 	    info->avmute)
 		return -ENODEV;
 
-	if (s->out_if != AUD_OUT_IF_I2S || s->type != AUD_TYPE_LPCM ||
-	    s->multi_stream || s->is_3d)
-		return -ENODEV;
-
-	if (!rate || rate > IT6625_AUDIO_MAX_RATE)
+	if (s->out_if != AUD_OUT_IF_I2S || s->multi_stream || s->is_3d)
 		return -ENODEV;
 
-	if (s->channels < 2 || s->channels % 2 ||
-	    s->channels > it6625_audio_max_channels(it6625))
+	if (it6625_audio_xport(it6625, s, &rate, &channels))
 		return -ENODEV;
 
 	if (!it6625_audio_wl_bits(s->i2s_wl))
@@ -2288,8 +2358,9 @@ static int it6625_dai_startup(struct snd_pcm_substream *substream,
 	struct it6625 *it6625 = dai_to_6625(dai);
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct it6625_audio_info info;
+	unsigned int channels;
 	unsigned long flags;
-	u32 gen;
+	u32 gen, rate;
 	int ret;
 
 	it6625_s_ctrl_audio(&it6625->sd);
@@ -2305,13 +2376,16 @@ static int it6625_dai_startup(struct snd_pcm_substream *substream,
 	if (ret)
 		return ret;
 
+	/* the check above passed, so this can't fail */
+	it6625_audio_xport(it6625, &info.stream, &rate, &channels);
+
 	ret = snd_pcm_hw_constraint_single(runtime, SNDRV_PCM_HW_PARAM_RATE,
-					   it6625_audio_fs_to_rate(info.stream.fs_code));
+					   rate);
 	if (ret < 0)
 		return ret;
 
 	ret = snd_pcm_hw_constraint_single(runtime, SNDRV_PCM_HW_PARAM_CHANNELS,
-					   info.stream.channels);
+					   channels);
 	if (ret < 0)
 		return ret;
 
@@ -2389,18 +2463,21 @@ static int it6625_dai_hw_params(struct snd_pcm_substream *substream,
 				struct snd_soc_dai *dai)
 {
 	struct it6625 *it6625 = dai_to_6625(dai);
-	const struct it6625_audio_stream *s;
+	unsigned int channels;
 	unsigned long flags;
+	u32 rate;
 	int ret;
 
 	it6625_s_ctrl_audio(&it6625->sd);
 
 	spin_lock_irqsave(&it6625->audio_lock, flags);
 	ret = it6625_audio_validate_locked(it6625);
-	s = &it6625->audio_accepted;
+	if (!ret)
+		ret = it6625_audio_xport(it6625, &it6625->audio_accepted,
+					 &rate, &channels);
 	if (!ret &&
-	    (params_rate(params) != it6625_audio_fs_to_rate(s->fs_code) ||
-	     params_channels(params) != s->channels ||
+	    (params_rate(params) != rate ||
+	     params_channels(params) != channels ||
 	     params_format(params) != SNDRV_PCM_FORMAT_S32_LE))
 		ret = -EINVAL;
 	spin_unlock_irqrestore(&it6625->audio_lock, flags);

-- 
2.34.1


