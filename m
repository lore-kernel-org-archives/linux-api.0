From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v4 08/16] fs-verity: add the hook for file
 ->setattr()
Date: Thu,  6 Jun 2019 08:51:57 -0700
Message-ID: <20190606155205.2872-9-ebiggers@kernel.org>
References: <20190606155205.2872-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190606155205.2872-1-ebiggers@kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-fscrypt@vger.kernel.org
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, linux-integrity@vger.kernel.org, linux-ext4@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Victor Hsieh <victorhsieh@google.com>
List-Id: linux-api@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a function fsverity_prepare_setattr() which filesystems that support
fs-verity must call to deny truncates of verity files.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/verity/open.c         | 21 +++++++++++++++++++++
 include/linux/fsverity.h |  7 +++++++
 2 files changed, 28 insertions(+)

diff --git a/fs/verity/open.c b/fs/verity/open.c
index a8a1261f0e30..91f7e2d05b54 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -302,6 +302,27 @@ int fsverity_file_open(struct inode *inode, struct file *filp)
 }
 EXPORT_SYMBOL_GPL(fsverity_file_open);
 
+/**
+ * fsverity_prepare_setattr - prepare to change a verity inode's attributes
+ * @dentry: dentry through which the inode is being changed
+ * @attr: attributes to change
+ *
+ * Verity files are immutable, so deny truncates.  This isn't covered by the
+ * open-time check because sys_truncate() takes a path, not a file descriptor.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	if (IS_VERITY(d_inode(dentry)) && (attr->ia_valid & ATTR_SIZE)) {
+		pr_debug("Denying truncate of verity file (ino %lu)\n",
+			 d_inode(dentry)->i_ino);
+		return -EPERM;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fsverity_prepare_setattr);
+
 /**
  * fsverity_cleanup_inode - free the inode's verity info, if present
  *
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 1372c236c877..cbcc358d0736 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -46,6 +46,7 @@ static inline struct fsverity_info *fsverity_get_info(const struct inode *inode)
 /* open.c */
 
 extern int fsverity_file_open(struct inode *inode, struct file *filp);
+extern int fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr);
 extern void fsverity_cleanup_inode(struct inode *inode);
 
 #else /* !CONFIG_FS_VERITY */
@@ -62,6 +63,12 @@ static inline int fsverity_file_open(struct inode *inode, struct file *filp)
 	return IS_VERITY(inode) ? -EOPNOTSUPP : 0;
 }
 
+static inline int fsverity_prepare_setattr(struct dentry *dentry,
+					   struct iattr *attr)
+{
+	return IS_VERITY(d_inode(dentry)) ? -EOPNOTSUPP : 0;
+}
+
 static inline void fsverity_cleanup_inode(struct inode *inode)
 {
 }
-- 
2.21.0
