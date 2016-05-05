From: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mountinfo: implement show_path for kernfs and cgroup
Date: Thu, 5 May 2016 10:20:58 -0500
Message-ID: <20160505152058.GC13186@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

Short explanation:

When showing a cgroupfs entry in mountinfo, show the path of the mount
root dentry relative to the reader's cgroup namespace root.

Long version:

When a uid 0 task which is in freezer cgroup /a/b, unshares a new cgroup
namespace, and then mounts a new instance of the freezer cgroup, the new
mount will be rooted at /a/b.  The root dentry field of the mountinfo
entry will show '/a/b'.

 cat > /tmp/do1 << EOF
 mount -t cgroup -o freezer freezer /mnt
 grep freezer /proc/self/mountinfo
 EOF

 unshare -Gm  bash /tmp/do1
 > 330 160 0:34 / /sys/fs/cgroup/freezer rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,freezer
 > 355 133 0:34 /a/b /mnt rw,relatime - cgroup freezer rw,freezer

The task's freezer cgroup entry in /proc/self/cgroup will simply show
'/':

 grep freezer /proc/self/cgroup
 9:freezer:/

If instead the same task simply bind mounts the /a/b cgroup directory,
the resulting mountinfo entry will again show /a/b for the dentry root.
However in this case the task will find its own cgroup at /mnt/a/b,
not at /mnt:

 mount --bind /sys/fs/cgroup/freezer/a/b /mnt
 130 25 0:34 /a/b /mnt rw,nosuid,nodev,noexec,relatime shared:21 - cgroup cgroup rw,freezer

In other words, there is no way for the task to know, based on what is
in mountinfo, which cgroup directory is its own.

With this patch, the dentry root field in mountinfo is shown relative
to the reader's cgroup namespace.  I.e.:

 unshare -Gm  bash /tmp/do1
 > 330 160 0:34 / /sys/fs/cgroup/freezer rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,freezer
 > 355 133 0:34 / /mnt rw,relatime - cgroup freezer rw,freezer

This way the task can correlate the paths in /proc/pid/cgroup to
/proc/self/mountinfo, and determine which cgroup directory (in any
mount which the reader created) corresponds to the task.

Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 fs/kernfs/mount.c      | 14 +++++++++++
 include/linux/kernfs.h |  2 ++
 kernel/cgroup.c        | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 79 insertions(+)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index f73541f..3b78724 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/pagemap.h>
 #include <linux/namei.h>
+#include <linux/seq_file.h>
 
 #include "kernfs-internal.h"
 
@@ -40,6 +41,18 @@ static int kernfs_sop_show_options(struct seq_file *sf, struct dentry *dentry)
 	return 0;
 }
 
+static int kernfs_sop_show_path(struct seq_file *sf, struct dentry *dentry)
+{
+	struct kernfs_node *node = dentry->d_fsdata;
+	struct kernfs_root *root = kernfs_root(node);
+	struct kernfs_syscall_ops *scops = root->syscall_ops;
+
+	if (scops && scops->show_path)
+		return scops->show_path(sf, node, root);
+
+	return seq_dentry(sf, dentry, " \t\n\\");
+}
+
 const struct super_operations kernfs_sops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= generic_delete_inode,
@@ -47,6 +60,7 @@ const struct super_operations kernfs_sops = {
 
 	.remount_fs	= kernfs_sop_remount_fs,
 	.show_options	= kernfs_sop_show_options,
+	.show_path	= kernfs_sop_show_path,
 };
 
 /**
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index c06c442..30f089e 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -152,6 +152,8 @@ struct kernfs_syscall_ops {
 	int (*rmdir)(struct kernfs_node *kn);
 	int (*rename)(struct kernfs_node *kn, struct kernfs_node *new_parent,
 		      const char *new_name);
+	int (*show_path)(struct seq_file *sf, struct kernfs_node *kn,
+			 struct kernfs_root *root);
 };
 
 struct kernfs_root {
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 909a7d3..afea39e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1215,6 +1215,41 @@ static void cgroup_destroy_root(struct cgroup_root *root)
 	cgroup_free_root(root);
 }
 
+/*
+ * look up cgroup associated with current task's cgroup namespace on the
+ * specified hierarchy
+ */
+static struct cgroup *
+current_cgns_cgroup_from_root(struct cgroup_root *root)
+{
+	struct cgroup *res = NULL;
+	struct css_set *cset;
+
+	lockdep_assert_held(&css_set_lock);
+
+	rcu_read_lock();
+
+	cset = current->nsproxy->cgroup_ns->root_cset;
+	if (cset == &init_css_set) {
+		res = &root->cgrp;
+	} else {
+		struct cgrp_cset_link *link;
+
+		list_for_each_entry(link, &cset->cgrp_links, cgrp_link) {
+			struct cgroup *c = link->cgrp;
+
+			if (c->root == root) {
+				res = c;
+				break;
+			}
+		}
+	}
+	rcu_read_unlock();
+
+	BUG_ON(!res);
+	return res;
+}
+
 /* look up cgroup associated with given css_set on the specified hierarchy */
 static struct cgroup *cset_cgroup_from_root(struct css_set *cset,
 					    struct cgroup_root *root)
@@ -1593,6 +1628,33 @@ static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 	return 0;
 }
 
+static int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
+			    struct kernfs_root *kf_root)
+{
+	int len = 0, ret = 0;
+	char *buf = NULL;
+	struct cgroup_root *kf_cgroot = cgroup_root_from_kf(kf_root);
+	struct cgroup *ns_cgroup;
+
+	buf = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	spin_lock_bh(&css_set_lock);
+	ns_cgroup = current_cgns_cgroup_from_root(kf_cgroot);
+	len = kernfs_path_from_node(kf_node, ns_cgroup->kn, buf, PATH_MAX);
+	spin_unlock_bh(&css_set_lock);
+
+	if (len >= PATH_MAX)
+		len = -ERANGE;
+	else if (len > 0) {
+		seq_escape(sf, buf, " \t\n\\");
+		len = 0;
+	}
+	kfree(buf);
+	return len;
+}
+
 static int cgroup_show_options(struct seq_file *seq,
 			       struct kernfs_root *kf_root)
 {
@@ -5433,6 +5495,7 @@ static struct kernfs_syscall_ops cgroup_kf_syscall_ops = {
 	.mkdir			= cgroup_mkdir,
 	.rmdir			= cgroup_rmdir,
 	.rename			= cgroup_rename,
+	.show_path		= cgroup_show_path,
 };
 
 static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
-- 
2.7.4
