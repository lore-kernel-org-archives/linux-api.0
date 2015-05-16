From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [CFT][PATCH 07/10] kernfs: Add support for always empty directories.
Date: Fri, 15 May 2015 21:09:24 -0500
Message-ID: <87mw15tgrv.fsf_-_@x220.int.ebiederm.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
	<87siaxuvik.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87siaxuvik.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org> (Eric W. Biederman's
	message of "Fri, 15 May 2015 21:05:39 -0500")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Add a new function kernfs_create_empty_dir that can be used to create
directory that can not be modified.

Update the code to use make_empty_dir_inode when reporting a
permanently empty directory to the vfs.

Update the code to not allow adding to permanently empty directories.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 fs/kernfs/dir.c        | 38 +++++++++++++++++++++++++++++++++++++-
 fs/kernfs/inode.c      |  2 ++
 include/linux/kernfs.h |  3 +++
 3 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index f131fc23ffc4..47dc636d80ed 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -585,6 +585,9 @@ int kernfs_add_one(struct kernfs_node *kn)
 		goto out_unlock;
 
 	ret = -ENOENT;
+	if (parent->flags & KERNFS_EMPTY_DIR)
+		goto out_unlock;
+
 	if ((parent->flags & KERNFS_ACTIVATED) && !kernfs_active(parent))
 		goto out_unlock;
 
@@ -776,6 +779,38 @@ struct kernfs_node *kernfs_create_dir_ns(struct kernfs_node *parent,
 	return ERR_PTR(rc);
 }
 
+/**
+ * kernfs_create_empty_dir - create an always empty directory
+ * @parent: parent in which to create a new directory
+ * @name: name of the new directory
+ *
+ * Returns the created node on success, ERR_PTR() value on failure.
+ */
+struct kernfs_node *kernfs_create_empty_dir(struct kernfs_node *parent,
+					    const char *name)
+{
+	struct kernfs_node *kn;
+	int rc;
+
+	/* allocate */
+	kn = kernfs_new_node(parent, name, S_IRUGO|S_IXUGO|S_IFDIR, KERNFS_DIR);
+	if (!kn)
+		return ERR_PTR(-ENOMEM);
+
+	kn->flags |= KERNFS_EMPTY_DIR;
+	kn->dir.root = parent->dir.root;
+	kn->ns = NULL;
+	kn->priv = NULL;
+
+	/* link in */
+	rc = kernfs_add_one(kn);
+	if (!rc)
+		return kn;
+
+	kernfs_put(kn);
+	return ERR_PTR(rc);
+}
+
 static struct dentry *kernfs_iop_lookup(struct inode *dir,
 					struct dentry *dentry,
 					unsigned int flags)
@@ -1247,7 +1282,8 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 	mutex_lock(&kernfs_mutex);
 
 	error = -ENOENT;
-	if (!kernfs_active(kn) || !kernfs_active(new_parent))
+	if (!kernfs_active(kn) || !kernfs_active(new_parent) ||
+	    (new_parent->flags & KERNFS_EMPTY_DIR))
 		goto out;
 
 	error = 0;
diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index 2da8493a380b..756dd56aaf60 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -296,6 +296,8 @@ static void kernfs_init_inode(struct kernfs_node *kn, struct inode *inode)
 	case KERNFS_DIR:
 		inode->i_op = &kernfs_dir_iops;
 		inode->i_fop = &kernfs_dir_fops;
+		if (kn->flags & KERNFS_EMPTY_DIR)
+			make_empty_dir_inode(inode);
 		break;
 	case KERNFS_FILE:
 		inode->i_size = kn->attr.size;
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 71ecdab1671b..29d1896c3ba5 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -45,6 +45,7 @@ enum kernfs_node_flag {
 	KERNFS_LOCKDEP		= 0x0100,
 	KERNFS_SUICIDAL		= 0x0400,
 	KERNFS_SUICIDED		= 0x0800,
+	KERNFS_EMPTY_DIR	= 0x1000,
 };
 
 /* @flags for kernfs_create_root() */
@@ -285,6 +286,8 @@ void kernfs_destroy_root(struct kernfs_root *root);
 struct kernfs_node *kernfs_create_dir_ns(struct kernfs_node *parent,
 					 const char *name, umode_t mode,
 					 void *priv, const void *ns);
+struct kernfs_node *kernfs_create_empty_dir(struct kernfs_node *parent,
+					    const char *name);
 struct kernfs_node *__kernfs_create_file(struct kernfs_node *parent,
 					 const char *name,
 					 umode_t mode, loff_t size,
-- 
2.2.1
