Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793688635;
	b=egEyqT37u77zRwyx0nMlOkVrBP97vgLkq4E2S/RUMxUQqog17F0U8MrdLsI2A5IvkJPa
	 Ks5uAAlcqoDHXrBeGaM8819lMh3LdCjfw7KWYs60ItjhZFe5QQtNMw0pmC/IFDadimW6Q
	 mM3/AcVQLYqK5DnmebHk888J/dK23sJLiwUoxOMKwbIP5y5Wdx6o3GhByY7ccT4oJZ+1x
	 7E2ctlk/ev71v+5JAuWVY5hGVlsre+Nue1+StcRQ5IrdOhlzDUYzRrgE+sh8GUBiGlkVZ
	 UyO1irYkN5httnC4DjXbgA1klswvd/yn6UOOVcxX9UEndoDta3jMCNvt/vglUd3chXA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793688635;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=gg0AlHO4/xEb6Mg5/MycJ5WLOVRedSUvbjhxDhP2q88=;
	b=5PD6+EYxx+JgE+f8Vl7gnKYgnDiYzE5WSXhbCzJzUPdPgDDkph2NCQB0If+TcF13grsT
	 zFlJrX1MjVGcVQUCl5qaO82vlSSxze1+JwBQee2g2tPMf4TzcsEB2q31MbXx3QxqqBGjm
	 UNpAlzql8f+v3iWBur8JTpGir7h2SmOyABmKQBeSPLK3z61mBBQFEFOsOIW0ikVf0pU2a
	 ly5cbUXAtGFbPPESa46W6pkrHJnlVlJfXzzG3SmMLTNDZJtzIPczlXzgUyOBRTrtxOwxu
	 RwspBehmQIQ1sMI/jb6Adqv9Pz9R8qitase3uBkgLGdBASMMujfd7NH3xD4AgzvtPWw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SjBtXTam;
	arc=fail smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDEB606D809;
	Tue,  3 Nov 2026 06:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SjBtXTam
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793688635;
	b=L+mOLiI5sMPO2prItda7ZVEhBBEsaKCK1Js8U9r7HEUEsap46cCfsKqnKgAf2BTvto/2
	 lBR86np5FqqYOcZt4buPm5OzpxX9PHKJttEVtKhuRtE7Z/Vvy/AH6ixXWblDEVOX68NQQ
	 MJCG8Zs5QdkDa7UjoZJ3r0mLvaDUdGJNBxtqtr+bc9o923H834AmF4eVr1v1Uag20T931
	 S35ZoZRgDU8Qjv06oC2wIatBhDGcjQgHm3ZbuLQrOPBwBWKxQlmjfJIstiQAeit76Lt54
	 GxqAym9SfNQZl/DyAUol8O6IVQoR+n1rnfFx8ShXHqnd5YNXZnYqg8U+orEtyKQ7mhQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793688635;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=gg0AlHO4/xEb6Mg5/MycJ5WLOVRedSUvbjhxDhP2q88=;
	b=24pw1Txl4+KHYc9b+X4oYwmUI5/3Ifsywx+KqM8CJ8D9lO1jsh7OHBq2NeUKfdbzywg7
	 at3UeDw1hVtm+LaPlKnvyK76z6eVv7KfDxWM40ZRWWe16yqMs/9wWs+nrAzQF2+Y3zajs
	 iDbJp78cJu0KdCpM6X1cM9Fl4ab1SKnzrDpIdFrOzd50iWR7NPaAN2J8pXDXL3SFjORKQ
	 nBAAjxQ2EYHDCBDIFrL/nMz2Xx5DMAl8IY51ykKPHhlACDPSNEz00ktg66XqoE5rjTV56
	 SJXIriGP4+/Nf+139Dj6YdQ42j+5s22hJRu+2jtBTNgfSTn+K5cJNt8bHnAFWXRc9rA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E94FB1F00A16;
	Tue,  3 Nov 2026 06:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793688635;
	bh=gg0AlHO4/xEb6Mg5/MycJ5WLOVRedSUvbjhxDhP2q88=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=SjBtXTamn5QIX2jBLkLa2rvbVTKSyLGt/s80Vi6xJ1RiHhwv67AVnUl1rCUKh7gzh
	 iaIFVuZbGpxppJdM/M9Cl8lZhQCBNKujvnvrFjhf+DgDfUQuEZE+VkL3OP4v5nWYwe
	 K/fk4XZA7D4ug5ew61glEgHD+kVKDS3AoS3h7V3fKr4rZZLfefqL/q2nvNnvJmMizZ
	 vvsxUV3s0fTWNd9d5+ykD/u4HbftZojrHyQA+VGRlZ25cbQd2uA3wE5Ifq0vaPVBDx
	 T7JFiUWd0G/3H7k+jCYNaQ/cZZRcp4npWWSE3Mn9ou8x1pV9BHR2vL/zjhd8Yx+qYb
	 L1/K3JmhN0/AA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 52B3746807;
	Tue,  3 Nov 2026 06:50:32 +0000 (UTC)
From: Hermes Wu via B4 Relay <devnull+Hermes.wu.ite.com.tw@kernel.org>
Date: Tue, 03 Nov 2026 14:50:23 +0800
Subject: [PATCH 5/5] media: i2c: it6625: capture compressed and HBR audio,
 not just LPCM
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
Message-Id: <20261103-upstream-it6625-alsa-i2s-v1-5-bb91e2879b01@ite.com.tw>
References: <20261103-upstream-it6625-alsa-i2s-v1-0-bb91e2879b01@ite.com.tw>
In-Reply-To: <20261103-upstream-it6625-alsa-i2s-v1-0-bb91e2879b01@ite.com.tw>
To: Hermes Wu <Hermes.Wu@ite.com.tw>, 
 Mauro Carvalho Chehab <mchehab@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Hans Verkuil <hverkuil+cisco@kernel.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>, 
 Liam Girdwood <lgirdwood@gmail.com>, linux-sound@vger.kernel.org, 
 linux-api@vger.kernel.org, Hermes Wu <Hermes.wu@ite.com.tw>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793688630; l=12769;
 i=Hermes.wu@ite.com.tw; s=20241230; h=from:subject:message-id;
 bh=wCAmb2xCM57osQBwFBWEBx5wH5tevGlbpI6pt8N+xBE=;
 b=qfTfif80G70u0ulUdBpENorUL3gUtuoSyn5+E76hkYCjFGtGRuOSFTA3M7I+f4gq+TZz6Cwxa
 S7yZYpO4d7QC+Oe9PDGW4DRGb5LOq14/O+oqlgTqCQQ6hRvyTRFUKPS
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

Add a read-only "Audio Type" menu control, V4L2_CID_IT6625_AUDIO_TYPE,
so that userspace can tell LPCM, compressed, HBR and DSD streams apart
without parsing the audio InfoFrame, and document it.

Signed-off-by: Hermes Wu <Hermes.wu@ite.com.tw>
---
 .../userspace-api/media/drivers/it6625.rst         |  30 ++++++
 drivers/media/i2c/it6625.c                         | 118 ++++++++++++++++++---
 include/uapi/linux/it6625.h                        |  25 +++++
 3 files changed, 157 insertions(+), 16 deletions(-)

diff --git a/Documentation/userspace-api/media/drivers/it6625.rst b/Documentation/userspace-api/media/drivers/it6625.rst
index efd970e8124979abffb6f9ba3ea1e1bc193820b3..1c4d319f88946ef79e0d847ba0f8adf5b2132210 100644
--- a/Documentation/userspace-api/media/drivers/it6625.rst
+++ b/Documentation/userspace-api/media/drivers/it6625.rst
@@ -16,3 +16,33 @@ them are read-only and describe the audio of the HDMI input.
 ``V4L2_CID_IT6625_AUDIO_PRESENT (boolean)``
 -------------------------------------------
     Whether the bridge currently receives HDMI audio.
+
+``V4L2_CID_IT6625_AUDIO_TYPE (menu)``
+-------------------------------------
+    The coding type of the HDMI audio stream, as last read successfully from
+    the bridge. The value is kept when audio goes away or reading the audio
+    status fails, so it describes the current stream only while
+    ``V4L2_CID_IT6625_AUDIO_PRESENT`` is set and
+    ``V4L2_CID_IT6625_AUDIO_SAMPLING_RATE`` is not 0.
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 4
+
+    * - ``V4L2_IT6625_AUDIO_TYPE_LPCM``
+      - Linear PCM.
+    * - ``V4L2_IT6625_AUDIO_TYPE_NLPCM``
+      - Compressed audio in IEC 61937 format.
+    * - ``V4L2_IT6625_AUDIO_TYPE_HBR``
+      - High bit rate compressed audio in IEC 61937 format. The bridge also
+        reports this type for some compressed streams at ordinary sampling
+        rates.
+    * - ``V4L2_IT6625_AUDIO_TYPE_DSD``
+      - One-bit audio. It cannot be captured.
+
+Compressed and high bit rate streams are captured as raw IEC 61937 data. The
+capture layout follows the sampling rate, not the coding type: at 768 kHz and
+705.6 kHz the stream is captured as 8 channels at a quarter of that rate,
+which needs 4 connected I2S data lines; at other rates it is captured as 2
+channels at the sampling rate.
diff --git a/drivers/media/i2c/it6625.c b/drivers/media/i2c/it6625.c
index f1bd42ad15eda1a2bd22dac00ba11a5b1c790e71..f9cd15dc24960cf2caf98576ecccd3f803dbfd86 100644
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
@@ -322,6 +328,7 @@ struct it6625 {
 	struct v4l2_ctrl *ctrl_5v_detect;
 	struct v4l2_ctrl *ctrl_audio_sampling_rate;
 	struct v4l2_ctrl *ctrl_audio_present;
+	struct v4l2_ctrl *ctrl_audio_type;
 	struct v4l2_ctrl *ctrl_link_freq;
 
 	struct delayed_work hpd_delayed_work;
@@ -1069,6 +1076,9 @@ static int it6625_audio_update_ctrls(struct it6625 *it6625)
 	if (!ret)
 		ret = __v4l2_ctrl_s_ctrl(it6625->ctrl_audio_present,
 					 info.present);
+	if (!ret)
+		ret = __v4l2_ctrl_s_ctrl(it6625->ctrl_audio_type,
+					 info.stream.type);
 
 	v4l2_ctrl_unlock(it6625->ctrl_audio_present);
 
@@ -2124,6 +2134,25 @@ static const struct v4l2_ctrl_config it6625_ctrl_audio_present = {
 	.flags = V4L2_CTRL_FLAG_READ_ONLY,
 };
 
+static const char * const it6625_audio_type_menu[] = {
+	[V4L2_IT6625_AUDIO_TYPE_LPCM] = "LPCM",
+	[V4L2_IT6625_AUDIO_TYPE_NLPCM] = "NLPCM",
+	[V4L2_IT6625_AUDIO_TYPE_HBR] = "HBR",
+	[V4L2_IT6625_AUDIO_TYPE_DSD] = "DSD",
+	NULL,
+};
+
+static const struct v4l2_ctrl_config it6625_ctrl_audio_type = {
+	.id = V4L2_CID_IT6625_AUDIO_TYPE,
+	.name = "Audio Type",
+	.type = V4L2_CTRL_TYPE_MENU,
+	.min = V4L2_IT6625_AUDIO_TYPE_LPCM,
+	.max = V4L2_IT6625_AUDIO_TYPE_DSD,
+	.def = V4L2_IT6625_AUDIO_TYPE_LPCM,
+	.qmenu = it6625_audio_type_menu,
+	.flags = V4L2_CTRL_FLAG_READ_ONLY,
+};
+
 static int it6625_v4l2_init_controls(struct v4l2_subdev *sd)
 {
 	struct it6625 *it6625 = sd_to_6625(sd);
@@ -2131,7 +2160,7 @@ static int it6625_v4l2_init_controls(struct v4l2_subdev *sd)
 	bool cphy_3trio = it6625->bus_type == V4L2_MBUS_CSI2_CPHY &&
 			   it6625->csi_lanes == 3;
 
-	v4l2_ctrl_handler_init(hdl, 4);
+	v4l2_ctrl_handler_init(hdl, 5);
 
 	it6625->ctrl_5v_detect =
 		v4l2_ctrl_new_std(hdl, NULL, V4L2_CID_DV_RX_POWER_PRESENT,
@@ -2143,6 +2172,8 @@ static int it6625_v4l2_init_controls(struct v4l2_subdev *sd)
 				     NULL);
 	it6625->ctrl_audio_present =
 		v4l2_ctrl_new_custom(hdl, &it6625_ctrl_audio_present, NULL);
+	it6625->ctrl_audio_type =
+		v4l2_ctrl_new_custom(hdl, &it6625_ctrl_audio_type, NULL);
 	it6625->ctrl_link_freq =
 		v4l2_ctrl_new_int_menu(hdl, NULL, V4L2_CID_LINK_FREQ, 0, 0,
 				       cphy_3trio ? it6626_cphy_3trio_link_freq :
@@ -2186,26 +2217,74 @@ static unsigned int it6625_audio_max_channels(const struct it6625 *it6625)
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
@@ -2281,8 +2360,9 @@ static int it6625_dai_startup(struct snd_pcm_substream *substream,
 	struct it6625 *it6625 = dai_to_6625(dai);
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct it6625_audio_info info;
+	unsigned int channels;
 	unsigned long flags;
-	u32 gen;
+	u32 gen, rate;
 	int ret;
 
 	it6625_audio_refresh(it6625);
@@ -2298,13 +2378,16 @@ static int it6625_dai_startup(struct snd_pcm_substream *substream,
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
 
@@ -2378,18 +2461,21 @@ static int it6625_dai_hw_params(struct snd_pcm_substream *substream,
 				struct snd_soc_dai *dai)
 {
 	struct it6625 *it6625 = dai_to_6625(dai);
-	const struct it6625_audio_stream *s;
+	unsigned int channels;
 	unsigned long flags;
+	u32 rate;
 	int ret;
 
 	it6625_audio_refresh(it6625);
 
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
diff --git a/include/uapi/linux/it6625.h b/include/uapi/linux/it6625.h
index a895658aaf6a80d3fb624cdece33c5135161c72d..9ab85378ac77d1e06bc87964c1066d35ad177c15 100644
--- a/include/uapi/linux/it6625.h
+++ b/include/uapi/linux/it6625.h
@@ -22,4 +22,29 @@
  */
 #define V4L2_CID_IT6625_AUDIO_PRESENT		(V4L2_CID_USER_IT6625_BASE + 1)
 
+/*
+ * Coding type of the HDMI audio stream, as last successfully read from the
+ * bridge. Read-only menu. It is kept, not cleared, when audio goes away or
+ * a status read fails, so it describes the current stream only while
+ * V4L2_CID_IT6625_AUDIO_PRESENT is set and
+ * V4L2_CID_IT6625_AUDIO_SAMPLING_RATE is non-zero.
+ *
+ * LPCM:  linear PCM, captured as is.
+ * NLPCM, HBR: IEC 61937 compressed stream, as reported by the bridge
+ *        firmware (which also reports HBR for plain 48 kHz DTS). The
+ *        capture layout follows V4L2_CID_IT6625_AUDIO_SAMPLING_RATE: at
+ *        768/705.6 kHz (TrueHD/MAT, DTS-HD MA) 8 channels on 4 I2S lanes
+ *        at a quarter of that rate, otherwise (AC-3, DTS, ...) 2 channels
+ *        at that rate.
+ * DSD:   one-bit audio; not capturable.
+ */
+#define V4L2_CID_IT6625_AUDIO_TYPE		(V4L2_CID_USER_IT6625_BASE + 2)
+
+enum v4l2_it6625_audio_type {
+	V4L2_IT6625_AUDIO_TYPE_LPCM = 0,
+	V4L2_IT6625_AUDIO_TYPE_NLPCM = 1,
+	V4L2_IT6625_AUDIO_TYPE_HBR = 2,
+	V4L2_IT6625_AUDIO_TYPE_DSD = 3,
+};
+
 #endif /* _UAPI_LINUX_IT6625_H */

-- 
2.34.1


