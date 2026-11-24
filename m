Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795489514;
	b=sjJrlTtFPNWS216AriYqmHqxVzYHP/i/v3p45yZx89A2673+kk0lsgbok9DXwIvRycXR
	 S0Dc2xXTbWhm5RB839uzkh46eXGLhMgFVJhIExh6zCDcCysgyrHHpKddlOyydDvJQz8pA
	 2mGaNy0lEIH3qp+kS4xe71rR2i6xEJqPQC7uDsyJtp8NdTyb1p77eZp/ndpxHuM/8g6lp
	 bKEAxDcK9hNVWU14KeAjyrcYM4GSFYDD09x5TPf2laHCYpDksgvmeTy3r80TADPUyxIL7
	 b/vggLcMYF/z9MJCeP+paGOuDDKwVk5G8nP7Gsm6DlRg5WLfyoTUZvM6ZrOZtmSODxQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795489514;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=2dK7mDkn61ry6ttF+pU42hfzol8M/U6YWXu80p0q3EA=;
	b=Up6t+x6XucryekM1+UZOzuoF/Ibs5qaJcl0ADpOZqYCtB5zSSDvKzHNvTXCDNvWHQ7qp
	 TQHbDWKh/KOnDAO35fe5aXR1GH/5I7NiXhyZq6aaAuw/w3IY1opVLEeO19HIdBsggB2a2
	 ATNkRC+nG/TTAFJvQBqZ89+u7Eb4vBT/XLL3W0WwhGTp5jvFDZTDk59hVgcgKEMo0QuJ3
	 8NGHqIHpyj8wC+L2xMRhjDUyRS7PAUod0CM6RDfsTO2xfugQ8ZipjtY0aHmPB6LOS4IbE
	 Naadq23BZ3g/foAlQR7FOZ/rMb3lgOeehwOS9Pu3FL9rUzIrrBpajuCkOA4av1bbvqw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gQFN9RBB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0B4606A31E;
	Tue, 24 Nov 2026 03:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gQFN9RBB
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795489513;
	b=KePpPDVBSPK8rsnR8qn/3mcWleyow1c74VGtPEcQKTYQTQw1lsFhK9EiCVfQ28FwQI+W
	 ZBtQblxSaqS8BBK1NgZ6Eg08Bm8BROizTyOlUta4l7IDF2xBAsdPDGpgBsQR6hxoqNt+S
	 RZjNhTEXCKARxhL4ZOuL7u+4JUPrdUN9m3Ojw0kjx3eYtCqj4o518xu9cl9lTPzRU+Zby
	 ONr7+QXR1kXjPIrfw577u0UbI4JSoiCUdp1+TbaQBjfaBsSccSUKxRPMATkFn4WqL/+U3
	 HUEdIpROauG4ii/PPqCB59xY1B4sXNqv0sypY9FopNBIEKvahskFkcnLGAaqajzrFXw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795489513;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=2dK7mDkn61ry6ttF+pU42hfzol8M/U6YWXu80p0q3EA=;
	b=wsD+ERMtjVuHR16oykqzfyYIUbvTOztx1Z3S8PhHduJkUS/hBn22msRbCr9m2/Hlg0LU
	 HHcaB2dFqm/evXqBeMmWjrH2iLhxBY5Scf+ooeOmhdFIEV1OyHu8w9fraw9FWymUu9ffa
	 dvaIHRRGUv28kmgwtRd1KlzKeA105IWpojJrtVF4pIyIlX0kZ23AWameIalIm4tqJBTkj
	 z9ULDQLdJ6o4xsdFOfegnxhVFaI49b8ecP89vI1r9XicmGPraU00RSeoZLhxtxMFC7nrC
	 KWfV0GLbeBAr/TvdA2jW74JOKF0MR1NtRyQFOnvJYidHOkrAabOL4iAb5tNBmXJnXng==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2C3E51F000CA;
	Tue, 24 Nov 2026 03:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795489513;
	bh=2dK7mDkn61ry6ttF+pU42hfzol8M/U6YWXu80p0q3EA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=gQFN9RBBhrJ87xTotR/hcQm9AtVmsJ+JPHcBGdUhxPsSH8hsf2EWHv1OYQ0I8n1Br
	 h3huRevEnWJ6ZLIRaRpSwsWRy1K0iM6O4G6RM+TZVm8u84m5V4VL1P60hhnj+Y/R/v
	 IchL5oHf1QIh9+5gVbaeM6ORv0tr6yGEB0dmj/gKO/O4QbnBO5W6mdnaEbGyPfO+qb
	 0qA6jLA3q/2WIuaR4JDQokXWV/bxGxOsZhN1dJmBYY7H3elnHKiPsqaLwxoaQWnm5q
	 dhIQ5Z9YU0SbuokBql6ku1cJ0IgDqUp9wX3/pWeLtK1PUKXHhuE/q4VLpdyDMQu1kU
	 ye7GG4683rgZg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A47F64C846;
	Tue, 24 Nov 2026 03:05:08 +0000 (UTC)
From: Hermes Wu via B4 Relay <devnull+Hermes.wu.ite.com.tw@kernel.org>
Date: Tue, 24 Nov 2026 11:04:38 +0800
Subject: [PATCH v2 1/9] media: v4l2-ctrls: add DV RX audio sampling rate
 and present controls
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
Message-Id: <20261124-upstream-it6625-alsa-i2s-v2-1-a154685f6989@ite.com.tw>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795489507; l=4280;
 i=Hermes.wu@ite.com.tw; s=20241230; h=from:subject:message-id;
 bh=uONLhvOawBsUyg64gstD6rmmzirFK6ytrgkdbVqwlM8=;
 b=t+GfKiFThuL8fWNAo3CF4Yrm8Ek3DT75KcBZ23nXzADx+NpigbJNn9U/HfLF/R+Ap0r7Nw4Rz
 CXPqRhjD+1qBc3NEVOzboThjWh5VSHbIzhCGZF1vFnfMmszkqHlvhuj
X-Developer-Key: i=Hermes.wu@ite.com.tw; a=ed25519;
 pk=qho5Dawp2WWj9CGyjtJ6/Y10xH8odjRdS6SXDaDAerU=
X-Endpoint-Received: by B4 Relay for Hermes.wu@ite.com.tw/20241230 with
 auth_id=310
X-Original-From: Hermes Wu <Hermes.wu@ite.com.tw>
Reply-To: Hermes.wu@ite.com.tw
Content-Transfer-Encoding: 7bit

From: Hermes Wu <Hermes.wu@ite.com.tw>

HDMI and DisplayPort receivers can report whether the source sends audio
and at which sampling rate. Drivers expose this today through
driver-specific controls (tc358743 and IT6625 each define their own pair),
so userspace has to know every driver to find it.

Add two standard read-only controls to the DV control class:
V4L2_CID_DV_RX_AUDIO_SAMPLING_RATE, the sampling rate in Hz, 0 when no
audio is received or the rate is not known, and
V4L2_CID_DV_RX_AUDIO_PRESENT, whether audio is received. Drivers set
the range of the sampling rate control.
---
 Documentation/userspace-api/media/v4l/ext-ctrls-dv.rst | 10 ++++++++++
 drivers/media/v4l2-core/v4l2-ctrls-defs.c              |  5 +++++
 include/uapi/linux/v4l2-controls.h                     |  2 ++
 3 files changed, 17 insertions(+)

diff --git a/Documentation/userspace-api/media/v4l/ext-ctrls-dv.rst b/Documentation/userspace-api/media/v4l/ext-ctrls-dv.rst
index 5918dde83efb324cd27cc4c771245cd2c38d0b0e..a9117912e9cb255a2ce452147858d927e9e3c27a 100644
--- a/Documentation/userspace-api/media/v4l/ext-ctrls-dv.rst
+++ b/Documentation/userspace-api/media/v4l/ext-ctrls-dv.rst
@@ -158,3 +158,13 @@ enum v4l2_dv_it_content_type -
     from a computer as opposed to content from a TV broadcast or an
     analog source. See ``V4L2_CID_DV_TX_IT_CONTENT_TYPE`` for the
     available content types.
+
+``V4L2_CID_DV_RX_AUDIO_SAMPLING_RATE (integer)``
+    Reads the sampling rate, in Hz, of the audio that the receiver
+    receives from the source. It is 0 if no audio is received, or if the
+    receiver cannot determine the sampling rate. This read-only control
+    is applicable to HDMI and DisplayPort connectors.
+
+``V4L2_CID_DV_RX_AUDIO_PRESENT (boolean)``
+    Detects whether the receiver receives audio from the source. This
+    read-only control is applicable to HDMI and DisplayPort connectors.
diff --git a/drivers/media/v4l2-core/v4l2-ctrls-defs.c b/drivers/media/v4l2-core/v4l2-ctrls-defs.c
index e062f2088490470c42d6c579ff7675be454a29b0..579b2d297cc8246dddb4e8d4ab74aed1e6084744 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls-defs.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-defs.c
@@ -1180,6 +1180,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_DV_RX_POWER_PRESENT:	return "Power Present";
 	case V4L2_CID_DV_RX_RGB_RANGE:		return "Rx RGB Quantization Range";
 	case V4L2_CID_DV_RX_IT_CONTENT_TYPE:	return "Rx IT Content Type";
+	case V4L2_CID_DV_RX_AUDIO_SAMPLING_RATE: return "Rx Audio Sampling Rate";
+	case V4L2_CID_DV_RX_AUDIO_PRESENT:	return "Rx Audio Present";
 
 	case V4L2_CID_FM_RX_CLASS:		return "FM Radio Receiver Controls";
 	case V4L2_CID_TUNE_DEEMPHASIS:		return "De-Emphasis";
@@ -1317,6 +1319,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_RDS_RX_TRAFFIC_ANNOUNCEMENT:
 	case V4L2_CID_RDS_RX_TRAFFIC_PROGRAM:
 	case V4L2_CID_RDS_RX_MUSIC_SPEECH:
+	case V4L2_CID_DV_RX_AUDIO_PRESENT:
 		*type = V4L2_CTRL_TYPE_BOOLEAN;
 		*min = 0;
 		*max = *step = 1;
@@ -1682,6 +1685,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_DV_TX_EDID_PRESENT:
 	case V4L2_CID_DV_RX_POWER_PRESENT:
 	case V4L2_CID_DV_RX_IT_CONTENT_TYPE:
+	case V4L2_CID_DV_RX_AUDIO_SAMPLING_RATE:
+	case V4L2_CID_DV_RX_AUDIO_PRESENT:
 	case V4L2_CID_RDS_RX_PTY:
 	case V4L2_CID_RDS_RX_PS_NAME:
 	case V4L2_CID_RDS_RX_RADIO_TEXT:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index d17e41d51d2ec1ccb9e8ceb3ccc89ebc4381a4cd..52124b7acdeab787978029aa49ea75d0ad4cc534 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -1301,6 +1301,8 @@ enum v4l2_dv_it_content_type {
 #define V4L2_CID_DV_RX_POWER_PRESENT		(V4L2_CID_DV_CLASS_BASE + 100)
 #define V4L2_CID_DV_RX_RGB_RANGE		(V4L2_CID_DV_CLASS_BASE + 101)
 #define V4L2_CID_DV_RX_IT_CONTENT_TYPE		(V4L2_CID_DV_CLASS_BASE + 102)
+#define V4L2_CID_DV_RX_AUDIO_SAMPLING_RATE	(V4L2_CID_DV_CLASS_BASE + 103)
+#define V4L2_CID_DV_RX_AUDIO_PRESENT		(V4L2_CID_DV_CLASS_BASE + 104)
 
 #define V4L2_CID_FM_RX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_RX | 0x900)
 #define V4L2_CID_FM_RX_CLASS			(V4L2_CTRL_CLASS_FM_RX | 1)

-- 
2.34.1


