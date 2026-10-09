Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E6A4E73AD
	for <linux-api@vger.kernel.org>; Fri,  9 Oct 2026 15:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791560358; cv=none; b=d54FZ8IOqqOp9qDaoxA9YwlI6tzCdHS9p/Mir8gD1HooDZBLa7uLX9XJmh9sfozjlMW7KrSyZtuhPOff65CerqhQ1H5CDOpe1EDNoJoIF/WLOqw+GFJdZ1PsorsgJbm1cZU+uetLqmr4vjIcn5uLl7JhYzhc4g/HrrUpSHeeP7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791560358; c=relaxed/simple;
	bh=TjffoSVP4U16dnt8mBcrf/Uk0C+Nixv+EuwNTgnHh+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JUlWCR6/qX8EyNc6iJUEtZfRM9OJD/8pxTTnimL9CTcrMS/0KzSj58vgt578oePBkMp8spJQjGY5x+GLamIVUEqWliBv1Kga+DwTLHuPu6eqmXc3LajP0WFq0aytbDmsS+u8hqUG9y1oAv8id2+Bc6lVy3FDjieakUEnpInMCAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OsRnOCbd; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OsRnOCbd"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cd5cd8d89b2so202394a12.1
        for <linux-api@vger.kernel.org>; Fri, 09 Oct 2026 08:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791560356; x=1792165156; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=c8f77HHpsEH+i+dnyZRMXGpE/YS81V6WgUKKKT/nSTs=;
        b=OsRnOCbdRbeV2F6Sgld2+YODaq1d+Sxxp6QtaufZzSy0p1p/RaYQijJnWydKRzG67R
         Kh6wRa/tgdkRD+M/KdDM7PzPNghRcJVhI0AVuYpoMPL6/W6T/o0d/hTTwfzuWQI4Fp1d
         k+tnJsQzibIK6zlMmBHWK+1PpdCFTmOFJJj0KaUMhj/k2R/hEv+eoYXP/UsY+zp+GSAg
         7ienKE13+dL04vCVrYEE3g5XVxBs2sf055PprSpKpmXrkJGAyYy/IEi34+71BctKnml1
         KHZOw2WE5Wpwu8QccuQRgSkcvDI2GcHdW8DWA4V43vHMN8FCDlwO1o90HF6qgmjNef16
         lhDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791560356; x=1792165156;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c8f77HHpsEH+i+dnyZRMXGpE/YS81V6WgUKKKT/nSTs=;
        b=SL6GyyGZ8bzT1jk5DaVA3C2mLEyYXaKDMjsgx/+8Ws8f/W/WXvDxrYlYaWlpYhHLIJ
         palXUzb5e2iZYv3oT6E8tTU2x1CuDNkcC35fClLaH2mS5NNEGD17wumQyX2hnjGCjR2d
         ewq3/dq+EBFCJcoVvTJ8ceGdcWCxs03lIwWLYg8SwB7bQI0EaaZmXsxWIDBsLRx0SgBB
         QGFHH/CyNX6SK22Tk0Hoe6eQHsku3mp4iDWjveeoJQoV1ArNK+Gmk7qh5PalV4OECbg9
         uACzEjvGVbyyUoeSpQLxR/s0PebMgcef1lRBeGUsBDnzovKM2NFsdRdoAvYqeRBhe+JT
         TCSg==
X-Forwarded-Encrypted: i=1; AKwUvBw0tkWvj6pa15Tu3jRtmwJLkfxsiJY3YlM8VaL+3M5EUtyYHIstr/JO+uQLlIkVxhwbhELT4JajITA=@vger.kernel.org
X-Gm-Message-State: AFq9FYLVAN7uAS91fIUwW6OqGM/kHhd5Vs4XAB9r7bAuuUnsWSLWNRwl
	LbmU1d041AW5ez4iErdeezHxCb5slxyeOnSzIRvPC+RLbnMukm5xjZAW
X-Gm-Gg: AYBFou1SFSGNEdpgqu/ZDqlIdCMccYdBocYpIDXK1tE6KIvTp+v3iXE1mx/L1d3Har6
	qeCmPYbsAtHOOHvqG671eoEkqG/ar0CYjydAimb4/TYQ26w/taDX8/zQz7yIpWuEwh3T9bSFjcx
	M5E4fn1Jzc+25GTJDlrMgvZZGTGdhITwL0H2Tv7ZOGEa/iqMZATbRb6HMhGSZqbeiSh9oZ/rIGG
	ceC6Mm7sxJ2ZNrjFagKN8Jh2SiEg4bT1+Dcfr7RLSMlGNSaNXCzzO70DOWezMONQ7EcR044guiA
	5gw9+pWlQm4u9BwNc6J5I0M9nZ2V6Mj5wMsHel23loSnKy+o1cuBETeoYUod4S+v4MFn8tVRzTu
	zMSoU2sR7NcSOUEmYACFrA64lYaHa4if5qTCIWfEBmCDWp0yNpBHfxGcjOLWESXOJHO9A5XF9i7
	B93YRth8X9PvbCkHt9HWQfmyUQF8yJaWm261MIWDOR6UJU//EoAZ6CSMLv/o5PBfJxhCILzU7YW
	vV3Jh4=
X-Received: by 2002:a17:902:ecd1:b0:2e5:a355:56d8 with SMTP id d9443c01a7336-2e842e1555dmr20384135ad.42.1791560355778;
        Fri, 09 Oct 2026 08:39:15 -0700 (PDT)
Received: from mincom1 ([14.67.155.18])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421ae999sm11847705ad.31.2026.10.09.08.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 08:39:15 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>,
	linux-hwmon@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] hwmon: Introduce uhwmon for userspace implementations
Date: Sat, 10 Oct 2026 00:38:39 +0900
Message-ID: <cover.1791531025.git.hurryman2212@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series introduces uhwmon, a generic hwmon interface connecting
userspace implementations to the kernel. It exposes hwmon sensor and
attribute definitions to userspace through <linux/hwmon.h>, allowing
userspace drivers to create standard hwmon sysfs attributes. uhwmon
forwards reads and writes through /dev/uhwmon. The hwmon core handles
numeric text conversion and newlines for kernel and userspace drivers.
The series also adds kernel documentation explaining the interface and
how to use its UAPI.

In the October 2024 IT87 discussion [1], a read-only hwmon driver
configured from userspace was suggested for chips without datasheets and
for testing new chips. Guenter Roeck said he would need proposal
details, but questioned whether the hwmon sysfs ABI justified new kernel
infrastructure: userspace drivers would still need hardware knowledge
and access. He suggested an API between those drivers and libsensors as
an alternative.

But I see practical value in retaining hwmon: the use case below already
works with unmodified sensors through its existing hwmon interface. A
common bridge can similarly let other daemons expose measurements
without adding a new input path to existing hwmon applications, reducing
duplicated integration work. The idea is conceptually similar to
dummy_hcd with a userspace gadget interface.

uhwmon's goal is to let applications using the standard hwmon interface
access sensors without mainline drivers, without adding per-device
support to userspace libraries or building and loading separate DKMS
modules. In theory, projects such as wireview-hwmon [2] could replace
their device-specific DKMS module with uhwmon and adapt their daemon to
use it. My current use case is bridging the Tapo API [3] to hwmon, using
a TAPO P110M smart plug to measure my system's power draw at the wall in
place of an ACPI power meter. I have tested this setup in an Ubuntu VM,
including live readings, daemon disconnect and recovery, and reboot startup.

[1] https://lkml.iu.edu/2410.2/11841.html
[2] https://github.com/emaspa/wireview-hwmon
[3] https://github.com/mihai-dinculescu/tapo

Jihong Min (5):
  hwmon: Export sensor and attribute definitions to userspace
  hwmon: Expose attribute validation and string helpers
  hwmon: Add a generic interface for userspace implementations
  hwmon: Reject truncated attribute names
  docs: hwmon: Document the uhwmon userspace interface

 Documentation/hwmon/index.rst                      |   1 +
 Documentation/hwmon/uhwmon.rst                     | 141 +++++
 Documentation/userspace-api/ioctl/ioctl-number.rst |   1 +
 MAINTAINERS                                        |   2 +
 drivers/hwmon/Kconfig                              |   9 +
 drivers/hwmon/Makefile                             |   1 +
 drivers/hwmon/hwmon.c                              |  38 +-
 drivers/hwmon/uhwmon.c                             | 641 +++++++++++++++++++++
 include/linux/hwmon.h                              | 356 +-----------
 include/uapi/linux/hwmon.h                         | 372 ++++++++++++
 include/uapi/linux/uhwmon.h                        |  64 ++
 11 files changed, 1267 insertions(+), 359 deletions(-)
 create mode 100644 Documentation/hwmon/uhwmon.rst
 create mode 100644 drivers/hwmon/uhwmon.c
 create mode 100644 include/uapi/linux/hwmon.h
 create mode 100644 include/uapi/linux/uhwmon.h


base-commit: 7b63ef2d55f24519e7e9e5f4d15dbea03f126e40


Sincerely,
Jihong Min
