From: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH 5/8] kernfs: define kernfs_node_dentry
Date: Mon,  4 Jan 2016 13:54:50 -0600
Message-ID: <1451937294-22589-6-git-send-email-serge.hallyn@ubuntu.com>
References: <1451937294-22589-1-git-send-email-serge.hallyn@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1451937294-22589-1-git-send-email-serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
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

Add a new kernfs api is added to lookup the dentry for a particular
kernfs path.

Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Serge E. Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
---
Changelog:
	20151116 - Don't allow user namespaces to bind new subsystems
	20151118 - postpone the FS_USERNS_MOUNT flag until the
	           last patch, until we can convince ourselves it
		   is safe.
	20151207 - Switch to walking up the kernfs path from kn root.
	20151208 - Split out the kernfs change
		 - Style changes
		 - Switch from pr_crit to WARN_ON
		 - Reorder arguments to kernfs_obtain_root
		 - rename kernfs_obtain_root to kernfs_node_dentry
---
 fs/kernfs/mount.c      |   67 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/kernfs.h |    2 ++
 2 files changed, 69 insertions(+)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index 8eaf417..7224296 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -14,6 +14,7 @@
 #include <linux/magic.h>
 #include <linux/slab.h>
 #include <linux/pagemap.h>
+#include <linux/namei.h>
 
 #include "kernfs-internal.h"
 
@@ -62,6 +63,72 @@ struct kernfs_root *kernfs_root_from_sb(struct super_block *sb)
 	return NULL;
 }
 
+/*
+ * find the next ancestor in the path down to @child, where @parent was the
+ * ancestor whose descendant we want to find.
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
+ * kernfs_node_dentry - get a dentry for the given kernfs_node
+ * @kn: kernfs_node for which a dentry is needed
+ * @sb: the kernfs super_block
+ */
+struct dentry *kernfs_node_dentry(struct kernfs_node *kn,
+				  struct super_block *sb)
+{
+	struct dentry *dentry;
+	struct kernfs_node *knparent = NULL;
+
+	BUG_ON(sb->s_op != &kernfs_sops);
+
+	dentry = dget(sb->s_root);
+
+	/* Check if this is the root kernfs_node */
+	if (!kn->parent)
+		return dentry;
+
+	knparent = find_next_ancestor(kn, NULL);
+	if (WARN_ON(!knparent))
+		return ERR_PTR(-EINVAL);
+
+	do {
+		struct dentry *dtmp;
+		struct kernfs_node *kntmp;
+
+		if (kn == knparent)
+			return dentry;
+		kntmp = find_next_ancestor(kn, knparent);
+		if (WARN_ON(!kntmp))
+			return ERR_PTR(-EINVAL);
+		dtmp = lookup_one_len(kntmp->name, dentry, strlen(kntmp->name));
+		dput(dentry);
+		if (IS_ERR(dtmp))
+			return dtmp;
+		knparent = kntmp;
+		dentry = dtmp;
+	} while (1);
+}
+
 static int kernfs_fill_super(struct super_block *sb, unsigned long magic)
 {
 	struct kernfs_super_info *info = kernfs_info(sb);
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 716bfde..c06c442 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -284,6 +284,8 @@ struct kernfs_node *kernfs_node_from_dentry(struct dentry *dentry);
 struct kernfs_root *kernfs_root_from_sb(struct super_block *sb);
 struct inode *kernfs_get_inode(struct super_block *sb, struct kernfs_node *kn);
 
+struct dentry *kernfs_node_dentry(struct kernfs_node *kn,
+				  struct super_block *sb);
 struct kernfs_root *kernfs_create_root(struct kernfs_syscall_ops *scops,
 				       unsigned int flags, void *priv);
 void kernfs_destroy_root(struct kernfs_root *root);
-- 
1.7.9.5
