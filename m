From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv1 7/8] cgroup: cgroup namespace setns support
Date: Mon, 13 Oct 2014 14:23:49 -0700
Message-ID: <1413235430-22944-8-git-send-email-adityakali@google.com>
References: <adityakali-cgroupns>
 <1413235430-22944-1-git-send-email-adityakali@google.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413235430-22944-1-git-send-email-adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

setns on a cgroup namespace is allowed only if
* task has CAP_SYS_ADMIN in its current user-namespace and
  over the user-namespace associated with target cgroupns.
* task's current cgroup is descendent of the target cgroupns-root
  cgroup.
* target cgroupns-root is same as or deeper than task's current
  cgroupns-root. This is so that the task cannot escape out of its
  cgroupns-root. This also ensures that setns() only makes the task
  get restricted to a deeper cgroup hierarchy.

Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup_namespace.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup_namespace.c b/kernel/cgroup_namespace.c
index c16604f..c612946 100644
--- a/kernel/cgroup_namespace.c
+++ b/kernel/cgroup_namespace.c
@@ -80,8 +80,48 @@ err_out:
 
 static int cgroupns_install(struct nsproxy *nsproxy, void *ns)
 {
-	pr_info("setns not supported for cgroup namespace");
-	return -EINVAL;
+	struct cgroup_namespace *cgroup_ns = ns;
+	struct task_struct *task = current;
+	struct cgroup *cgrp = NULL;
+	int err = 0;
+
+	if (!ns_capable(current_user_ns(), CAP_SYS_ADMIN) ||
+	    !ns_capable(cgroup_ns->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* Prevent cgroup changes for this task. */
+	threadgroup_lock(task);
+
+	cgrp = get_task_cgroup(task);
+
+	err = -EINVAL;
+	if (!cgroup_on_dfl(cgrp))
+		goto out_unlock;
+
+	/* Allow switch only if the task's current cgroup is descendant of the
+	 * target cgroup_ns->root_cgrp.
+	 */
+	if (!cgroup_is_descendant(cgrp, cgroup_ns->root_cgrp))
+		goto out_unlock;
+
+	/* Only allow setns to a cgroupns root-ed deeper than task's current
+	 * cgroupns-root. This will make sure that tasks cannot escape their
+	 * cgroupns by attaching to parent cgroupns.
+	 */
+	if (!cgroup_is_descendant(cgroup_ns->root_cgrp,
+				  task_cgroupns_root(task)))
+		goto out_unlock;
+
+	err = 0;
+	get_cgroup_ns(cgroup_ns);
+	put_cgroup_ns(nsproxy->cgroup_ns);
+	nsproxy->cgroup_ns = cgroup_ns;
+
+out_unlock:
+	threadgroup_unlock(current);
+	if (cgrp)
+		cgroup_put(cgrp);
+	return err;
 }
 
 static void *cgroupns_get(struct task_struct *task)
-- 
2.1.0.rc2.206.gedb03e5
