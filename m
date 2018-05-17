From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] workqueue: Set worker->desc to workqueue name by default
Date: Wed, 16 May 2018 21:34:46 -0700
Message-ID: <20180517043448.3152269-5-tj@kernel.org>
References: <20180517043448.3152269-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180517043448.3152269-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, jiangshanlai@gmail.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, kernel-team@fb.com, csmall@enc.com.au, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

Work functions can use set_worker_desc() to improve the visibility of
what the worker task is doing.  Currently, the desc field is unset at
the beginning of each execution and there is a separate field to track
the field is set during the current execution.

Instead of leaving empty till desc is set, worker->desc can be used to
remember the last workqueue the worker worked on by default and users
that use set_worker_desc() can override it to something more
informative as necessary.

This simplifies desc handling and helps tracking the last workqueue
that the worker exected on to improve visibility.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c          | 21 ++++++++++-----------
 kernel/workqueue_internal.h |  1 -
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2fde50f..3fbe007 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2088,6 +2088,12 @@ __acquires(&pool->lock)
 	worker->current_pwq = pwq;
 	work_color = get_work_color(work);
 
+	/*
+	 * Record wq name for cmdline and debug reporting, may get
+	 * overridden through set_worker_desc().
+	 */
+	strscpy(worker->desc, pwq->wq->name, WORKER_DESC_LEN);
+
 	list_del_init(&work->entry);
 
 	/*
@@ -2183,7 +2189,6 @@ __acquires(&pool->lock)
 	worker->current_work = NULL;
 	worker->current_func = NULL;
 	worker->current_pwq = NULL;
-	worker->desc_valid = false;
 	pwq_dec_nr_in_flight(pwq, work_color);
 }
 
@@ -4346,7 +4351,6 @@ void set_worker_desc(const char *fmt, ...)
 		va_start(args, fmt);
 		vsnprintf(worker->desc, sizeof(worker->desc), fmt, args);
 		va_end(args);
-		worker->desc_valid = true;
 	}
 }
 
@@ -4370,7 +4374,6 @@ void print_worker_info(const char *log_lvl, struct task_struct *task)
 	char desc[WORKER_DESC_LEN] = { };
 	struct pool_workqueue *pwq = NULL;
 	struct workqueue_struct *wq = NULL;
-	bool desc_valid = false;
 	struct worker *worker;
 
 	if (!(task->flags & PF_WQ_WORKER))
@@ -4383,22 +4386,18 @@ void print_worker_info(const char *log_lvl, struct task_struct *task)
 	worker = kthread_probe_data(task);
 
 	/*
-	 * Carefully copy the associated workqueue's workfn and name.  Keep
-	 * the original last '\0' in case the original contains garbage.
+	 * Carefully copy the associated workqueue's workfn, name and desc.
+	 * Keep the original last '\0' in case the original is garbage.
 	 */
 	probe_kernel_read(&fn, &worker->current_func, sizeof(fn));
 	probe_kernel_read(&pwq, &worker->current_pwq, sizeof(pwq));
 	probe_kernel_read(&wq, &pwq->wq, sizeof(wq));
 	probe_kernel_read(name, wq->name, sizeof(name) - 1);
-
-	/* copy worker description */
-	probe_kernel_read(&desc_valid, &worker->desc_valid, sizeof(desc_valid));
-	if (desc_valid)
-		probe_kernel_read(desc, worker->desc, sizeof(desc) - 1);
+	probe_kernel_read(desc, worker->desc, sizeof(desc) - 1);
 
 	if (fn || name[0] || desc[0]) {
 		printk("%sWorkqueue: %s %pf", log_lvl, name, fn);
-		if (desc[0])
+		if (strcmp(name, desc))
 			pr_cont(" (%s)", desc);
 		pr_cont("\n");
 	}
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index 4a182e0..66fbb5a 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -31,7 +31,6 @@ struct worker {
 	struct work_struct	*current_work;	/* L: work being processed */
 	work_func_t		current_func;	/* L: current_work's fn */
 	struct pool_workqueue	*current_pwq; /* L: current_work's pwq */
-	bool			desc_valid;	/* ->desc is valid */
 	struct list_head	scheduled;	/* L: scheduled works */
 
 	/* 64 bytes boundary on 64bit, 32 on 32bit */
-- 
2.9.5
