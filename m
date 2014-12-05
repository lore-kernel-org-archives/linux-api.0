From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv3 3/8] cgroup: add function to get task's cgroup on default
	hierarchy
Date: Thu,  4 Dec 2014 17:55:45 -0800
Message-ID: <1417744550-6461-4-git-send-email-adityakali@google.com>
References: <adityakali-cgroupns>
	<1417744550-6461-1-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1417744550-6461-1-git-send-email-adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

get_task_cgroup() returns the (reference counted) cgroup of the
given task on the default hierarchy.

Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h |  1 +
 kernel/cgroup.c        | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 9fd99f5..d6930de 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -579,6 +579,7 @@ static inline void pr_cont_cgroup_path(struct cgroup *cgrp)
 }
 
 char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen);
+struct cgroup *get_task_cgroup(struct task_struct *task);
 
 int cgroup_add_dfl_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
 int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index bb263d0..5d8fc84 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1966,6 +1966,31 @@ char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 }
 EXPORT_SYMBOL_GPL(task_cgroup_path);
 
+/*
+ * get_task_cgroup - returns the cgroup of the task in the default cgroup
+ * hierarchy.
+ *
+ * @task: target task
+ * This function returns the @task's cgroup on the default cgroup hierarchy. The
+ * returned cgroup has its reference incremented (by calling cgroup_get()). So
+ * the caller must cgroup_put() the obtained reference once it is done with it.
+ */
+struct cgroup *get_task_cgroup(struct task_struct *task)
+{
+	struct cgroup *cgrp;
+
+	mutex_lock(&cgroup_mutex);
+	down_read(&css_set_rwsem);
+
+	cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
+	cgroup_get(cgrp);
+
+	up_read(&css_set_rwsem);
+	mutex_unlock(&cgroup_mutex);
+	return cgrp;
+}
+EXPORT_SYMBOL_GPL(get_task_cgroup);
+
 /* used to track tasks and other necessary states during migration */
 struct cgroup_taskset {
 	/* the src and dst cset list running through cset->mg_node */
-- 
2.2.0.rc0.207.ga3a616c
