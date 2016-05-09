From: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mountinfo: implement show_path for kernfs and cgroup
Date: Mon, 9 May 2016 09:59:55 -0500
Message-ID: <20160509145955.GA12316@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

Patch summary:

When showing a cgroupfs entry in mountinfo, show the path of the mount
root dentry relative to the reader's cgroup namespace root.

Short explanation (courtesy of mkerrisk):

If we create a new cgroup namespace, then we want both /proc/self/cgroup
and /proc/self/mountinfo to show cgroup paths that are correctly
virtualized with respect to the cgroup mount point.  Previous to this
patch, /proc/self/cgroup shows the right info, but /proc/self/mountinfo
does not.

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

Example (by mkerrisk):

First, a little script to save some typing and verbiage:

# cat cgroup_info.sh
#!/bin/sh
echo -e "\t/proc/self/cgroup:\t$(cat /proc/self/cgroup | grep freezer)"
cat /proc/self/mountinfo | grep freezer |
        awk '{print "\tmountinfo:\t\t" $4 "\t" $5}'
#

Create cgroup, place this shell into the cgroup, and look at the state
of the /proc files:

# mkdir -p /sys/fs/cgroup/freezer/a/b
# echo $$ > /sys/fs/cgroup/freezer/a/b/cgroup.procs
# echo $$
2653
# cat /sys/fs/cgroup/freezer/a/b/cgroup.procs
2653                         # Our shell
14254                        # cat(1)
# ./cgroup_info.sh
        /proc/self/cgroup:      10:freezer:/a/b
        mountinfo:              /       /sys/fs/cgroup/freezer

Create a shell in new cgroup and mount namespaces. The act of creating
a new cgroup namespace causes the process's current cgroups directories
to become its cgroup root directories. (Here, I'm using my own version
of the "unshare" utility, which takes the same options as the util-linux
version):

# ~mtk/tlpi/code/ns/unshare -Cm bash

Look at the state of the /proc files:

# ./cgroup_info.sh
        /proc/self/cgroup:      10:freezer:/
        mountinfo:              /       /sys/fs/cgroup/freezer

The third entry in /proc/self/cgroup (the pathname of the cgroup inside
the hierarchy) is correctly virtualized w.r.t. the cgroup namespace, which
is rooted at /a/b in the outer namespace.

However, the info in /proc/self/mountinfo is not for this cgroup
namespace, since we are seeing a duplicate of the mount from the
old mount namespace, and the info there does not correspond to the
new cgroup namespace. However, trying to create a new mount still
doesn't show us the right information in mountinfo:

# mount --make-rslave /               # Prevent our mount operations
                                      # propagating to other mountns
# mkdir -p /mnt/freezer               # Create a new mount point
# umount /sys/fs/cgroup/freezer       # Discard old mount
# mount -t cgroup -o freezer freezer /mnt/freezer/
# ./cgroup_info.sh
        /proc/self/cgroup:      7:freezer:/
        mountinfo:              /a/b    /mnt/freezer

The act of creating a new cgroup namespace caused the process's
current freezer directory, "/a/b", to become its cgroup freezer root
directory. In other words, the pathname directory of the directory
within the newly mounted cgroup filesystem should be "/",
but mountinfo wrongly shows us "/a/b". The consequence of this is
that the process in the cgroup namespace cannot correctly construct
the pathname of its cgroup root directory from the information in
/proc/PID/mountinfo.

With this patch, the dentry root field in mountinfo is shown relative
to the reader's cgroup namespace.  So the same steps as above:

# mkdir -p /sys/fs/cgroup/freezer/a/b
# echo $$ > /sys/fs/cgroup/freezer/a/b/cgroup.procs
# ./cgroup_info.sh
        /proc/self/cgroup:      10:freezer:/a/b
        mountinfo:              /       /sys/fs/cgroup/freezer
# ~mtk/tlpi/code/ns/unshare -Cm bash
# ./cgroup_info.sh
        /proc/self/cgroup:      10:freezer:/
        mountinfo:              /../..  /sys/fs/cgroup/freezer
# mount --make-rslave /
# mkdir -p /mnt/freezer
# umount /sys/fs/cgroup/freezer
# mount -t cgroup -o freezer freezer /mnt/freezer/
# ./cgroup_info.sh
        /proc/self/cgroup:      10:freezer:/
        mountinfo:              /       /mnt/freezer

# ls /mnt/freezer/
cgroup.clone_children  freezer.parent_freezing  freezer.state      tasks
cgroup.procs           freezer.self_freezing    notify_on_release
# echo $$
3164
# cat /mnt/freezer/cgroup.procs
2653                   # First shell that placed in this cgroup
3164                   # Shell started by 'unshare'
14197                  # cat(1)

Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Tested-by: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Acked-by: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
