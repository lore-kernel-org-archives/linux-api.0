From: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH 2/2] mountinfo: implement show_path for kernfs and cgroup
Date: Sun, 17 Apr 2016 15:04:32 -0500
Message-ID: <1460923472-29370-3-git-send-email-serge.hallyn@ubuntu.com>
References: <1460923472-29370-1-git-send-email-serge.hallyn@ubuntu.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460923472-29370-1-git-send-email-serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

When showing a cgroupfs entry in mountinfo, show the
path of the mount root dentry relative to the reader's
cgroup namespace root.

Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 fs/kernfs/mount.c      | 14 ++++++++++++++
 include/linux/kernfs.h |  2 ++
 kernel/cgroup.c        | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+)

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
index 671dc05..9a0d7b3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1593,6 +1593,40 @@ static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 	return 0;
 }
 
+static int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
+			    struct kernfs_root *kf_root)
+{
+	int len = 0, ret = 0;
+	char *buf = NULL;
+	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
+	struct cgroup_root *kf_cgroot = cgroup_root_from_kf(kf_root);
+	struct cgroup *ns_cgroup;
+
+	mutex_lock(&cgroup_mutex);
+	spin_lock_bh(&css_set_lock);
+	ns_cgroup = cset_cgroup_from_root(ns->root_cset, kf_cgroot);
+	len = kernfs_path_from_node(kf_node, ns_cgroup->kn, NULL, 0);
+	if (len > 0)
+		buf = kmalloc(len + 1, GFP_ATOMIC);
+	if (buf)
+		ret = kernfs_path_from_node(kf_node, ns_cgroup->kn, buf, len + 1);
+
+	spin_unlock_bh(&css_set_lock);
+	mutex_unlock(&cgroup_mutex);
+
+	if (len <= 0)
+		return len;
+	if (!buf)
+		return -ENOMEM;
+	if (ret == len) {
+		seq_escape(sf, buf, " \t\n\\");
+		ret = 0;
+	} else if (ret >= 0)
+		ret = -EINVAL;
+	kfree(buf);
+	return ret;
+}
+
 static int cgroup_show_options(struct seq_file *seq,
 			       struct kernfs_root *kf_root)
 {
@@ -5430,6 +5464,7 @@ static struct kernfs_syscall_ops cgroup_kf_syscall_ops = {
 	.mkdir			= cgroup_mkdir,
 	.rmdir			= cgroup_rmdir,
 	.rename			= cgroup_rename,
+	.show_path		= cgroup_show_path,
 };
 
 static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
-- 
2.7.4
