From: Jiri Pirko <jpirko-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH, RESEND] getrusage: fill ru_maxrss value
Date: Tue, 16 Dec 2008 15:56:41 +0100
Message-ID: <20081216155641.1411f8a7@psychotron.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hugh-DTz5qymZ9yRBDgjK7y7TUQ@public.gmane.org>, jlim-sJ/iWh9BUns@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patch makes ->ru_maxrss value in struct rusage filled accordingly to
rss hiwater mark. This struct is filled as a parameter to
getrusage syscall. ->ru_maxrss value is set to pages which might be correct
as "time" application converts it to KBs.

To make this happen we extend struct signal_struct by two fields. The
first one is ->maxrss which we use to store rss hiwater of the task. The
second one is ->cmaxrss which we use to store highest rss hiwater of all
task childs. These values are used in k_getrusage() to actually fill
->ru_maxrss. k_getrusage() uses current rss hiwater value directly
if mm struct exists.

We clear the ->maxrss as a part of flush_old_exec() to be consistent
because bprm_mm_init() does not copy ->hiwater_rss.

Note that we use recently introduced get_mm_hiwater_rss() helper to
actually get the rss hiwater value:
http://lkml.org/lkml/2008/12/12/172


Signed-off-by: Jiri Pirko <jpirko-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/exec.c             |    1 +
 include/linux/sched.h |    1 +
 kernel/exit.c         |    4 ++++
 kernel/fork.c         |    1 +
 kernel/sys.c          |   12 ++++++++++++
 5 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index ec5df9a..8d3d0f9 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -870,6 +870,7 @@ static int de_thread(struct task_struct *tsk)
 	sig->notify_count = 0;
 
 no_thread_group:
+	sig->maxrss = 0;
 	exit_itimers(sig);
 	flush_itimer_signals();
 	if (leader)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f4c70dc..41b04ee 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -563,6 +563,7 @@ struct signal_struct {
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
 	unsigned long inblock, oublock, cinblock, coublock;
 	struct task_io_accounting ioac;
+	unsigned long maxrss, cmaxrss;
 
 	/*
 	 * We don't bother to synchronize most readers of this at all,
diff --git a/kernel/exit.c b/kernel/exit.c
index 81b6372..61d622d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1053,6 +1053,8 @@ NORET_TYPE void do_exit(long code)
 	if (group_dead) {
 		hrtimer_cancel(&tsk->signal->real_timer);
 		exit_itimers(tsk->signal);
+		if (tsk->mm)
+			tsk->signal->maxrss = get_mm_hiwater_rss(tsk->mm);
 	}
 	acct_collect(code, group_dead);
 	if (group_dead)
@@ -1351,6 +1353,8 @@ static int wait_task_zombie(struct task_struct *p, int options,
 			sig->oublock + sig->coublock;
 		task_io_accounting_add(&psig->ioac, &p->ioac);
 		task_io_accounting_add(&psig->ioac, &sig->ioac);
+		if (psig->cmaxrss < sig->maxrss)
+			psig->cmaxrss = sig->maxrss;
 		spin_unlock_irq(&p->parent->sighand->siglock);
 	}
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 495da2e..36ac3e5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -850,6 +850,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
 	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
 	task_io_accounting_init(&sig->ioac);
+	sig->maxrss = sig->cmaxrss = 0;
 	taskstats_tgid_init(sig);
 
 	task_lock(current->group_leader);
diff --git a/kernel/sys.c b/kernel/sys.c
index 31deba8..67328ff 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1569,6 +1569,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 			r->ru_majflt = p->signal->cmaj_flt;
 			r->ru_inblock = p->signal->cinblock;
 			r->ru_oublock = p->signal->coublock;
+			r->ru_maxrss = p->signal->cmaxrss;
 
 			if (who == RUSAGE_CHILDREN)
 				break;
@@ -1583,6 +1584,8 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 			r->ru_majflt += p->signal->maj_flt;
 			r->ru_inblock += p->signal->inblock;
 			r->ru_oublock += p->signal->oublock;
+			if (r->ru_maxrss < p->signal->maxrss)
+				r->ru_maxrss = p->signal->maxrss;
 			t = p;
 			do {
 				accumulate_thread_rusage(t, r);
@@ -1598,6 +1601,15 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 out:
 	cputime_to_timeval(utime, &r->ru_utime);
 	cputime_to_timeval(stime, &r->ru_stime);
+
+	task_lock(p);
+	if (p->mm) {
+		unsigned long maxrss = get_mm_hiwater_rss(p->mm);
+
+		if (r->ru_maxrss < maxrss)
+			r->ru_maxrss = maxrss;
+	}
+	task_unlock(p);
 }
 
 int getrusage(struct task_struct *p, int who, struct rusage __user *ru)
-- 
1.5.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
