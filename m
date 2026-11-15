Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794763896;
	b=Jyg5annzlQz41EilX9ev6qxerfzSWe9Ad8g9tVFUJkNFQ3i1c1AbWg9Yo/WDOsHn0J+w
	 wy8zmfr4e9Qtk08+2KQ9N1AXW3B5sbKdis4ThLOcvB21WVcQGAsgFJN88b+nqbBmR+3kd
	 HrhA02TUzw2Io5IkJdvoqRWs+yNGEfAmBMZKcR447FyKUn5tWY69HQxIDsAcbF1Jy6iyI
	 MGhxVOQFhhaxy+Ly7L5j31AmU+Cn09O4eKCa2KvtOShi+b6AL0zUhwrBWfutRIRkkO2kt
	 yHidvZLwfFb6PLb/M1KuetjCtNdmJ4ZD6z5iYEg+4K9nu1HGzvZOp0W6ttiCcg/GRfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794763896;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=OOoGbzzliSLmnyqJeCjid1TcPxlvLpPGcbsazxaQIMo=;
	b=2+DGT/N+Rn1BIS/rPyrxfQwuwIuhJx6hc03GjJlxpMRv30fYeDKE8+Ccel0WE92WL2ZJ
	 zJz5T9lCG5v1nHXVf5whJpBQBsyB6Lm2HcuyQiBYORDrgbtFBdyNnvJkZaxc9pCRxH4Qt
	 PNHtqBQDvAgmIOHuV+MorDmmCmuQtxuTArXQqeqfjLHboOER77x+KKk/HhayrQ5gcX8Mx
	 Ld5WzkdLrfQmWw63INdoyUm5w1NntP/wR7z41nyc/e7uiB8lOvxO75q/aRe1lgmUjJ2p/
	 g6Iy3ktzpd73Na4/0LjTJoSVjlit3phKcl193RDg2vpOhsbL7BRtCA5qI0hLl+B4AnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=PmPyT0qd;
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FA3606A31D;
	Sun, 15 Nov 2026 17:31:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31FA3606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=PmPyT0qd
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=OOoGbzzliSLmnyqJeCjid1TcPxlvLpPGcbsazxaQIMo=; t=1794763894; x=2110123894; 
	b=PmPyT0qd53mliCIeOleZ2IoG3cOq1bzXqh0W4JtcfLeNRt0aGevW4A7RrKiMT279zPveLBqEpgL
	9/xLQ8EzlDPK9VpVtoQ5z9d1rvJp+4svoitqw3d4rhCpkEZvBauxG1cK7TuywJJX5sdtCXVQt37s5
	SnTZAP4Gxj3LAsISHVoNcHAa304xofA1YShAvURG2xEQ8+ifbSFlqc48KkSUmZgoOxFQT0k2gnl0H
	U+m9xZ3mr7+7fUr8qxeao6BEAw6MCmK7Eo3tzjNBC1Z/MnzoFJPxM3a7ZVxZNsxDqrHiMYktvkTAa
	4TVaHQXj7pfpuEvmKu8gXnSduUVTULTosTEQ==;
Received: from [177.172.124.218] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xSe4b-00B0BK-1i; Sun, 15 Nov 2026 18:31:25 +0100
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Sun, 15 Nov 2026 14:31:12 -0300
Subject: [PATCH v8 03/10] futex: Make exit_robust_list32() unconditionally
 available for 64-bit kernels
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
Content-Transfer-Encoding: 8bit
Message-Id: <20261115-tonyk-robust_futex-v8-3-a4fe47333a28@igalia.com>
References: <20261115-tonyk-robust_futex-v8-0-a4fe47333a28@igalia.com>
In-Reply-To: <20261115-tonyk-robust_futex-v8-0-a4fe47333a28@igalia.com>
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
index 28a6ad4a8da4..6fce97012015 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -1230,12 +1230,12 @@ static bool robust_list_clear_pending(unsigned long __user *pop)
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
@@ -1268,8 +1268,8 @@ static void exit_robust_list32(struct task_struct *curr)
 	struct robust_list_head32 __user *head = curr->futex.robust_list32;
 	unsigned int limit = ROBUST_LIST_LIMIT, cur_mod, next_mod, pend_mod;
 	struct robust_list __user *entry, *next_entry, *pending;
-	compat_uptr_t uentry, next_uentry, upending;
-	compat_long_t futex_offset;
+	u32 uentry, next_uentry, upending;
+	s32 futex_offset;
 	int rc;
 
 	/*
@@ -1472,7 +1472,7 @@ static void futex_cleanup(struct task_struct *tsk)
 		tsk->futex.robust_list = NULL;
 	}
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_64BIT
 	if (unlikely(tsk->futex.robust_list32)) {
 		exit_robust_list32(tsk);
 		tsk->futex.robust_list32 = NULL;

-- 
2.56.1

