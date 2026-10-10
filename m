Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987E83F9263
	for <linux-api@vger.kernel.org>; Sat, 10 Oct 2026 10:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791627430; cv=none; b=jY9eus9bZq7gxYqzdXOyR8T1wh0W1Le4DeDKhxlwM37uQ1dR8c6ByL0UPoKCf75RVsoO77pDhONYxDYDsZtq4V6PtLusK8hrXEv1nTzYjnh2WsqbPZb/NNRxCO5Un+hn9BCAKga0MVjLISE4KokeoH5UxgkB9xc2fkmm/1YYRg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791627430; c=relaxed/simple;
	bh=J6vDvjbCk7MX9LMkq+wxze1fd6NDlSnZqCj5f9c4+ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKSosywx1W/dJ9udG3wS24mgclKaO8xzhKel9SaTU7RU0pfXSTBwLgKFJDeFyRg8wtBWWU97T8iM980BrW3E0eFevZpQzoQGEL4JYO3i2335cF045azUKlkofSsgrMCeSRAx1+j8Za+K8Rb9u+5FYpzgCp2G2FF+EWTfbLEkfqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K+9UkMdt; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K+9UkMdt"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48441a2ba1bso287470f8f.1
        for <linux-api@vger.kernel.org>; Sat, 10 Oct 2026 03:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791627423; x=1792232223; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Pmb79NaTW27JYmEVgkO6fhUqLko5WfA8ujw653XjoMk=;
        b=K+9UkMdtgssN7RUKlVEm7ikmSWN2s3yOAKc+5Go4e1PbOlqFF7cwQL3r7zJnLWV6To
         N7j6YMVRHhio2Ettd7pXnu17pNVN++uYYNbXlcCt0YaU9+PgqBWZVwjTnxHJQyb1UXUi
         kMKBUuA3K7SB46uNUzQr+Euyi6iXxt0gu9RTv+Lr7W94vrlN5LQEuUSgkCrlg8MvV0db
         ItvFR+FAWVKQq/XKbrq1+p1Zqy8nY0GYBwGtUmHOpk1BTLHB2dbJEWs8zZjgPycKgLuq
         YL5NVnrs78WFs2U+X8XyAuZ8FWqX89LZ+w5QW/UwERll7PURNmBTsS0gkKxyYdIGOsUS
         PxMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791627423; x=1792232223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Pmb79NaTW27JYmEVgkO6fhUqLko5WfA8ujw653XjoMk=;
        b=tJG+o3miXZsNmdLIr3WSh/Du2rJ2VzZjlddVEtptSyqK5Fphh+WAJ39ZAz6KPpzhnV
         lmUNN9qMCfZA+3vC5ToUozjArPur/Ks8MNRHVArfKR5IjLx5oI5YaHN0qg/Svb4PNQMP
         pFve/0RpSSmKpMQW7+Cgyyz5sGkEq1rErhDXHL5bi5gGONfMsl5qIQ6FVWRmzMmj7ZwS
         yqJcGrCaxvPwriMvf/p/TGdOSg3dhv2+8k3gpUgfXXBHet2oRmu3iVdxxGza+xolhZ4f
         jk2NKUCxtS8GDr3sqymni31J1uUhzpekkLrQ6waCMYLVKxxu6IAORU/FIPDruWF7HxTt
         uFhg==
X-Forwarded-Encrypted: i=1; AKwUvBy52SZvCtVrZVHHYlUEiaHzDWSq/063z13SQHwQO1szJM91nVp9BYBsqxnXbZr6uJG69o5t8tmZOhU=@vger.kernel.org
X-Gm-Message-State: AFq9FYLOagRB40vKwDdAcbwn6nrVvWDlQBF9OaIab5OJFdT33DXVLspT
	1ZhTFWP6urmNuw4gNFCtUFGCO3iY6kH/Ec9rtco0qppfpUFoXjNW/IzB
X-Gm-Gg: AYBFou3TqgcGzPKvBJOs9yz+r0yN+7b8QPieKZlp0dn5sMXBHE8PEAPrxH1ie7P5N3U
	CxYnMEi+nm39prBCakjVq3XL3fA4sDW7F57djVBcSrqT52ZD3pZWQv+JAq2Au7pNKeXu7y7/9h5
	cYHx0z/09Ez8T7ScdBjWyx0VvXyt61bKxKwnUwHe6nORL7Y8k1W5WNq+iTG/LhesUw6v7xPwhIK
	8kq7geA63j12Jp0UmkLwJgx3WoXoZoSNm7tfypKS8eLOfHi8AYOJHJSDTYkxnBJyK2nr/AIiZMM
	Yo0M6Q5mRXT15zKR6oc0LWXBQqPxCzNTrZQgmqDn6eeuiUbdw+bwg3iUgIQDLDKAFDtYCuIvOpy
	705YFYBSAiLSp10dSb+tU+2CQegCecytc9JMH1dcjkba10KwV8ZRhSQELYJhxay0xYKsE62dxwc
	TB84B04+Ih7s7VD4U/ngHnxMJLDWeXvXRLAFgYFNGm/5VDWNOZvOtmCdpfepwU
X-Received: by 2002:a5d:5386:0:b0:487:767:b301 with SMTP id ffacd0b85a97d-48dbacd94c0mr6289963f8f.57.1791627423442;
        Sat, 10 Oct 2026 03:17:03 -0700 (PDT)
Received: from ASUS ([85.105.252.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db98c38f4sm9417856f8f.27.2026.10.10.03.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 03:17:02 -0700 (PDT)
From: Bartu Alev <bartualev@gmail.com>
To: platform-driver-x86@vger.kernel.org
Cc: ilpo.jarvinen@linux.intel.com,
	hansg@kernel.org,
	luke@ljones.dev,
	denis.benato@linux.dev,
	benato.denis96@gmail.com,
	corentin.chary@gmail.com,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bartu Alev <bartualev@gmail.com>
Subject: [PATCH v3 5/5] Documentation/ABI: asus-wmi: document TUF keyboard RGB attributes
Date: Sat, 10 Oct 2026 13:16:01 +0300
Message-ID: <20261010101601.888709-6-bartualev@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261010101601.888709-1-bartualev@gmail.com>
References: <20261010101601.888709-1-bartualev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
 .../ABI/testing/sysfs-platform-asus-wmi       | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-platform-asus-wmi b/Documentation/ABI/testing/sysfs-platform-asus-wmi
index f9825c6150b5..c63e7cdaefb0 100644
--- a/Documentation/ABI/testing/sysfs-platform-asus-wmi
+++ b/Documentation/ABI/testing/sysfs-platform-asus-wmi
@@ -238,3 +238,45 @@ Description:
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
+		the current boot only.  mode selects the animation, with 0
+		static; values of 9 and above 12 are sent as 10.  red,
+		green and blue are 0 to 255.  speed is 0 (slow), 1 (normal)
+		or 2 (fast).
+
+		Reads return the current hardware configuration in the same
+		format, with the command word fixed at 1.
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
+		Reads return the current flags in the same format, with the
+		command word fixed at 1.
-- 
2.56.0

