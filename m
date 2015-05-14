From: ebiederm@xmission.com (Eric W. Biederman)
Subject: [CFT][PATCH 04/10] fs: Add helper functions for permanently empty directories.
Date: Thu, 14 May 2015 12:33:09 -0500
Message-ID: <87382zjc8a.fsf@x220.int.ebiederm.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87pp63jcca.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Thu, 14 May 2015 12:30:45 -0500")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, =?utf-8?Q?St=C3=A9phane?= Graber <stgraber@ubuntu.com>, Eric Windisch <ewindisch@docker.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org


To ensure it is safe to mount proc and sysfs I need to check if
filesystems that are mounted on top of them are mounted on truly empty
directories.  Given that some directories can gain entries over time,
knowing that a directory is empty right now is insufficient.

Therefore add supporting infrastructure for permantently empty
directories that proc and sysfs can use when they create mount points
for filesystems and fs_fully_visible can use to test for permanently
empty directories to ensure that nothing will be gained by mounting a
fresh copy of proc or sysfs.

Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/libfs.c         | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |  2 ++
 2 files changed, 98 insertions(+)

diff --git a/fs/libfs.c b/fs/libfs.c
index cb1fb4b9b637..02813592e121 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1093,3 +1093,99 @@ simple_nosetlease(struct file *filp, long arg, struct file_lock **flp,
 	return -EINVAL;
 }
 EXPORT_SYMBOL(simple_nosetlease);
+
+
+/*
+ * Operations for a permanently empty directory.
+ */
+static struct dentry *empty_dir_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
+{
+	return ERR_PTR(-ENOENT);
+}
+
+static int empty_dir_getattr(struct vfsmount *mnt, struct dentry *dentry,
+				 struct kstat *stat)
+{
+	struct inode *inode = d_inode(dentry);
+	generic_fillattr(inode, stat);
+	return 0;
+}
+
+static int empty_dir_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	return -EPERM;
+}
+
+static int empty_dir_setxattr(struct dentry *dentry, const char *name,
+			      const void *value, size_t size, int flags)
+{
+	return -EOPNOTSUPP;
+}
+
+static ssize_t empty_dir_getxattr(struct dentry *dentry, const char *name,
+				  void *value, size_t size)
+{
+	return -EOPNOTSUPP;
+}
+
+static int empty_dir_removexattr(struct dentry *dentry, const char *name)
+{
+	return -EOPNOTSUPP;
+}
+
+static ssize_t empty_dir_listxattr(struct dentry *dentry, char *list, size_t size)
+{
+	return -EOPNOTSUPP;
+}
+
+static const struct inode_operations empty_dir_inode_operations = {
+	.lookup		= empty_dir_lookup,
+	.permission	= generic_permission,
+	.setattr	= empty_dir_setattr,
+	.getattr	= empty_dir_getattr,
+	.setxattr	= empty_dir_setxattr,
+	.getxattr	= empty_dir_getxattr,
+	.removexattr	= empty_dir_removexattr,
+	.listxattr	= empty_dir_listxattr,
+};
+
+static loff_t empty_dir_llseek(struct file *file, loff_t offset, int whence)
+{
+	/* An empty directory has two entries . and .. at offsets 0 and 1 */
+	return generic_file_llseek_size(file, offset, whence, 2, 2);
+}
+
+static int empty_dir_readdir(struct file *file, struct dir_context *ctx)
+{
+	dir_emit_dots(file, ctx);
+	return 0;
+}
+
+static const struct file_operations empty_dir_operations = {
+	.llseek		= empty_dir_llseek,
+	.read		= generic_read_dir,
+	.iterate	= empty_dir_readdir,
+	.fsync		= noop_fsync,
+};
+
+
+void make_empty_dir_inode(struct inode *inode)
+{
+	set_nlink(inode, 2);
+	inode->i_mode = S_IFDIR | S_IRUGO | S_IXUGO;
+	inode->i_uid = GLOBAL_ROOT_UID;
+	inode->i_gid = GLOBAL_ROOT_GID;
+	inode->i_rdev = 0;
+	inode->i_size = 2;
+	inode->i_blkbits = PAGE_SHIFT;
+	inode->i_blocks = 0;
+
+	inode->i_op = &empty_dir_inode_operations;
+	inode->i_fop = &empty_dir_operations;
+}
+
+bool is_empty_dir_inode(struct inode *inode)
+{
+	return (inode->i_fop == &empty_dir_operations) &&
+		(inode->i_op == &empty_dir_inode_operations);
+}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2d24eeb8e59c..571aab91bfc0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2780,6 +2780,8 @@ extern struct dentry *simple_lookup(struct inode *, struct dentry *, unsigned in
 extern ssize_t generic_read_dir(struct file *, char __user *, size_t, loff_t *);
 extern const struct file_operations simple_dir_operations;
 extern const struct inode_operations simple_dir_inode_operations;
+extern void make_empty_dir_inode(struct inode *inode);
+extern bool is_empty_dir_inode(struct inode *inode);
 struct tree_descr { char *name; const struct file_operations *ops; int mode; };
 struct dentry *d_alloc_name(struct dentry *, const char *);
 extern int simple_fill_super(struct super_block *, unsigned long, struct tree_descr *);
-- 
2.2.1

