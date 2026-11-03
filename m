Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793725821;
	b=DrOWlFedKHIXQ2PEhDEBJmLlsdCD8Zp4B03tqrDtUNEdAYuWRYocCutr+yqccVSK4fro
	 sAKyaTqB/P58u4j/4t7m9emjn8+mqLtmTUPRypUfUz7Qspprkgsc8pb2/yMgjVHD3AXii
	 c1UsF7ZxgZ6NdYJVGXe0TQ3n01s/ZIvIgD3urVMw4f52aPcVLrTxtQoXBZ4KxTOaEtTBL
	 PjTPQEFVF/g67QQirTzDEYkNwppZy+e9gT/+QJN1Mh28JYh2MzKZ1CRl9GI+zIh9gO7eT
	 pbE9CtFFvbLf3522zQLfQ0PxsSJKu7wCNGyEtGzYNgt61xF7An43I7gq2eg3EOKJ0ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793725821;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=v98czZJjrFY0hKiKY11IKxTSpAh/LCSHwoFbHDSEB+0=;
	b=VoQsrcvZlic1K28ZS2laK256JwqzEFBLxYdKH1BetX0pxc8w9W59J2GT75Ghp0ddUk+W
	 We5Apg4TbqSSS7mc6+BHflaMEN+OVEdHFDBGyC4cqRw5MLBdtyL6nI8nz+tDrL5SJVZb3
	 UWfLT5IXQC1RNlZRb5oASxcyw57PaqN5kk4pgvBg7PwjD+RU/LPP85bI+HVzdOjFEzcHC
	 CD2atdeqkmM5T7ukqatfR92cOwAJQye+zRBib4FdM6DYE/i1QZZaOAaZLfJwJD1Fkco+f
	 pDI9MjJ87Tjy1Jk3fv4PqB94V+38QfeQqge7na/D05rmUY0UE3UhosrtEAiOztRw8Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OIjvoPlh;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6B8606A33E
	for <linux-api@vger.kernel.org>; Tue,  3 Nov 2026 17:10:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE6B8606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OIjvoPlh
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso36214965e9.1
        for <linux-api@vger.kernel.org>; Tue, 03 Nov 2026 09:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793725819; x=1794330619; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=v98czZJjrFY0hKiKY11IKxTSpAh/LCSHwoFbHDSEB+0=;
        b=OIjvoPlhEcC/mavN0s5g8B1KSJ3zQtXy7YeWfoqEhXVNkSWKQnNFAeJZz8I2Dh914p
         xxePxGvSW7Y1CE2m/+d9g/gYqpeOwSVuaE+5FzxISuuDYq7YdktGn2C7a9S3JDDjEqxB
         rOZREhKipGyNj27oBhC7Q/aJq0TkeQsrUP3J6zQKpBq9H8IXSgm6F7iWeE4n6YiBn2uz
         Kj0GjbZBofKvVDY+q1MhIxwMb56ytIvN8XmKi3BcSgnkYe6ccGACw3ydmtdvKag0cAd+
         711PVlA696c+VOhublTnygHUeb9ijDFrOQPjAzFUmKta3QEP1PMtHVGy2pwI2TNT2Lzs
         U9sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793725819; x=1794330619;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v98czZJjrFY0hKiKY11IKxTSpAh/LCSHwoFbHDSEB+0=;
        b=tSiQjgBJf49YIkw5I3Gm3JSFM8c10q67CRAcd0RkiHBAk/nLYcvNulkY89qu/Ox953
         gSwSFBMepeF1R+7ODIh4BIqV5kyqR5iYtlB81ifRcI9NoAOoqVgEp9pUci82AywYb4mm
         02sRh0osGJTsGVo2IpyRI3vYQovYZuzcJk0m24lHZMF3RrToXIA25c9qGdET1E85rYJ4
         2XH0zFxgcHAkahQmZWE+nwEpH0hQM/8oWdPGFO8Zr/SB4BdS6BZfGMAIrYNuUZu38IH+
         d9KT3+5lUwlVgx7lf4vz83ztter+bCcBqAWShku9+VNjUDTw+/cFkbtz0DyLLv2BvRIS
         oGxA==
X-Forwarded-Encrypted: i=1; AKwUvBzXUaDhKN3SIFz8ngcMln8XCML0lEOZop3aF/lx9yuZSVY/v9/SzjJ+3iWOd14XYNyK7G3u7JO/Klo=@vger.kernel.org
X-Gm-Message-State: APuU4Z8SKpqt/Dn8rJmVbop1ooMjYSEJ4yBlwp7AqPMUYFzny//crARe
	XfASE1DRu0PLJj9fQntzVa7WLdHhfAnUfpXCj3aVZEARBPUsKISgq7m4
X-Gm-Gg: AYBFou2ygK3DjZJ9galC8751jqH4sGSNfISznMEVGEJfTi2ai5/gWAunmX/brtJZTEw
	2o1KLCifSd3wyGuJTz5J3sOSGCsNoImM6vB5gqtFBUs4GwBal9vGlQNuySw57DisZWdVUSBKHpN
	4Nv4Bl65uf47wcbTMwpIhsLFmpZvmupa4jkxuMDYbdpd3yKhDK6R8kPqMqw/m4sm0gQgCxGgxnf
	CPZUDv56KnmH+KIgKbptbzaMwGVmmD/wEgjx1VXl2+ZPreK0QmAoQZIS9C34YEsqbUVSRP4ffE2
	2VWtAsmVMiRUO93Yzva3b+PX/8rK1dZkf2/GhCsBP7wsWarwXdwZ/XMHfoHRuRPFXSooVClzOuN
	YX/F7m4DEwxtjVE+BxHZrTRWLtFTZQ6dqid2bTPcFHPt160Ap5aha1ADsoq796SBk3UdTnaB8+q
	/XMcMTlGwNNKVvkqQK8GOiEKk9IkBhrgGj1uhYLczH4Xae9GoDOeebldKBc/aJYR+BBd0shWVl5
	521jA9YJb39dWqLLrkasvkRCxb9Lzb/uTP8eTPOiFRMV3w8bHP67F2TwBYFy7a6B9RIGero6Lsm
	1Nc9v2iS2SCmI66FMT7KjCBochzyfUMh27Ew8HdRR8o6lTT2JSRfi+Fs
X-Received: by 2002:a05:600c:a48:b0:4b2:2ec5:8a2b with SMTP id 5b1f17b1804b1-4b22ec58f9emr97823365e9.10.1793725818948;
        Tue, 03 Nov 2026 09:10:18 -0800 (PST)
Received: from LAPTOP-AVI.. ([147.234.101.233])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a9fafe08sm112749075e9.3.2026.11.03.09.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 09:10:18 -0800 (PST)
From: Avi Weiss <thnkslprpt@gmail.com>
To: mingo@redhat.com,
	peterz@infradead.org
Cc: juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	tommaso.cucinotta@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	Avi Weiss <thnkslprpt@gmail.com>
Subject: [PATCH] sched/deadline: Clamp negative runtime in sched_getattr
Date: Tue,  3 Nov 2026 19:10:14 +0200
Message-ID: <20261103171013.2511027-2-thnkslprpt@gmail.com>
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

A SCHED_DEADLINE task can overrun its execution budget, leaving
dl_se->runtime negative until replenishment. Dynamic sched_getattr()
copies this signed value into the unsigned sched_attr.sched_runtime,
causing userspace to see a value near U64_MAX instead of zero
remaining budget.

Clamp negative runtime to zero when reporting the dynamic value.
Keep the signed deadline accounting unchanged.

Reproduced the overflow on an unpatched 7.4-rc1 kernel in a QEMU
guest. Verified that the patched kernel reports zero for negative
runtime, while positive runtime, static parameters, replenishment,
and non-deadline queries behave as expected.

A five-run VM benchmark of the unchanged static sched_getattr()
path showed no apparent regression (median 110.62 ns before,
102.10 ns after). Negligible improvement maybe just due to noise.

Fixes: 2e7af192697e ("sched/deadline: Add reporting of runtime left & abs deadline to sched_getattr() for DEADLINE tasks")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
---
 kernel/sched/deadline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index c0ebdcde5fe5..7b098da8076c 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3870,7 +3870,7 @@ void __getparam_dl(struct task_struct *p, struct sched_attr *attr, unsigned int
 		if (task_current(rq, p))
 			update_curr_dl(rq);
 
-		attr->sched_runtime = dl_se->runtime;
+		attr->sched_runtime = max_t(s64, dl_se->runtime, 0);
 		adj_deadline = dl_se->deadline - rq_clock(rq) + ktime_get_ns();
 		attr->sched_deadline = adj_deadline;
 	} else {

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.43.0

