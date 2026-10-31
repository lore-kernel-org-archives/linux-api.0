Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793431335;
	b=qkgrhv6YJDAB0mx6lPXKyBLbYwLKDJHQs3lfu9G5ysVyxkfuGipC54gmoi9v/OXL0kqQ
	 QIJQYg/vOIuyr6dsXGUhGnxNxaxlJ0cilHPguffoqtSc977UxxffVOEedI6U4S4y9QElz
	 BnOxxyfKcYnwbNsN/+LV1051QXz3/FFJQviGWYo29gS8z0r2kM8fQflUMJonyQKLGdLKn
	 lQWTGXEnQftn9eowa/Y6QFtwZfLMhUhV5oqtF7VvKSQmAPs5dCOj0Fc6OxjyQbuj+t6h/
	 799y/KPKtwewCKJMaFubZcMODfZUf8WHX+n95WLZXDpV4/nBinGF3dpUjKz08SexLqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793431335;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5xJ2Aaj5OkzQ8Zqzm1v69zHKFwlKxaSVQ+QJZIXxxzU=;
	b=IMZI6X7PO0kEqqCbdrwXouR2hDWJzpcTUckHcmYxXTah6+97ppG4MfxGkAg6pWxcBe4m
	 dJN88bBaI5yqoSJiVtYJtyVUVoHBcrkE+tDtRT9SQBO4TJ5mkuuJxQfq9iqOKJHQdwPWI
	 BAsNvcgHQk9bPGMVmbpm34sbUwE0qAyQDnWrt7HC5dkFMhbR+re6nrVmOme9OGXd+sUaB
	 /csR1j2gd4EPSSnDGSv97QX9ki6NvoowKD8JHdU8KNbk8U59Zxk323YMo+AXakZuW3Vib
	 oVP9h4r5u4m4/3l+vHxcBPPEV0z1qKOIHwFC1Tx21uQQv2gEgaBK4VnGLMnEH4YE3zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sUDBAl3R;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07356606A31D
	for <linux-api@vger.kernel.org>; Sat, 31 Oct 2026 07:22:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07356606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sUDBAl3R
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso14745205e9.3
        for <linux-api@vger.kernel.org>; Sat, 31 Oct 2026 00:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793431333; x=1794036133; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5xJ2Aaj5OkzQ8Zqzm1v69zHKFwlKxaSVQ+QJZIXxxzU=;
        b=sUDBAl3RdCdqV4LujOE/vJNIErc6UaAwV8HQ1kXCA3PtrlRLW5eChfdFxSrMwwq1S9
         rqvMFG1WYDr7CAhRUfBpNHjZj1m+8d4ElM2OUuPtgg3gWfEdoJYdGdTg56kBap36SFmM
         m74k/iSF4SYzgOh/H1tEv9Z8yU/sJDljL0f+sBHBK4H848apG2I9zhcLWOzFwVIxm/6l
         RKp+IQoBmNo8ugmk6gjiBI8t5sIpWJ/N9YhVsuhcpCHvEkwe2HlLva6ojx8GTNKT4phF
         vOuc9CWql0bethLcCHh6xVqnqagqw6l3Pt5xjPyplpoahFwylo6Xmlxq5bTCbllVjbRS
         WrPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793431333; x=1794036133;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5xJ2Aaj5OkzQ8Zqzm1v69zHKFwlKxaSVQ+QJZIXxxzU=;
        b=QGbR8xJT5zEgqfjbQYZMXQwvAJcGffTYyxRqbmbRZFA4iKb3v/gHq3OKKqLxkf87B5
         nvYNzz8QK+vSKxzjvlSbdAmG0p4cOpi6lcq1r0qAVx9PQghWy6tJwlWBKmY7Zg/uGH/V
         TS3J6vXj3FKrpRP+4F9j/5+VElQWySX4/dyxUgFKm1wT3/mPA6waGaRDp5Ajn3/EBVqg
         KUDHVMARU5MTYgWBhEIAYdYUcPPsAttBH4rzy9OC4jqaQJY0deHIuEqh9Lxc7+nRbiD9
         JEMrRyJqIg3AM4ZAKcrtcpAD+4raMNEp1qQrU8WetDDqqgS/huNJsbIAA3baquW2KJKL
         OptQ==
X-Forwarded-Encrypted: i=1; AKwUvByHeyQIYIvB1VR4bT+8eRmQVRGDRl62kjD7fvWH77hz89Gd8vxErq32AS2XK7pmsKRu0Y1PvBHDXV0=@vger.kernel.org
X-Gm-Message-State: AFq9FYLAJCHlgGJ7auLypEfaVDcD9XTqMGxGK8iVSgs47HcYZ31m3mX3
	V1YmDylUuNHb4JIOKlBh9EWBs9D0hlfgv09XZ6ugebcrraVDTN+CEcD7
X-Gm-Gg: AYBFou1Cbis+/bS4WmWWLhEFiRLF0sLb2Qqf3T7YChyelAvawcpTMmvqM4TJVo+PK9u
	D6OaEHJ5D0Csspk6vOr8Ii3TGlBiIAK1s/1ybW2CdQYeqY8kOShGu6B99iwzVVTbTZLoK/KQkLt
	9O4AoUSPmYYfo9jZ5DSmrl0/fwrKFxhQc9n9EpWN60W9SzKTwARxBEvN3pf1IUjhtjqf1ihnTnF
	/Ft921m2LvQw2vAuSRLya5UEGkcl89lQNjXCxaciEpWRZoQp+RcO3joyw/pPpCxmi4oBfug2uaW
	NYvLgdX2ZzxIOto/Sb/7INfHs+T+uRncgNEhyq7i7lKza5epudunECZfbhUOgeQOpaOD0ZZuiQn
	DGuoKpuIKrUzNt3tF3scl68bKKp7yBN+TDSbMA/qK1tVlAy+nWn8s1hzgGcZVO3EAQQirsJBKxJ
	gl0SoAqPxzxluCt+UrlaHKl6WLy5oHvEJ5D1CM2RyT8UnmOTAVKPLm5anS5opt9uAlXqm3QYgFQ
	VC3a5eL+ktXoxTdBUaJ4qGbtGfFEAIYVHRIvscEDXRHh0LB21EdpN6ZGDXweAxOXVK2eXwqs/Uk
	82fG1kiXyZTr0/Ux5ug0SOhMKnSUZ7IZeC0IQE/g5LVu
X-Received: by 2002:a05:600d:a:b0:4ac:aae6:6401 with SMTP id 5b1f17b1804b1-4acaae665d8mr56656675e9.12.1793431333162;
        Sat, 31 Oct 2026 00:22:13 -0700 (PDT)
Received: from localhost.localdomain ([2a06:c701:4773:6f00:c8d4:ec29:293e:f39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b723b4sm7709687f8f.17.2026.10.31.00.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 00:22:12 -0700 (PDT)
From: Avi Weiss <thnkslprpt@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avi Weiss <thnkslprpt@gmail.com>
Subject: [PATCH] fs: clamp FIONREAD result to int range
Date: Sat, 31 Oct 2026 09:22:09 +0200
Message-ID: <20261031072208.3096100-2-thnkslprpt@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FIONREAD returns the difference between the file size and the current
position in an int. When the difference is outside the int range, the
result wraps, so a file with 4 GiB remaining can be reported as empty.

Clamp the result to the signed int range before returning it to userspace.
Preserve negative counts for file positions past EOF.

Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
---
 fs/ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 1c152c2b1b67d..ecc2a4cfe6100 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -7,6 +7,7 @@
 
 #include <linux/syscalls.h>
 #include <linux/mm.h>
+#include <linux/minmax.h>
 #include <linux/capability.h>
 #include <linux/compat.h>
 #include <linux/file.h>
@@ -550,8 +551,8 @@ static int do_vfs_ioctl(struct file *filp, unsigned int fd,
 		if (!S_ISREG(inode->i_mode) || IS_ANON_FILE(inode))
 			return vfs_ioctl(filp, cmd, arg);
 
-		return put_user(i_size_read(inode) - filp->f_pos,
-				(int __user *)argp);
+		return put_user(clamp_t(loff_t, i_size_read(inode) - filp->f_pos,
+					INT_MIN, INT_MAX), (int __user *)argp);
 
 	case FS_IOC_GETFLAGS:
 		return ioctl_getflags(filp, argp);

base-commit: 36aad21d50d1af3f6954bb0c988257a908202477
-- 
2.43.0

