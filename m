From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v8 01/12] kthread: Rename probe_kthread_data() to kthread_probe_data()
Date: Thu,  9 Jun 2016 15:51:55 +0200
Message-ID: <1465480326-31606-2-git-send-email-pmladek@suse.com>
References: <1465480326-31606-1-git-send-email-pmladek@suse.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465480326-31606-1-git-send-email-pmladek-IBi9RG/b67k@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

A good practice is to prefix the names of functions by the name
of the subsystem.

This patch fixes the name of probe_kthread_data(). The other wrong
functions names are part of the kthread worker API and will be
fixed separately.

Suggested-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Signed-off-by: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
---
 include/linux/kthread.h | 2 +-
 kernel/kthread.c        | 4 ++--
 kernel/workqueue.c      | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index e691b6a23f72..c792ee1628d0 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -44,7 +44,7 @@ bool kthread_should_stop(void);
 bool kthread_should_park(void);
 bool kthread_freezable_should_stop(bool *was_frozen);
 void *kthread_data(struct task_struct *k);
-void *probe_kthread_data(struct task_struct *k);
+void *kthread_probe_data(struct task_struct *k);
 int kthread_park(struct task_struct *k);
 void kthread_unpark(struct task_struct *k);
 void kthread_parkme(void);
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 9ff173dca1ae..0bec14aa844e 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -138,7 +138,7 @@ void *kthread_data(struct task_struct *task)
 }
 
 /**
- * probe_kthread_data - speculative version of kthread_data()
+ * kthread_probe_data - speculative version of kthread_data()
  * @task: possible kthread task in question
  *
  * @task could be a kthread task.  Return the data value specified when it
@@ -146,7 +146,7 @@ void *kthread_data(struct task_struct *task)
  * inaccessible for any reason, %NULL is returned.  This function requires
  * that @task itself is safe to dereference.
  */
-void *probe_kthread_data(struct task_struct *task)
+void *kthread_probe_data(struct task_struct *task)
 {
 	struct kthread *kthread = to_kthread(task);
 	void *data = NULL;
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e1c0e996b5ae..64a9df2daa2b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4249,7 +4249,7 @@ void print_worker_info(const char *log_lvl, struct task_struct *task)
 	 * This function is called without any synchronization and @task
 	 * could be in any state.  Be careful with dereferences.
 	 */
-	worker = probe_kthread_data(task);
+	worker = kthread_probe_data(task);
 
 	/*
 	 * Carefully copy the associated workqueue's workfn and name.  Keep
-- 
1.8.5.6
