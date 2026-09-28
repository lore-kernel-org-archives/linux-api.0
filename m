Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BDE4A0F09
	for <linux-api@vger.kernel.org>; Mon, 28 Sep 2026 11:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790594356; cv=none; b=VDaIzRY10Qn9u2X6d7Ifl82g14ihcihE6zTOPXEB91g4eB7FAWckJABli//r1wiig2eF2rhahXqDNX091YTCAeoCHj0112DDsgn4+QY7YC+Ju1Qj3OVKcw8WPgrQP/y6nccyJuGfKghtsXC8CTj5ME/G6GhW4KI4eWD91LasO5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790594356; c=relaxed/simple;
	bh=kO3ynIq/wB6ie8eo0zrTf/NB7cypH/DrpREYSikioVs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IBHIRCzP3+O6DnsCM+odDZ/wuwsrgn9nvPAIOJo20Iw7/Sw457UlQI8+xcH4mXD971f3hiYlnALjjkCa06QifaMmdl5mHnRv1voxGWwDkaDTa7jYytVUWU8ysnh247HmGMcyHfLFS7lCNYJq3cXP/DPN32vEsydGtVnuGuCLea4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QkPMsord; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QkPMsord"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-4885d4825adso1727823f8f.0
        for <linux-api@vger.kernel.org>; Mon, 28 Sep 2026 04:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790594353; x=1791199153; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wc84nfWgNf4LDDPo4HpZtovz6WNxAg7/CHpGE5J6vyA=;
        b=QkPMsord9VJSackfuNx9kszICrztNypybkDjzQfhCx3uLQAzzisZ63FC1ij24rMPuz
         PQQWTCmlABDhdeSgaGhEISAGUtv9toayM0hbPsZSR5PEr436Kri5E5CY3PfZQMmDMn8c
         eHlxu9Dje2wpoYJ6TBT94q5XxUgK2NV6AhnJjb7vdBJbw3VncRjsOH7teYlHT1OIq4dd
         isH0Ce1hkpppqzI+DbgyrirnHMYTJ7kFfc/daHa5yvf21uKv02Y9l0/Ex6fAle3sMpA6
         W2jARPsqk7JMN3MV5g7PhkMexO3Ndnl+a0ZOkD6II/X3GChKi9PkptEcEs62Rkigtv3n
         EkNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790594353; x=1791199153;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wc84nfWgNf4LDDPo4HpZtovz6WNxAg7/CHpGE5J6vyA=;
        b=cOrNd7DGBK4OFFyaY7uO0tzZM8tr/T3r5bwTSPZP1OQp30qnh/nAit2yXsZpaQnbkH
         RJqq8g3rc6c4+IKhJgUuN/jjehQlTGJIu+Tbw/m72mWVT6H33jgSp0bEI9y6DPlvqa0R
         mQs6FWuJ36OvJK5tZP1G+1CAI4oRtBt28O2r4ACwSy0xM0hWRfjPgGBrD17G7STTo8vK
         K2DQYrGH0Hn1jJiYqbZxfIE/4xyQ0d2OnJqPMrum5yMFAe/VcmAma14fx7WbmokXVyeq
         whbFjwy3H5BG0lcZHQcS4PLwTUVkh2rnIUfrtfsnNQZxs1fX7mZnCE44n7Dq8ovBGd/B
         Hnkg==
X-Forwarded-Encrypted: i=1; AKwUvBxwgeBnJiteIHqsVRfOR4K7TFJyHopzLN3ys961VGY70oLt6iryEn0xgtGtUyPJ/Y614rnot4/ihmc=@vger.kernel.org
X-Gm-Message-State: AFq9FYLTfKcc7t8gAgOymCN8PoISZQ7x/WKrWXI1un3Dclpk1Sluc6dQ
	FpPvUiHSq3LR4TKoswLbXSf7y0o1nFJVyS8BWiERXymne0kKBbhSIhu5
X-Gm-Gg: AYBFou2lM8HT7302WyHSi8GZ3x2SEBkm2mm0i8PhaHVN4ySlMo+WJ9ha6AN8LvBycSy
	UV7go2l+t9d9jTxJwobB3koEjxk2zy/2hBw4IuN7Lu3Wz2YjJem3Bl4cBg/CRsg8rJ+AqPB3F7K
	HBGFUQZDBUkatMRc7/YRdGQBip4TSdeGKAYxHaUz9ro8Kc95EejRmtMvFXxFV0iUqYfbGd3G7Cs
	5cB4hWC4qNQ0KMbO/yNbuBHW7ux0AJGWZd4Nagcdq+cSLMZR/7eRomCwqqR5aRD5oiALhdJ7r2h
	wD7dZzB3NHlVnm/LnywJXPD+0eUBdFaWzSxUJnYaBkmm1A5NRvnE7q+SkoP0qkyK1o8aLpmTjGG
	hgkKAHS4OXMRfzmnm4me1IiukaGPk9gZs0yVtog2gnP2FjIZRl9XOS+Gj2xwko9NlwPmXH3cv6r
	pxuJmwypje8L9D+rDTlwpkkHI3+t/Dad6ly8jXtdZKpM72CL82yuJ0iKp1T+vGW1HMOpXzF3jgu
	coxKZUQ2KXdRkGVbqR/t96j+gDSyShJdHWC3sBkSnuDUlGrnbTm1V2sSAYNMVn0lpW5UFiaAY3k
	8cizJzEn9ZtZHjC351D69dhL/N3dw6e5Hw93s6a3NQPT6QKLlOk=
X-Received: by 2002:a05:6000:4108:b0:488:7787:469d with SMTP id ffacd0b85a97d-4887787490dmr17106824f8f.25.1790594352582;
        Mon, 28 Sep 2026 04:19:12 -0700 (PDT)
Received: from localhost.localdomain (37-188-186-98.red.o2.cz. [37.188.186.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a34a638sm26164969f8f.9.2026.09.28.04.19.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Sep 2026 04:19:11 -0700 (PDT)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
To: Lee Jones <lee@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Rong Zhang <i@rong.moe>,
	linux-leds@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] leds: Add support for CZ.NIC Turris 1.x LEDs
Date: Mon, 28 Sep 2026 13:19:05 +0200
Message-ID: <20260928111907.72592-1-pepe.schlehofer@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The CZ.NIC Turris 1.x routers have eight RGB LEDs on the front panel,
driven by the CZ.NIC CPLD firmware. arch/powerpc/boot/dts/turris1x.dts
already describes the LED controller, but there is no driver for it, so
Linux cannot control these LEDs.

Pali posted v1 and v2 in July 2022 [1][2] and a RESEND in December 2022
[3]. The RESEND did not address the review of v2, and Krzysztof NAKed
the binding [4] and objected to the driver [5] for that reason. Lee
asked Pavel whether he was happy with the user-space interface [6] and
later reviewed the driver [7]. Pali answered part of that review [8],
but no new version followed.

I am picking the series up. Most of the driver was reworked for v3;
authorship stays with Pali as the original author. The changelog of
each patch lists the changes and, for the review points that did not
lead to a change, the reason.

On the user-space interface: the global brightness follows the Turris
Omnia driver, which already has /sys/class/leds/<led>/device/brightness
[9]. The Turris 1.x uses the same attribute, documented in the same ABI
entry. Marek asked in the v1 review for the index of the selected level
[10], which is brightness_level, and Lee asked for one value per file
instead of the eight values in one brightness_values file [7], which
are now brightness_levels/<N>.

Marek, patch 2/2 extends the brightness entry in
Documentation/ABI/testing/sysfs-class-led-driver-turris-omnia and adds
that file to the new MAINTAINERS entry. Could you ack that part?

The series is based on leds/for-leds-next (05b4738b0078). The driver
implements hw_offloaded() for its private trigger and sets
hw_control_trigger, as the hardware control changes there require, so
it does not build on mainline yet.

Testing on a Turris 1.1:
- With OpenWrt's 6.18.44 kernel, the driver as it was before that
  adaptation, built as a module: colour and brightness, the brightness
  level attributes including invalid writes, the timer trigger, the
  turris1x-cpld hardware trigger, unbind and bind, and rmmod while
  triggers ran and a level file was held open, also watched at the
  panel. After a reboot, the CPLD registers read at the U-Boot prompt
  still had the WiFi LED's disable bit that the shutdown handler sets,
  and after sysrq-b, which skips the shutdown, the bit was clear. With
  linux,default-trigger set in the device tree, the driver took those
  LEDs over from the CPLD, and the turris1x-cpld trigger gave them back.
- With a kernel built from leds/for-leds-next and this series, the
  driver built in: the LEDs except the WiFi LED start under the
  turris1x-cpld trigger, which trigger_may_offload_to_hw reports as
  offloaded and under which reading brightness returns ENODATA. Writing
  a brightness drops the trigger, writing multi_intensity keeps it, the
  timer trigger works, and unbind and bind give the LEDs back to the
  CPLD. The WiFi LED has no trigger_may_offload_to_hw. The panel showed
  the same.
The lines were rewrapped at 100 columns after these runs, which changes
no object code (objdump -dr). Neither kernel had lock debugging.

dt_binding_check with dtschema 2026.9 is clean and rejects a bogus
property added to the example, dtbs_check reports no warning for the LED
controller in turris1x.dtb, and tools/docs/get_abi.py reports no new
warning. checkpatch --strict reports only the MAINTAINERS question on
1/2, answered in its changelog, and a macro argument reuse check on 2/2,
where the argument is always a literal. Built with W=1 and sparse on
leds/for-leds-next (05b4738b0078) for powerpc, as a module and built in
(vmlinux links), and with COMPILE_TEST for x86_64 and arm64 as a module.

[1] https://lore.kernel.org/r/20220705000448.14337-1-pali@kernel.org/
[2] https://lore.kernel.org/r/20220705155929.25565-1-pali@kernel.org/
[3] https://lore.kernel.org/r/20221226123630.6515-1-pali@kernel.org/
[4] https://lore.kernel.org/r/8b829332-5cd7-2910-88db-513716e0919a@kernel.org/
[5] https://lore.kernel.org/r/d8172c80-a3a0-07f6-97ea-9130c49fab18@kernel.org/
[6] https://lore.kernel.org/r/Y9Ozg2O41a2iijMc@google.com/
[7] https://lore.kernel.org/r/Y/iDVlodp9sBkX9D@google.com/
[8] https://lore.kernel.org/r/20230309203526.5hcfa2w47vqzmny6@pali/
[9] https://lore.kernel.org/r/20230202234653.ukwpjntws3roacty@pali/
[10] https://lore.kernel.org/r/20220705143001.7371a256@thinkpad/

Pali Rohár (2):
  dt-bindings: leds: Add CZ.NIC Turris 1.x LED controller
  leds: Add support for Turris 1.x LEDs

 .../sysfs-class-led-driver-turris-omnia       |  13 +-
 .../testing/sysfs-class-led-driver-turris1x   |  23 +
 .../bindings/leds/cznic,turris1x-leds.yaml    | 132 ++++
 MAINTAINERS                                   |  10 +
 drivers/leds/Kconfig                          |  13 +
 drivers/leds/Makefile                         |   1 +
 drivers/leds/leds-turris-1x.c                 | 609 ++++++++++++++++++
 7 files changed, 798 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-led-driver-turris1x
 create mode 100644 Documentation/devicetree/bindings/leds/cznic,turris1x-leds.yaml
 create mode 100644 drivers/leds/leds-turris-1x.c


base-commit: 05b4738b0078f7d6f154f68068a11c8a0635e9df
-- 
2.54.0 (Apple Git-157)

