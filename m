From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH] cgroup namespaces: add a 'nsroot=' mountinfo field
Date: Mon, 21 Mar 2016 18:41:33 -0500
Message-ID: <20160321234133.GA22463@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Linux Containers <containers-qjLDD68F18O7TbgM5vRIOg@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

One practical problem I've found with cgroup namespaces is that there
is no way to disambiguate between a cgroupfs mount which was done in
a cgroup namespace, and a bind mount of a cgroupfs directory.  So
whether I do

unshare --cgroup -- bash -c "mount -t cgroup -o freezer f /mnt; cat /proc/self/mountinfo"

or whether I just

mount --bind /sys/fs/cgroup/freezer/$(awk -F: '/freezer/ { print $3 }' /proc/self/cgroup) /mnt

'mount root' field (field 3) in /proc/self/mountinfo will show the
same thing, the result of awk -F: '/freezer/ { print $3 }' /proc/self/cgroup.

This patch adds a 'nsroot=' field to cgroup mountinfo entries, so that
userspace can distinguish a mount made in a cgroup namespace from a bind
mount from a cgroup subdirectory.

Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 fs/kernfs/mount.c      |  2 +-
 include/linux/kernfs.h |  3 ++-
 kernel/cgroup.c        | 29 ++++++++++++++++++++++++++++-
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index b67dbcc..58f59fd 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -36,7 +36,7 @@ static int kernfs_sop_show_options(struct seq_file *sf, struct dentry *dentry)
 	struct kernfs_syscall_ops *scops = root->syscall_ops;
 
 	if (scops && scops->show_options)
-		return scops->show_options(sf, root);
+		return scops->show_options(sf, dentry, root);
 	return 0;
 }
 
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index c06c442..3124b91 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -145,7 +145,8 @@ struct kernfs_node {
  */
 struct kernfs_syscall_ops {
 	int (*remount_fs)(struct kernfs_root *root, int *flags, char *data);
-	int (*show_options)(struct seq_file *sf, struct kernfs_root *root);
+	int (*show_options)(struct seq_file *sf, struct dentry *dentry,
+			    struct kernfs_root *root);
 
 	int (*mkdir)(struct kernfs_node *parent, const char *name,
 		     umode_t mode);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 671dc05..806d1e7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1593,7 +1593,32 @@ static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 	return 0;
 }
 
-static int cgroup_show_options(struct seq_file *seq,
+static void cgroup_show_nsroot(struct seq_file *seq, struct dentry *dentry,
+			       struct kernfs_root *kf_root)
+{
+	struct kernfs_node *d_kn = dentry->d_fsdata;
+	char *nsroot;
+	int len, ret;
+
+	if (!kf_root)
+		return;
+	len = kernfs_path_from_node(d_kn, kf_root->kn, NULL, 0);
+	if (len <= 0)
+		return;
+	nsroot = kzalloc(len + 1, GFP_ATOMIC);
+	if (!nsroot)
+		return;
+	ret = kernfs_path_from_node(d_kn, kf_root->kn, nsroot, len + 1);
+	if (ret <= 0 || ret > len)
+		goto out;
+
+	seq_show_option(seq, "nsroot", nsroot);
+
+out:
+	kfree(nsroot);
+}
+
+static int cgroup_show_options(struct seq_file *seq, struct dentry *dentry,
 			       struct kernfs_root *kf_root)
 {
 	struct cgroup_root *root = cgroup_root_from_kf(kf_root);
@@ -1619,6 +1644,8 @@ static int cgroup_show_options(struct seq_file *seq,
 		seq_puts(seq, ",clone_children");
 	if (strlen(root->name))
 		seq_show_option(seq, "name", root->name);
+	cgroup_show_nsroot(seq, dentry, kf_root);
+
 	return 0;
 }
 
-- 
2.7.3
