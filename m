From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: [PATCH v4] sched/fair: Add advisory flag for borrowing a timeslice
Date: Wed,  3 Dec 2014 12:40:28 -0700
Message-ID: <1417635628-29078-1-git-send-email-khalid.aziz@oracle.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: tglx@linutronix.de, corbet@lwn.net, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org, riel@redhat.com, akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com, mgorman@suse.de, raistlin@linux.it, kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org, gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com, oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com, keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu, vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com
Cc: Khalid Aziz <khalid.aziz@oracle.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

sched/fair: Add advisory flag for borrowing a timeslice

This patch adds a way for a task to request to borrow one timeslice
from future if it is about to be preempted, so it could delay
preemption and complete any critical task it is in the middle of.

This feature improves performance for apps that use userspace locking
across large number of threads, for example large databases and Java,
and similar solutions have been used for many years on other OSs.
This feature helps in situation where a task acquires a lock before
performing a critical operation on shared data and happens to have
acquired the lock just before its timeslice is up which means it gets
preempted before it completes its task. This lock being held causes
all other tasks that also acquire the same lock to perform their
critical operation on shared data, to start queueing up and causing
large number of context switches. This queueing problem can be avoided
if the task that acquires lock first could request scheduler to let it
borrow one timeslice once it enters its critical section and hence
allow it to complete its critical section without causing queueing
problem. If critical section completes before the task is due for
preemption, the task can desassert its request which causes scheduler
to proceed with normal preemption. A task sends the scheduler this
request by setting a flag in a memory location it has shared with the
kernel. Kernel uses bytes in the same memory location to let the task
know when its request for amnesty from preemption has been granted.

These rules apply to the use of this feature:

- Request to borrow timeslice is not guranteed to be honored.
- If the task is allowed to borrow, kernel will inform the task
  of this. When this happens, task must yield the processor as soon
  as it completes its critical section.
- If the task fails to yield processor after being allowed to
  borrow, it is penalized by not honoring its next request for
  extra timeslice.
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
v4:
	- Added a shared data structure to define the memory location
	  used for requesting preemption delay.
	- Fixed a hole in the code that allowed preemption delay to
	  continue to happen if preemption delay feature was disabled
	  with sysctl after a task had already started using this.
	- Removed the restriction on setting location of shared data
	  structure only when one is not set currently.
	- Moved almost all conditionally compiled code into header files
	- Cleaned up config dependency for CONFIG_SCHED_PREEMPT_DELAY
	- Changed permission on preempt_delay_available sysctl to allow
	  users to read it.
	- Updated documentation file to match the code changes
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

 Documentation/scheduler/sched-preempt-delay.txt | 112 ++++++++++++++++++++
 arch/x86/Kconfig                                |  11 ++
 include/linux/sched.h                           |  38 +++++++
 include/linux/sched/sysctl.h                    |   4 +
 include/uapi/linux/prctl.h                      |   3 +
 include/uapi/linux/sched.h                      |   9 ++
 kernel/fork.c                                   |   2 +
 kernel/sched/core.c                             |   1 +
 kernel/sched/debug.c                            |   1 +
 kernel/sched/fair.c                             | 129 +++++++++++++++++++++++-
 kernel/sys.c                                    |   6 ++
 kernel/sysctl.c                                 |   9 ++
 12 files changed, 322 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/scheduler/sched-preempt-delay.txt

diff --git a/Documentation/scheduler/sched-preempt-delay.txt b/Documentation/scheduler/sched-preempt-delay.txt
new file mode 100644
index 0000000..4c9e111
--- /dev/null
+++ b/Documentation/scheduler/sched-preempt-delay.txt
@@ -0,0 +1,112 @@
+=================================
+What is preemption delay feature?
+=================================
+
+There are times when a userspace task is executing a critical section
+which gates a number of other tasks that want access to the same
+critical section. If the task holding the lock that guards this critical
+section happens to grab the lock just before its timeslice is up and is
+preempted by the scheduler, scheduler ends up scheduling other
+tasks which immediately try to grab the lock to enter the critical
+section. This only results in lots of context switches as tasks wake up
+and go to sleep immediately. If on the other hand, the original task
+were allowed to run for an extra timeslice, it could have completed
+executing its critical section allowing other tasks to make progress
+when they get scheduled. Preemption delay feature allows a task to
+request scheduler to let it borrow one extra timeslice, if possible.
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
+option. This memory location is interpreted as the following data
+structure (defined in linux/sched.h):
+
+struct sched_delay_req {
+	unsigned char nopreempt;	/* flag to request preemption delay */
+	unsigned char yield;		/* flag from kernel indicating  */
+					/* preemption delay was granted */
+	unsigned char rsvd[2];		/* reserved */
+};
+
+Task requests a preemption delay by writing a non-zero value to the
+first byte - nopreempt. Scheduler checks this value before preempting
+the task. Scheduler can choose to grant one and only an additional
+time slice to the task for each delay request but this delay is not
+guaranteed. If scheduler does grant an additional timeslice, it will
+set the flag in second byte. Upon completion of the section of code
+where the task wants preemption delay, task should check the second byte.
+If the flag in second byte is set, it should clear this flag and call
+sched_yield() so as to not hog the processor. If a thread was granted
+additional timeslice and it fails to call sched_yield(), scheduler
+will penalize it by denying its next request for additional timeslice.
+Following sample code illustrates how to use this feature:
+
+#include <linux/sched.h>
+
+int main()
+{
+	unsigned char buf[256];
+	struct sched_delay_req delay;
+
+	bzero(&delay, sizeof(delay));
+
+	/* Tell kernel where the flag lives */
+	prctl(PR_SET_PREEMPT_DELAY, &delay);
+
+	while (/* some condition is true */) {
+		/* do some work and get ready to enter critical section */
+		delay.nopreempt = 1;
+		/*
+		 * Obtain lock for critical section
+		 */
+		/*
+		 * critical section
+		 */
+		/*
+		 * Release lock for critical section
+		 */
+		delay.nopreempt = 0;
+		/* Give the CPU up if required */
+		if (delay.yield) {
+			delay.yield = 0;
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
+1. If the location of shared flag is not aligned to 4-byte boundary,
+   prctl() will terminate with EFAULT.
+2. Userspace app should zero out the sched_delay_req structure before
+   giving kernel the address of this structure. Stale data in this
+   structure could cause unintended requests for preemption delay.
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 41a503c..6c24167 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -852,6 +852,17 @@ config SCHED_MC
 	  making when dealing with multi-core CPU chips at a cost of slightly
 	  increased overhead in some places. If unsure say N here.
 
+config SCHED_PREEMPT_DELAY
+	def_bool n
+	prompt "Scheduler preemption delay support"
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
index 5e344bb..0b2f911 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1116,6 +1116,7 @@ struct sched_statistics {
 	u64			nr_wakeups_affine_attempts;
 	u64			nr_wakeups_passive;
 	u64			nr_wakeups_idle;
+	u64			nr_preempt_delayed;
 };
 #endif
 
@@ -1232,6 +1233,14 @@ enum perf_event_task_context {
 	perf_nr_task_contexts,
 };
 
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+struct preempt_delay {
+	struct sched_delay_req *delay_req;	/* delay request flag pointer */
+	unsigned char delay_granted;		/* currently in delay */
+	unsigned char yield_penalty;		/* failure to yield penalty */
+};
+#endif
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
@@ -1324,6 +1333,9 @@ struct task_struct {
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+	struct preempt_delay sched_preempt_delay;
+#endif
 
 	unsigned long atomic_flags; /* Flags needing atomic access. */
 
@@ -3031,4 +3043,30 @@ static inline unsigned long rlimit_max(unsigned int limit)
 	return task_rlimit_max(current, limit);
 }
 
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+static inline void task_init_preempt_delay(struct task_struct *p)
+{
+	memset(&p->sched_preempt_delay, 0, sizeof(struct preempt_delay));
+}
+static inline void task_clear_preempt_yield(struct task_struct *p)
+{
+	p->sched_preempt_delay.yield_penalty = 0;
+}
+extern int preempt_delay_write(struct task_struct *task,
+					unsigned long preempt_delay_addr);
+#define SCHED_SET_PREEMPT_DELAY(a)	preempt_delay_write(current, a)
+#define SCHED_GET_PREEMPT_DELAY(a)	\
+		put_user((unsigned long)current->sched_preempt_delay.delay_req,\
+				(unsigned long __user *)a)
+#else
+static inline void task_init_preempt_delay(struct task_struct *p)
+{
+}
+static inline void task_clear_preempt_yield(struct task_struct *p)
+{
+}
+#define SCHED_SET_PREEMPT_DELAY(a)	(-EINVAL)
+#define SCHED_GET_PREEMPT_DELAY(a)	(-EINVAL)
+#endif /* CONFIG_SCHED_PREEMPT_DELAY */
+
 #endif
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
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index b932be9..66a2f67 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -49,4 +49,13 @@
  */
 #define SCHED_FLAG_RESET_ON_FORK	0x01
 
+/*
+ * struct for requesting preemption delay from scheduler
+ */
+struct sched_delay_req {
+	unsigned char nopreempt;
+	unsigned char yield;
+	unsigned char rsvd[2];
+};
+
 #endif /* _UAPI_LINUX_SCHED_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 9b7d746..aea655b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1672,6 +1672,8 @@ long do_fork(unsigned long clone_flags,
 			get_task_struct(p);
 		}
 
+		task_init_preempt_delay(p);
+
 		wake_up_new_task(p);
 
 		/* forking complete and child started to run, tell ptracer */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 24beb9b..a926eea 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4201,6 +4201,7 @@ SYSCALL_DEFINE0(sched_yield)
 {
 	struct rq *rq = this_rq_lock();
 
+	task_clear_preempt_yield(current);
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
index ef2b104..a880c6f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -428,6 +428,129 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+int sysctl_preempt_delay_available;
+
+int
+preempt_delay_write(struct task_struct *task, unsigned long preempt_delay_addr)
+{
+	/*
+	 * Do not allow write if preemption delay feature is disabled
+	 */
+	if (!sysctl_preempt_delay_available)
+		return -EPERM;
+
+	if ((void *)preempt_delay_addr == NULL) {
+		task->sched_preempt_delay.delay_req = NULL;
+		return 0;
+	}
+
+	/*
+	 * Validate the pointer. It should be naturally aligned
+	 */
+	if (unlikely((preempt_delay_addr % sizeof(u32)) != 0))
+		return -EFAULT;
+	if (unlikely(!access_ok(rw, preempt_delay_addr,
+					sizeof(struct sched_delay_req))))
+		return -EFAULT;
+
+	task->sched_preempt_delay.delay_req =
+				(struct sched_delay_req *) preempt_delay_addr;
+	return 0;
+}
+
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
+	struct sched_delay_req *delay_req, delay_flag;
+	int ret;
+
+	if (!sysctl_preempt_delay_available)
+		goto resched_now;
+
+	/*
+	 * Check if task is using pre-emption delay feature. If address
+	 * for preemption delay request flag is not set, this task is
+	 * not using preemption delay feature, we can reschedule without
+	 * any delay
+	 */
+	delay_req = curr->sched_preempt_delay.delay_req;
+	if (delay_req == NULL)
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
+	 * in userspace earlier. If there is a page fault accessing this
+	 * flag in userspace, that means userspace has not touched this
+	 * flag recently and we can assume no preemption delay is needed.
+	 *
+	 * If task is not requesting additional timeslice, resched now
+	 */
+	pagefault_disable();
+	ret = __copy_from_user_inatomic(&delay_flag, delay_req,
+			sizeof(u32));
+	pagefault_enable();
+	if (ret || !delay_flag.nopreempt)
+		goto resched_now;
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
+	 * it wants amnesty.
+	 */
+	delay_flag.nopreempt = 0;
+	delay_flag.yield = 1;
+	schedstat_inc(curr, se.statistics.nr_preempt_delayed);
+	__copy_to_user_inatomic(delay_req, &delay_flag, sizeof(u32));
+
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
 
@@ -2951,7 +3074,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 	ideal_runtime = sched_slice(cfs_rq, curr);
 	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
 	if (delta_exec > ideal_runtime) {
-		resched_curr(rq_of(cfs_rq));
+		delay_resched_rq(rq_of(cfs_rq));
 		/*
 		 * The current task ran long enough, ensure it doesn't get
 		 * re-elected due to buddy favours.
@@ -2975,7 +3098,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 		return;
 
 	if (delta > ideal_runtime)
-		resched_curr(rq_of(cfs_rq));
+		delay_resched_rq(rq_of(cfs_rq));
 }
 
 static void
@@ -4792,7 +4915,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	return;
 
 preempt:
-	resched_curr(rq);
+	delay_resched_rq(rq);
 	/*
 	 * Only set the backward buddy when the current task is still
 	 * on the rq. This can happen when a wakeup gets interleaved
diff --git a/kernel/sys.c b/kernel/sys.c
index 1eaa2f0..a8b1eff 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2203,6 +2203,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			me->mm->def_flags &= ~VM_NOHUGEPAGE;
 		up_write(&me->mm->mmap_sem);
 		break;
+	case PR_SET_PREEMPT_DELAY:
+		error = SCHED_SET_PREEMPT_DELAY(arg2);
+		break;
+	case PR_GET_PREEMPT_DELAY:
+		error = SCHED_GET_PREEMPT_DELAY(arg2);
+		break;
 	default:
 		error = -EINVAL;
 		break;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 15f2511..c1cd344 100644
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
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
 	{ }
 };
 
-- 
1.9.1

