Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793688635;
	b=FAc9fN8S7oKUigjQHiIr1DmF9Ro0LV1VoKRcnrNBSIdj68ZTp8b6BoaRvlAAaD383+Zz
	 G+pngVxb1EpgYLdQsmpOyUYA9bbL0jve9XHrtusicYQPD+VLMNgyE+27bBK2khPd2d3gv
	 JHhTxGOERhg0qH+SlYwbD+ZKpKwzVtIBySpdR+2z9wYHLlm1q6S7pdrcIrBDz4nwWm/l+
	 G6VL6dfyfFsm22UWLHtXShxGfhwCTJnDIg8/oNXFPp2iOAjP6tgrIKLWGprQ6whmowjdD
	 kqDp583QDdX4Ecxpc8siZP3aQQ7/FA99HkS5TTariU0y2Kg3oZMufTQjbewHFurb4PA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793688635;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=O/68xx5ufGD2Z5hepHuRXosJTqiGTE6W1d6Jm9B2bcE=;
	b=xQo3+0EsFocxQGm6IFRDCPk+FEn5QasHiNy+/siVg6CYTeN2jzi+eKWh6HTyCautgKZs
	 sXnbm0+n+41xIyRBuHqOmimGWbZwCUvzMeeyqNxZbaUBtJ3YrrEkODzpFxGLTkPBMRNI5
	 Ln0gmtUCq54MnYxdpUmqNNU9uIV7tRcDxkpoeWOHuRfU5lru5RR2x44rsju2t802uLVki
	 OHsf5y1E20WxVAf6HnZlU8KlsQ0ynwsckeiUJ//aN3EEBX46eHKzcn7K6Vc0KGoTKzXYe
	 R9hyk9+xL1qD2AQT3DVqF1xsspU5F5fcuIod1HCMaAQyub5aMVeD7imVABRJmIKAuTw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fY2gVT9l;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B77606A330;
	Tue,  3 Nov 2026 06:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fY2gVT9l
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793688634;
	b=rlH5KNnhpRjCAu4E9mgIy1cwZ4Qf3slrJrYVPJJjfiX4ZSRHvDSkn0hgKXqhOw9WUsZo
	 yfzdu6mMXQxGB3Dsi+47u+I/9fgLjdHOABpGmGjn7L7bSeUu622D4HHXeAQMhA5oaSS5G
	 Y7sUpUQ0z87h6fbnnCxcxHeYHUd/ZMsZ33HLsERAqgXIZLrQmGP4S7RWBvNBr/OC37l5N
	 IX/1YEUSmpxosjTBV9mdsOmBlf56rPGbp249qd9T+k4unLiPV9AC8HCxm+C1lEjzP/553
	 OND2Ty3XnMOXllr5DGfPnXByh+hvVyMxeKwwGqoU6WEFMfmEiupBpm7MZRkVb8TkbaQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793688634;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=O/68xx5ufGD2Z5hepHuRXosJTqiGTE6W1d6Jm9B2bcE=;
	b=OUnxswREcT5s7EwFItZSCQe/4OX28YA0LvluwsCDcKyGpCowLhGKq+05KYv+50NuEieF
	 joZR06IFXOsU9e4++WSxThiqcdjnqFj9nko7D1yN2xRBVwJ6HJK8+p5LALjp5d0F0coHP
	 u1jiBczy9xAqFOqc/AUWNbYllG9tT+YCFSzZkdmxAjneObQqP0wEah4tFyRQZWJS7ypvb
	 qLPtBeo+/dlG391EV+ljBK/dAG2IpwVF49YAn8kJ2PZkq5xoZKr4mbQQvv6NrR8tDKuLy
	 FGO/jVCfF/xdYcsbSDW0usTtunyW9qAGekej5IgjbihtxUOQIKewEMbfkEBUDyEPIlQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B20D61F0093A;
	Tue,  3 Nov 2026 06:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793688634;
	bh=O/68xx5ufGD2Z5hepHuRXosJTqiGTE6W1d6Jm9B2bcE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=fY2gVT9l9nyihxuTya/00m/PQ706ZyPoNgqfCuev+KAgpg2RxmFss3/j+fi3gAK35
	 HMPO1PJr3CTmQ+iSVKrf/zzb3fOCvcv2Pw+UuS53SOSfdEhD/JK+eynDcjWCxFHtZy
	 uVuagZh4xQWRGzIfRoCFSuwCu58Feq9WloZg5p3nTut2899lkK5cFI6/ZnTO7TzCsr
	 q7CcJEE8W8vBUB1aAsZFeBD7ZjYbuB0DSvRU7n60W40FiBggAVXl2l5LTnWjlDYRc3
	 nOmLp3Z0ocMJpYUHbxB3UVkqRn/EQ4ih8f/uYTGgoKJxCDvsr0QfMwTa91ajMwn1a0
	 5W3nx+uIvp4OQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2B3F5467FB;
	Tue,  3 Nov 2026 06:50:32 +0000 (UTC)
From: Hermes Wu via B4 Relay <devnull+Hermes.wu.ite.com.tw@kernel.org>
Date: Tue, 03 Nov 2026 14:50:20 +0800
Subject: [PATCH 2/5] media: Documentation: it6625: document the audio
 controls
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
Message-Id: <20261103-upstream-it6625-alsa-i2s-v1-2-bb91e2879b01@ite.com.tw>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793688630; l=2749;
 i=Hermes.wu@ite.com.tw; s=20241230; h=from:subject:message-id;
 bh=ysI2023N4J3uX9hTybs3IcHa3N84jOblyDxxemwdqPk=;
 b=Wf/UUYj5V/9n6qXXtNTs44d/blo0+4IUpelP+53k//2gxOddpy6cz7WNwMeFlVbeyTTk/uaPf
 DtnLq6Y8VX6CwLx7D3L0akmMLNih8WZXkCt04zH/i5gBhBLAU2VZta4
X-Developer-Key: i=Hermes.wu@ite.com.tw; a=ed25519;
 pk=qho5Dawp2WWj9CGyjtJ6/Y10xH8odjRdS6SXDaDAerU=
X-Endpoint-Received: by B4 Relay for Hermes.wu@ite.com.tw/20241230 with
 auth_id=310
X-Original-From: Hermes Wu <Hermes.wu@ite.com.tw>
Reply-To: Hermes.wu@ite.com.tw
Content-Transfer-Encoding: 7bit

From: Hermes Wu <Hermes.wu@ite.com.tw>

The IT6625 driver exposes two read-only driver-specific controls,
V4L2_CID_IT6625_AUDIO_SAMPLING_RATE and V4L2_CID_IT6625_AUDIO_PRESENT,
which so far are described only in the uAPI header.

Add a page for the driver to the V4L2 driver-specific documentation that
describes both controls, and list it in MAINTAINERS.

Signed-off-by: Hermes Wu <Hermes.wu@ite.com.tw>
---
 Documentation/userspace-api/media/drivers/index.rst  |  1 +
 Documentation/userspace-api/media/drivers/it6625.rst | 18 ++++++++++++++++++
 MAINTAINERS                                          |  1 +
 3 files changed, 20 insertions(+)

diff --git a/Documentation/userspace-api/media/drivers/index.rst b/Documentation/userspace-api/media/drivers/index.rst
index 8d2c489b8453e11b8e15ef9d9c1c0312f3da06af..57be8dd5749d7f5aa6e0e21c7e3d89d377a209d0 100644
--- a/Documentation/userspace-api/media/drivers/index.rst
+++ b/Documentation/userspace-api/media/drivers/index.rst
@@ -33,6 +33,7 @@ For more details see the file COPYING in the source distribution of Linux.
 	dcmipp
 	dw100
 	imx-uapi
+	it6625
 	mali-c55
 	max2175
 	npcm-video
diff --git a/Documentation/userspace-api/media/drivers/it6625.rst b/Documentation/userspace-api/media/drivers/it6625.rst
new file mode 100644
index 0000000000000000000000000000000000000000..efd970e8124979abffb6f9ba3ea1e1bc193820b3
--- /dev/null
+++ b/Documentation/userspace-api/media/drivers/it6625.rst
@@ -0,0 +1,18 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+ITE IT6625/IT6626 HDMI to MIPI bridge driver
+============================================
+
+The IT6625 driver implements the following driver-specific controls. All of
+them are read-only and describe the audio of the HDMI input.
+
+``V4L2_CID_IT6625_AUDIO_SAMPLING_RATE (integer)``
+-------------------------------------------------
+    The sampling rate of the HDMI audio stream, in Hz. 0 means that the rate
+    is not available: there is no stable input signal or no audio, the bridge
+    reported a rate code that the driver does not recognize, or reading the
+    audio status failed.
+
+``V4L2_CID_IT6625_AUDIO_PRESENT (boolean)``
+-------------------------------------------
+    Whether the bridge currently receives HDMI audio.
diff --git a/MAINTAINERS b/MAINTAINERS
index 760791e3635f3c306e7fed7240b948d29b45ae66..1d6de374d86d3046d993bf220195b1a75049fa8a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13972,6 +13972,7 @@ M:	Hermes Wu <Hermes.Wu@ite.com.tw>
 S:	Maintained
 T:	git git://linuxtv.org/media.git
 F:	Documentation/devicetree/bindings/media/i2c/ite,it6625.yaml
+F:	Documentation/userspace-api/media/drivers/it6625.rst
 F:	drivers/media/i2c/it6625.c
 F:	include/uapi/linux/it6625.h
 

-- 
2.34.1


