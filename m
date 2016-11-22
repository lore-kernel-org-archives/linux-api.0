From: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC PATCH 2/3] vfs: add d_replace()
Date: Tue, 22 Nov 2016 00:25:02 -0800
Message-ID: <527297d2dae27845b3b7ba8ad6e81ef477fddee2.1479802448.git.osandov@fb.com>
References: <cover.1479802448.git.osandov@fb.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1479802448.git.osandov-b10kYP2dOMg@public.gmane.org>
In-Reply-To: <cover.1479802448.git.osandov-b10kYP2dOMg@public.gmane.org>
References: <cover.1479802448.git.osandov-b10kYP2dOMg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>

Changes the inode associated with a dentry. This'll be useful for
implementations of linkat() AT_REPLACE.

Signed-off-by: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>
---
 fs/dcache.c            | 68 +++++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/dcache.h |  1 +
 2 files changed, 63 insertions(+), 6 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 5c7cc95..aaa2b16 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -316,6 +316,16 @@ static void dentry_free(struct dentry *dentry)
 		call_rcu(&dentry->d_u.d_rcu, __d_free);
 }
 
+static void dentry_iput(struct dentry *dentry, struct inode *inode)
+{
+	if (!inode->i_nlink)
+		fsnotify_inoderemove(inode);
+	if (dentry->d_op && dentry->d_op->d_iput)
+		dentry->d_op->d_iput(dentry, inode);
+	else
+		iput(inode);
+}
+
 /*
  * Release the dentry's inode, using the filesystem
  * d_iput() operation if defined.
@@ -335,12 +345,7 @@ static void dentry_unlink_inode(struct dentry * dentry)
 		raw_write_seqcount_end(&dentry->d_seq);
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&inode->i_lock);
-	if (!inode->i_nlink)
-		fsnotify_inoderemove(inode);
-	if (dentry->d_op && dentry->d_op->d_iput)
-		dentry->d_op->d_iput(dentry, inode);
-	else
-		iput(inode);
+	dentry_iput(dentry, inode);
 }
 
 /*
@@ -1816,6 +1821,24 @@ void d_instantiate(struct dentry *entry, struct inode * inode)
 }
 EXPORT_SYMBOL(d_instantiate);
 
+static void lock_two_inodes(struct inode *inode1, struct inode *inode2)
+{
+	if (inode1 > inode2)
+		swap(inode1, inode2);
+	if (inode1)
+		spin_lock(&inode1->i_lock);
+	if (inode2)
+		spin_lock(&inode2->i_lock);
+}
+
+static void unlock_two_inodes(struct inode *inode1, struct inode *inode2)
+{
+	if (inode1)
+		spin_unlock(&inode1->i_lock);
+	if (inode2)
+		spin_unlock(&inode2->i_lock);
+}
+
 /**
  * d_instantiate_no_diralias - instantiate a non-aliased dentry
  * @entry: dentry to complete
@@ -2339,6 +2362,39 @@ void d_delete(struct dentry * dentry)
 }
 EXPORT_SYMBOL(d_delete);
 
+/**
+ * d_replace - change the inode a dentry is associated with
+ * @dentry: dentry to modify
+ * @inode: inode to attach to this dentry
+ *
+ * Fill in new inode information in a dentry that may have previously been
+ * instantiated. This handles both negative and positive dentries.
+ */
+void d_replace(struct dentry *dentry, struct inode *inode)
+{
+	struct inode *old_inode = dentry->d_inode;
+	unsigned int add_flags;
+
+	lock_two_inodes(old_inode, inode);
+	spin_lock(&dentry->d_lock);
+	add_flags = d_flags_for_inode(inode);
+
+	if (old_inode)
+		hlist_del(&dentry->d_u.d_alias);
+	hlist_add_head(&dentry->d_u.d_alias, &inode->i_dentry);
+
+	raw_write_seqcount_begin(&dentry->d_seq);
+	__d_set_inode_and_type(dentry, inode, add_flags);
+	raw_write_seqcount_end(&dentry->d_seq);
+	fsnotify_update_flags(dentry);
+
+	spin_unlock(&dentry->d_lock);
+	unlock_two_inodes(old_inode, inode);
+	if (old_inode)
+		dentry_iput(dentry, old_inode);
+}
+EXPORT_SYMBOL(d_replace);
+
 static void __d_rehash(struct dentry *entry)
 {
 	struct hlist_bl_head *b = d_hash(entry->d_name.hash);
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 5beed7b..0610bb0 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -224,6 +224,7 @@ extern int d_instantiate_no_diralias(struct dentry *, struct inode *);
 extern void __d_drop(struct dentry *dentry);
 extern void d_drop(struct dentry *dentry);
 extern void d_delete(struct dentry *);
+extern void d_replace(struct dentry *, struct inode *);
 extern void d_set_d_op(struct dentry *dentry, const struct dentry_operations *op);
 
 /* allocate/de-allocate */
-- 
2.10.2
