From: Daniel Colascione <dancol@google.com>
Subject: [PATCH 1/7] Add a new flags-accepting interface for anonymous inodes
Date: Sat, 12 Oct 2019 12:15:56 -0700
Message-ID: <20191012191602.45649-2-dancol@google.com>
References: <20191012191602.45649-1-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191012191602.45649-1-dancol@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, lokeshgidra@google.com, dancol@google.com, nnk@google.com
Cc: nosh@google.com, timmurray@google.com
List-Id: linux-api@vger.kernel.org

Add functions forwarding from the old names to the new ones so we
don't need to change any callers.

Signed-off-by: Daniel Colascione <dancol@google.com>
---
 fs/anon_inodes.c            | 62 ++++++++++++++++++++++---------------
 include/linux/anon_inodes.h | 27 +++++++++++++---
 2 files changed, 59 insertions(+), 30 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 89714308c25b..caa36019afca 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -56,60 +56,71 @@ static struct file_system_type anon_inode_fs_type = {
 };
 
 /**
- * anon_inode_getfile - creates a new file instance by hooking it up to an
- *                      anonymous inode, and a dentry that describe the "class"
- *                      of the file
+ * anon_inode_getfile2 - creates a new file instance by hooking it up to
+ *                       an anonymous inode, and a dentry that describe
+ *                       the "class" of the file
  *
  * @name:    [in]    name of the "class" of the new file
  * @fops:    [in]    file operations for the new file
  * @priv:    [in]    private data for the new file (will be file's private_data)
- * @flags:   [in]    flags
+ * @flags:   [in]    flags for the file
+ * @anon_inode_flags: [in] flags for anon_inode*
  *
- * Creates a new file by hooking it on a single inode. This is useful for files
+ * Creates a new file by hooking it on an unspecified inode. This is useful for files
  * that do not need to have a full-fledged inode in order to operate correctly.
  * All the files created with anon_inode_getfile() will share a single inode,
  * hence saving memory and avoiding code duplication for the file/inode/dentry
  * setup.  Returns the newly created file* or an error pointer.
+ *
+ * anon_inode_flags must be zero.
  */
-struct file *anon_inode_getfile(const char *name,
-				const struct file_operations *fops,
-				void *priv, int flags)
+struct file *anon_inode_getfile2(const char *name,
+				 const struct file_operations *fops,
+				 void *priv, int flags, int anon_inode_flags)
 {
+	struct inode *inode;
 	struct file *file;
 
-	if (IS_ERR(anon_inode_inode))
-		return ERR_PTR(-ENODEV);
-
-	if (fops->owner && !try_module_get(fops->owner))
-		return ERR_PTR(-ENOENT);
+	if (anon_inode_flags)
+		return ERR_PTR(-EINVAL);
 
+	inode =	anon_inode_inode;
+	if (IS_ERR(inode))
+		return ERR_PTR(-ENODEV);
 	/*
-	 * We know the anon_inode inode count is always greater than zero,
-	 * so ihold() is safe.
+	 * We know the anon_inode inode count is always
+	 * greater than zero, so ihold() is safe.
 	 */
-	ihold(anon_inode_inode);
-	file = alloc_file_pseudo(anon_inode_inode, anon_inode_mnt, name,
+	ihold(inode);
+
+	if (fops->owner && !try_module_get(fops->owner)) {
+		file = ERR_PTR(-ENOENT);
+		goto err;
+	}
+
+	file = alloc_file_pseudo(inode, anon_inode_mnt, name,
 				 flags & (O_ACCMODE | O_NONBLOCK), fops);
 	if (IS_ERR(file))
 		goto err;
 
-	file->f_mapping = anon_inode_inode->i_mapping;
+	file->f_mapping = inode->i_mapping;
 
 	file->private_data = priv;
 
 	return file;
 
 err:
-	iput(anon_inode_inode);
+	iput(inode);
 	module_put(fops->owner);
 	return file;
 }
 EXPORT_SYMBOL_GPL(anon_inode_getfile);
+EXPORT_SYMBOL_GPL(anon_inode_getfile2);
 
 /**
- * anon_inode_getfd - creates a new file instance by hooking it up to an
- *                    anonymous inode, and a dentry that describe the "class"
- *                    of the file
+ * anon_inode_getfd2 - creates a new file instance by hooking it up to an
+ *                     anonymous inode, and a dentry that describe the "class"
+ *                     of the file
  *
  * @name:    [in]    name of the "class" of the new file
  * @fops:    [in]    file operations for the new file
@@ -122,8 +133,8 @@ EXPORT_SYMBOL_GPL(anon_inode_getfile);
  * hence saving memory and avoiding code duplication for the file/inode/dentry
  * setup.  Returns new descriptor or an error code.
  */
-int anon_inode_getfd(const char *name, const struct file_operations *fops,
-		     void *priv, int flags)
+int anon_inode_getfd2(const char *name, const struct file_operations *fops,
+		      void *priv, int flags, int anon_inode_flags)
 {
 	int error, fd;
 	struct file *file;
@@ -133,7 +144,7 @@ int anon_inode_getfd(const char *name, const struct file_operations *fops,
 		return error;
 	fd = error;
 
-	file = anon_inode_getfile(name, fops, priv, flags);
+	file = anon_inode_getfile2(name, fops, priv, flags, anon_inode_flags);
 	if (IS_ERR(file)) {
 		error = PTR_ERR(file);
 		goto err_put_unused_fd;
@@ -147,6 +158,7 @@ int anon_inode_getfd(const char *name, const struct file_operations *fops,
 	return error;
 }
 EXPORT_SYMBOL_GPL(anon_inode_getfd);
+EXPORT_SYMBOL_GPL(anon_inode_getfd2);
 
 static int __init anon_inode_init(void)
 {
diff --git a/include/linux/anon_inodes.h b/include/linux/anon_inodes.h
index d0d7d96261ad..10699462dcb1 100644
--- a/include/linux/anon_inodes.h
+++ b/include/linux/anon_inodes.h
@@ -11,11 +11,28 @@
 
 struct file_operations;
 
-struct file *anon_inode_getfile(const char *name,
-				const struct file_operations *fops,
-				void *priv, int flags);
-int anon_inode_getfd(const char *name, const struct file_operations *fops,
-		     void *priv, int flags);
+#define ANON_INODE_SECURE 1
+
+struct file *anon_inode_getfile2(const char *name,
+				 const struct file_operations *fops,
+				 void *priv, int flags, int anon_inode_flags);
+int anon_inode_getfd2(const char *name, const struct file_operations *fops,
+		      void *priv, int flags, int anon_inode_flags);
+
+static inline int anon_inode_getfd(const char *name,
+				   const struct file_operations *fops,
+				   void *priv, int flags)
+{
+	return anon_inode_getfd2(name, fops, priv, flags, 0);
+}
+
+static inline struct file *anon_inode_getfile(const char *name,
+					      const struct file_operations *fops,
+					      void *priv, int flags)
+{
+	return anon_inode_getfile2(name, fops, priv, flags, 0);
+}
+
 
 #endif /* _LINUX_ANON_INODES_H */
 
-- 
2.23.0.700.g56cf767bdb-goog
