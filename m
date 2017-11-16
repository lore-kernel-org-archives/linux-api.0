From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v11 for 4.15 01/24] Restartable sequences system
 call
Date: Thu, 16 Nov 2017 17:09:31 +0000 (UTC)
Message-ID: <1869501326.16653.1510852171734.JavaMail.zimbra@efficios.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com> <20171114200414.2188-2-mathieu.desnoyers@efficios.com> <20171116161815.dg4hi2z35rkh4u4s@hirez.programming.kicks-ass.net> <438349693.16595.1510849627973.JavaMail.zimbra@efficios.com> <20171116163218.fg4u4bbzfrbxatvz@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171116163218.fg4u4bbzfrbxatvz-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

----- On Nov 16, 2017, at 11:32 AM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:

> On Thu, Nov 16, 2017 at 04:27:07PM +0000, Mathieu Desnoyers wrote:
>> ----- On Nov 16, 2017, at 11:18 AM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:
>> 
>> > On Tue, Nov 14, 2017 at 03:03:51PM -0500, Mathieu Desnoyers wrote:
>> >> @@ -977,6 +978,13 @@ struct task_struct {
>> >>  	unsigned long			numa_pages_migrated;
>> >>  #endif /* CONFIG_NUMA_BALANCING */
>> >>  
>> >> +#ifdef CONFIG_RSEQ
>> >> +	struct rseq __user *rseq;
>> >> +	u32 rseq_len;
>> >> +	u32 rseq_sig;
>> >> +	bool rseq_preempt, rseq_signal, rseq_migrate;
>> > 
>> > No bool please. Use something that has a defined size in ILP32/LP64.
>> > _Bool makes it absolutely impossible to speculate on structure layout
>> > across architectures.
>> 
>> I should as well make all those a bitmask within a "u32 rseq_event_mask" then,
>> sounds fair ?
> 
> Sure, whatever works and isn't _Bool ;-)

So something along those lines should do the trick (including
the mask request from Ben Maurer):

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b995a3b..44aef30 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -982,7 +982,7 @@ struct task_struct {
        struct rseq __user *rseq;
        u32 rseq_len;
        u32 rseq_sig;
-       bool rseq_preempt, rseq_signal, rseq_migrate;
+       u32 rseq_event_mask;
 #endif
 
        struct tlbflush_unmap_batch     tlb_ubc;
@@ -1676,6 +1676,16 @@ static inline void set_task_cpu(struct task_struct *p, un
 #endif
 
 #ifdef CONFIG_RSEQ
+/*
+ * Map the event mask on the user-space ABI enum rseq_cs_flags
+ * for direct mask checks.
+ */
+enum rseq_event_mask {
+       RSEQ_EVENT_PREEMPT      = RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT,
+       RSEQ_EVENT_SIGNAL       = RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL,
+       RSEQ_EVENT_MIGRATE      = RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE,
+};
+
 static inline void rseq_set_notify_resume(struct task_struct *t)
 {
        if (t->rseq)
@@ -1718,16 +1728,16 @@ static inline void rseq_sched_out(struct task_struct *t)
 }
 static inline void rseq_signal_deliver(struct pt_regs *regs)
 {
-       current->rseq_signal = true;
+       current->rseq_event_mask |= RSEQ_EVENT_SIGNAL;
        rseq_handle_notify_resume(regs);
 }
 static inline void rseq_preempt(struct task_struct *t)
 {
-       t->rseq_preempt = true;
+       t->rseq_event_mask |= RSEQ_EVENT_PREEMPT;
 }
 static inline void rseq_migrate(struct task_struct *t)
 {
-       t->rseq_migrate = true;
+       t->rseq_event_mask |= RSEQ_EVENT_MIGRATE;
 }
 #else
 static inline void rseq_set_notify_resume(struct task_struct *t)
diff --git a/kernel/rseq.c b/kernel/rseq.c
index 6f0d48c..d773003 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -159,7 +159,7 @@ static bool rseq_get_rseq_cs(struct task_struct *t,
 static int rseq_need_restart(struct task_struct *t, uint32_t cs_flags)
 {
        bool need_restart = false;
-       uint32_t flags;
+       uint32_t flags, event_mask;
 
        /* Get thread flags. */
        if (__get_user(flags, &t->rseq->flags))
@@ -174,26 +174,17 @@ static int rseq_need_restart(struct task_struct *t, uint32
         * a preempted signal handler could fail to restart the prior
         * execution context on sigreturn.
         */
-       if (flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL) {
-               if (!(flags & RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE))
-                       return -EINVAL;
-               if (!(flags & RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT))
+       if (unlikely(flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL)) {
+               if ((flags & (RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
+                               | RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT))
+                       != (RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
+                                | RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT))
                        return -EINVAL;
        }
-       if (t->rseq_migrate
-                       && !(flags & RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE))
-               need_restart = true;
-       else if (t->rseq_preempt
-                       && !(flags & RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT))
-               need_restart = true;
-       else if (t->rseq_signal
-                       && !(flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL))
-               need_restart = true;
-
-       t->rseq_preempt = false;
-       t->rseq_signal = false;
-       t->rseq_migrate = false;
-       if (need_restart)
+       event_mask = t->rseq_event_mask;
+       t->rseq_event_mask = 0;
+       event_mask &= ~flags;
+       if (event_mask)
                return 1;
        return 0;
 }


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
