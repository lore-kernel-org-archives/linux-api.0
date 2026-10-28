Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793194435;
	b=MXP/sw6K6ozzcWFpRrERNb9Hqnk9qdC0Vv8mQYSX3aghVKoMHzUGUTzZW5S556LUw/U5
	 AwdFd2NjWFpAGdGt8259cQ3Y0mjG6KFDXpnjRFCTA49dZdcA21TuXWuNKxoF8sgIkMQnt
	 0eqLp9u6ss6bL0EZ+cVo8LE67n5SJZoPHRcoVPpTCBLOSN7zYD0n5/Vd5bUp/z67kODr7
	 Xjc2z7zHFR6ikNYzsb6MvcgD0rNCZqNxBISa0WokR/yMUACbHiCmfUUpn2uuyeZzttON5
	 GYl36ae/R1wh0Irz2vP7hXVt1M9BC3j21AM4l+GP8lU7Iy8dhzUv4YSbnqpXO5CwvPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793194435;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0jiG2rD9So/arZvMAXmt3lPJiORsbNPvj+sHUkRM/lY=;
	b=p0rmGOcvAz2fxKBhp7iaiMLM5v+2mA2YgjG8RTsOd9Y/IW/0lAH+kzBGbwtXYkByZckD
	 qZr7v1VGq6jHk+R9S+eknujI10ZoqhBvSSShp7EZpQzq3pgXrjHZclJF4cGGsJTELWT5p
	 hFHsfGQ7NfdJ6lTQvFaLppacdTke+uszvk5gODyC5Dtj/8brK+vP4E/heC+2ws8m4KJL7
	 GlM2GGDm6OlxuTca6Fs9DOYOZb69YEM7sFhiNXqtUpjZwLajjVGTm+v5nOLxpTcQVGI2o
	 Iw16Qj/IHFE8Mg+SG7iBq0RDWFePJYD4A4uykxznXyFIB5ijLyzA9eFrvFdTx80+jkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=armoriq.io;
	spf=pass smtp.mailfrom=armoriq.io;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="dLn/UHz5";
	arc=none smtp.remote-ip=74.125.224.50
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7D860A261F
	for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 13:33:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D7D860A261F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=armoriq.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=armoriq.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=dLn/UHz5
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-67583c777abso1182264d50.1
        for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 06:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=armoriq-io.20260707.gappssmtp.com; s=20260707; t=1793194434; x=1793799234; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0jiG2rD9So/arZvMAXmt3lPJiORsbNPvj+sHUkRM/lY=;
        b=dLn/UHz5laULvOPw2Z4Il7Aes12V3tgaa7l8ko/Z6TiMfArXMOE0vl5uTrR+SM5+UC
         UXFW9wsVIwY7y6LQZ8Kp7zfKyM2kDUosLPf1Ulylv65drrBZkQnx9UltIGDC7E6Y8v5X
         vwnC3zFVtn+PPhm6Xqmb90g5fxvW3ExPK0sCXwdU1j6tyT5zdgBDt3uLraIrJulfCxZu
         FACMECN/6hf9PgeufeuE3m5Z/5aJMCrCGQdje9ZZQeU4OZytdlGUyRiMn2lENLTUQC0I
         cX4W5vCVgrdNNQaW6ET7ZfWTwM7jkpctDlFBps+8rRNUpTevoiHxA0NpeASFFj4Jj+Tt
         BQPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793194434; x=1793799234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0jiG2rD9So/arZvMAXmt3lPJiORsbNPvj+sHUkRM/lY=;
        b=Sz2OeJOiEnNVHMuwB7WZuA4h+booyXkPGkVN2ed5TIANrO5jVuUbEZYkwFc7sqn4m9
         I4hWSt8dCfJhDrBlqV0ZD/fHjxfvNp0STy1E0CkQL9X09+78VGwdTJxI8ZAomc6mrfJD
         eU+Hm0ioeUwEehCCfq3EGfJX8ElOJEEOz5UT4yx/O6dBngGhya+6p1kMzZkzq1CbVxvl
         EeVM1siAAdL+Oe9GWTeV1ElR2TtudFS1ibMb3AazLGhrBDPiDZWhz5ygX+9yJyQ+89GJ
         rQzPKk2nsbfSM7caS5X+9v4IGRN7Z/HPSSMbYfDCjZS9o4L87WsVIoUKAJ7ylpIz63gx
         Mkeg==
X-Forwarded-Encrypted: i=1; AKwUvBylBt5aVb8iQI9XxQ3ZifPlUF3D0ZfIpViZxzyu4ujsuKIlJji21XxI7NXDOJ5j7v1evxpUvb0oV0k=@vger.kernel.org
X-Gm-Message-State: AFq9FYKaJa9R837Ie2Gfg2vQ0MlHbiniZewHQ+7WM3tyq2LERX7SwjoX
	B3ZrimAG9Mw3RjzBKy8/kAlp0SILjOWJhO9kYTHxcCxJpZIhs2ji2VgIgqB+yBBPb/1/
X-Gm-Gg: AYBFou1WN/YEE7ggcMRYnujyJIYZ3CFrA0icSGj/TrxWayXe9LJMxwpKSGcMWZBuZaE
	gqdgl6jUpb3l9ey4KeueO7Wn4fDiUbmasjBTTL2cZ30B15oaO+0xrwzaVf31rfSn+OZbHv1AquN
	8VwdzrWH5XXJ3FTdyeAs2uBpX7BahZgpl5sd+JeuVrAurUbTSHy3kx0WJAZQ+O2ofNpLrvaMumt
	mSGUNn6nys5uFgmj8d4lz0G7qQGiaXDoxPWmbdA1NpAEYMfGtq7jRjoA4NMsRFsB5TxRds5DXcq
	LkLglcUZyqooRPZ4T05mSTGgWHGn57V1dIKGLQBGtYxvNVTjVnTv+SDFHvMkZFaDrhE6hONhl20
	uHEiiIAW8C2iFH3K0HwPUTeXEQXCB8rgwsa4I0WVj/zk9eTj07D64i/3O3u4/lA7pSiJ2jDfHBr
	D08ajy0kFFE5tiZAjaiGtX6rmnLjLl2r4Xj+6vxppKjKPx8ev0a8dUYmPnPeB3ZQWl+Xubn2zyY
	Vziy68CVbQ6r0U2w0BL1FHX6YRawVEtCdhC4grcex+SVvIbsZuV3ZB0bllMULUvZSi1YL/7PlWX
	6LLwRNjzXbUVV3pCvdwqWGIddT94QCr1le2JxuL3haE8rNO5vNhc2TDTG1nEwDYHdMGnzpvyyYT
	0U2HQ3w3VYvvEGqrGqAiCXwHt8dMPHkjypbxbGFA1cPDKdg0=
X-Received: by 2002:a05:690e:4884:20b0:675:449d:3d72 with SMTP id 956f58d0204a3-67a814bcec8mr653958d50.32.1793194433581;
        Wed, 28 Oct 2026 06:33:53 -0700 (PDT)
Received: from CC-KJQTV599DQ.attlocal.net ([2600:1702:7b5a:ab90:103d:30e1:1f09:a9ae])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a79f38dfesm1694911d50.1.2026.10.28.06.33.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 06:33:53 -0700 (PDT)
From: Ketan Bhardwaj <ketan@armoriq.io>
To: Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org,
	linux-api@vger.kernel.org,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	linux-kernel@vger.kernel.org,
	"HARIHARA SUDHAN . R" <harisudhan@armoriq.io>,
	Ketan Bhardwaj <ketan@armoriq.io>
Subject: [RFC PATCH v2 5/6] kernel: add KAP checks for unshare and setns
Date: Wed, 28 Oct 2026 09:33:34 -0400
Message-ID: <20261028133335.75899-6-ketan@armoriq.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261028133335.75899-1-ketan@armoriq.io>
References: <20261028133335.75899-1-ketan@armoriq.io>
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

Check unshare and setns against the bound task's authority. Neither
has an LSM hook, so they call KAP directly. Every namespace type is
checked, and setns checks the type of the namespace it is given.

Unbound tasks are not checked.

Assisted-by: Claude
Co-developed-by: HARIHARA SUDHAN. R <harisudhan@armoriq.io>
Signed-off-by: HARIHARA SUDHAN. R <harisudhan@armoriq.io>
Assisted-by: Codex
Signed-off-by: Ketan Bhardwaj <ketan@armoriq.io>
---
 kernel/fork.c    | 4 ++++
 kernel/nsproxy.c | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index eb198c8..4216a2d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -52,6 +52,7 @@
 #include <linux/cpu.h>
 #include <linux/cgroup.h>
 #include <linux/security.h>
+#include <linux/kap.h>
 #include <linux/hugetlb.h>
 #include <linux/seccomp.h>
 #include <linux/swap.h>
@@ -3276,6 +3277,9 @@ int ksys_unshare(unsigned long unshare_flags)
 			 current->fs != current->real_fs);
 
 	err = check_unshare_flags(unshare_flags);
+	if (err)
+		goto bad_unshare_out;
+	err = kap_check_namespace_flags(unshare_flags, "unshare");
 	if (err)
 		goto bad_unshare_out;
 	/*
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 3fb1595..d41d7f5 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -25,6 +25,7 @@
 #include <linux/proc_ns.h>
 #include <linux/file.h>
 #include <linux/syscalls.h>
+#include <linux/kap.h>
 #include <linux/cgroup.h>
 #include <linux/perf_event.h>
 #include <linux/nstree.h>
@@ -589,6 +590,10 @@ SYSCALL_DEFINE2(setns, int, fd, int, flags)
 	if (err)
 		goto out;
 
+	err = kap_check_namespace_flags(flags, "setns");
+	if (err)
+		goto out;
+
 	err = prepare_nsset(flags, &nsset);
 	if (err)
 		goto out;
-- 
2.51.0

