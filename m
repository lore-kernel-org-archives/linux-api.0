From: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH 5/7] cgroup: mount cgroupns-root when inside non-init cgroupns
Date: Fri, 27 Nov 2015 14:52:23 -0600
Message-ID: <1448657545-531-6-git-send-email-serge.hallyn@ubuntu.com>
References: <1448657545-531-1-git-send-email-serge.hallyn@ubuntu.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1448657545-531-1-git-send-email-serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

This patch enables cgroup mounting inside userns when a process
as appropriate privileges. The cgroup filesystem mounted is
rooted at the cgroupns-root. Thus, in a container-setup, only
the hierarchy under the cgroupns-root is exposed inside the container.
This allows container management tools to run inside the containers
without depending on any global state.
In order to support this, a new kernfs api is added to lookup the
dentry for the cgroupns-root.

Changelog:
	20151116 - Don't allow user namespaces to bind new subsystems
	20151118 - postpone the FS_USERNS_MOUNT flag until the
	           last patch, until we can convince ourselves it
		   is safe.

Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 fs/kernfs/mount.c      |   50 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/kernfs.h |    2 ++
 kernel/cgroup.c        |   39 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 90 insertions(+), 1 deletion(-)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index 8eaf417..cc41fe1 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -62,6 +62,56 @@ struct kernfs_root *kernfs_root_from_sb(struct super_block *sb)
 	return NULL;
 }
 
+/**
+ * kernfs_obtain_root - get a dentry for the given kernfs_node
+ * @sb: the kernfs super_block
+ * @kn: kernfs_node for which a dentry is needed
+ *
+ * This can be used by callers which want to mount only a part of the kernfs
+ * as root of the filesystem.
+ */
+struct dentry *kernfs_obtain_root(struct super_block *sb,
+				  struct kernfs_node *kn)
+{
+	struct dentry *dentry;
+	struct inode *inode;
+
+	BUG_ON(sb->s_op != &kernfs_sops);
+
+	/* inode for the given kernfs_node should already exist. */
+	inode = kernfs_get_inode(sb, kn);
+	if (!inode) {
+		pr_debug("kernfs: could not get inode for '");
+		pr_cont_kernfs_path(kn);
+		pr_cont("'.\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	/* instantiate and link root dentry */
+	dentry = d_obtain_root(inode);
+	if (!dentry) {
+		pr_debug("kernfs: could not get dentry for '");
+		pr_cont_kernfs_path(kn);
+		pr_cont("'.\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/*
+	 * If this is a new dentry, set it up. We need kernfs_mutex because
+	 * this may be called by callers other than kernfs_fill_super.
+	 */
+	mutex_lock(&kernfs_mutex);
+	if (!dentry->d_fsdata) {
+		kernfs_get(kn);
+		dentry->d_fsdata = kn;
+	} else {
+		WARN_ON(dentry->d_fsdata != kn);
+	}
+	mutex_unlock(&kernfs_mutex);
+
+	return dentry;
+}
+
 static int kernfs_fill_super(struct super_block *sb, unsigned long magic)
 {
 	struct kernfs_super_info *info = kernfs_info(sb);
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index d025ebd..1903777 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -284,6 +284,8 @@ struct kernfs_node *kernfs_node_from_dentry(struct dentry *dentry);
 struct kernfs_root *kernfs_root_from_sb(struct super_block *sb);
 struct inode *kernfs_get_inode(struct super_block *sb, struct kernfs_node *kn);
 
+struct dentry *kernfs_obtain_root(struct super_block *sb,
+				  struct kernfs_node *kn);
 struct kernfs_root *kernfs_create_root(struct kernfs_syscall_ops *scops,
 				       unsigned int flags, void *priv);
 void kernfs_destroy_root(struct kernfs_root *root);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0afed6b..2f487a4 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2005,6 +2005,15 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	int ret;
 	int i;
 	bool new_sb;
+	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
+
+	get_cgroup_ns(ns);
+
+	/* Check if the caller has permission to mount. */
+	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN)) {
+		put_cgroup_ns(ns);
+		return ERR_PTR(-EPERM);
+	}
 
 	/*
 	 * The first time anyone tries to mount a cgroup, enable the list
@@ -2121,6 +2130,11 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		goto out_unlock;
 	}
 
+	if (!opts.none && !capable(CAP_SYS_ADMIN)) {
+		ret = -EPERM;
+		goto out_unlock;
+	}
+
 	root = kzalloc(sizeof(*root), GFP_KERNEL);
 	if (!root) {
 		ret = -ENOMEM;
@@ -2139,12 +2153,34 @@ out_free:
 	kfree(opts.release_agent);
 	kfree(opts.name);
 
-	if (ret)
+	if (ret) {
+		put_cgroup_ns(ns);
 		return ERR_PTR(ret);
+	}
+
 out_mount:
 	dentry = kernfs_mount(fs_type, flags, root->kf_root,
 			      is_v2 ? CGROUP2_SUPER_MAGIC : CGROUP_SUPER_MAGIC,
 			      &new_sb);
+
+	if (!IS_ERR(dentry)) {
+		/*
+		 * In non-init cgroup namespace, instead of root cgroup's
+		 * dentry, we return the dentry corresponding to the
+		 * cgroupns->root_cgrp.
+		 */
+		if (ns != &init_cgroup_ns) {
+			struct dentry *nsdentry;
+			struct cgroup *cgrp;
+
+			cgrp = cset_cgroup_from_root(ns->root_cset, root);
+			nsdentry = kernfs_obtain_root(dentry->d_sb,
+				cgrp->kn);
+			dput(dentry);
+			dentry = nsdentry;
+		}
+	}
+
 	if (IS_ERR(dentry) || !new_sb)
 		cgroup_put(&root->cgrp);
 
@@ -2157,6 +2193,7 @@ out_mount:
 		deactivate_super(pinned_sb);
 	}
 
+	put_cgroup_ns(ns);
 	return dentry;
 }
 
-- 
1.7.9.5
