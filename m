Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793231575;
	b=ngQ0sYe1f+bvhZaC5xPXNc47G9CEzn1PUH3zbQZv1POGHEm9icEDZjydK0PexcmavZKR
	 n6y2/UX0YMfcnVS82N7wZIOt1eMxgPcFTqFf1tTvw5rwvr+Rb3HSC/ljMpm2i5ttE5f1Y
	 I3rtcb1PPyoIRhj2GDKPzYskcH9eDHTkSuMV7Ea3KIv/v3nd3aTg0ykp3tfw6oC6Ev4Ux
	 lI+wIteMv1XfEM96pDWp564z1On7EAcYb24EjraItLMOV39krC6F4Lc59xbqBh9kR3QEt
	 X+KOC7Y5G2CiMRLoAfulrz6mBOT+IimFwpC6RN/os4mcYgzDsLy1qupPj9v5Wtw7n1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793231575;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=NShZ2F0kBjLdK/kOL2KImL5dsxE3V0Ajk4CzI2p8lPA=;
	b=Xtep+7wMLhVBnaHFrS0sYdviRosVq7NdG1BC+c5hlDmtWvx8m9ioNsHGKA5dXC1V+NjH
	 0/q7FCl9mHa/UHSNkAo/0Btm5A72Qz9/SzyJwLNEM4A7vfM4t35Yd7pX83uUxmq53T9IZ
	 5eSUCev8P0E9nE5ykHIcz6coFN4MYcy4a0AQuBKWZPRcDzxmHDp2MA6WoEJOVkmirfD3e
	 BH1/EaVNtQ5W6FKQJDYYvRMXgJfuQRZk/Foom+XmFpgNaTWRKhAOojTbGECl31NWruw5h
	 8XobYN6LKJWJACxGf22kv/IjIaTLJYZiDl6+1M68UqFdmFGHnCc5jeBglACc0HRNEfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ObkCEo3A;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04268606A32A
	for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 23:52:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04268606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ObkCEo3A
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so2092125e9.1
        for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 16:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793231573; x=1793836373; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NShZ2F0kBjLdK/kOL2KImL5dsxE3V0Ajk4CzI2p8lPA=;
        b=ObkCEo3ApCzCdBf4QLwsQw/gIczNDklONgJYDnqaoOVsGgVKSXJd1tmG+Fb9fp36Xf
         IehrQMgYCyhhPhaLmhhcKSOrjNJvduh5BBlwvzyJWINxNfc4D4egOaL+ipRrR4BMopOo
         pDXhxZhRFRaST0XknNmt7hs5S80V8oJkGKD6Nnwh5WxsPB3iaqnSqeXqLWT+gv8ud4U6
         h8k1gtTDdl9XqbTz4X42aMDBoVrbWk+L/OlKYbvkBgloVrKIgN0DDv91RCKwfpgmG3RB
         P/li0F84zo5DTVY80qFPH+ZeihHTt9xqd6jLQ9QLdb+IMVnNAtK9gGe1YhG8vuU1LsuR
         wQZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793231573; x=1793836373;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NShZ2F0kBjLdK/kOL2KImL5dsxE3V0Ajk4CzI2p8lPA=;
        b=2IE4seAvIrhNqoKnVwMCDZdtpTejP9NC5ujZV8hUTREh1Zo9965J/3gr7z5QB3K6Mo
         tjLl3EX3zsT/Sil4jg5m8AdfiBkdIYtfTQY/zJx0UDzib/ZiKchF6wzHcaT5nRd9ahc4
         sEaQs1iz4jUio/rU1ZAova8pi3jVcWT8WndpzPFEfvW2+HzX2TFL9vREson/2WOZcdAn
         OzQU9i8oVk7SOfbKvFGG7Ol1LKrhMF7lpl88MDiNQiIIjSwoR02y3gwoJC2sbBPZdH+0
         7dCYHkEN4c7Q0OZUvhi2XQYJlo5ePGDqWmHEmsfKlXOYhpDWW4TRWw01LNpnkCfJwKEl
         uZ9Q==
X-Forwarded-Encrypted: i=1; AKwUvByfGYspZvphwSCDRqbbSrQ1gqrzF7AqQnUHH6ufM3r8w6TQX7xWwqVPhzoJoZAKj49eloyPsQXKiWM=@vger.kernel.org
X-Gm-Message-State: AFq9FYIdYjZFYUtaIV5vQVG+clgtNCENkx2APDAjPOQw7E7zptdYMvMd
	rE57B6xq5Nf+oRHz2z1IJOLvDgJ+9hygawR9F24i4CeA/nvazkNZyCjF
X-Gm-Gg: AYBFou3jQdPpPSUlaqKugGm6HU/cMM987CuvsUW/trcler1/jMpJiDNj7N23ROIZna+
	4leHmPLKc/QKWZruwQTLlwuuXY51pww/XvF888142z10giEtenPxk4gdeiEzIGAOhCT3IrkrR+w
	dL+IMvLbWAoKLYlnhqvBO5k4L8E4sV/46gvEFEUdlnS4Ll+TiWlhmpiboQwoxSw4XfFQnBeWt4X
	fbX7j6bRF0x+WxC9wt9AyLi4FjygfBFp76NfU9TLnev7VTMN++/aahU0UqGCgbJbpggwBnYpoMY
	H22aLNWXIaR0F+MRwitW3VpUUVrzY9qfghs/CzC+WBv+b8qqxgORMYaS/7mU4uTFXV8kFXhGl5I
	Zvvv7ZWnA2wGPAy/zv+2GlfguMlwk/SW7xWWs3wUrubvXoQreErzk7M5IYcpwq0rcEB+ZzUo83g
	cF69FNzFYF/l0qlOyhWCsGM73tRC2z5v6A9TXPADZD6n5kLghWlxDm6Z7qyU+gAt7pikn6Z9j5/
	FLMmERrLSAGun19q5yq705Qgc19gucJ+KDOnfJthfT3SXNXacwxsH0o+BAm8z54W3prp+xuvSDU
	f9NBB9q5k4TBRCE4d8qv5y8MlOU=
X-Received: by 2002:a05:600c:621a:b0:4a2:10f9:37db with SMTP id 5b1f17b1804b1-4aa871e8be0mr25693755e9.7.1793231573393;
        Wed, 28 Oct 2026 16:52:53 -0700 (PDT)
Received: from [127.0.1.1] ([85.105.252.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa80f04785sm23669055e9.4.2026.10.28.16.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 16:52:53 -0700 (PDT)
From: Bartu Alev <bartualev@gmail.com>
Date: Thu, 29 Oct 2026 02:48:52 +0300
Subject: [PATCH v4 2/2] Documentation/ABI: asus-wmi: document TUF keyboard
 RGB attributes
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
Message-Id: <20261029-asus-tuf-rgb-v4-v4-2-0d3b877d2c30@gmail.com>
References: <20261029-asus-tuf-rgb-v4-v4-0-0d3b877d2c30@gmail.com>
In-Reply-To: <20261029-asus-tuf-rgb-v4-v4-0-0d3b877d2c30@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>, 
 "Luke D. Jones" <luke@ljones.dev>, Denis Benato <denis.benato@linux.dev>, 
 Hans de Goede <hansg@kernel.org>, 
 =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-api@vger.kernel.org, Denis Benato <benato.denis96@gmail.com>, 
 Bartu Alev <bartualev@gmail.com>
X-Mailer: b4 0.15.2

The kbd_rgb_mode and kbd_rgb_state attributes predate their
documentation: they were introduced as write-only interfaces and never
received ABI entries.  The readback support now being added makes the
omission visible, since the read format is part of the interface.

Describe both attributes, their positional write formats, the write
verbs, and the readback form.  The attributes are gated on WMI device
presence rather than on the laptop model, and userspace tools route
several non-TUF ASUS lines through the same devices, so the
description says ASUS laptops that expose the WMI zonal RGB devices
instead of claiming TUF models only.

Signed-off-by: Bartu Alev <bartualev@gmail.com>
---
 Documentation/ABI/testing/sysfs-platform-asus-wmi | 46 +++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-platform-asus-wmi b/Documentation/ABI/testing/sysfs-platform-asus-wmi
index f9825c6150b5..23e5f265f722 100644
--- a/Documentation/ABI/testing/sysfs-platform-asus-wmi
+++ b/Documentation/ABI/testing/sysfs-platform-asus-wmi
@@ -238,3 +238,49 @@ Description:
 		Set if the MCU can go in to low-power mode on system sleep
 			* 0 - False,
 			* 1 - True
+
+What:		/sys/class/leds/asus::kbd_backlight/kbd_rgb_mode
+Date:		Oct 2026
+KernelVersion:	7.4
+Contact:	Bartu Alev <bartualev@gmail.com>
+Description:
+		Controls the keyboard RGB lighting on ASUS laptops that
+		expose the WMI zonal RGB devices (the kernel names them
+		"TUF" for historical reasons; TUF models have them and so
+		do some other ASUS lines).  Writes take six positional
+		values:
+
+		    <cmd> <mode> <red> <green> <blue> <speed>
+
+		cmd is 1 to save the setting to flash or 0 to apply it for
+		the current boot only.  mode selects the animation, 0 is
+		static; mode 9 and modes 12 and above are sent as 10.  red,
+		green and blue are 0 to 255.  speed is 0 (slow), 1 (normal)
+		or 2 (fast).
+
+		Reads return the current hardware configuration in the same
+		positional format, except the command word, which reads as
+		n/a because it only applies to writes.  Reads fail with
+		-ENODEV on hardware without readback support.
+
+What:		/sys/class/leds/asus::kbd_backlight/kbd_rgb_state
+Date:		Oct 2026
+KernelVersion:	7.4
+Contact:	Bartu Alev <bartualev@gmail.com>
+Description:
+		Controls when the keyboard RGB backlight is lit, on the
+		hardware that exposes kbd_rgb_mode.  Writes take five
+		positional values:
+
+		    <cmd> <boot> <awake> <sleep> <shutdown>
+
+		cmd is 1 to save the setting to flash or 0 to apply it for
+		the current boot only.  Each flag is 1 or 0: boot, awake
+		and sleep enable the backlight during boot, normal
+		operation and suspend, and shutdown keeps the backlight lit
+		while the machine powers off (S5).
+
+		Reads return the current flags in the same positional format,
+		except the command word, which reads as n/a because it only
+		applies to writes.  Reads fail with -ENODEV on hardware
+		without readback support.

-- 
2.56.0

