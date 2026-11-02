Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793605462;
	b=mVaBCWqeak5Gw4Z15tITzJHiFLhXqv48FgZcEevjB0TanS1UQUAHBCEejSLZ4NHTym0H
	 NyS4C84XszibF6aK4ZBLTmgM+Tm5IC+VS7ajXPNOOyOGTH9XN4vE35Wnwz0LUOy3VMZqL
	 ildt3JIefnuBFv2wdRq77PE+7uKDQAwZKmFsMFcS9JKsTIOdzHpgYEeqORH+BDDFvPlmm
	 m2J4hVc5/azsA7lVExC3Wfhp0g38u0WujKowu2yHTTy18vVzeEqIS6tbfYBG2GGvRWU2T
	 vcLgt1weKZx3JnLmaC31g4Ns0cr4pvPD7wGNhl1qCI/NYSZDgBlx7H5IXk9o7sP9jiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793605462;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KUnvJpVPViW69AF9NkZWmBblFWCE3alugKf4rSddKS0=;
	b=fIuZgqALIpHeA9d9d2KfWAICBI60xZoP2tuvL2XK4GH4Usb0fgPQUvCfDl0IeeW4dP/1
	 FYYGXXfio82+XqFQ7XwqznggPfhwS0yxJ3q/CUgwiuBc2poJR2uAYC2g6x6eZnK9FAkBl
	 wEvyX43o64nGYsly4ZAQOImrip1bqEvEEBFH5orZtx+xOpvBEHcvro+SHAJ9ZsP/xzRgs
	 vdmWP3TjlJ1lkA+HKE0yAvZlYKZzy6FrE0A4rCQDVvLf7d+6aBje2rzE6FYrDrVO4QV+C
	 2tINofRDmiB2U26VhMK0UfcI+ZiQiAd4cyj48v6ImHr8k71+nA7Q8sgXGbS4vbJx60Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QeLZFuY6;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8361F606A33E
	for <linux-api@vger.kernel.org>; Mon,  2 Nov 2026 07:44:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8361F606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QeLZFuY6
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48e3b22e971so1251472f8f.0
        for <linux-api@vger.kernel.org>; Sun, 01 Nov 2026 23:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793605461; x=1794210261; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KUnvJpVPViW69AF9NkZWmBblFWCE3alugKf4rSddKS0=;
        b=QeLZFuY6mIhG5rzjWO62mDesKo0jmIC+d12Httjn5kyoXafH5D2vvtFeUt40Vry7WS
         m34GzWAdpIRf8fdu4MqLLqQ4UBO5jbUVcSc5aj6KsNB/tK1vo4ffHQGnPr10MZoMPDiz
         IOmXiiPcmjbGg+rPF4qbqZvL3WqrdHND3PeC8ZQ8XVVIj2Qe8mFARNngJRFbpzkp4DIz
         i3oLbHSVB7/AMa2Q+kixbii2k1XlYcnonfs62EueJka30Y+0vJQsmM2lIUWGYYPWxTIS
         yUY0fqONZh76OqmB2NtlbMiAe+YAQqduPeD3+n5AdqAQb3wDt52BmrOHMkThaZg5S1ac
         uKbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793605461; x=1794210261;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KUnvJpVPViW69AF9NkZWmBblFWCE3alugKf4rSddKS0=;
        b=0OENEhQ/Ym+OEjoegHDn6sRAiEkpfUHpKQL7namXflMv4mhA8uiG/jude8M/DwgHuu
         iTUpy4IsfCUgm7bpHTjjFf3feni2wtMoYq3zRtv5O8WMzzOSBoeKAqBZM2ocaJvvyk/t
         XZQ5HsRnpUUAgv7B7MNwd2Up+NqOYkHZHwtMU95g4fnLiCmErxDZrXc2u7ihV+uQa72Y
         5A//4b8+9aNxnG4CmvyTNIFd0raQg6NDVtCcuzjFwQwX1QvpX1kCo1586fynTF0mCnXh
         hZM9uRb9cpFCHE/LsG9y8ElynFiJhs3fNVU0g78OG7zFoOYOQb3cV/Jma60LYVDCS6JQ
         teQA==
X-Forwarded-Encrypted: i=1; AKwUvByDe2fBTP1b5/tx0KLvJ/sQfj3sIx+JG6H1hknwqjvatnrI1f4d5hvwvhm8KgwHO/gFD2B1FpzYBiY=@vger.kernel.org
X-Gm-Message-State: APuU4Z/SFCzJekjPw0I75g3KnGGeOJSr8zf5uPqLeXTyMCrZCBbBt1Q4
	8DketzyKJU9ZvOl5zaOLM++8DeUi28OMehlj5IEMScY09hEQYHhqRcWO
X-Gm-Gg: AYBFou1TGOU/PlNn5Y7agNO6p08BiirM4VGAe1bGaIDG2r2hgw2OPVb63OCz3bKEYKT
	m0UHcWk2iqO5jLKq2zRLK5h1/vUiQ64fPguIqn11iYUlFI+V15sdt1tmoHC3X/yArtYIBL+8daN
	GaozCndxLJELfe+OlXO7AWL5JdZWCPyw/bjDLDX6uib6tCtZEj+KBer0IMPnSadE/WkYLcEyT/l
	30IDHTFUS4ZctzHhIH+20e+rAJyMG5JzLKq+SnJll9NS1j1fOZeeey9RzD0abSEGqKTxV95i4ss
	+JZcGPNv+i9v6x8BD3M6MOMUc6oi28b9Ft4SuTp6iDrfquMGxiwvvWU6OKAVvKHxH0dtBgZVT1v
	uMylhfAbyfVliwDn82hs5oeLsStboKRfFmrXog0f0xC9alq7oWEpWwFWZ9F71hliN7LQ+1P53hx
	PKDNJFrc4wId12KYUHta+rE09UcB9g9v5McAJFbljCPeR7qORw18NI6kU9bmHbYlYoLWQ2pegbC
	jX1Nu2bwVrZ2gO1IM7x7oahBsieqfYir7CT3JsrbWGxd7wQRh/QOVXi4McSsIwnokqD/l9jXniG
	obAP8LRTiXvPMw==
X-Received: by 2002:a05:6000:310f:b0:48d:f95e:6e8 with SMTP id ffacd0b85a97d-48e6e2c3586mr19528998f8f.1.1793605460880;
        Sun, 01 Nov 2026 23:44:20 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b81c74sm18050374f8f.36.2026.11.01.23.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 23:44:20 -0800 (PST)
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
Subject: [PATCH RESEND 1/3] mm/mlock: make a zero length request a no-op whatever the alignment
Date: Mon,  2 Nov 2026 08:43:59 +0100
Message-ID: <20261102074412.189554-2-azpijr@gmail.com>
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

A zero length mlock() or munlock() at an unaligned address is rounded up
to a page, so mlock(addr + 5, 0) locks a page that was never asked for,
and munlock(addr + 5, 0) unlocks one the caller may still rely on.  An
aligned zero length is already a no-op.

Return early for a zero length, before the rounding and before
can_do_mlock().  This is a uapi change: with RLIMIT_MEMLOCK=0 and no
CAP_IPC_LOCK, mlock(addr, 0) returns 0 instead of -EPERM, which is what
munlock(addr, 0) already returns.  man 2 mlock does not say what a zero
length should do, and -EINVAL would break callers that pass one today and
get 0.

Reported-by: Park Tae-sun <ts930@dgu.ac.kr>
Link: https://lore.kernel.org/all/179066531783.50175.13377521828379196177@dgu.ac.kr/
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 mm/mlock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/mlock.c b/mm/mlock.c
index 1c70a7829394..673a8433a0a9 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -612,6 +612,9 @@ static __must_check int do_mlock(unsigned long start, size_t len,
 
 	start = untagged_addr(start);
 
+	if (!len)
+		return 0;
+
 	if (!can_do_mlock())
 		return -EPERM;
 
@@ -678,6 +681,9 @@ SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
 
 	start = untagged_addr(start);
 
+	if (!len)
+		return 0;
+
 	len = PAGE_ALIGN(len + (offset_in_page(start)));
 	start &= PAGE_MASK;
 
-- 
2.56.0

