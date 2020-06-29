Return-Path: <SRS0=AR3n=AK=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB25AC433DF
	for <linux-api@archiver.kernel.org>; Mon, 29 Jun 2020 19:00:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CE652053B
	for <linux-api@archiver.kernel.org>; Mon, 29 Jun 2020 19:00:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="LfGlIR78"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgF2TAq (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:00:46 -0400
Received: from mail.efficios.com ([167.114.26.124]:48098 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbgF2TAo (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 29 Jun 2020 15:00:44 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 2B8F926B41C;
        Mon, 29 Jun 2020 15:00:43 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id nUImhvXRtgxZ; Mon, 29 Jun 2020 15:00:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id DD78326B41B;
        Mon, 29 Jun 2020 15:00:42 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com DD78326B41B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1593457242;
        bh=yRiGtquXYPCKnEyIARANnhxrsJ53NZMKmbMlMj8D3uI=;
        h=From:To:Date:Message-Id;
        b=LfGlIR78By8/8roQib/qqkAK6+yO2iNQnY5d2StV4LtIkEIZpT+Nhs31qOt5kI+GS
         lnkr4B7x/iU+2WBed+9UIb3q4RsR5SoedDOGm0bvdTwTMLMFWXfY0LUNh1DmTUNtea
         k5d2/GnBiQlBeWOqsR4y5JhhVKANFh7tuC3Cm5QQfqB2fTgBLjB2jcVI+g0siEoyBp
         D3XJQnp1XsO46qm6rml0sqtVf3EyRvZU2AJiWeztafJdk4p63iVy5Xz/gbMBSNrBDJ
         VzGv5fywOyAO4mFSXbruv9K98GYzFCL8g71QGy9yqYfIjLuODVVSF1pF2gs6nsTs9J
         tTrmL3K7NIjNw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id o4in7l92-71t; Mon, 29 Jun 2020 15:00:42 -0400 (EDT)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 553DC26B4AC;
        Mon, 29 Jun 2020 15:00:42 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Florian Weimer <fweimer@redhat.com>
Cc:     Carlos O'Donell <carlos@redhat.com>,
        Joseph Myers <joseph@codesourcery.com>,
        Szabolcs Nagy <szabolcs.nagy@arm.com>,
        libc-alpha@sourceware.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Maurer <bmaurer@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH 2/3] Linux: Use rseq in sched_getcpu if available (v9)
Date:   Mon, 29 Jun 2020 15:00:35 -0400
Message-Id: <20200629190036.26982-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200629190036.26982-1-mathieu.desnoyers@efficios.com>
References: <20200629190036.26982-1-mathieu.desnoyers@efficios.com>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

When available, use the cpu_id field from __rseq_abi on Linux to
implement sched_getcpu().  Fall-back on the vgetcpu vDSO if unavailable.

Benchmarks:

x86-64: Intel E5-2630 v3@2.40GHz, 16-core, hyperthreading

glibc sched_getcpu():                     13.7 ns (baseline)
glibc sched_getcpu() using rseq:           2.5 ns (speedup:  5.5x)
inline load cpuid from __rseq_abi TLS:     0.8 ns (speedup: 17.1x)

CC: Carlos O'Donell <carlos@redhat.com>
CC: Florian Weimer <fweimer@redhat.com>
CC: Joseph Myers <joseph@codesourcery.com>
CC: Szabolcs Nagy <szabolcs.nagy@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ben Maurer <bmaurer@fb.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: Will Deacon <will.deacon@arm.com>
CC: Paul Turner <pjt@google.com>
CC: libc-alpha@sourceware.org
CC: linux-kernel@vger.kernel.org
CC: linux-api@vger.kernel.org
---
Changes since v1:
- rseq is only used if both __NR_rseq and RSEQ_SIG are defined.

Changes since v2:
- remove duplicated __rseq_abi extern declaration.

Changes since v3:
- update ChangeLog.

Changes since v4:
- Use atomic_load_relaxed to load the __rseq_abi.cpu_id field, a
  consequence of the fact that __rseq_abi is not volatile anymore.
- Include atomic.h which provides atomic_load_relaxed.

Changes since v5:
- Use __ASSUME_RSEQ to detect rseq availability.

Changes since v6:
- Remove use of __ASSUME_RSEQ.

Changes since v7:
- Fix incorrect merge with commit d0def09ff6 ("linux: Fix vDSO macros
  build with time64 interfaces")

Changes since v8:
- Update patch title.
- Add /* RSEQ_SIG */ for #else and #endif.
---
 sysdeps/unix/sysv/linux/sched_getcpu.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/sysdeps/unix/sysv/linux/sched_getcpu.c b/sysdeps/unix/sysv/linux/sched_getcpu.c
index c019cfb3cf..c0f992e056 100644
--- a/sysdeps/unix/sysv/linux/sched_getcpu.c
+++ b/sysdeps/unix/sysv/linux/sched_getcpu.c
@@ -18,10 +18,12 @@
 #include <errno.h>
 #include <sched.h>
 #include <sysdep.h>
+#include <atomic.h>
 #include <sysdep-vdso.h>
+#include <sys/rseq.h>
 
-int
-sched_getcpu (void)
+static int
+vsyscall_sched_getcpu (void)
 {
   unsigned int cpu;
   int r = -1;
@@ -32,3 +34,19 @@ sched_getcpu (void)
 #endif
   return r == -1 ? r : cpu;
 }
+
+#ifdef RSEQ_SIG
+int
+sched_getcpu (void)
+{
+  int cpu_id = atomic_load_relaxed (&__rseq_abi.cpu_id);
+
+  return cpu_id >= 0 ? cpu_id : vsyscall_sched_getcpu ();
+}
+#else /* RSEQ_SIG */
+int
+sched_getcpu (void)
+{
+  return vsyscall_sched_getcpu ();
+}
+#endif /* RSEQ_SIG */
-- 
2.17.1

