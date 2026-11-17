Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794911489;
	b=ZY9Z/takl6SjEz3JMs9KsG3lCq2R2PWb43pV4RLXrezjWR/HZVbDhwvXQcNKx/0f3lzJ
	 tlyZmLEyhm/xC2kspavvEsyutOjmm1X6JotRpDD9c9sIjZavuphZRfh3VFlIaiivmEL/h
	 lerPaPxKw20Pvd25A1xN/6GI014T+zzHyZARtEPj4NBQXLeaiLaHW2j4SGxt+Upv4Hhz6
	 4zQOe/O2YrGXQrDXSu/oqHGOXrbsyRpFCji2LdLJ/8sltZRzVe5doGcMORk2DeRETeI2u
	 W27S8dHcj3HWc0wCtnulYpFZV/99Cv9oREaD+aE1aJQ9L1BJvRVG30235FfK2D41j5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794911489;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=L52Pp9F5WYzGwkkSwn+CCeVr/a7z+958O3ezUPX/7nM=;
	b=5dwa77kXCLMxrhTMS5Rmmwd4lF/rWJyBsjhtcsPC9Xy9CquwZf6BYXzLD/1Ti+u6tE+y
	 ffgVbqVkCaHeOrWRzUb1kfeuyhRjZWsXTwfpfp/ktmmMlNF6ThBA02QJtmUbze+CEuPuY
	 ucoTPfTqcRQ1wOIaf8JvPyuxYeh9y6hCJb+w2XqKObi5B7hDozNgU23/zbb5E8tQ7amFl
	 ZEn9lNEee7jhjLutWjadnCW/zTcwV+gdyae8Jzcwz03PMVo9e9EFNB0q+6dzA1onC9Fls
	 w7uPY8fnoiMof9PT9rERftglEVFTQLY+4VUjS9FNVUX/O6nh6ATQ1GIvf9JH20gprKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fpjxiuA1;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8BF606A8A6
	for <linux-api@vger.kernel.org>; Tue, 17 Nov 2026 10:31:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E8BF606A8A6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fpjxiuA1
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso37607935e9.1
        for <linux-api@vger.kernel.org>; Tue, 17 Nov 2026 02:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794911481; x=1795516281; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L52Pp9F5WYzGwkkSwn+CCeVr/a7z+958O3ezUPX/7nM=;
        b=fpjxiuA1j0GuHAe2aLk3KqfwWlK8JsqosfEM6uJIZe3Ehh2Hbqvkq7flsoI/6fleZ4
         VGAgewCEXvooTvOTKcWqQvdgpy3vIvepCZdk73/ajldX7TOBqerZ/dpcatzuF+jT7YGj
         dpwtcUK8S8R0YFaQYgJrTDcUsK9CnusUdGEhbkI6S+1VXj3d30BEmGbgQSAPItF77lKw
         1+2661r0jXMORIcM070JWUAFxVdeLrIjvjQ7f+E3hRNROkcPlkDaHMNmtAhNK+87JpIJ
         LKCvtbpSZQsZ8d9jEh+KOcDaesRa8UDBqKg4fT4yV1GFxMagE8QBT5ej1iybH4y+0nyu
         tOfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794911481; x=1795516281;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L52Pp9F5WYzGwkkSwn+CCeVr/a7z+958O3ezUPX/7nM=;
        b=Jqp0UZgDpq703N1MJ4IxTlAbGcLw6usVbjZgC5028FbTDTo4hAr3FbvMX66dw0WO8K
         JEFmwN5w/QPNrNG+uhBx4B7HYrkdKztDDOA16tjl/PJx8YAccbcvfSFtne1g/5Sokm/0
         Sg028oaAA8y5O3bgp2Ya+Jz02drKfwh5HzNyHpiOZLcZOubH4+34Vnj4ISSetQzUhMDc
         Fu5YlnQTDIv4thmi92NC+lJBf5ED3lZqiGyMMLQrB7nbtKN9vMyqijCJiQxxTBuOTdl8
         o4Nds79zs+3Di92/HHAaTWmRjxaH+tRq4L96x2UW2ajF0/VIDPwsgc6UH6V/TeyOxWs+
         P14g==
X-Forwarded-Encrypted: i=1; AL+hErFo5lE/SSaPIK26k/LZfy9BckQ1vzCXi6pYO1PJC/QuQEBiZ2eD5ALI+tlXeTD2kKxn7QxPmymbAL8=@vger.kernel.org
X-Gm-Message-State: APuU4Z/VOyECLNxTJdZ/F3SxwogO3bgj6ZSC08b9W9N284+sBlHwPCPv
	TDVV6+L+gTb7Cjo0HBcw0rTCEX+Vvfjn+CEyO7VeKoFX8LyjR56gZRE+
X-Gm-Gg: AYBFou3Kp0HM8rQsYajhiHqWuYiE33S/v8TMCybocSji7TdiFR4GN8nhyZ87iMHWpdP
	r6uvyH9HJMl2gydQG5TmuziZ2s4l9VPFHNmvjpjAm9brmhyHyytafjYgYC99my+fKBstzt8Pe0i
	aKizi2d9nq6zevG1oDyh9pcSQXX27xiAij1/7b1KFHp/yfljynAfHezWAmS93RHgA8pAuMbrHbs
	iHRZkLLdvlLKQibUrE7qSkjTFHNf6bkzaDgVXTLRsqYrlUvCvhBEtuM1TQtNGedh8n0qlqGpdHB
	La3KDFSUKsmKPIDlMMQPm4fmrwmpO5xOzznswC8gUTpHCvkfJmPYMB90Y5E06GtxSi59EoBEols
	3oZBuMgcpgqzCWPYTBXmKJ3x/z5YTGeLAGPNtYq+YnGT2qTaWca7SBN52f/B42ObvkRDTwspxMf
	Q56Z2JB3WMvEE4Xyq/bndYloumcPc7GDVwek0b+nVigHp9TlA830wpJjb+GqHABHtCTsdSSeJdR
	iJPWKwEFfWp0DfMtFjVMFDGbDlrZRF8yOK6xe2MQDudavu58cmDS/Q2mb9YYb0Sm0/+uhW/88o0
	Jte2eN9jQ2vHJEnbnOv2v8fLpw4=
X-Received: by 2002:a05:600c:4e45:b0:4a2:e0c:2b0a with SMTP id 5b1f17b1804b1-4bb55a84b08mr272748995e9.16.1794911481308;
        Tue, 17 Nov 2026 02:31:21 -0800 (PST)
Received: from [127.0.1.1] ([85.105.252.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb783965d4sm57712355e9.7.2026.11.17.02.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 02:31:21 -0800 (PST)
From: Bartu Alev <bartualev@gmail.com>
Date: Tue, 17 Nov 2026 13:31:06 +0300
Subject: [PATCH v5 3/3] Documentation/ABI: asus-wmi: document TUF keyboard
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
Message-Id: <20261117-asus-tuf-rgb-v4-v5-3-95268035eef1@gmail.com>
References: <20261117-asus-tuf-rgb-v4-v5-0-95268035eef1@gmail.com>
In-Reply-To: <20261117-asus-tuf-rgb-v4-v5-0-95268035eef1@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>, 
 "Luke D. Jones" <luke@ljones.dev>, Denis Benato <denis.benato@linux.dev>, 
 Hans de Goede <hansg@kernel.org>, 
 =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-api@vger.kernel.org, Denis Benato <benato.denis96@gmail.com>, 
 Bartu Alev <bartualev@gmail.com>, Daniel Pereira <danielmaraboo@gmail.com>
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

Reviewed-by: Daniel Pereira <danielmaraboo@gmail.com>
Signed-off-by: Bartu Alev <bartualev@gmail.com>
---
 Documentation/ABI/testing/sysfs-platform-asus-wmi | 46 +++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-platform-asus-wmi b/Documentation/ABI/testing/sysfs-platform-asus-wmi
index f9825c6150b5c..6aacfc6a42cf1 100644
--- a/Documentation/ABI/testing/sysfs-platform-asus-wmi
+++ b/Documentation/ABI/testing/sysfs-platform-asus-wmi
@@ -238,3 +238,49 @@ Description:
 		Set if the MCU can go in to low-power mode on system sleep
 			* 0 - False,
 			* 1 - True
+
+What:		/sys/class/leds/asus::kbd_backlight/kbd_rgb_mode
+Date:		Nov 2026
+KernelVersion:	7.5
+Contact:	Bartu Alev <bartualev@gmail.com>
+Description:
+		Controls the keyboard RGB lighting on ASUS laptops that
+		expose the WMI zonal RGB devices (the kernel names them
+		"TUF" for historical reasons; TUF models have them and so
+		do some other ASUS lines).  Writes take six positional
+		values::
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
+Date:		Nov 2026
+KernelVersion:	7.5
+Contact:	Bartu Alev <bartualev@gmail.com>
+Description:
+		Controls when the keyboard RGB backlight is lit, on the
+		hardware that exposes kbd_rgb_mode.  Writes take five
+		positional values::
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

