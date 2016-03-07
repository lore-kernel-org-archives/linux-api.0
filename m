From: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Subject: [PATCH 3/4] sigaltstack: implement SS_AUTODISARM flag
Date: Mon,  7 Mar 2016 19:39:43 +0300
Message-ID: <1457368784-11090-4-git-send-email-stsp@list.ru>
References: <1457368784-11090-1-git-send-email-stsp@list.ru>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457368784-11090-1-git-send-email-stsp-cmBhpYW9OiY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: stsp-cmBhpYW9OiY@public.gmane.org
Cc: Stas Sergeev <stsp-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
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

To detect the support of this functionality, one can do
err = sigaltstack(SS_DISABLE | SS_AUTODISARM);
if (err && errno == EINVAL) unsupported();

Signed-off-by: Stas Sergeev <stsp-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>

CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
CC: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
CC: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
CC: Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>
CC: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
CC: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
CC: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
CC: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
CC: "Amanieu d'Antras" <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
CC: Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
CC: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
CC: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
---
 include/linux/sched.h       |  8 ++++++++
 include/linux/signal.h      |  4 +++-
 include/uapi/linux/signal.h |  4 +++-
 kernel/fork.c               |  2 +-
 kernel/signal.c             | 10 ++++++++--
 5 files changed, 23 insertions(+), 5 deletions(-)

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
index 7c73165..7388260 100644
--- a/include/uapi/linux/signal.h
+++ b/include/uapi/linux/signal.h
@@ -7,7 +7,9 @@
 #define SS_ONSTACK	1
 #define SS_DISABLE	2
 
+/* bit-flags */
+#define SS_AUTODISARM	(1 << 4)	/* disable sas during sighandling */
 /* mask for all SS_xxx flags */
-#define SS_FLAG_BITS	0
+#define SS_FLAG_BITS	SS_AUTODISARM
 
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
index 9a24bc3..e1096ad 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3133,6 +3133,7 @@ do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long s
 
 		current->sas_ss_sp = (unsigned long) ss_sp;
 		current->sas_ss_size = ss_size;
+		current->sas_ss_flags = ss_flags;
 	}
 
 	error = 0;
@@ -3163,9 +3164,14 @@ int restore_altstack(const stack_t __user *uss)
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
