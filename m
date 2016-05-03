From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH 4/4] signals/sigaltstack: Change SS_AUTODISARM to (1U << 31)
Date: Tue,  3 May 2016 10:31:52 -0700
Message-ID: <bb996508a600af14b406810c3d58fe0e0d0afe0d.1462296606.git.luto@kernel.org>
References: <cover.1462296606.git.luto@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1462296606.git.luto@kernel.org>
In-Reply-To: <cover.1462296606.git.luto@kernel.org>
References: <cover.1462296606.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Stas Sergeev <stsp@list.ru>, Al Viro <viro@zeniv.linux.org.uk>, Aleksa Sarai <cyphar@cyphar.com>, Amanieu d'Antras <amanieu@gmail.com>, Andrea Arcangeli <aarcange@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Brian Gerst <brgerst@gmail.com>, Denys Vlasenko <dvlasenk@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Frederic Weisbecker <fweisbec@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Jason Low <jason.low2@hp.com>, Josh Triplett <josh@joshtriplett.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Moore <pmoore@redhat.com>, Pavel
List-Id: linux-api@vger.kernel.org

Using bit 4 divides the space of available bits strangely.  Use bit
31 instead so that we have a better chance of keeping flag and mode
bits separate in the long run.

Cc: Stas Sergeev <stsp@list.ru>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Amanieu d'Antras <amanieu@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Jason Low <jason.low2@hp.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Moore <pmoore@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 include/uapi/linux/signal.h               | 2 +-
 tools/testing/selftests/sigaltstack/sas.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/signal.h b/include/uapi/linux/signal.h
index 738826048af2..cd0804b6bfa2 100644
--- a/include/uapi/linux/signal.h
+++ b/include/uapi/linux/signal.h
@@ -8,7 +8,7 @@
 #define SS_DISABLE	2
 
 /* bit-flags */
-#define SS_AUTODISARM	(1 << 4)	/* disable sas during sighandling */
+#define SS_AUTODISARM	(1U << 31)	/* disable sas during sighandling */
 /* mask for all SS_xxx flags */
 #define SS_FLAG_BITS	SS_AUTODISARM
 
diff --git a/tools/testing/selftests/sigaltstack/sas.c b/tools/testing/selftests/sigaltstack/sas.c
index 4280d0699792..1bb01258e559 100644
--- a/tools/testing/selftests/sigaltstack/sas.c
+++ b/tools/testing/selftests/sigaltstack/sas.c
@@ -18,7 +18,7 @@
 #include <errno.h>
 
 #ifndef SS_AUTODISARM
-#define SS_AUTODISARM  (1 << 4)
+#define SS_AUTODISARM  (1U << 31)
 #endif
 
 static void *sstack, *ustack;
-- 
2.5.5
