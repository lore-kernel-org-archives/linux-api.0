From: Stas Sergeev <stsp@list.ru>
Subject: [PATCH 1/2] sigaltstack: implement SS_AUTODISARM flag
Date: Tue,  1 Mar 2016 00:29:04 +0300
Message-ID: <1456781345-8243-2-git-send-email-stsp@list.ru>
References: <1456781345-8243-1-git-send-email-stsp@list.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456781345-8243-1-git-send-email-stsp@list.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: stsp@list.ru
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Richard Weinberger <richard@nod.at>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Jason Low <jason.low2@hp.com>, Andrea Arcangeli <aarcange@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Josh Triplett <josh@joshtriplett.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, Amanieu d'Antras <amanieu@gmail.com>, Paul Moore <pmoore@redhat.com>, Sasha Levin <sasha.levin@oracle.com>, Palmer Dabbelt <palmer@dabbelt.com>, Vladimir Davydov <vdavydov@parallels.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Stas Sergeev <stsp@users.sourceforge.net>
List-Id: linux-api@vger.kernel.org

This patch implements the SS_AUTODISARM flag that can be ORed with
SS_ONSTACK when forming ss_flags.
When this flag is set, sigaltstack will be disabled when entering
the signal handler; more precisely, after saving sas to uc_stack.
When leaving the signal handler, the sigaltstack is restored by
uc_stack.
When this flag is used, it is safe to switch from sighandler with
swapcontext(). Without this flag, the subsequent signal will corrupt
the state of the switched-away sighandler.

CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Richard Weinberger <richard@nod.at>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Tejun Heo <tj@kernel.org>
CC: Heinrich Schuchardt <xypron.glpk@gmx.de>
CC: Jason Low <jason.low2@hp.com>
CC: Andrea Arcangeli <aarcange@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
CC: Josh Triplett <josh@joshtriplett.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Aleksa Sarai <cyphar@cyphar.com>
CC: "Amanieu d'Antras" <amanieu@gmail.com>
CC: Paul Moore <pmoore@redhat.com>
CC: Sasha Levin <sasha.levin@oracle.com>
CC: Palmer Dabbelt <palmer@dabbelt.com>
CC: Vladimir Davydov <vdavydov@parallels.com>
CC: linux-kernel@vger.kernel.org
CC: linux-api@vger.kernel.org
CC: Andy Lutomirski <luto@amacapital.net>

Signed-off-by: Stas Sergeev <stsp@users.sourceforge.net>
---
 include/linux/sched.h       |  8 ++++++++
 include/linux/signal.h      |  4 +++-
 include/uapi/linux/signal.h |  3 +++
 kernel/fork.c               |  2 +-
 kernel/signal.c             | 23 ++++++++++++-----------
 5 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a10494a..26201cd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1587,6 +1587,7 @@ struct task_struct {
 
 	unsigned long sas_ss_sp;
 	size_t sas_ss_size;
+	unsigned sas_ss_flags;
 
 	struct callback_head *task_works;
 
@@ -2573,6 +2574,13 @@ static inline int sas_ss_flags(unsigned long sp)
 	return on_sig_stack(sp) ? SS_ONSTACK : 0;
 }
 
+static inline void sas_ss_reset(struct task_struct *p)
+{
+	p->sas_ss_sp = 0;
+	p->sas_ss_size = 0;
+	p->sas_ss_flags = SS_DISABLE;
+}
+
 static inline unsigned long sigsp(unsigned long sp, struct ksignal *ksig)
 {
 	if (unlikely((ksig->ka.sa.sa_flags & SA_ONSTACK)) && ! sas_ss_flags(sp))
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 92557bb..3fbe814 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -432,8 +432,10 @@ int __save_altstack(stack_t __user *, unsigned long);
 	stack_t __user *__uss = uss; \
 	struct task_struct *t = current; \
 	put_user_ex((void __user *)t->sas_ss_sp, &__uss->ss_sp); \
-	put_user_ex(sas_ss_flags(sp), &__uss->ss_flags); \
+	put_user_ex(t->sas_ss_flags, &__uss->ss_flags); \
 	put_user_ex(t->sas_ss_size, &__uss->ss_size); \
+	if (t->sas_ss_flags & SS_AUTODISARM) \
+		sas_ss_reset(t); \
 } while (0);
 
 #ifdef CONFIG_PROC_FS
diff --git a/include/uapi/linux/signal.h b/include/uapi/linux/signal.h
index e1bd50c2..4691bc5 100644
--- a/include/uapi/linux/signal.h
+++ b/include/uapi/linux/signal.h
@@ -6,5 +6,8 @@
 
 #define SS_ONSTACK	1
 #define SS_DISABLE	2
+#define SS_VALMASK	0xf
+/* bit-flags */
+#define SS_AUTODISARM	(1 << 4)	/* disable sas during sighandling */
 
 #endif /* _UAPI_LINUX_SIGNAL_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 2e391c7..68c8716 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1483,7 +1483,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 * sigaltstack should be cleared when sharing the same VM
 	 */
 	if ((clone_flags & (CLONE_VM|CLONE_VFORK)) == CLONE_VM)
-		p->sas_ss_sp = p->sas_ss_size = 0;
+		sas_ss_reset(p);
 
 	/*
 	 * Syscall tracing and stepping should be turned off in the
diff --git a/kernel/signal.c b/kernel/signal.c
index 0508544..fab6bea 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3100,13 +3100,14 @@ do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long s
 	if (uss) {
 		void __user *ss_sp;
 		size_t ss_size;
-		int ss_flags;
+		unsigned ss_flags;
+		unsigned ss_xflags;
 
 		error = -EFAULT;
 		if (!access_ok(VERIFY_READ, uss, sizeof(*uss)))
 			goto out;
 		error = __get_user(ss_sp, &uss->ss_sp) |
-			__get_user(ss_flags, &uss->ss_flags) |
+			__get_user(ss_xflags, &uss->ss_flags) |
 			__get_user(ss_size, &uss->ss_size);
 		if (error)
 			goto out;
@@ -3115,14 +3116,8 @@ do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long s
 		if (on_sig_stack(sp))
 			goto out;
 
+		ss_flags = ss_xflags & SS_VALMASK;
 		error = -EINVAL;
-		/*
-		 * Note - this code used to test ss_flags incorrectly:
-		 *  	  old code may have been written using ss_flags==0
-		 *	  to mean ss_flags==SS_ONSTACK (as this was the only
-		 *	  way that worked) - this fix preserves that older
-		 *	  mechanism.
-		 */
 		if (ss_flags != SS_DISABLE && ss_flags != SS_ONSTACK && ss_flags != 0)
 			goto out;
 
@@ -3137,6 +3132,7 @@ do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long s
 
 		current->sas_ss_sp = (unsigned long) ss_sp;
 		current->sas_ss_size = ss_size;
+		current->sas_ss_flags = ss_xflags;
 	}
 
 	error = 0;
@@ -3167,9 +3163,14 @@ int restore_altstack(const stack_t __user *uss)
 int __save_altstack(stack_t __user *uss, unsigned long sp)
 {
 	struct task_struct *t = current;
-	return  __put_user((void __user *)t->sas_ss_sp, &uss->ss_sp) |
-		__put_user(sas_ss_flags(sp), &uss->ss_flags) |
+	int err = __put_user((void __user *)t->sas_ss_sp, &uss->ss_sp) |
+		__put_user(t->sas_ss_flags, &uss->ss_flags) |
 		__put_user(t->sas_ss_size, &uss->ss_size);
+	if (err)
+		return err;
+	if (t->sas_ss_flags & SS_AUTODISARM)
+		sas_ss_reset(t);
+	return 0;
 }
 
 #ifdef CONFIG_COMPAT
-- 
2.7.2
