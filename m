Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793231568;
	b=fUZZgQa2WjP+Vv3NTWPGInnqbReO1dbuHqdqiRK/5/QyoFHHB/E2iB4PF8vDidVf5XIs
	 HHgPk0LlIv1zW4Evhe8nX0lLhzAGVd5kL/TdDAv5He7k/jQHKZaIXhXDsquTdoU4wMbk+
	 o6RihkpgiEmEFIcDRNv7QSf/bSWLipvNLEHeLtbd/ckjpst13Fx56zCNeCWhnXfd3ECqg
	 pKHkTNmHx12V6j2J9eGLiY83LgqhX63FgJsHCG09uAn3H37GxyaY5G8A7lCJTX22bLnc0
	 y8/SXCvpDZqI6S6m8H5Q2tWcRfhoIxJCgEzKQjtWH+UEwQDnbVHtCcMcpJqvDDOFoOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793231568;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer;
	bh=4WsOLd1UHsYxqktmaE+tPwAPjAowkbjm66X13t21J+o=;
	b=TYfggUS4eMGMsu1rIhpfipclGUinmEX9uu2g7ndS4EvUbQkylIevnbUQC/ZBKlsS/xpS
	 C/vux5IhEz71IX/YEg63WxnrcKoiDkCq6tU7eLqOZe2a3BT15eBB8rPMAxg9t/LqJEDFF
	 nQiLYUQ404x3Wgq/05fE6P3efxN5KvmAizHXpb5wC1BgGy7hNwSYtgIpHkne1LFkrZeDh
	 lvZUWL/6JEUEQa8klJmhRr1bx1y+t5XvfrjVGfhbNA+hUwc1CPXBpb1pC35Y0QT0FHMXO
	 Cc3A79KOz1GfH6ptcJf/W1eWLZXVwgSE6hck5mqr35RZslZr4yoVN51v7AWEZ96lp8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sH8c0Noa;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF852606A32A
	for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 23:52:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF852606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sH8c0Noa
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so13930555e9.2
        for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 16:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793231566; x=1793836366; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=4WsOLd1UHsYxqktmaE+tPwAPjAowkbjm66X13t21J+o=;
        b=sH8c0Noat/9o4Ev/8DOjxktSSBQCeVVy5ugZdyB5DVeLVPmixq8K34WEg7N0QpLnzM
         HRkC77EUSg1uMsdS2sEYfZ+kDa85TNMCQGya4ylfzFBajPHhom9HBGZy37jNCur55usq
         E6q+z4pg8ed4FDN3HdtXH3lleZnsPmqrzrlvV/w7uli5R9vPuds105vQ8qWMs85TUmdW
         QtKPzLgEg/osd2kivNcnGjZBUcvupFLmb3zgpYNJ/GOJv5XrpzmO6Z/oN8EnrsJa/g2H
         hnxHXU3d3+QGLK+SBxwrdvCXBKx/ofMIuMeKx8zWEcOwTO2ToAZMENnl4I21xuBb0P8A
         SaUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793231566; x=1793836366;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=4WsOLd1UHsYxqktmaE+tPwAPjAowkbjm66X13t21J+o=;
        b=Dzdur47r0rZloCWGOkC5iBj6C7+rcoLERUzdb35VFiLpSkvvbIXUhzPXQbk/kJVizf
         R7v/slvsFssoaFzbhKcyOyCos47L1FTz0o8yOJWOMwq9lq9c9OnnFDLTdIL7Br9vM1nq
         AmGAWgX302ukGush0HDQDrsu21/DryKPJo4IW2Bko2K6KZa8hkUnQDMD6ajMD24NT84p
         QJ7Butx6oisBeM4+fVkjTGY3Ok2Pw6e3PdFqDRdj7zrs1kZeYrDJjT5O3XUWGSh0bbbW
         4M0+1M7kvipeCz0s9KUvez87YUtnfWrbeTe28q7enYg+EYKIfayBM1iTSN1nH4yTi2sx
         N1Eg==
X-Forwarded-Encrypted: i=1; AKwUvBwfI2LGzmrJV7h7JrqkdQKOr8Y7vSdzRAdBaOAyxE/pqrBRwGtFLDyDz6KczBJbCSKrxph58NAkajA=@vger.kernel.org
X-Gm-Message-State: AFq9FYLO5MyiwfVRmLqg10drSqmqMpBcMyn1hAuA9Y5LHCRBsZcp264z
	XEwEjXHCPcmjCLJ29W1dFpb5POKTVM3+XpRxYtDWQpbPO3NdFKve2XLc
X-Gm-Gg: AYBFou0JrcVNkPipTM3dlES3kmWTE8CpaXI9ZET+Zc14szllE4EOElzkGtpMAf1F9bf
	KQEpdMLWTKI8c3nBEBoYBWmBWQQ7YukpaWwJqWWX8ac7tuw7UOnXboLfqKdNxxCrUVEfx35QUim
	dNpi1ic2dkQQSBIKsQV16Wu4yzlRawwd9+nx8PEbpd6lLiVtBfA4e/RDrwbybmgBL8b1au7NRY4
	/O9uGxnBuEb6SZ7AAuIfethmMXmHzc35P+Yv/TLMcnAO/+aBr2W++a2EFfnZ1x8JRmcFoYwVi/U
	kIibfuSPS1ijHFx+piMwoOHi6n2JVOctoqhSKjah0SJLTfkvUf/rc68BeVQSk0s7SIVnPbem4Z7
	oCr88S+SIk8OZV0p2xbKFBXiNv/JoNPzxd//085He0lHbPiHXzkuYAzCgGxj18tTNSeWfITntvm
	GGbVtvgewyzLwV2N7jiWXzK9FegGlGNxJRGKxVzXgdr9fruErnvrjONLSZcgfax5bhqR2AgcAYP
	/qdlZS1acr5QrP83GpNoBXuilBa6WhkmJTBRRieQORlQb1wczaUSJFeEF8NkUS3DVZ2BussaG9l
	oTVTv1qX8SAM03ZcS6rSdJaQCY8=
X-Received: by 2002:a05:600c:8b77:b0:4a2:cbe:bebc with SMTP id 5b1f17b1804b1-4a966c3ff3amr75213645e9.23.1793231566086;
        Wed, 28 Oct 2026 16:52:46 -0700 (PDT)
Received: from [127.0.1.1] ([85.105.252.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa80f04785sm23669055e9.4.2026.10.28.16.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 16:52:45 -0700 (PDT)
From: Bartu Alev <bartualev@gmail.com>
Subject: [PATCH v4 0/2] platform/x86: asus-wmi: TUF keyboard RGB readback
Date: Thu, 29 Oct 2026 02:48:50 +0300
Message-Id: <20261029-asus-tuf-rgb-v4-v4-0-0d3b877d2c30@gmail.com>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/32NzQ6CMBAGX8X0bMluKS315HsYDwUK1PBjWmg0h
 HeXYmK8aPY0yTezC/HGWePJ6bAQZ4L1dhw24McDKVs9NIbaamPCgAkEpqj2s6fTXFPXFDRwCkJ
 XKtUCBBRks+7O1PaxFy/XN/u5uJlyipm4aK2fRvfcXwaMu70OimUMQHKeIFMSOUVaaDfNujPh3
 PTadkk59iRGA/vWBEAmWJagxEzAPy39aAj7CcAkz3MJ6pe2rusLiGY/XSUBAAA=
X-Change-ID: 20261029-asus-tuf-rgb-v4-06ad93a6060b
To: Corentin Chary <corentin.chary@gmail.com>, 
 "Luke D. Jones" <luke@ljones.dev>, Denis Benato <denis.benato@linux.dev>, 
 Hans de Goede <hansg@kernel.org>, 
 =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-api@vger.kernel.org, Denis Benato <benato.denis96@gmail.com>, 
 Bartu Alev <bartualev@gmail.com>
X-Mailer: b4 0.15.2

Patches 1-3 of v3 are in review-ilpo-next already, so this reroll
carries only the remaining two patches, rebased on top of it.

DSTS device 0x0010005B evaluates the DSDT method EC0.KBLS(), which
snapshots the EC's host-visible keyboard state into a 16-byte buffer:
lighting mode, red, green and blue levels, animation speed, and the
four power flags.  kbd_rgb_mode and kbd_rgb_state become readable and
report the write format with n/a in the command position, because the
command word belongs to the write verb and has no state equivalent.

Changes in v4:
- report n/a in the command position on read instead of a synthetic 1,
  as discussed in the v2 thread: the command word belongs to the write
  verb, so there is no state to report there
- ABI documentation: describe the n/a command word, state the mode
  clamping exactly (mode 9 and modes 12 and above are sent as 10), and
  note that reads fail with -ENODEV on hardware without readback
  support

Provenance: the KBLS buffer layout and the speed-code semantics were
recovered by static analysis of the EC firmware (ITE IT5570VG), with
the help of an LLM-driven toolchain.  Tested on a TUF Gaming A15
(FA507NV): the v2 readback on kernel 7.2.6, and the S5 behaviour of
the shutdown flag by A/B testing both values.

v3: https://lore.kernel.org/all/20261010101601.888709-1-bartualev@gmail.com/
v2: https://lore.kernel.org/all/20260926005625.171560-1-bartualev@gmail.com/
v1: https://lore.kernel.org/all/20260925200744.129714-1-bartualev@gmail.com/

Signed-off-by: Bartu Alev <bartualev@gmail.com>
---
Bartu Alev (2):
      platform/x86: asus-wmi: add TUF keyboard RGB readback support
      Documentation/ABI: asus-wmi: document TUF keyboard RGB attributes

 Documentation/ABI/testing/sysfs-platform-asus-wmi | 46 +++++++++++++
 drivers/platform/x86/asus-wmi.c                   | 83 ++++++++++++++++++++++-
 include/linux/platform_data/x86/asus-wmi.h        |  3 +
 3 files changed, 130 insertions(+), 2 deletions(-)
---
base-commit: 9d3475065167197742b0882aff21cf8e78393277
change-id: 20261029-asus-tuf-rgb-v4-06ad93a6060b

Best regards,
--  
Bartu Alev <bartualev@gmail.com>

