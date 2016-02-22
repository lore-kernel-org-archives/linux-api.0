From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v5 01/20] kthread/smpboot: Do not park in kthread_create_on_cpu()
Date: Mon, 22 Feb 2016 15:56:51 +0100
Message-ID: <1456153030-12400-2-git-send-email-pmladek@suse.com>
References: <1456153030-12400-1-git-send-email-pmladek@suse.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456153030-12400-1-git-send-email-pmladek-IBi9RG/b67k@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

kthread_create_on_cpu() was added by the commit 2a1d446019f9a5983e
("kthread: Implement park/unpark facility"). It is currently used
only when enabling new CPU. For this purpose, the newly created
kthread has to be parked.

The CPU binding is a bit tricky. The kthread is parked when the CPU
has not been allowed yet. And the CPU is bound when the kthread
is unparked.

The function would be useful for more per-CPU kthreads, e.g.
bnx2fc_thread, fcoethread. For this purpose, the newly created
kthread should stay in the uninterruptible state.

This patch moves the parking into smpboot. It binds the thread
already when created. Then the function might be used universally.
Also the behavior is consistent with kthread_create() and
kthread_create_on_node().

Signed-off-by: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Reviewed-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
---
 kernel/kthread.c | 8 ++++++--
 kernel/smpboot.c | 5 +++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 9ff173dca1ae..1ffc11ec5546 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -390,10 +390,10 @@ struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
 				   cpu);
 	if (IS_ERR(p))
 		return p;
+	kthread_bind(p, cpu);
+	/* CPU hotplug need to bind once again when unparking the thread. */
 	set_bit(KTHREAD_IS_PER_CPU, &to_kthread(p)->flags);
 	to_kthread(p)->cpu = cpu;
-	/* Park the thread to get it out of TASK_UNINTERRUPTIBLE state */
-	kthread_park(p);
 	return p;
 }
 
@@ -407,6 +407,10 @@ static void __kthread_unpark(struct task_struct *k, struct kthread *kthread)
 	 * which might be about to be cleared.
 	 */
 	if (test_and_clear_bit(KTHREAD_IS_PARKED, &kthread->flags)) {
+		/*
+		 * Newly created kthread was parked when the CPU was offline.
+		 * The binding was lost and we need to set it again.
+		 */
 		if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags))
 			__kthread_bind(k, kthread->cpu, TASK_PARKED);
 		wake_up_state(k, TASK_PARKED);
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index d264f59bff56..79f07014be6e 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -186,6 +186,11 @@ __smpboot_create_thread(struct smp_hotplug_thread *ht, unsigned int cpu)
 		kfree(td);
 		return PTR_ERR(tsk);
 	}
+	/*
+	 * Park the thread so that it could start right on the CPU
+	 * when it is available.
+	 */
+	kthread_park(tsk);
 	get_task_struct(tsk);
 	*per_cpu_ptr(ht->store, cpu) = tsk;
 	if (ht->create) {
-- 
1.8.5.6
