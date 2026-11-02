Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793605466;
	b=cmlrosqEkl7f/5VSlrbrzeAKZvT0KiPMMNqkdsbCvVz31EzmR3OQ6B5D0G67idMBsxEk
	 jJ/wBWCNN1BCclmMr8KDK4YZtCCaC9uzJvPOUeE3pkjMRf0powvGCshgn9m99h544QNZ9
	 bUI9AfB6R34tobEjqUWuIDtJ4PUOVH5ELJZenpcSm5+ob4PuoK8lh7clPjtlS7KxwmyqS
	 qg91J/42gtDpRlssS5368REY9Nix3IAQCHKROc4FB3nwvJCplbrLe4eVYY1lkWVMEFv2s
	 LMoxCz1Y0FCXQFQ8fgUqFdY+HfbzbJVSY/PpOgzE92eMLeEgp2IHMxoRDpfq4iRGVHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793605466;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=frsPb1t3Wa1UoN+W1OLcN+MUypjNEa6QpG2s8csovOc=;
	b=YYyVOf64MM+PfNYC46Z9gYW4HtT4huG+l6mRqqd1QC7q2rRJPdloJGrI8Xs6IECflxWk
	 /AkjpSKLhWTOcKITrIryYDzMODTcV5VKyYmVAMkogq/Oh+XtziBfxakDlAk+JJ3tqBP0B
	 dRwz+rku+g87TRfoYhdR5tSB8UIkKNV25rcbvLKVl6TlmCjDZ7ChCih554d1OqA6CurF7
	 yScodCX5fTUbspW46vAi8cfI7KBfMWNtMvrdKelGJBn5naqxkGPcL92VEqzveuI+RMuJd
	 VQitMQs13IdguJ2XBpp18pGSp8MXZU7SF/0otAnCOCEbknoAOYftFCVYKeyRT1ebbDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HJ+cDcAL;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE378606A326
	for <linux-api@vger.kernel.org>; Mon,  2 Nov 2026 07:44:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE378606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HJ+cDcAL
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48c4d99c32bso1802249f8f.1
        for <linux-api@vger.kernel.org>; Sun, 01 Nov 2026 23:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793605464; x=1794210264; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=frsPb1t3Wa1UoN+W1OLcN+MUypjNEa6QpG2s8csovOc=;
        b=HJ+cDcALq3xnIfz5alX6NrO8pJjmgk2lptN87Lv9/jmTYd0C8pjGqWCsPnsQnEFfIc
         5euRxL2BrUL2aSUkgYwLXwRP7ZCctu5IrmPKpKW7GynqOLnaZjgXlQIjlNqBhnP4mwL1
         +cvQ0Nv/F8WdxDo/MjyDGNymVkwMk6SquY8auEWQeUPjHYtExMe3rW5GAI2oF+uj9mp0
         bq2EjuUjcX7F3xx/ZrsCS+rEbt6D1tAk8pJmoWTlYIiPr2j67fUb7zHy45fa7Z7HpP4q
         e4646eu7GoZcH6b//6E1PYX57Ce4wYme0SB7JDWYm+WVcBBdWd+sdhipZELs0I2Y/uLC
         fMbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793605464; x=1794210264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=frsPb1t3Wa1UoN+W1OLcN+MUypjNEa6QpG2s8csovOc=;
        b=oxofZosCMZ8xSgla87u50FOkU1LI+Idp3WGGID3c2cnJ/4u9TkX1MHnsLAFF5sBNkp
         syNjZG5D7xo9nBYX0kJjKSmI4bKXUHRevGoZf12NFmnETo/01+E56zU6pzHITJSliSh7
         Wf56EdklE0qhU9zRhHvg3JLRRTG1hfCXI/47rLm58mcywJBUyGVFx+k6QcgS69R5AiV1
         F7q6RTZrnyUBzVXDuUZq1YiRmgI/nACQdfpGhkNx4q7PdSx2Rk0gmOu5qO6p7p+2bikL
         YFzFGwXBZzPf+d2KPMnX6kgQJVbvay6/ScIQ7kBWprG1vxmyAnskZAk6o5+Kq2e7W2Jb
         i8CA==
X-Forwarded-Encrypted: i=1; AKwUvBw73lnrL7Bwr3dRKFKeU2HntEJifJEH8POj+PEBWHPfYIGnJnwTkbTd9XZG2LBQUBO8mD+bKPl6AjY=@vger.kernel.org
X-Gm-Message-State: AFq9FYISIX4S3PDca0lEU2CoOAwdcxoI4JZ4Xpre7L6m9Xtj3GQT6H0i
	ovJntkK6xMcnNHQao+MJwN8hDLUVoKLEbNNrEjzZ3cp8aNwFebPR97x8
X-Gm-Gg: AYBFou1ajc6bna1jhb3H/iYtfRhsLTpcpPjNQuOj3rgyQuwfrrM/cm78eS39AOXjFN7
	RWD+zYfhCtiOhOp1AI/iPLG60t+nSvESv9A7GukWvn04KD0wiUA6OSx6BqKgEiN5jvAZvqO0L97
	hOlvU6YzeJItoCWMBWuBUspdzR5zYATrbXG8DUVlPWkn9U2DvxzWa093IL2ChgOI/jq/HFLO77e
	VSoxH/pUg8CtITlfjUosiERLEKbK+6SDx6dFHjBBlkv4i6wu6jked28Qk43Sq7ce0Kh78DFYeou
	XmUhKLnrkggbivBHSacPO5M1DmtnJKBVrz2r+DFJ2dAJb/olZgPW3PV/N/6pYIcSN6tp9IkIx+X
	IOCzNFjNWwR0pi4EVUKOUvHhmEyMlA3iPnf42bc6VUheIvpJswfnoYYROKkz25lIj5qGs5XGdVA
	TSVy3Tg5otf6aVHv2Pt73XBogdWKcA0/66T7sL1VWW7BMviRxVBuEQfHPq59ZgmeKZjSWNv1+ec
	+tB/PAP1MvYUyAgiC7MKg/qpmCNGDx1g3WlYh3MLu304K99T8+LxupicM49VC2mi+sIeIOm3y86
	5JkfpIwJ2E0KmQ==
X-Received: by 2002:a05:600c:1907:b0:4a2:1a:a116 with SMTP id 5b1f17b1804b1-4ac16fa15edmr211678515e9.0.1793605464208;
        Sun, 01 Nov 2026 23:44:24 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b81c74sm18050374f8f.36.2026.11.01.23.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 23:44:23 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	ts930@dgu.ac.kr,
	alx@kernel.org,
	linux-api@vger.kernel.org,
	linux-man@vger.kernel.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [PATCH RESEND 2/3] mm/mlock: reject ranges that cannot be represented
Date: Mon,  2 Nov 2026 08:44:00 +0100
Message-ID: <20261102074412.189554-3-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102074412.189554-1-azpijr@gmail.com>
References: <20261102074412.189554-1-azpijr@gmail.com>
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

A length within a page of ULONG_MAX wraps when mlock() and munlock()
round the range to pages.  At an aligned address the length becomes 0 and
the call is a silent success; at an unaligned one it becomes a single
page, which is then locked or unlocked.  An overflowing start + len is
only caught in apply_vma_lock_flags(), after the RLIMIT_MEMLOCK check, so
mlock() returns -ENOMEM without CAP_IPC_LOCK and -EINVAL with it.

Return -EINVAL, as man 2 mlock documents, when start + len overflows or
the end overflows when rounded up to a page.  Doing this before
can_do_mlock() also avoids making the result depend on
RLIMIT_MEMLOCK/CAP_IPC_LOCK.  Requests that get a silent success today
now fail.

Reported-by: Park Tae-sun <ts930@dgu.ac.kr>
Closes: https://lore.kernel.org/all/179066531783.50175.13377521828379196177@dgu.ac.kr/
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 mm/mlock.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 673a8433a0a9..0e9d8c110152 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -608,6 +608,7 @@ static __must_check int do_mlock(unsigned long start, size_t len,
 {
 	unsigned long locked;
 	unsigned long lock_limit;
+	unsigned long end;
 	int error = -ENOMEM;
 
 	start = untagged_addr(start);
@@ -615,12 +616,19 @@ static __must_check int do_mlock(unsigned long start, size_t len,
 	if (!len)
 		return 0;
 
+	/* Reject a wrapping range before can_do_mlock() and the rlimit check. */
+	end = start + len;
+	if (end < start)
+		return -EINVAL;
+	end = PAGE_ALIGN(end);
+	if (!end)
+		return -EINVAL;
+	start &= PAGE_MASK;
+	len = end - start;
+
 	if (!can_do_mlock())
 		return -EPERM;
 
-	len = PAGE_ALIGN(len + (offset_in_page(start)));
-	start &= PAGE_MASK;
-
 	lock_limit = rlimit(RLIMIT_MEMLOCK);
 	lock_limit >>= PAGE_SHIFT;
 	locked = len >> PAGE_SHIFT;
@@ -676,6 +684,7 @@ SYSCALL_DEFINE3(mlock2, unsigned long, start, size_t, len, int, flags)
 
 SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
 {
+	unsigned long end;
 	vma_flags_t flags = EMPTY_VMA_FLAGS;
 	int ret;
 
@@ -684,8 +693,14 @@ SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
 	if (!len)
 		return 0;
 
-	len = PAGE_ALIGN(len + (offset_in_page(start)));
+	end = start + len;
+	if (end < start)
+		return -EINVAL;
+	end = PAGE_ALIGN(end);
+	if (!end)
+		return -EINVAL;
 	start &= PAGE_MASK;
+	len = end - start;
 
 	if (mmap_write_lock_killable(current->mm))
 		return -EINTR;
-- 
2.56.0

