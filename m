From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv1 6/8] cgroup: restrict cgroup operations within task's
	cgroupns
Date: Mon, 13 Oct 2014 14:23:48 -0700
Message-ID: <1413235430-22944-7-git-send-email-adityakali@google.com>
References: <adityakali-cgroupns>
	<1413235430-22944-1-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1413235430-22944-1-git-send-email-adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Restrict following operations within the calling tasks:
* cgroup_mkdir & cgroup_rmdir
* cgroup_attach_task
* writes to cgroup files outside of task's cgroupns-root

Also, read of /proc/<pid>/cgroup file is now restricted only
to tasks under same cgroupns-root. If a task tries to look
at cgroup of another task outside of its cgroupns-root, then
it won't be able to see anything for the default hierarchy.
This is same as if the cgroups are not mounted.

Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f8099b4..2fc0dfa 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2318,6 +2318,12 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 	struct task_struct *task;
 	int ret;
 
+	/* Only allow changing cgroups accessible within task's cgroup
+	 * namespace. i.e. 'dst_cgrp' should be a descendant of task's
+	 * cgroupns->root_cgrp. */
+	if (!cgroup_is_descendant(dst_cgrp, task_cgroupns_root(leader)))
+		return -EPERM;
+
 	/* look up all src csets */
 	down_read(&css_set_rwsem);
 	rcu_read_lock();
@@ -2882,6 +2888,10 @@ static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 	struct cgroup_subsys_state *css;
 	int ret;
 
+	/* Reject writes to cgroup files outside of task's cgroupns-root. */
+	if (!cgroup_is_descendant(cgrp, task_cgroupns_root(current)))
+		return -EINVAL;
+
 	if (cft->write)
 		return cft->write(of, buf, nbytes, off);
 
@@ -4560,6 +4570,13 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	parent = cgroup_kn_lock_live(parent_kn);
 	if (!parent)
 		return -ENODEV;
+
+	/* Allow mkdir only within process's cgroup namespace root. */
+	if (!cgroup_is_descendant(parent, task_cgroupns_root(current))) {
+		ret = -EPERM;
+		goto out_unlock;
+	}
+
 	root = parent->root;
 
 	/* allocate the cgroup and its ID, 0 is reserved for the root */
@@ -4822,6 +4839,13 @@ static int cgroup_rmdir(struct kernfs_node *kn)
 	if (!cgrp)
 		return 0;
 
+	/* Allow rmdir only within process's cgroup namespace root.
+	 * The process can't delete its own root anyways. */
+	if (!cgroup_is_descendant(cgrp, task_cgroupns_root(current))) {
+		cgroup_kn_unlock(kn);
+		return -EPERM;
+	}
+
 	ret = cgroup_destroy_locked(cgrp);
 
 	cgroup_kn_unlock(kn);
@@ -5051,6 +5075,15 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		if (root == &cgrp_dfl_root && !cgrp_dfl_root_visible)
 			continue;
 
+		cgrp = task_cgroup_from_root(tsk, root);
+
+		/* The cgroup path on default hierarchy is shown only if it
+		 * falls under current task's cgroupns-root.
+		 */
+		if (root == &cgrp_dfl_root &&
+		    !cgroup_is_descendant(cgrp, task_cgroupns_root(current)))
+			continue;
+
 		seq_printf(m, "%d:", root->hierarchy_id);
 		for_each_subsys(ss, ssid)
 			if (root->subsys_mask & (1 << ssid))
@@ -5059,7 +5092,6 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 			seq_printf(m, "%sname=%s", count ? "," : "",
 				   root->name);
 		seq_putc(m, ':');
-		cgrp = task_cgroup_from_root(tsk, root);
 		path = cgroup_path(cgrp, buf, PATH_MAX);
 		if (!path) {
 			retval = -ENAMETOOLONG;
-- 
2.1.0.rc2.206.gedb03e5
