Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793044287;
	b=Fpz4ZfK3slLPLix1mpHDUVL7J4y8plJZVjwf0v+jg8FFAxR1bdYNasxVZ4MQFY1gH2Po
	 JDQqmDQlVfpPDhFcbOT5bHqJfvyzhHrfKG/UAKwHQGtIbAkzukinUEgtE74pbFpOvXZsQ
	 bLp0oa5vxNYaCHW554txh6qmj9dwG7fHS5RHtuRhrB+4T6+E4OToT8mDNwKEslWBDwW98
	 zYmtx5x7dVt1tmvPNNxme4VOfcPeT8/cBqcT6ZGgR7rJxDreUOT24QfL2Km9Zgh0BScyR
	 LptuL1vfZdkkKqhw+mhGMMHHWKJuoLiRFhS4Qh9ZQFFt+m+LMX8gfVPtBcnj/Nsi+9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793044287;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=4b2ajp4FBPrDna2YeWMnx5O5XVNt9W3jkATtNW1wXKo=;
	b=j+PSouBlmP1Hcrq3yliywgRsoHDoFhkolLyeXsTsUjHqT1vYvo1cTj2bLWm44EbzVobG
	 kfllycBNJYDUvToJCqzez8MKxO5CtlYtKu2HVTILmIbU0jq+urTTWiTOt67/iwfP5RfN6
	 U8H+XAky7i6tv5Ui5ZRdHD2eVsP8WsHavL9YA+0Y78pOgMES6B0TfCLDmrpsofNrEv4GV
	 bbcFYS9Zrno2YqFwStdf67vTv4S7B5pMnZvU1e/MH0fbER0OiSeG6nM2XjdOWWfM3A/ZX
	 1iB416Fweey+3aU37MpuSDlgEdWVE+106noKoU6sSOs5x3rivusHI9jguZYuaPkZu1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=feYEH80F;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E02E606A31D
	for <linux-api@vger.kernel.org>; Mon, 26 Oct 2026 19:51:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E02E606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=feYEH80F
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48e20edd106so2953271f8f.1
        for <linux-api@vger.kernel.org>; Mon, 26 Oct 2026 12:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793044284; x=1793649084; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4b2ajp4FBPrDna2YeWMnx5O5XVNt9W3jkATtNW1wXKo=;
        b=feYEH80FuTGX+mIFQCD8uHGEvbXlUSxByhEejpRyuyYMvBwvTKkmB4LKU/2Q1Dqxn1
         rYWTjYz66FLvEv1pfmg27AmldxWdkiAxR3O1SFimiZStr7xUn6PdYCaj+Hbv+XikVdFj
         VTknQCYldsZepXSHr7pp0srQrvhA3eurw+JQoWJ4au1n4XOlbJ+pJruBw4sDCnxExG1F
         8P/7jSRwzoUNjBfF6RbEwwgRfBtinYu+JXUyGzlsCdrA6yj20YrVZXSXab6v0Ch/mH4i
         x2FSuRADTowDXvsmjP6zwXY/6pEKpkH8ywOmrIJbHazptQKGEeUJVjTBqBk4qOUXKN/t
         OzRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793044284; x=1793649084;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4b2ajp4FBPrDna2YeWMnx5O5XVNt9W3jkATtNW1wXKo=;
        b=LzpojNo2Z5YQS4nMwXU1pZA8PvIwitfn2arUw/TbAMCW9uV5BfLDBqIxcV6NEMWnxi
         6HjQOxVR43U86XsASse0Ifl6t/xv4dPRgvhrsjm0wxF3GF8xzg+ZyCi3vhhZxL2tWHG6
         jA5GJAl4sdNABvobzRRkFsRXIY8EtIfiEZV7yakKB5O/I/9wkBXV6HHF+U0AHvRUgJaZ
         GWQUd6Jspnqdw6IZhku5OoeL7w7gjbl8G7vZxDsVQPisROxx6kBX7+6Bc9In/jdkuows
         YH1CTCygs80apQo+U53HA0orjddnIYyZzAK0rdO+3ISE5bnnnRsKjwRQSZK6BxtbU7EM
         zmkg==
X-Forwarded-Encrypted: i=1; AKwUvByikU5pvHKNNMVDu14yT3s8OYTBShsRMCaRjMf1r2Z36WHfKm/yRZSenoROdPxTzwyl6wTrMjR2wkU=@vger.kernel.org
X-Gm-Message-State: AFq9FYIEAxf8h6PDmzTIWi2dGusfRCCLnF1zY/oslQIcP1Mpiuopj9CD
	ZXHML0/8AZhStTYt3NGO5q1axpalcYEWFeJvbm1wW+r2pbUODPgr4/vs
X-Gm-Gg: AYBFou3FdR4WD0PAJxAa1BsKB2HpT+FFPJQATWR31bJKGgeTjFIwzu2hZlcJsJ4jr7j
	L9Dv8c3hEJqhLbsiIFsd1jk0nu+t6b7U3U97eVEP9daVTLpZ+/RviCnOj8KujyTxpugcU4v5q4e
	fYqJA0iq6V03PpXqpM4/a5oKMnSbWl+9AmJ5ETlFAHRIcnLGBLPJX2Ngt5Cankwu3iyu74kvtGx
	a9SI4xL9X9nf0AVRT9X0N4E8E6iCTVZYmuzUe4QRadB4IqxPeXP4M1TRVgZdMCwiP/tRq+Oqnd7
	rcApUaXqnRewYUJpyQ1cCGr9GRG2WlJyVBHtUNS7yZgZCjpnpM6WB9jUVIh6fpX6jXSfWQvnFrr
	GY9Dzn3DE8D/Ka82jz1SkaD4FcMUGzqYIwJ5dC0sTe+rm9ohmnRNQWxjh2+IeT7v1ISSe+K6qZ7
	OYPcHuCBTLYS8ZaA1O/866yZSzTwN3qwULtUf3aDYnQmcdsCV4szPSrea2G5VM0QmwhCzfC35aV
	lU9vjS9irL2MjhPlZfuIfsVb0cHrOmN9afGnGVoETrCT9Pt0qdhFwSS2Co4fDnd3bM0Y/oyrFRi
	fguxZyH4L3HsIOQFi3z20aX6qISkjGZz33cuDIoYKqGQFVF5UXxDDhADPFblZoHD6Okj9OYjttR
	ExAuO8qlNQzKAiywcaKzLFp1X81UINzsV3Ryk+wGXugJysGAwK/4Qjs6Xtzmkh9IOU58Xiu4NOO
	lDNiI4
X-Received: by 2002:a5d:5e8d:0:b0:48d:ee35:b3fe with SMTP id ffacd0b85a97d-48e3eb3cbfamr12691780f8f.8.1793044284375;
        Mon, 26 Oct 2026 12:51:24 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a00-1028-8388-a84e-8ce1-bbf6-5949-b0f3.ipv6.o2.cz. [2a00:1028:8388:a84e:8ce1:bbf6:5949:b0f3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebc3c5bsm18877654f8f.9.2026.10.26.12.51.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 26 Oct 2026 12:51:23 -0700 (PDT)
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
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	linux-leds@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] leds: Add support for CZ.NIC Turris 1.x LEDs
Date: Mon, 26 Oct 2026 20:51:18 +0100
Message-ID: <20261026195120.12759-1-pepe.schlehofer@gmail.com>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The CZ.NIC Turris 1.x routers have eight RGB LEDs driven by the CPLD.
turris1x.dts already describes the controller, but there is no driver.

Pali posted v1, v2 and a RESEND in 2022 [1][2][3]. I took the series
over with v3 [4] and kept Pali as the author.

The main change in v4 follows Marek's review. The five LAN LEDs share
one colour and can only be switched on and off, so rgb:lan-1 is now the
only multicolor LAN LED and its colour applies to all five. All five
have max_brightness 1.

Marek, I left out the symlinks. Linking a single attribute needs
compat_only_sysfs_link_entry_to_kobj(), which is meant for keeping old
paths working. Instead, the ABI says that rgb:lan-1 sets the colour of
all five. A link to the whole rgb:lan-1 directory can come on top if
you or Lee want it.

The global brightness moved from the Omnia ABI file to the Turris 1.x
one, because here it is a 0-255 CPLD level, not a percentage.

Based on leds/for-leds-next (59cf91cf87ab), because the driver uses
the hw_offloaded() callback queued there.

Tested on a Turris 1.1 with leds/for-leds-next plus this series, the
driver as a module and CONFIG_PROVE_LOCKING:
- the colour set through rgb:lan-1 shows on all LAN LEDs that are on,
  also while rgb:lan-1 is off or under a trigger
- brightness levels, triggers, unbind/bind and rmmod work as in v3
- no lockdep report from the driver
- after a reboot, the stock U-Boot (2015.04) finds the LEDs back under
  CPLD control, after sysrq-b they keep the Linux state (checked with
  v3, the shutdown code is the same)

W=1 and sparse on powerpc, COMPILE_TEST on x86_64 and arm64,
dt_binding_check, dtbs_check and get_abi.py show nothing new.
checkpatch --strict only asks about MAINTAINERS on 1/2 and warns about
a macro argument reuse on 2/2.

[1] https://lore.kernel.org/r/20220705000448.14337-1-pali@kernel.org/
[2] https://lore.kernel.org/r/20220705155929.25565-1-pali@kernel.org/
[3] https://lore.kernel.org/r/20221226123630.6515-1-pali@kernel.org/
[4] https://lore.kernel.org/r/20260928111907.72592-1-pepe.schlehofer@gmail.com/

Pali Rohár (2):
  dt-bindings: leds: Add CZ.NIC Turris 1.x LED controller
  leds: turris-1x: Add support for CZ.NIC Turris 1.x LEDs

 .../testing/sysfs-class-led-driver-turris1x   |  58 ++
 .../bindings/leds/cznic,turris1x-leds.yaml    | 132 ++++
 MAINTAINERS                                   |   9 +
 drivers/leds/Kconfig                          |  13 +
 drivers/leds/Makefile                         |   1 +
 drivers/leds/leds-turris-1x.c                 | 624 ++++++++++++++++++
 6 files changed, 837 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-led-driver-turris1x
 create mode 100644 Documentation/devicetree/bindings/leds/cznic,turris1x-leds.yaml
 create mode 100644 drivers/leds/leds-turris-1x.c


base-commit: 59cf91cf87abb67a49b1bb7b9d3b06486abde8cf
-- 
2.54.0 (Apple Git-157)

