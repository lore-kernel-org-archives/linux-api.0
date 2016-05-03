From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH 1/4] signals/sigaltstack: If SS_AUTODISARM, bypass on_sig_stack
Date: Tue,  3 May 2016 10:31:49 -0700
Message-ID: <c46bee4654ca9e68c498462fd11746e2bd0d98c8.1462296606.git.luto@kernel.org>
References: <cover.1462296606.git.luto@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1462296606.git.luto@kernel.org>
In-Reply-To: <cover.1462296606.git.luto@kernel.org>
References: <cover.1462296606.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Stas Sergeev <stsp@list.ru>, Al Viro <viro@zeniv.linux.org.uk>, Aleksa Sarai <cyphar@cyphar.com>, Amanieu d'Antras <amanieu@gmail.com>, Andrea Arcangeli <aarcange@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Brian Gerst <brgerst@gmail.com>, Denys Vlasenko <dvlasenk@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Frederic Weisbecker <fweisbec@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Jason Low <jason.low2@hp.com>, Josh Triplett <josh@joshtriplett.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Moore <pmoore@redhat.com>, Pavel
List-Id: linux-api@vger.kernel.org

If a signal stack is set up with SS_AUTODISARM, then the kernel
inherently avoids incorrectly resetting the signal stack if signals
recurse: the signal stack will be reset on the first signal
delivery.  This means that we don't need check the stack pointer
when delivering signals if SS_AUTODISARM is set.

This will make segmented x86 programs more robust: currently there's
a hole that could be triggered if ESP/RSP appears to point to the
signal stack but actually doesn't due to a nonzero SS base.

Signed-off-by: Stas Sergeev <stsp@list.ru>
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
 include/linux/sched.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2950c5cd3005..8f03a93348b9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2576,6 +2576,18 @@ static inline int kill_cad_pid(int sig, int priv)
  */
 static inline int on_sig_stack(unsigned long sp)
 {
+	/*
+	 * If the signal stack is AUTODISARM then, by construction, we
+	 * can't be on the signal stack unless user code deliberately set
+	 * SS_AUTODISARM when we were already on the it.
+	 *
+	 * This improve reliability: if user state gets corrupted such that
+	 * the stack pointer points very close to the end of the signal stack,
+	 * then this check will enable the signal to be handled anyway.
+	 */
+	if (current->sas_ss_flags & SS_AUTODISARM)
+		return 0;
+
 #ifdef CONFIG_STACK_GROWSUP
 	return sp >= current->sas_ss_sp &&
 		sp - current->sas_ss_sp < current->sas_ss_size;
-- 
2.5.5
