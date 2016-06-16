From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v9 04/12] kthread: Allow to call __kthread_create_on_node() with va_list args
Date: Thu, 16 Jun 2016 13:17:23 +0200
Message-ID: <1466075851-24013-5-git-send-email-pmladek@suse.com>
References: <1466075851-24013-1-git-send-email-pmladek@suse.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466075851-24013-1-git-send-email-pmladek-IBi9RG/b67k@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

kthread_create_on_node() implements a bunch of logic to create
the kthread. It is already called by kthread_create_on_cpu().

We are going to extend the kthread worker API and will
need to call kthread_create_on_node() with va_list args there.

This patch does only a refactoring and does not modify the existing
behavior.

Signed-off-by: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
---
 kernel/kthread.c | 72 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 42 insertions(+), 30 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index aea12c9fec98..8ed2a4434185 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -244,33 +244,10 @@ static void create_kthread(struct kthread_create_info *create)
 	}
 }
 
-/**
- * kthread_create_on_node - create a kthread.
- * @threadfn: the function to run until signal_pending(current).
- * @data: data ptr for @threadfn.
- * @node: task and thread structures for the thread are allocated on this node
- * @namefmt: printf-style name for the thread.
- *
- * Description: This helper function creates and names a kernel
- * thread.  The thread will be stopped: use wake_up_process() to start
- * it.  See also kthread_run().  The new thread has SCHED_NORMAL policy and
- * is affine to all CPUs.
- *
- * If thread is going to be bound on a particular cpu, give its node
- * in @node, to get NUMA affinity for kthread stack, or else give NUMA_NO_NODE.
- * When woken, the thread will run @threadfn() with @data as its
- * argument. @threadfn() can either call do_exit() directly if it is a
- * standalone thread for which no one will call kthread_stop(), or
- * return when 'kthread_should_stop()' is true (which means
- * kthread_stop() has been called).  The return value should be zero
- * or a negative error number; it will be passed to kthread_stop().
- *
- * Returns a task_struct or ERR_PTR(-ENOMEM) or ERR_PTR(-EINTR).
- */
-struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
-					   void *data, int node,
-					   const char namefmt[],
-					   ...)
+static struct task_struct *__kthread_create_on_node(int (*threadfn)(void *data),
+						    void *data, int node,
+						    const char namefmt[],
+						    va_list args)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
 	struct task_struct *task;
@@ -311,11 +288,8 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 	task = create->result;
 	if (!IS_ERR(task)) {
 		static const struct sched_param param = { .sched_priority = 0 };
-		va_list args;
 
-		va_start(args, namefmt);
 		vsnprintf(task->comm, sizeof(task->comm), namefmt, args);
-		va_end(args);
 		/*
 		 * root may have changed our (kthreadd's) priority or CPU mask.
 		 * The kernel thread should not inherit these properties.
@@ -326,6 +300,44 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 	kfree(create);
 	return task;
 }
+
+/**
+ * kthread_create_on_node - create a kthread.
+ * @threadfn: the function to run until signal_pending(current).
+ * @data: data ptr for @threadfn.
+ * @node: task and thread structures for the thread are allocated on this node
+ * @namefmt: printf-style name for the thread.
+ *
+ * Description: This helper function creates and names a kernel
+ * thread.  The thread will be stopped: use wake_up_process() to start
+ * it.  See also kthread_run().  The new thread has SCHED_NORMAL policy and
+ * is affine to all CPUs.
+ *
+ * If thread is going to be bound on a particular cpu, give its node
+ * in @node, to get NUMA affinity for kthread stack, or else give NUMA_NO_NODE.
+ * When woken, the thread will run @threadfn() with @data as its
+ * argument. @threadfn() can either call do_exit() directly if it is a
+ * standalone thread for which no one will call kthread_stop(), or
+ * return when 'kthread_should_stop()' is true (which means
+ * kthread_stop() has been called).  The return value should be zero
+ * or a negative error number; it will be passed to kthread_stop().
+ *
+ * Returns a task_struct or ERR_PTR(-ENOMEM) or ERR_PTR(-EINTR).
+ */
+struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
+					   void *data, int node,
+					   const char namefmt[],
+					   ...)
+{
+	struct task_struct *task;
+	va_list args;
+
+	va_start(args, namefmt);
+	task = __kthread_create_on_node(threadfn, data, node, namefmt, args);
+	va_end(args);
+
+	return task;
+}
 EXPORT_SYMBOL(kthread_create_on_node);
 
 static void __kthread_bind_mask(struct task_struct *p, const struct cpumask *mask, long state)
-- 
1.8.5.6
