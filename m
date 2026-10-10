Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A8534CFD0
	for <linux-api@vger.kernel.org>; Sat, 10 Oct 2026 10:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791627404; cv=none; b=BgOthFGtkIjcuWbW4cj7ir5dzG2D7/P/3NpB7Zdf3YLlgeUV5QuU25g8AkQMoY5nQnOHvm/SdkWGrhR5Nb7IuBrqZ74WiGND+dsbmGaMqRUhLAIdYBkmn61IeZNmvFAuq0Cf/Jfk5R4HGYDZA1nbPgznwjetXeb9E8ugBCulr00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791627404; c=relaxed/simple;
	bh=e1njbT5bJi85eZxLY/530NAqny3vA2RxrG3AcqTroqM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TgiTtQorekeA+gcrwCJ8Yr23sbnWFX19wTvmmCPHKq4WNTFLnxriIfqUZcKq0fKu3s2qB7rQqVxUGbM5x5i/0pnF5OdXkqfHfwfjchkewaaXEs0xsl95GDWEyQVlAYFPNvCWfKilMonqW7RN2F9gLAdCZIUjojXDgsj0LYf+flk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FR1FfYT8; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FR1FfYT8"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a17baef589so3728415e9.0
        for <linux-api@vger.kernel.org>; Sat, 10 Oct 2026 03:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791627400; x=1792232200; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KFVRilLphheYZDM+G1ugCIoIXs4pytm2C1ieeD0EW20=;
        b=FR1FfYT8YfmSQOC1Rkc7IdHGm8OO8r+6IwE34Ci01l39dqznbYJWn/THZWL/GkgHkL
         GH7MkmEVQbKELGm1wgh1I+hMqp2v0bpTYlnYDDu0Qm9CJ+GcnqygjuI7Cn6OlT52SY1y
         vKsIbpBT9vJznnJGfTx8xM+3vSCjhKGrjjwtWKyo2U/pMRuCqCv6J7AJxbdr6/FcTLdE
         GJ/cErDO5MgQh6lfwOp0pUFkm2Sz0iub59bew6Hxt5PIihk1//4Zlr4zwGJtRp2xXlWt
         8mSDqM1kCdhwXHIBNPNKfBcMDb6I24nQZ7GXJ5DPfw6vrq2boSCjZIC1S9rJMNsFN4HB
         IEgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791627400; x=1792232200;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KFVRilLphheYZDM+G1ugCIoIXs4pytm2C1ieeD0EW20=;
        b=mlvT9ehITkrtbwX7bkQJCFn2bcViWCBMpdvYcjJtDODAqyfkdMvWZEoyBetwInVeWX
         tcG9qt7LXQSkZpIElYV9cDKShWksHY8bw2uJd+Ww5bDZaIB2AKludFlj0brCeMg6u//C
         Z3YZdoWd6sVNByQxUg2StrKWmhQjiOi/si5Y9bSYwuVosseJJWuM4+CZrpVu/+z0BPIB
         XSBBr7dzy9d6Br9jx8b5kPhAQfIzWIaOkB1chrz7Do1sf2N/Dsg3pfspQtQhN+U0VWlq
         mvKRBsXOVOmU+fvOnR3Yjf1E9Qv8g7cDUdK8TPbgkjSsX7o1lUVVBl/kDJoRghOhU+uB
         awpA==
X-Forwarded-Encrypted: i=1; AKwUvBwpGsWTMLkRxdx6M7y3eopoOTAnHxf3m9jthI7+4ML7i703INYKoMVDpdt8uYYyhIqAyRkIWmUafyc=@vger.kernel.org
X-Gm-Message-State: AFq9FYJCdmn3/KXTTI2wkY/rsI9J54/+pnEwFp09Pjk2BrErd7a9dfGH
	W+BRfmqZsLJ7C9gIEDoWBR183ySlyfEoqURMoa311cTDnIeBvNfrKhjk
X-Gm-Gg: AYBFou2Ko61PlaX77OB3APtqvE3CqpjRbsV8GrsydmksTMIVrSmx391HtuKF89f470Z
	W4FRly0mW9UtmDtaLTz2CLMqfyBFuJ1eCSlELR/1JgM39N8nNzNL+SZIIw4UHdYWBmZf8ugGJVw
	TKfVOjDlAIEfKrEQtVtF66LdMWKo2FbJXUzWQqdHfc1AHt+ZG2XBneR86vv4IC+wt7MOBENm6qP
	opr18W9fzzvr12V8td6OYe63JOYgXB/2jOGgR6Wlf1bgapU1WEMe7eL2nDdhudH7WmbEVJg1Xpo
	40KPuYL5lapJa4p7O8sE4zLmPhh75qVGLGEkDdtDp6SO7f5DInKF4gGxV5lZccL2WIs15WSlLDO
	Ggw82Rum/vUimA3F/Xc2dbwCTgi+Hr3MJP/Gn1+FTjRfk8Z1S8/bdWtmHlkzouxFk9Qo+r3Td/3
	09Mag2hGf9xPPtPC7cZ8rMqgjVE5xm+81gdXtahmqlo8udgCG+C02paW3h1ug=
X-Received: by 2002:a05:600c:4593:b0:4a1:7ed5:99e8 with SMTP id 5b1f17b1804b1-4a18e49bffbmr90382875e9.22.1791627400129;
        Sat, 10 Oct 2026 03:16:40 -0700 (PDT)
Received: from ASUS ([85.105.252.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db98c38f4sm9417856f8f.27.2026.10.10.03.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 03:16:39 -0700 (PDT)
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
Subject: [PATCH v3 0/5] platform/x86: asus-wmi: TUF keyboard shutdown naming and RGB readback
Date: Sat, 10 Oct 2026 13:15:56 +0300
Message-ID: <20261010101601.888709-1-bartualev@gmail.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series fixes the name of the fourth TUF keyboard power state and
makes the TUF keyboard RGB attributes readable.

The fourth flag of kbd_rgb_state was labelled "keyboard" and treated as
a no-op since it was introduced.  In hardware it gates the backlight
during the ACPI S5 power-off sequence: with the bit set the keyboard
lights up white while the machine powers off, with the bit clear the
machine powers off dark.  Patch 2 renames the field and carries a Fixes
tag for stable.

The remaining patches prepare and add readback.  DSTS device 0x0010005B
evaluates the DSDT method EC0.KBLS(), which returns a 16-byte snapshot
of the EC's keyboard state: lighting mode, red, green and blue levels,
animation speed, and the four power flags.  Both kbd_rgb_mode and
kbd_rgb_state become readable and report the write format with the
command word fixed at 1.

Responses to the v2 review:

Ilpo:
- Documentation: patch 5 adds the missing ABI entries.
- Errno: the helper already separates the cases.
  asus_wmi_evaluate_method_buf() returns -EIO for a failed evaluation
  and -ENODEV for an unsupported DEVID.  The readback keeps the
  err < 0 ? err : -ENODEV normalization for the positive ACPI integers
  that leak through, and the AML signature check returns -ENODEV as
  well.
- Named defines: patch 3 names the three speed codes and the four state
  bits, and the decoding comments are gone.
- Struct: patch 4 parses the status buffer through a packed struct.

Denis:
- DEVID naming: the write DEVID is now ASUS_WMI_DEVID_TUF_RGB_CMD
  (patch 1) and the read DEVID is ASUS_WMI_DEVID_TUF_RGB_READ_STATUS,
  as you suggested.
- -ENODATA: asus_wmi_evaluate_method_buf() already returns -ENODATA for
  empty buffers, so no extra handling was added.

Provenance: the KBLS buffer layout and the speed-code semantics were
recovered by static analysis of the EC firmware (ITE IT5570VG),
assisted by an LLM-driven toolchain; the readback patch carries an
Assisted-by tag.  Tested on a TUF Gaming A15 (FA507NV): the v2
readback on kernel 7.2.6, and the S5 behaviour of the shutdown flag by
A/B testing both values.

Changes in v3, relative to v2:
- split into five patches, one logical change each
- renamed the write DEVID to ASUS_WMI_DEVID_TUF_RGB_CMD and the new one
  to ASUS_WMI_DEVID_TUF_RGB_READ_STATUS, per Denis Benato
- named the speed codes and the power state bits and dropped the
  decoding comments
- parse the status buffer through a packed struct
- added the ABI documentation, with the attributes documented at their
  real location under /sys/class/leds/asus::kbd_backlight/ and worded
  for all laptops that expose the zonal RGB devices, not only TUF
  models
- added linux-api to Cc, which the earlier versions missed

v2: https://lore.kernel.org/all/20260926005625.171560-1-bartualev@gmail.com/
v1: https://lore.kernel.org/all/20260925200744.129714-1-bartualev@gmail.com/

Bartu Alev (5):
  platform/x86: asus-wmi: rename TUF RGB state DEVID to _CMD
  platform/x86: asus-wmi: fix TUF keyboard power state shutdown naming
  platform/x86: asus-wmi: name the TUF keyboard RGB state and speed
    codes
  platform/x86: asus-wmi: add TUF keyboard RGB readback support
  Documentation/ABI: asus-wmi: document TUF keyboard RGB attributes

 .../ABI/testing/sysfs-platform-asus-wmi       |  42 ++++++
 drivers/platform/x86/asus-wmi.c               | 123 +++++++++++++++---
 include/linux/platform_data/x86/asus-wmi.h    |   5 +-
 3 files changed, 153 insertions(+), 17 deletions(-)


base-commit: af32da41b0327b9c6a37856ba82b6760d6c8d10e
-- 
2.56.0

