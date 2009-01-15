From: Jiri Pirko <jpirko-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] getrusage: fill ru_ixrss, ru_idrss and ru_isrss values
Date: Thu, 15 Jan 2009 15:38:27 +0100
Message-ID: <20090115153827.459ec787@psychotron.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patch makes three values in rusage structure filled in getrusage
syscall. These values are in KB units so as the ->ru_maxrss value. They
are ru_ixrss, ru_idrss and ru_isrss. Note that also these values are
wrongly converted from pages to KBs by GNU time application (patch
posted to app. maintainer).

These three values are actually accumulated memory usages. It means
that each (in the ideal case) jiffy we need to add appropriate mm->xxx
value to the counter. For this I'm using acct_update_integrals()
function that is already accumulating total_vm and rss accumulated
values for taskstats. I've extended this function to accumulate also
vm_shared and vm_stack values from mm->. In the same fashion the
task_struct is extended. I've also changed the accumulation time
measure interval from USECs to jiffies. That's correct because there
can't by lesser time interval then jiffy and we also achieve later
potential u64 overflow (I do not see why this was not done this way in
the first place). Three macros are added under the tast_struct
definition in sched.h (I'm not sure this is the right place). These
macros are actually getting appropriate i[xds]rss values from fields
added to task_struct.

The struct signal_struct was extended by six fields. These refer to
i[xds]rss values and i[xds]rss of childs. These are filled up in the
similar way as other near fields in __exit_signal() and
wait_task_zombie().

Note that taskstats can be possibly extended to pass accumulated
vm_shared and vm_stack too.


Please review and comment this patch - all comments are highly welcomed.

Btw wouldn't it be nice to have macro like K() (PAGEs->KBs) globally
defined instead of defining it on each spot in kernel where we need it?
FreeBSD has this - pgtok().

Thanks

Jirka

Applied after: getrusage-fill-ru_maxrss-value.patch

Signed-off-by: Jiri Pirko <jpirko-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sched.h |   22 +++++++++++++++++++---
 kernel/exit.c         |    9 +++++++++
 kernel/fork.c         |    1 +
 kernel/sys.c          |   17 ++++++++++++++++-
 kernel/tsacct.c       |   24 ++++++++++++------------
 5 files changed, 57 insertions(+), 16 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4da3b86..9303bc0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -561,6 +561,7 @@ struct signal_struct {
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
 	unsigned long inblock, oublock, cinblock, coublock;
 	unsigned long maxrss, cmaxrss;
+	unsigned long ixrss, idrss, isrss, cixrss, cidrss, cisrss;
 	struct task_io_accounting ioac;
 
 	/*
@@ -1327,9 +1328,11 @@ struct task_struct {
 	siginfo_t *last_siginfo; /* For ptrace use.  */
 	struct task_io_accounting ioac;
 #if defined(CONFIG_TASK_XACCT)
-	u64 acct_rss_mem1;	/* accumulated rss usage */
-	u64 acct_vm_mem1;	/* accumulated virtual memory usage */
-	cputime_t acct_timexpd;	/* stime + utime since last update */
+	u64 acct_rss_mem1;		/* accumulated rss usage */
+	u64 acct_total_vm_mem1;		/* accumulated virtual memory usage */
+	u64 acct_shared_vm_mem1;	/* accumulated shared virtual memory usage */
+	u64 acct_stack_vm_mem1;		/* accumulated stack virtual memory usage */
+	cputime_t acct_timexpd;		/* stime + utime since last update */
 #endif
 #ifdef CONFIG_CPUSETS
 	nodemask_t mems_allowed;
@@ -1399,6 +1402,19 @@ struct task_struct {
 #endif
 };
 
+#if defined(CONFIG_TASK_XACCT)
+#define get_task_ixrss(tsk) jiffies_to_clock_t((tsk)->acct_shared_vm_mem1)
+#define get_task_idrss(tsk) jiffies_to_clock_t( \
+			(tsk)->acct_total_vm_mem1 - \
+			(tsk)->acct_shared_vm_mem1 - \
+			(tsk)->acct_stack_vm_mem1)
+#define get_task_isrss(tsk) jiffies_to_clock_t((tsk)->acct_stack_vm_mem1)
+#else
+#define get_task_ixrss(tsk) 0UL
+#define get_task_idrss(tsk) 0UL
+#define get_task_isrss(tsk) 0UL
+#endif
+
 /*
  * Priority of a process goes from 0..MAX_PRIO-1, valid RT
  * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
diff --git a/kernel/exit.c b/kernel/exit.c
index 088b7a8..17309e1 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -123,6 +123,9 @@ static void __exit_signal(struct task_struct *tsk)
 		sig->maj_flt += tsk->maj_flt;
 		sig->nvcsw += tsk->nvcsw;
 		sig->nivcsw += tsk->nivcsw;
+		sig->ixrss += get_task_ixrss(tsk);
+		sig->idrss += get_task_idrss(tsk);
+		sig->isrss += get_task_isrss(tsk);
 		sig->inblock += task_io_get_inblock(tsk);
 		sig->oublock += task_io_get_oublock(tsk);
 		task_io_accounting_add(&sig->ioac, &tsk->ioac);
@@ -1362,6 +1365,12 @@ static int wait_task_zombie(struct task_struct *p, int options,
 		maxrss = max(sig->maxrss, sig->cmaxrss);
 		if (psig->cmaxrss < maxrss)
 			psig->cmaxrss = maxrss;
+		psig->cixrss +=
+			get_task_ixrss(p) + sig->ixrss + sig->cixrss;
+		psig->cidrss +=
+			get_task_idrss(p) + sig->idrss + sig->cidrss;
+		psig->cisrss +=
+			get_task_isrss(p) + sig->isrss + sig->cisrss;
 		task_io_accounting_add(&psig->ioac, &p->ioac);
 		task_io_accounting_add(&psig->ioac, &sig->ioac);
 		spin_unlock_irq(&p->parent->sighand->siglock);
diff --git a/kernel/fork.c b/kernel/fork.c
index 4b50de3..62ce9ee 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -858,6 +858,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
 	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
 	sig->maxrss = sig->cmaxrss = 0;
+	sig->ixrss = sig->idrss = sig->isrss = sig->cixrss = sig->cidrss = sig->cisrss = 0;
 	task_io_accounting_init(&sig->ioac);
 	taskstats_tgid_init(sig);
 
diff --git a/kernel/sys.c b/kernel/sys.c
index e442d38..96d0cc5 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1618,6 +1618,9 @@ static void accumulate_thread_rusage(struct task_struct *t, struct rusage *r)
 	r->ru_majflt += t->maj_flt;
 	r->ru_inblock += task_io_get_inblock(t);
 	r->ru_oublock += task_io_get_oublock(t);
+	r->ru_ixrss += get_task_ixrss(t);
+	r->ru_idrss += get_task_idrss(t);
+	r->ru_isrss += get_task_isrss(t);
 }
 
 static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
@@ -1654,6 +1657,9 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 			r->ru_inblock = p->signal->cinblock;
 			r->ru_oublock = p->signal->coublock;
 			maxrss = p->signal->cmaxrss;
+			r->ru_ixrss = p->signal->cixrss;
+			r->ru_idrss = p->signal->cidrss;
+			r->ru_isrss = p->signal->cisrss;
 
 			if (who == RUSAGE_CHILDREN)
 				break;
@@ -1670,6 +1676,9 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 			r->ru_oublock += p->signal->oublock;
 			if (maxrss < p->signal->maxrss)
 				maxrss = p->signal->maxrss;
+			r->ru_ixrss += p->signal->ixrss;
+			r->ru_idrss += p->signal->idrss;
+			r->ru_isrss += p->signal->isrss;
 			t = p;
 			do {
 				accumulate_thread_rusage(t, r);
@@ -1696,7 +1705,13 @@ out:
 			mmput(mm);
 		}
 	}
-	r->ru_maxrss = maxrss * (PAGE_SIZE / 1024); /* convert pages to KBs */
+
+/* convert pages to KBs */
+#define K(x) ((x) << (PAGE_SHIFT - 10))
+	r->ru_maxrss = K(maxrss);
+	r->ru_ixrss = K(r->ru_ixrss);
+	r->ru_idrss = K(r->ru_idrss);
+	r->ru_isrss = K(r->ru_isrss);
 }
 
 int getrusage(struct task_struct *p, int who, struct rusage __user *ru)
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 43f891b..9543870 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -86,9 +86,9 @@ void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
 {
 	struct mm_struct *mm;
 
-	/* convert pages-usec to Mbyte-usec */
-	stats->coremem = p->acct_rss_mem1 * PAGE_SIZE / MB;
-	stats->virtmem = p->acct_vm_mem1 * PAGE_SIZE / MB;
+	/* convert pages-jiffy to Mbyte-usec */
+	stats->coremem = p->acct_rss_mem1 * jiffies_to_usecs(1) * PAGE_SIZE / MB;
+	stats->virtmem = p->acct_total_vm_mem1 * jiffies_to_usecs(1) * PAGE_SIZE / MB;
 	mm = get_task_mm(p);
 	if (mm) {
 		/* adjust to KB unit */
@@ -120,21 +120,19 @@ void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
 void acct_update_integrals(struct task_struct *tsk)
 {
 	if (likely(tsk->mm)) {
-		cputime_t time, dtime;
-		struct timeval value;
-		u64 delta;
+		cputime_t time;
+		unsigned long delta; /* delta in jiffies */
 
 		time = tsk->stime + tsk->utime;
-		dtime = cputime_sub(time, tsk->acct_timexpd);
-		jiffies_to_timeval(cputime_to_jiffies(dtime), &value);
-		delta = value.tv_sec;
-		delta = delta * USEC_PER_SEC + value.tv_usec;
+		delta = cputime_to_jiffies(cputime_sub(time, tsk->acct_timexpd));
 
 		if (delta == 0)
 			return;
 		tsk->acct_timexpd = time;
 		tsk->acct_rss_mem1 += delta * get_mm_rss(tsk->mm);
-		tsk->acct_vm_mem1 += delta * tsk->mm->total_vm;
+		tsk->acct_total_vm_mem1 += delta * tsk->mm->total_vm;
+		tsk->acct_shared_vm_mem1 += delta * tsk->mm->shared_vm;
+		tsk->acct_stack_vm_mem1 += delta * tsk->mm->stack_vm;
 	}
 }
 
@@ -146,6 +144,8 @@ void acct_clear_integrals(struct task_struct *tsk)
 {
 	tsk->acct_timexpd = 0;
 	tsk->acct_rss_mem1 = 0;
-	tsk->acct_vm_mem1 = 0;
+	tsk->acct_total_vm_mem1 = 0;
+	tsk->acct_shared_vm_mem1 = 0;
+	tsk->acct_stack_vm_mem1 = 0;
 }
 #endif
-- 
1.6.0.3

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
