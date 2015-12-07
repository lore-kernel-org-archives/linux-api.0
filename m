From: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH 5/7] cgroup: mount cgroupns-root when inside non-init cgroupns
Date: Mon,  7 Dec 2015 17:06:20 -0600
Message-ID: <1449529582-4075-6-git-send-email-serge.hallyn@ubuntu.com>
References: <1449529582-4075-1-git-send-email-serge.hallyn@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1449529582-4075-1-git-send-email-serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
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
	20151207 - Switch to walking up the kernfs path from kn root.

Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 fs/kernfs/mount.c      |   74 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/kernfs.h |    2 ++
 kernel/cgroup.c        |   39 ++++++++++++++++++++++++-
 3 files changed, 114 insertions(+), 1 deletion(-)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index 8eaf417..9219444 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -14,6 +14,7 @@
 #include <linux/magic.h>
 #include <linux/slab.h>
 #include <linux/pagemap.h>
+#include <linux/namei.h>
 
 #include "kernfs-internal.h"
 
@@ -62,6 +63,79 @@ struct kernfs_root *kernfs_root_from_sb(struct super_block *sb)
 	return NULL;
 }
 
+/*
+ * find the next ancestor in the path down to @child, where @parent was the
+ * parent whose child we want to find.
+ *
+ * Say the path is /a/b/c/d.  @child is d, @parent is NULL.  We return the root
+ * node.  If @parent is b, then we return the node for c.
+ * Passing in d as @parent is not ok.
+ */
+static struct kernfs_node *
+find_next_ancestor(struct kernfs_node *child, struct kernfs_node *parent)
+{
+	if (child == parent) {
+		pr_crit_once("BUG in find_next_ancestor: called with parent == child");
+		return NULL;
+	}
+
+	while (child->parent != parent) {
+		if (!child->parent)
+			return NULL;
+		child = child->parent;
+	}
+
+	return child;
+}
+
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
+	struct kernfs_node *knparent = NULL;
+
+	BUG_ON(sb->s_op != &kernfs_sops);
+
+	dentry = dget(sb->s_root);
+	if (!kn->parent) // this is the root
+		return dentry;
+
+	knparent = find_next_ancestor(kn, NULL);
+	if (!knparent) {
+		pr_crit("BUG: find_next_ancestor for root dentry returned NULL\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	do {
+		struct dentry *dtmp;
+		struct kernfs_node *kntmp;
+
+		if (kn == knparent)
+			return dentry;
+		kntmp = find_next_ancestor(kn, knparent);
+		if (!kntmp) {
+			pr_crit("BUG: find_next_ancestor returned NULL for node\n");
+			return ERR_PTR(-EINVAL);
+		}
+		dtmp = lookup_one_len(kntmp->name, dentry, strlen(kntmp->name));
+		dput(dentry);
+		if (IS_ERR(dtmp))
+			return dtmp;
+		knparent = kntmp;
+		dentry = dtmp;
+	} while (1);
+
+	// notreached
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
index a5ab74d..09cd718 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2011,6 +2011,15 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
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
@@ -2127,6 +2136,11 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
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
@@ -2145,12 +2159,34 @@ out_free:
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
 
@@ -2163,6 +2199,7 @@ out_mount:
 		deactivate_super(pinned_sb);
 	}
 
+	put_cgroup_ns(ns);
 	return dentry;
 }
 
-- 
1.7.9.5
