From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: [PATCH v3] sched/fair: Add advisory flag for borrowing a timeslice (was: Pre-emption control for userspace)
Date: Mon, 24 Nov 2014 13:56:35 -0700
Message-ID: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, corbet@lwn.net, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org, riel@redhat.com, akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, raistlin@linux.it, kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org, gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com, oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com, keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu, vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com
Cc: Khalid Aziz <khalid.aziz@oracle.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

sched/fair: Add advisory flag for borrowing a timeslice

This patch adds a way for a task to request to borrow one timeslice
from future if it is about to be preempted, so it could delay
preemption and complete any critical task it is in the middle of.

This feature helps with performance on databases and has been
used for many years on other OSs by the databases. This feature
helps in situation where a task acquires a lock before performing a
critical operation on the database and happens to get preempted before
it completes its task.  This lock being held causes all other tasks
that also acquire the same lock to perform their critical operation
on the database, to start queueing up and causing large number of
context switches.  This queueing problem can be avoided if the task
that acquires lock first could request scheduler to let it borrow one
timeslice once it enters its critical section and hence allow it to
complete its critical section without causing queueing problem. If
critical section completes before the task is due for preemption,
the task can simply desassert its request. A task sends the
scheduler this request by setting a flag in a memory location it has
shared with the kernel.  Kernel uses bytes in the same memory location
to let the task know when its request for amnesty from preemption
has been granted.

These rules apply to the use of this feature:

- Request to borrow timeslice is not guranteed to be honored.
- If the task is allowed to borrow, kernel will inform the task
  of this. When this happens, task must yield the processor as soon
  as it completes its critical section.
- If the task fails to yield processor after being allowed to
  borrow, it is penalized by forcing it to skip its next time slot
  by the scheduler.
- Task is charged additional time for the borrowed timeslice as
  accumulated run time. This pushes it further down in consideration
  for the next task to run.

This feature was tested with a TPC-C workload. TPC-C workload shows
a 3% improvement in tpcc throughput when using this feature, which
is a significant improvement.

A new sysctl tunable kernel.preempt_delay_available enables this
feature at run time. The kernel boots up with this feature disabled
by default.

Documentation file included in this patch contains details on how to
use this feature, and conditions associated with its use. This patch
also adds a new field in scheduler statistics which keeps track of
how many times a task was granted amnesty from preemption.

Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
---

With this new version of this patch, the kernel will not enable
preemption delay by default. This feature must be turned on by using
sysctl tunable kernel.preempt_delay_available. With this change, there
are now two ways to eliminate the impact of this feature on systems
that do not intend to use it and are sensitive to scheduling delays
that may be caused by the use of this feature. This feature can be
configured out for custom built kernels. For pre-compiled kernels where
this feature may have been configured in, it will stay off until enabled
through sysctl tunable.

Changelog:
v3:
	- Use prctl() syscall to give kernel the location for shared flag 
	  instead of using a proc file.
	- Disabled this feature by default on a newly booted kernel and
	  added a sysctl tunable to enable/disable it at runtime.
v2:
	- Replaced mmap operation with a more memory efficient futex
	  like communication between userspace and kernel
	- Added a flag to let userspace know if it was granted amnesty
	- Added a penalty for tasks failing to yield CPU when they
	  are granted amnesty from pre-emption

v1:
	- Initial RFC patch with mmap for communication between userspace
	  and kernel

 Documentation/scheduler/sched-preempt-delay.txt | 117 ++++++++++++++++++++++++
 arch/x86/Kconfig                                |  12 +++
 include/linux/sched.h                           |  15 +++
 include/linux/sched/sysctl.h                    |   4 +
 include/uapi/linux/prctl.h                      |   3 +
 kernel/fork.c                                   |   5 +
 kernel/sched/core.c                             |   8 ++
 kernel/sched/debug.c                            |   1 +
 kernel/sched/fair.c                             | 115 ++++++++++++++++++++++-
 kernel/sys.c                                    |  43 +++++++++
 kernel/sysctl.c                                 |   9 ++
 11 files changed, 329 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/scheduler/sched-preempt-delay.txt

diff --git a/Documentation/scheduler/sched-preempt-delay.txt b/Documentation/scheduler/sched-preempt-delay.txt
new file mode 100644
index 0000000..07dd699
--- /dev/null
+++ b/Documentation/scheduler/sched-preempt-delay.txt
@@ -0,0 +1,117 @@
+=================================
+What is preemption delay feature?
+=================================
+
+There are times when a userspace task is executing a critical section
+which gates a number of other tasks that want access to the same
+critical section. If the task holding the lock that guards this critical
+section is preempted by the scheduler in the middle of its critical
+section because its timeslice is up, scheduler ends up scheduling other
+threads which immediately try to grab the lock to enter the critical
+section. This only results in lots of context changes are tasks wake up
+and go to sleep immediately again. If on the other hand, the original
+task were allowed to run for an extra timeslice, it could have completed
+executing its critical section allowing other tasks to make progress
+when they get scheduled. Preemption delay feature allows a task to
+request scheduler to grant it one extra timeslice, if possible.
+
+
+==================================
+Using the preemption delay feature
+==================================
+
+This feature is compiled in the kernel by setting
+CONFIG_SCHED_PREEMPT_DELAY in kernel configuration. By default, the
+kernel boots up with this feature disabled. Enable it using sysctl
+tunable kernel.preempt_delay_available. Once this feature is
+enabled, the userspace process communicates with the kernel using a
+4-byte memory location in its address space. This location must be
+aligned to 4-byte boundary. It first gives the kernel address for this
+memory location by making a prctl() system call with PR_SET_PREEMPT_DELAY
+option. This memory location is interpreted as a sequence of 4 bytes:
+
+	byte[0] = flag to request preemption delay
+	byte[1] = flag from kernel indicating preemption delay was granted
+	byte[2] = reserved for future use
+	byte[3] = reserved for future use
+
+Task requests a preemption delay by writing a non-zero value to the
+first byte. Scheduler checks this value before preempting the task.
+Scheduler can choose to grant one and only an additional time slice to
+the task for each delay request but this delay is not guaranteed.
+If scheduler does grant an additional timeslice, it will set the flag
+in second byte. Upon completion of the section of code where the task
+wants preemption delay, task should check the second byte. If the flag
+in second byte is set, it should clear this flag and call sched_yield()
+so as to not hog the processor. If a thread was granted additional
+timeslice and it fails to call sched_yield(), scheduler will penalize
+it by denying its next request for additional timeslice. Following sample
+code illustrates how to use this feature:
+
+int main()
+{
+	unsigned char buf[256];
+	union {
+		struct {
+			unsigned char nopreempt;
+			unsigned char yield;
+			unsigned char rsvd[2];
+		} flags;
+		uint32_t preempt_delay;
+	} delay;
+
+	delay.preempt_delay = 0;
+
+	/* Tell kernel where the flag lives */
+	prctl(PR_SET_PREEMPT_DELAY, &delay);
+
+	while (/* some condition is true */) {
+		/* do some work and get ready to enter critical section */
+		delay.flags.nopreempt = 1;
+		/*
+		 * Obtain lock for critical section
+		 */
+		/*
+		 * critical section
+		 */
+		/*
+		 * Release lock for critical section
+		 */
+		delay.flags.nopreempt = 0;
+		/* Give the CPU up if required */
+		if (delay.flags.yield) {
+			delay.flags.yield = 0;
+			sched_yield();
+		}
+		/* do some more work */
+	}
+	/*
+	 * Tell kernel we are done asking for preemption delay
+	 */
+	prctl(PR_SET_PREEMPT_DELAY, NULL);
+}
+
+
+====================
+Scheduler statistics
+====================
+
+Preemption delay features adds a new field to scheduler statictics -
+nr_preempt_delayed. This is a per thread statistic that tracks the
+number of times a thread was granted amnesty from preemption when it
+requested for one. "cat /proc/<pid>/task/<tid>/sched" will list this
+number along with other scheduler statistics.
+
+
+=====
+Notes
+=====
+
+1. Location of shared flag can be set using prctl() only once. To
+   write a new memory address, the previous memory address must be
+   cleared first by writing NULL. Each new memory address requires
+   validation in the kernel and update of pointers. Changing this
+   address too many times creates too much overhead.
+
+2. If the location of shared flag is not aligned to 4-byte boundary,
+   prctl() will terminate with EFAULT.
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ded8a67..3dac536 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -852,6 +852,18 @@ config SCHED_MC
 	  making when dealing with multi-core CPU chips at a cost of slightly
 	  increased overhead in some places. If unsure say N here.
 
+config SCHED_PREEMPT_DELAY
+	def_bool n
+	prompt "Scheduler preemption delay support"
+	depends on PROC_FS
+	---help---
+	  Say Y here if you want to be able to delay scheduler preemption
+	  when possible by setting a flag in a memory location after
+	  sharing the address of this location with kernel using
+	  PR_SET_PREEMPT_DELAY prctl() call. See
+	  Documentation/scheduler/sched-preempt-delay.txt for details.
+	  If in doubt, say "N".
+
 source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5e344bb..f5150e4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1116,6 +1116,7 @@ struct sched_statistics {
 	u64			nr_wakeups_affine_attempts;
 	u64			nr_wakeups_passive;
 	u64			nr_wakeups_idle;
+	u64			nr_preempt_delayed;
 };
 #endif
 
@@ -1324,6 +1325,13 @@ struct task_struct {
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+	struct preempt_delay {
+		u32 __user *delay_req;		/* delay request flag pointer */
+		unsigned char delay_granted;	/* currently in delay */
+		unsigned char yield_penalty;	/* failure to yield penalty */
+	} sched_preempt_delay;
+#endif
 
 	unsigned long atomic_flags; /* Flags needing atomic access. */
 
@@ -2179,6 +2187,13 @@ extern u64 scheduler_tick_max_deferment(void);
 static inline bool sched_can_stop_tick(void) { return false; }
 #endif
 
+#if defined(CONFIG_SCHED_PREEMPT_DELAY) && defined(CONFIG_PROC_FS)
+extern void sched_preempt_delay_show(struct seq_file *m,
+					struct task_struct *task);
+extern void sched_preempt_delay_set(struct task_struct *task,
+					unsigned char *val);
+#endif
+
 #ifdef CONFIG_SCHED_AUTOGROUP
 extern void sched_autogroup_create_attach(struct task_struct *p);
 extern void sched_autogroup_detach(struct task_struct *p);
diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index 596a0e0..516f74e 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -107,4 +107,8 @@ extern int sysctl_numa_balancing(struct ctl_table *table, int write,
 				 void __user *buffer, size_t *lenp,
 				 loff_t *ppos);
 
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+extern int sysctl_preempt_delay_available;
+#endif
+
 #endif /* _SCHED_SYSCTL_H */
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 513df75..ecfd2cd 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -179,4 +179,7 @@ struct prctl_mm_map {
 #define PR_SET_THP_DISABLE	41
 #define PR_GET_THP_DISABLE	42
 
+#define PR_SET_PREEMPT_DELAY	43
+#define PR_GET_PREEMPT_DELAY	44
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 9b7d746..7f0d843 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1671,6 +1671,11 @@ long do_fork(unsigned long clone_flags,
 			init_completion(&vfork);
 			get_task_struct(p);
 		}
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+		p->sched_preempt_delay.delay_req = NULL;
+		p->sched_preempt_delay.delay_granted = 0;
+		p->sched_preempt_delay.yield_penalty = 0;
+#endif
 
 		wake_up_new_task(p);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 240157c..38cb515 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4230,6 +4230,14 @@ SYSCALL_DEFINE0(sched_yield)
 {
 	struct rq *rq = this_rq_lock();
 
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+	/*
+	 * Clear the penalty flag for current task to reward it for
+	 * palying by the rules
+	 */
+	current->sched_preempt_delay.yield_penalty = 0;
+#endif
+
 	schedstat_inc(rq, yld_count);
 	current->sched_class->yield_task(rq);
 
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index ce33780..618d2ac 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -597,6 +597,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	P(se.statistics.nr_wakeups_affine_attempts);
 	P(se.statistics.nr_wakeups_passive);
 	P(se.statistics.nr_wakeups_idle);
+	P(se.statistics.nr_preempt_delayed);
 
 	{
 		u64 avg_atom, avg_per_cpu;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 34baa60..58f6e1b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -428,6 +428,115 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+/*
+ * delay_resched_rq(): Check if the task about to be preempted has
+ *	requested an additional time slice. If it has, grant it additional
+ *	timeslice once.
+ */
+static void
+delay_resched_rq(struct rq *rq)
+{
+	struct task_struct *curr = rq->curr;
+	struct sched_entity *se;
+	int cpu = task_cpu(curr);
+	u32 __user *delay_req;
+	unsigned int delay_req_flag;
+	unsigned char *delay_flag;
+
+	/*
+	 * Check if task is using pre-emption delay feature. If address
+	 * for preemption delay request flag is not set, this task is
+	 * not using preemption delay feature, we can reschedule without
+	 * any delay
+	 */
+	delay_req = curr->sched_preempt_delay.delay_req;
+
+	if ((delay_req == NULL) || (cpu != smp_processor_id()))
+		goto resched_now;
+
+	/*
+	 * Pre-emption delay will  be granted only once. If this task
+	 * has already been granted delay, rechedule now
+	 */
+	if (curr->sched_preempt_delay.delay_granted) {
+		curr->sched_preempt_delay.delay_granted = 0;
+		goto resched_now;
+	}
+
+	/*
+	 * Get the value of preemption delay request flag from userspace.
+	 * Task had already passed us the address where the flag is stored
+	 * in userspace earlier. This flag is just like the PROCESS_PRIVATE
+	 * futex, leverage the futex code here to read the flag. If there
+	 * is a page fault accessing this flag in userspace, that means
+	 * userspace has not touched this flag recently and we can
+	 * assume no preemption delay is needed.
+	 *
+	 * If task is not requesting additional timeslice, resched now
+	 */
+	if (delay_req) {
+		int ret;
+
+		pagefault_disable();
+		ret = __copy_from_user_inatomic(&delay_req_flag, delay_req,
+				sizeof(u32));
+		pagefault_enable();
+		delay_flag = &delay_req_flag;
+		if (ret || !delay_flag[0])
+			goto resched_now;
+	} else {
+		goto resched_now;
+	}
+
+	/*
+	 * Current thread has requested preemption delay and has not
+	 * been granted an extension yet. If this thread failed to yield
+	 * processor after being granted amnesty last time, penalize it
+	 * by not granting this delay request, otherwise give it an extra
+	 * timeslice.
+	 */
+	if (curr->sched_preempt_delay.yield_penalty) {
+		curr->sched_preempt_delay.yield_penalty = 0;
+		goto resched_now;
+	}
+
+	se = &curr->se;
+	curr->sched_preempt_delay.delay_granted = 1;
+
+	/*
+	 * Set the penalty flag for failing to yield the processor after
+	 * being granted immunity. This flag will be cleared in
+	 * sched_yield() if the thread indeed calls sched_yield
+	 */
+	curr->sched_preempt_delay.yield_penalty = 1;
+
+	/*
+	 * Let the thread know it got amnesty and it should call
+	 * sched_yield() when it is done to avoid penalty next time
+	 * it wants amnesty. We need to write to userspace location.
+	 * Since we just read from this location, chances are extremley
+	 * low we might page fault. If we do page fault, we will ignore
+	 * it and accept the cost of failed write in form of unnecessary
+	 * penalty for userspace task for not yielding processor.
+	 * This is a highly unlikely scenario.
+	 */
+	delay_flag[0] = 0;
+	delay_flag[1] = 1;
+	pagefault_disable();
+	__copy_to_user_inatomic(delay_req, &delay_req_flag, sizeof(u32));
+	pagefault_enable();
+
+	schedstat_inc(curr, se.statistics.nr_preempt_delayed);
+	return;
+
+resched_now:
+	resched_curr(rq);
+}
+#else
+#define delay_resched_rq(rq) resched_curr(rq)
+#endif /* CONFIG_SCHED_PREEMPT_DELAY */
+
 static __always_inline
 void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec);
 
@@ -2939,7 +3048,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 	ideal_runtime = sched_slice(cfs_rq, curr);
 	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
 	if (delta_exec > ideal_runtime) {
-		resched_curr(rq_of(cfs_rq));
+		delay_resched_rq(rq_of(cfs_rq));
 		/*
 		 * The current task ran long enough, ensure it doesn't get
 		 * re-elected due to buddy favours.
@@ -2963,7 +3072,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 		return;
 
 	if (delta > ideal_runtime)
-		resched_curr(rq_of(cfs_rq));
+		delay_resched_rq(rq_of(cfs_rq));
 }
 
 static void
@@ -4780,7 +4889,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	return;
 
 preempt:
-	resched_curr(rq);
+	delay_resched_rq(rq);
 	/*
 	 * Only set the backward buddy when the current task is still
 	 * on the rq. This can happen when a wakeup gets interleaved
diff --git a/kernel/sys.c b/kernel/sys.c
index 1eaa2f0..9edf572 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2025,6 +2025,36 @@ static int prctl_get_tid_address(struct task_struct *me, int __user **tid_addr)
 }
 #endif
 
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+int sysctl_preempt_delay_available;
+
+static int
+preempt_delay_write(struct task_struct *task, unsigned long preempt_delay_addr)
+{
+	/*
+	 * Do not allow write if pointer is currently set
+	 */
+	if (task->sched_preempt_delay.delay_req &&
+			((void *)preempt_delay_addr != NULL))
+		return -EINVAL;
+
+	/*
+	 * Validate the pointer. It should be aligned to 4-byte boundary.
+	 */
+	if (unlikely(!IS_ALIGNED(preempt_delay_addr, 4)))
+		return -EFAULT;
+	if (unlikely(!access_ok(rw, preempt_delay_addr, sizeof(u32))))
+		return -EFAULT;
+
+	task->sched_preempt_delay.delay_req = (u32 __user *) preempt_delay_addr;
+
+	/* zero out flags */
+	put_user(0, (uint32_t *)preempt_delay_addr);
+
+	return 0;
+}
+#endif
+
 SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
@@ -2203,6 +2233,19 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			me->mm->def_flags &= ~VM_NOHUGEPAGE;
 		up_write(&me->mm->mmap_sem);
 		break;
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+	case PR_SET_PREEMPT_DELAY:
+		if (sysctl_preempt_delay_available)
+			error = preempt_delay_write(current, arg2);
+		else
+			error = -EPERM;
+		break;
+	case PR_GET_PREEMPT_DELAY:
+		error = put_user(
+			(unsigned long)current->sched_preempt_delay.delay_req,
+					(unsigned long __user *)arg2);
+		break;
+#endif
 	default:
 		error = -EINVAL;
 		break;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 15f2511..ad450cf 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1104,6 +1104,15 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+	{
+		.procname	= "preempt_delay_available",
+		.data		= &sysctl_preempt_delay_available,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
 	{ }
 };
 
-- 
1.9.1
