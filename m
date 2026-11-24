Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795489518;
	b=XOi2oEoW5Uav7K45LvxGLjeQjvuQnTd8cVpQHr8oI0YV1+FI3dcChmALQpIGB3jHNYJp
	 tPqylePP94MtRGTeqE1SNjQ6+KoQYX89KEU8MJtHbrc/T94Wig7f9Uws3EGQSwcq0kYec
	 M1qloiNn8ByWhLgLrOnH/5QqzG37av22Dk68cFJ8WsKcUK83McuyVvrq+O1rL6FBJ+c8J
	 05aJCaFA0V76VccNIriXEfGFDd26XG4IvI1Uz8CW/9cZEnH1vGUZbeRh7TvjNmIXxD2/t
	 IuBCu0k/6ynhNR25lybIX4eA3/0DzznXig6v9S0+mC3G7jrn4fYTkeHnorskdMKJLAg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795489518;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=2iyyFcVSg4IXHWI13krZgsa4ELKXfeEulZmZ6HrlhiM=;
	b=q8kQ+p2/lR8VVrFNRXYFsY9LvcSI3hsqFjmmh1bFnrVzDds02RInZZEILPdsb9tyThUf
	 DUfWb6GMu/t7w4OZL+rU3JeS1ymAqTjWR7MAgUrBZpZhsfzLtz2wQm6N1SPdaCTh+hFqw
	 uC1C5dlxgk5gHeXvk1epdnY8btlfo0tHJ7KBreuDzcESuNL7VwrAf353YuvBFWpeY7Fd0
	 OtxS4oioDicR+j12fXICAfqPkOkawX07Lv0PbkwW9f1PEnXVpvEEiwKZlQaxTmSQ9XskZ
	 M3EmjkeQiuFYFf/VSm0uD/tveUf3RlH7dQm6qL335lR6eB+aJS+9e8Z8iok8OJECizg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sa3m4iBa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8E9606A321;
	Tue, 24 Nov 2026 03:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sa3m4iBa
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795489518;
	b=JFRPNN8V0MDHqx9OjCPUnU0XOFM36NyCVSt4VMB44YA9EQMYb0CpR9eEV2nOlWJYaC3h
	 CBmqIZVV2InRg3S5dgRKaY0jJDbBpiYVlcE+jBijIwqsOwkyaCHKrGk+oNVIAQob3wcM0
	 0mVuakmMKZtrIHpqIgKvUNUCAp5k51ktNa5xFAdaWk+9Wd5x34rWqNud+duuFMbVebz3C
	 yPH0yIGXBdsilQ63BeY+zmZYgBPAJCIX4X1371LFC3vNQ30h4GtRcXFVGhbzxDi8cw1Io
	 QW4ybLZfLCvF6m+DYkaYKUym2PKQITWYcP8XCLGDMv3KhtVZvpdjNaF9ioPB+48RGTw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795489518;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=2iyyFcVSg4IXHWI13krZgsa4ELKXfeEulZmZ6HrlhiM=;
	b=AnnDnEVIF78HyjfjKZRdruifCPs8hugbqc89cqCvJlMOrcJbcGtd9Yi9pKK3GOdqPpgO
	 fVsaJijS0i8QImVVdXD+wPEy1+u6aQNKYQnw82ytmW5qytDzyoFX0hCgiXy4yhTUwd8Le
	 TRI74JWL66to9nFaOFyIqQc2oMZEWSLKGXQ7zEGdy6jlsEsxzbeuN646V66mJYa2Ni5eo
	 rHrz6oFdKhc52+wEl2r7vU5BV1nk5PUU8R93EcTJ8g2PiOMOCXh5GuZ7gy3zKXbXj0Rd5
	 p+z0q+Mn9iK4OKlxwQlUKsg5xskt6cyxM/L9DGGFYJCD1oBKDkLGsgPEenO0PNmidbg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2C3B61F000C6;
	Tue, 24 Nov 2026 03:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795489518;
	bh=2iyyFcVSg4IXHWI13krZgsa4ELKXfeEulZmZ6HrlhiM=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=Sa3m4iBa3UNSiVRd1aDSbAqdZ0Tn3O9ndNhdHqY7D25RN+yjQyuGaYmEIdzGtOuud
	 UpXiuPFcAr3cpldYlT82n4ghXZxQ6/UJIaRff5aSm5YeAeL/TdWaI74TX9NbyRhERk
	 3y9LOM720X6jDUFEmAhWWKazgBF6tn1kHtMnt+IhD75V740tbr2G5iZW2HX9sR1N96
	 lLdHoL+FzMObcBPHHY2mXyFdZeMBnTfH24KR+JJNFCchsc9KUTXPVD7BeaJwZk5sEc
	 YHPMjBoMQxhq4Uabv5HVAh77dAKVhygKMipRqV6j8f6+YcnYh7lTNyfKRH+GGH1a7R
	 6qVVp2zCTHniA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 819F04C85B;
	Tue, 24 Nov 2026 03:05:08 +0000 (UTC)
From: Hermes Wu via B4 Relay <devnull+Hermes.wu.ite.com.tw@kernel.org>
Subject: [PATCH v2 0/9] media: i2c: it6625: add HDMI audio capture over I2S
Date: Tue, 24 Nov 2026 11:04:37 +0800
Message-Id: <20261124-upstream-it6625-alsa-i2s-v2-0-a154685f6989@ite.com.tw>
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
X-B4-Tracking: v=1; b=H4sIAMX+BGsC/3WNyw6CMBBFf4XM2iFtUWhZ+R+GRQujTCKPtBU1h
 H+34trlOck9d4VAnilAna3gaeHA05hAHTJoezveCLlLDEqoUgpp8DGH6MkOyLEs1QntPVhkFdB
 YTcVRV7pzLaT57OnKrz19aRL3HOLk3/vTIr/2F5Wi+B9dJAp0zkhSujJOyDNHyttpyOMTmm3bP
 j16ZyjBAAAA
X-Change-ID: 20261019-upstream-it6625-alsa-i2s-9a8e34878dbc
To: Hermes Wu <Hermes.Wu@ite.com.tw>, 
 Mauro Carvalho Chehab <mchehab@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Hans Verkuil <hverkuil+cisco@kernel.org>, 
 Hans Verkuil <hverkuil@kernel.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>, 
 Liam Girdwood <lgirdwood@gmail.com>, linux-sound@vger.kernel.org, 
 linux-api@vger.kernel.org, Hermes Wu <Hermes.wu@ite.com.tw>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795489507; l=4862;
 i=Hermes.wu@ite.com.tw; s=20241230; h=from:subject:message-id;
 bh=vE3mJuwHS/greoet4bzWeW4mkaCUK2qOxxGLDNg9Lvw=;
 b=pgmH8rQI6cfhR1PMXnLyweUlaqR5DA93b4VupL8ghoS8YCi8aNyJgRvVfdXAB9lAcr+Up4+tN
 S5ntJGMQ5fIDMEZnp3G3VTIylfknggcFI05CuFqhiV+4UUHy8OBDd2d
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
with simple-audio-card. It also adds standard V4L2 controls for the
audio state of an HDMI receiver, and uses them in tc358743 and IT6625.

Patches 1 and 2 add read-only DV RX controls for the audio sampling
rate, audio presence and audio type to the V4L2 core.
Patch 3 makes tc358743 report the standard rate and presence controls
next to its custom ones.
Patch 4 adds the '#sound-dai-cells' and 'ite,i2s-data-lanes' properties
to the IT6625 binding.
Patch 5 decodes the IT6625 audio status registers with FIELD_GET() and
reads them in one place.
Patch 6 adds the I2S capture DAI for LPCM.
Patch 7 extends the DAI to compressed (IEC 61937) and HBR streams, and
reports the stream type through the standard audio type control.
Patch 8 switches IT6625 from its driver-specific audio rate and presence
controls to the standard ones.
Patch 9 removes the IT6625 driver-specific audio controls from the uAPI.
They came with the driver, which is in v7.4-rc1 but not in a released
kernel yet.

The series is based on media next.

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

Signed-off-by: Hermes Wu <Hermes.wu@ite.com.tw>
---
Changes in v2:
- New patches 1 and 2: standard read-only DV RX controls
  V4L2_CID_DV_RX_AUDIO_SAMPLING_RATE, V4L2_CID_DV_RX_AUDIO_PRESENT and
  V4L2_CID_DV_RX_AUDIO_TYPE, documented in ext-ctrls-dv.rst.
- New patch 3: tc358743 also reports the standard rate and presence
  controls.
- Drop the patch documenting the driver-specific IT6625 controls
  (it6625.rst); the standard controls are documented in the core.
- Patch 6 (I2S capture DAI): .shutdown re-arms the rate settle polling
  when a rate is still settling, and .startup, .hw_params and .prepare
  also update the V4L2 audio controls when they refresh the status.
- Patch 7: report the audio type through V4L2_CID_DV_RX_AUDIO_TYPE
  instead of a driver-specific control.
- New patch 8: IT6625 uses the standard rate and presence controls.
- New patch 9: remove the IT6625 driver-specific audio controls and the
  V4L2_CID_USER_IT6625_BASE reservation.
- Patch 4 (binding): add the Reviewed-by tag; no change.
- Rebase on the current media next, which now contains the IT6625 reset
  timing and DV timings fixes.
- Link to v1: https://lore.kernel.org/r/20261103-upstream-it6625-alsa-i2s-v1-0-bb91e2879b01@ite.com.tw

---
Hermes Wu (9):
      media: v4l2-ctrls: add DV RX audio sampling rate and present controls
      media: v4l2-ctrls: add the DV RX audio type control
      media: i2c: tc358743: also report the standard audio controls
      dt-bindings: media: ite,it6625: add audio DAI properties
      media: i2c: it6625: decode audio status fields with FIELD_GET()
      media: i2c: it6625: add I2S audio capture DAI
      media: i2c: it6625: capture compressed and HBR audio, not just LPCM
      media: i2c: it6625: use the standard audio rate and present controls
      media: uapi: it6625: remove the driver-specific audio controls

 .../devicetree/bindings/media/i2c/ite,it6625.yaml  |  23 +-
 .../userspace-api/media/v4l/ext-ctrls-dv.rst       |  35 +
 MAINTAINERS                                        |   1 -
 drivers/media/i2c/Kconfig                          |   1 +
 drivers/media/i2c/it6625.c                         | 905 ++++++++++++++++++---
 drivers/media/i2c/tc358743.c                       |  31 +-
 drivers/media/v4l2-core/v4l2-ctrls-defs.c          |  17 +
 include/uapi/linux/it6625.h                        |  25 -
 include/uapi/linux/v4l2-controls.h                 |  15 +-
 9 files changed, 910 insertions(+), 143 deletions(-)
---
base-commit: 48fe5a7834cc10081887d7bcd9ff0a4cadc3fa8c
change-id: 20261019-upstream-it6625-alsa-i2s-9a8e34878dbc

Best regards,
-- 
Hermes Wu <Hermes.wu@ite.com.tw>


