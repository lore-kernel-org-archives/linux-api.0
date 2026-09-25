Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9499B40DB43;
	Fri, 25 Sep 2026 17:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790358830; cv=none; b=EsMnnbkxDX0NFKBni8ANgXVRuVG0jFtCTLLS9Juxe5WZjI31UCoGm0L1ov4TlsdLrzoqq13kbL4CoNBsO3HPp2Z9rkzpPOn5656gDY0ywsUwPNjDzbJpvt6wHY0EubywlOB0Fkty/1sQuIvX8qz87lRI0/4aa0MxQHaxHBYt2Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790358830; c=relaxed/simple;
	bh=Q/2mBid2ony3PIO9dtx6pt4gxYJM3WeHbmy62eCoJFw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=po8OcsKhW+H3ksms24VSEAcgTZ6u/Ua5eyktYOl3xN8unlz1JrM8LnAq5b/WB7YAtAjIoWIaQ5eL4l6w7/arNCFsFIlPgXBKSNZG4/kSJ2lhQPeDzTD/d2yGKBfb8VnFt+huqYdDZaHwvadf2942HarWxasub2YzVEgbArNwS2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=UGK+0Kk0; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="UGK+0Kk0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=psP9N/lC0knD9v50TG7W2AIOlNJ6AWX05cvMgkgzsLQ=; b=UGK+0Kk0KDiC74DFEcY2DrUSYX
	COPgRzAz05VYl1QWBfr0z1GrannntcXbKBifSPhuJYEgWfS6+AhPjt8mtCuMLRFTkIe4qG8rtZB2o
	BwowVaos+skN7OjC+WczKsUcVFBu2AbJh2/1f6dowG1WGs9Yg6gaecsgt5hlMrBY5rTd/DMXzNZS4
	jHbijDvFSiMWf8u9j7XifTITspBFBzEntBnRWtPeFpxwEGBA0x+1DPvsMGaWxq/cKDLX7+QWIs+x0
	a8iIS++W57R3RrttISqlTD4e3Hj8QxHtZr1Xp6f9+t1sDv+vt0G5zrca7uLWPlNQEsXWayp9mbreB
	O9X3VT/Q==;
Received: from [177.172.123.214] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xAA7E-007GQg-1c; Fri, 25 Sep 2026 19:53:43 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 25 Sep 2026 14:53:26 -0300
Subject: [PATCH v7 03/10] futex: Make exit_robust_list32() unconditionally
 available for 64-bit kernels
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260925-tonyk-robust_futex-v7-3-d1095991152c@igalia.com>
References: <20260925-tonyk-robust_futex-v7-0-d1095991152c@igalia.com>
In-Reply-To: <20260925-tonyk-robust_futex-v7-0-d1095991152c@igalia.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Darren Hart <dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Waiman Long <longman@redhat.com>, Ryan Houdek <Sonicadvance1@gmail.com>, 
 Thomas Gleixner <tglx@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-api@vger.kernel.org, kernel-dev@igalia.com, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2

The new syscall set_robust_list2() needs to handle both 64-bit and
32-bit robust lists, but not every 64-bit platform have compat entry
points. Make exit_robust_list32() unconditionally available for 64-bit
kernels regardless of having a compat configuration.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 kernel/futex/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index 4b1bf211c3dc..6f01c27ae38b 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -1222,12 +1222,12 @@ static bool robust_list_clear_pending(unsigned long __user *pop)
 	return false;
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_64BIT
 static void __user *futex_uaddr(struct robust_list __user *entry,
 				compat_long_t futex_offset)
 {
-	compat_uptr_t base = ptr_to_compat(entry);
-	void __user *uaddr = compat_ptr(base + futex_offset);
+	u32 base = (u32)(unsigned long)(entry);
+	void __user *uaddr = (void __user *)(unsigned long)(base + futex_offset);
 
 	return uaddr;
 }
@@ -1260,8 +1260,8 @@ static void exit_robust_list32(struct task_struct *curr)
 	struct robust_list_head32 __user *head = curr->futex.robust_list32;
 	unsigned int limit = ROBUST_LIST_LIMIT, cur_mod, next_mod, pend_mod;
 	struct robust_list __user *entry, *next_entry, *pending;
-	compat_uptr_t uentry, next_uentry, upending;
-	compat_long_t futex_offset;
+	u32 uentry, next_uentry, upending;
+	s32 futex_offset;
 	int rc;
 
 	/*
@@ -1464,7 +1464,7 @@ static void futex_cleanup(struct task_struct *tsk)
 		tsk->futex.robust_list = NULL;
 	}
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_64BIT
 	if (unlikely(tsk->futex.robust_list32)) {
 		exit_robust_list32(tsk);
 		tsk->futex.robust_list32 = NULL;

-- 
2.55.0

