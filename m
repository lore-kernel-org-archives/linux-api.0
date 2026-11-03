Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793688634;
	b=m9+T2eS44C8fM/2KY8mRPoFZ9xuc1WwCA+fxn2uN/QUZJ4w0yNfvUOFemFwy814U/j5A
	 8lQCVGD/Lukg1xsOT6csqDb3131H3j0DnQIzAPtmVzrEH/ZsFzoAsW4IBQORNTdEPwPkl
	 0yA8IgGsEMPYOh7cThRFTnGbwVqXcotDQkYKuQnKK5CtMYUAdFahRgqNkqMhvEQ6DdOq6
	 4ubwdE7OJO1mkwFmrJCNHHygGXc6w66cLi4+Qic2TbNX6Jk5CHsKApuJ2tDdhUoADh4tx
	 aCUQITowZLfEUpy0MySOLHNwsCdvzjfPpaI/smL8MKYl18oIL5EmutisIkq/q3KI7hQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793688634;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=HwclU+gLykGCGcplaQdtPQR2+Vkq9X8QL9LHv2ipImQ=;
	b=QNN2popiyUboeQpFEYm2KR9Gs94gvW/NCMPAQPvOsMhaql6Y2G1vsAK5/nUG9AvAzdqH
	 nlaGT2qeKiDmgupzHKO/LRPLs8rpeV8PDqfUgRjgPPfA7cqiA1GwyvO6EEwponzMAOtBa
	 EygoSZDCw1MozX3bmoIsFGurz8XFBsXgD4kIRyhS1SbiDNmhfG28V4YyUscSd7LE2tCo5
	 YpFsae0pna98sTiDbs/G6FmNPDE1zrHguNMJhjtO0gW44PUqhWDXaL8GbzMIUE3gIj3lX
	 OfRwx1f/YTo3Vr8/1zogdpIo2Pwf6fFLHWkVhRXREVFyE+ogJy5zvchrGTk9tDEACCA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YOBpAbRS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C758A606A329;
	Tue,  3 Nov 2026 06:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YOBpAbRS
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793688633;
	b=GxUjPtbIEkgZv4lZNqmPL4p8/ZG2EmgLwIeU55IDoxUfXRw8e2CnV35fLgO3gmCvahVi
	 Gj/bUy+koB/BEihfGv9NAnvlQ2u3xXtugSjhEG+d+ROPEbJToXrO7JAjdvjxm/AHhJwD1
	 axsDJeHs4Mzv+q+4YxcDkcJvWJtTUNjD2VgKkNGgVwdntN1bIa6047X4JJP8xmzujCzxx
	 m5jXGZ+A1EwHHkzuj9rmWl9547APiyYzbZLnvYiH/FPgiGsYZNCAVd/bszDPbSov2TOPg
	 FbjDZc9ONvjM9EVCnErgJxVzex8TIwndJioWTmRVSkKFL8seXKKXWQsvcsD9kO/jpfA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793688633;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=HwclU+gLykGCGcplaQdtPQR2+Vkq9X8QL9LHv2ipImQ=;
	b=vmkhlwyr85/YtPf+4VUJlYYEccftZsqfBvfGZPfmYtMLvkGEPYisSJ/CwMF/lNoTMsY2
	 pYBms+lJ+RqV8+xNG0ElFlZKGusZ8eBWbUMtEAf4/DNXFbHHSGv2o/5PTYBfER7Q3hqns
	 f3Nhxp9vLOxaRpRBxsV9DiB4cS38Y1xE+OE3p+7RJt4gYJtAISMNRr7w5WpR5tm8FkQ6Q
	 1Wq+2iS18HBFhH9g7Y5K2bgFEzJHjTS/97OVnNXaOKB/3mmIcm9qye3box1VbYi6gRRsd
	 zvjmun54D+iZxVVXNCZLH5sGXG/jiPD0Of2+Sd3r65ysfBGC28Jhb1mITg3ZTDToLcQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B0ADF1F000C1;
	Tue,  3 Nov 2026 06:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793688633;
	bh=HwclU+gLykGCGcplaQdtPQR2+Vkq9X8QL9LHv2ipImQ=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=YOBpAbRS5jTu9ycyvrHBL44PEZkuV4zjn12w8l3nOpQ5YmarlQWsdozzy4ZmOoAV4
	 GytBfwI80HotAU0Sjvse6Z2Cbzw+Z7cbPD5wFvykR1GZzRuHF7LviwLd7okA09cviT
	 ZNgC/DBXU6MnqCUa6+ozXxkGIDF+HCTFjum584sDV5Gb+T5KPwccS2WkDZ8omR1gxg
	 jeRbT+GSlr3Za4XeF2Iv3vEZm+VuVxRsESPeORr+IhqpBxqTN5GWbORIseU2JWRqVI
	 OfBLJ1wHG1rQoWSke4xHEhhZ9bPzHmj9r+0WwNQxp0c38Pa8UeMy4Bdir9tqa6bRva
	 kV6lLBrzybbyQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0DB76467F7;
	Tue,  3 Nov 2026 06:50:32 +0000 (UTC)
From: Hermes Wu via B4 Relay <devnull+Hermes.wu.ite.com.tw@kernel.org>
Subject: [PATCH 0/5] media: i2c: it6625: add HDMI audio capture over I2S
Date: Tue, 03 Nov 2026 14:50:18 +0800
Message-Id: <20261103-upstream-it6625-alsa-i2s-v1-0-bb91e2879b01@ite.com.tw>
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
X-B4-Tracking: v=1; b=H4sIACqE6WoC/x3MQQrCMBBA0auEWXegiRqTXqW4GJtRBzSGTCtC6
 N0NLt/i/wbKVVhhMg0qf0TlnTvsYGB5UL4zSuoGNzpvRxtxK7pWphfK6r07IT2VUJxipMCHYzi
 HdF2g56XyTb7/9XzZ9x9IUoyyagAAAA==
X-Change-ID: 20261019-upstream-it6625-alsa-i2s-9a8e34878dbc
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793688630; l=2997;
 i=Hermes.wu@ite.com.tw; s=20241230; h=from:subject:message-id;
 bh=Nm+fsrBt7LJXn+KC2GFbWQ/8X/G2DwmBWKzhDgqwqdg=;
 b=l1cuymu/R23iIZBojovlJlGBLcPG4Zzq0c6k9OGEhwLVRMnxJNdnaXjmTdbgQq579U1xp9d2j
 IRgp47ihNlvAVKetj6CyPRXPTVLn00zkav2H3wfZxLrlMNsPJwR3x2b
X-Developer-Key: i=Hermes.wu@ite.com.tw; a=ed25519;
 pk=qho5Dawp2WWj9CGyjtJ6/Y10xH8odjRdS6SXDaDAerU=
X-Endpoint-Received: by B4 Relay for Hermes.wu@ite.com.tw/20241230 with
 auth_id=310
X-Original-From: Hermes Wu <Hermes.wu@ite.com.tw>
Reply-To: Hermes.wu@ite.com.tw

IT6625 and IT6626 decode the audio of their HDMI input and output it on
an I2S interface, driving the bit and frame clocks themselves. The audio
format is not configurable by the host; the bridge reports the stream it
passes through in read-only status registers.

This series adds an ASoC capture DAI to the IT6625 V4L2 driver, so that
this audio can be recorded through a SoC I2S controller, for example
with simple-audio-card.

Patch 1 adds the '#sound-dai-cells' and 'ite,i2s-data-lanes' properties
to the binding.
Patch 2 documents the existing driver-specific audio controls.
Patch 3 decodes the audio status registers with FIELD_GET() and reads
them in one place.
Patch 4 adds the I2S capture DAI for LPCM.
Patch 5 extends the DAI to compressed (IEC 61937) and HBR streams, and
adds a read-only audio type control.

The series is based on media next and does not depend on the pending
IT6625 reset timing [1] and DV timings [2] series; either applies before
or after this one.

Tested by capturing HDMI audio from a signal generator, a PC and a
second HDMI output looped back to the bridge, through an SoC I2S
controller with simple-audio-card:
- LPCM at 32 kHz to 192 kHz with 2 channels on one data line and 8
  channels on four data lines, from 16-bit and 24-bit sources. 128 kHz
  was not captured, as the I2S controller used does not support it.
- AC-3, DTS-HD and TrueHD bitstreams, captured bit-exact, including
  high bit rate streams on four data lines.
- Rate, channel and coding changes, unplug, AV mute and pause/resume
  while capturing, and the audio controls with no capture open.
One-bit, multi-stream and 3D audio could not be tested; the driver
rejects them.

[1] https://lore.kernel.org/r/20261007-upstream-it6625-reset-delay-v2-0-c5d6b2522bbe@ite.com.tw
[2] https://lore.kernel.org/r/20261103-upstream-it6625-dv-timings-fix-v2-0-127b879da6d3@ite.com.tw

Signed-off-by: Hermes Wu <Hermes.wu@ite.com.tw>
---
Hermes Wu (5):
      dt-bindings: media: ite,it6625: add audio DAI properties
      media: Documentation: it6625: document the audio controls
      media: i2c: it6625: decode audio status fields with FIELD_GET()
      media: i2c: it6625: add I2S audio capture DAI
      media: i2c: it6625: capture compressed and HBR audio, not just LPCM

 .../devicetree/bindings/media/i2c/ite,it6625.yaml  |  23 +-
 .../userspace-api/media/drivers/index.rst          |   1 +
 .../userspace-api/media/drivers/it6625.rst         |  48 ++
 MAINTAINERS                                        |   1 +
 drivers/media/i2c/Kconfig                          |   1 +
 drivers/media/i2c/it6625.c                         | 879 +++++++++++++++++++--
 include/uapi/linux/it6625.h                        |  25 +
 7 files changed, 899 insertions(+), 79 deletions(-)
---
base-commit: d7e7bca7169873b46e857c025c10f3336c1258d8
change-id: 20261019-upstream-it6625-alsa-i2s-9a8e34878dbc

Best regards,
-- 
Hermes Wu <Hermes.wu@ite.com.tw>


