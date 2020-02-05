From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6 3/6] cgroup: refactor fork helpers
Date: Wed,  5 Feb 2020 14:26:20 +0100
Message-ID: <20200205132623.670015-4-christian.brauner@ubuntu.com>
References: <20200205132623.670015-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200205132623.670015-1-christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This refactors the fork helpers so they can be easily modified in the
next patches. The patch just moves the cgroup threadgroup rwsem grab and
release into the helpers. They don't need to be directly exposed in fork.c.

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Acked-by: Michal Koutný <mkoutny-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
/* v1 */
patch not present

/* v2 */
patch not present

/* v3 */
Link: https://lore.kernel.org/r/20200117002143.15559-4-christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
patch introduced
- Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
  - split into separate commmit

/* v4 */
Link: https://lore.kernel.org/r/20200117181219.14542-4-christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
unchanged

/* v5 */
Link: https://lore.kernel.org/r/20200121154844.411-4-christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
- Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
  - remove struct task_struct *parent argument from clone helpers in favor of
    using current directly
- Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>:
  - fix typo in commit message

/* v6 */
- Michal Koutný <mkoutny-IBi9RG/b67k@public.gmane.org>:
  - Remove "kargs" comments leftover from rebasing. They only become relevant
    in later commits.
---
 kernel/cgroup/cgroup.c | 44 +++++++++++++++++++++++++-----------------
 kernel/fork.c          |  6 +-----
 2 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 7c1c8677849e..991f10662e95 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5895,17 +5895,20 @@ static struct cgroup *cgroup_get_from_file(struct file *f)
 
 /**
  * cgroup_can_fork - called on a new task before the process is exposed
- * @child: the task in question.
+ * @child: the child process
  *
- * This calls the subsystem can_fork() callbacks. If the can_fork() callback
- * returns an error, the fork aborts with that error code. This allows for
- * a cgroup subsystem to conditionally allow or deny new forks.
+ * This calls the subsystem can_fork() callbacks. If the cgroup_can_fork()
+ * callback returns an error, the fork aborts with that error code. This
+ * allows for a cgroup subsystem to conditionally allow or deny new forks.
  */
 int cgroup_can_fork(struct task_struct *child)
+	__acquires(&cgroup_threadgroup_rwsem) __releases(&cgroup_threadgroup_rwsem)
 {
 	struct cgroup_subsys *ss;
 	int i, j, ret;
 
+	cgroup_threadgroup_change_begin(current);
+
 	do_each_subsys_mask(ss, i, have_canfork_callback) {
 		ret = ss->can_fork(child);
 		if (ret)
@@ -5922,17 +5925,20 @@ int cgroup_can_fork(struct task_struct *child)
 			ss->cancel_fork(child);
 	}
 
+	cgroup_threadgroup_change_end(current);
+
 	return ret;
 }
 
 /**
- * cgroup_cancel_fork - called if a fork failed after cgroup_can_fork()
- * @child: the task in question
- *
- * This calls the cancel_fork() callbacks if a fork failed *after*
- * cgroup_can_fork() succeded.
- */
+  * cgroup_cancel_fork - called if a fork failed after cgroup_can_fork()
+  * @child: the child process
+  *
+  * This calls the cancel_fork() callbacks if a fork failed *after*
+  * cgroup_can_fork() succeded.
+  */
 void cgroup_cancel_fork(struct task_struct *child)
+	__releases(&cgroup_threadgroup_rwsem)
 {
 	struct cgroup_subsys *ss;
 	int i;
@@ -5940,19 +5946,19 @@ void cgroup_cancel_fork(struct task_struct *child)
 	for_each_subsys(ss, i)
 		if (ss->cancel_fork)
 			ss->cancel_fork(child);
+
+	cgroup_threadgroup_change_end(current);
 }
 
 /**
- * cgroup_post_fork - called on a new task after adding it to the task list
- * @child: the task in question
- *
- * Adds the task to the list running through its css_set if necessary and
- * call the subsystem fork() callbacks.  Has to be after the task is
- * visible on the task list in case we race with the first call to
- * cgroup_task_iter_start() - to guarantee that the new task ends up on its
- * list.
+ * cgroup_post_fork - finalize cgroup setup for the child process
+ * @child: the child process
+ *
+ * Attach the child process to its css_set calling the subsystem fork()
+ * callbacks.
  */
 void cgroup_post_fork(struct task_struct *child)
+	__releases(&cgroup_threadgroup_rwsem)
 {
 	struct cgroup_subsys *ss;
 	struct css_set *cset;
@@ -5995,6 +6001,8 @@ void cgroup_post_fork(struct task_struct *child)
 	do_each_subsys_mask(ss, i, have_fork_callback) {
 		ss->fork(child);
 	} while_each_subsys_mask();
+
+	cgroup_threadgroup_change_end(current);
 }
 
 /**
diff --git a/kernel/fork.c b/kernel/fork.c
index 080809560072..ca5de25690c8 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2165,7 +2165,6 @@ static __latent_entropy struct task_struct *copy_process(
 	INIT_LIST_HEAD(&p->thread_group);
 	p->task_works = NULL;
 
-	cgroup_threadgroup_change_begin(current);
 	/*
 	 * Ensure that the cgroup subsystem policies allow the new process to be
 	 * forked. It should be noted the the new process's css_set can be changed
@@ -2174,7 +2173,7 @@ static __latent_entropy struct task_struct *copy_process(
 	 */
 	retval = cgroup_can_fork(p);
 	if (retval)
-		goto bad_fork_cgroup_threadgroup_change_end;
+		goto bad_fork_put_pidfd;
 
 	/*
 	 * From this point on we must avoid any synchronous user-space
@@ -2280,7 +2279,6 @@ static __latent_entropy struct task_struct *copy_process(
 
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
-	cgroup_threadgroup_change_end(current);
 	perf_event_fork(p);
 
 	trace_task_newtask(p, clone_flags);
@@ -2292,8 +2290,6 @@ static __latent_entropy struct task_struct *copy_process(
 	spin_unlock(&current->sighand->siglock);
 	write_unlock_irq(&tasklist_lock);
 	cgroup_cancel_fork(p);
-bad_fork_cgroup_threadgroup_change_end:
-	cgroup_threadgroup_change_end(current);
 bad_fork_put_pidfd:
 	if (clone_flags & CLONE_PIDFD) {
 		fput(pidfile);
-- 
2.25.0
