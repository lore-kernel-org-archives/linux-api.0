From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v18 19/22] richacl: Add richacl xattr handler
Date: Mon, 29 Feb 2016 09:17:24 +0100
Message-ID: <1456733847-17982-20-git-send-email-agruenba@redhat.com>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456733847-17982-1-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Add richacl xattr handler implementing the xattr operations based on the
get_richacl and set_richacl inode operations.

Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/richacl_xattr.c            | 73 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/richacl_xattr.h |  2 ++
 2 files changed, 75 insertions(+)

diff --git a/fs/richacl_xattr.c b/fs/richacl_xattr.c
index a273139..afa2859 100644
--- a/fs/richacl_xattr.c
+++ b/fs/richacl_xattr.c
@@ -18,7 +18,9 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/xattr.h>
 #include <linux/richacl_xattr.h>
+#include <uapi/linux/xattr.h>
 
 MODULE_LICENSE("GPL");
 
@@ -160,3 +162,74 @@ richacl_to_xattr(struct user_namespace *user_ns,
 	return real_size;
 }
 EXPORT_SYMBOL_GPL(richacl_to_xattr);
+
+static bool
+richacl_xattr_list(struct dentry *dentry)
+{
+	return IS_RICHACL(d_backing_inode(dentry));
+}
+
+static int
+richacl_xattr_get(const struct xattr_handler *handler,
+		  struct dentry *dentry, const char *name, void *buffer,
+		  size_t buffer_size)
+{
+	struct inode *inode = d_backing_inode(dentry);
+	struct richacl *acl;
+	int error;
+
+	if (*name)
+		return -EINVAL;
+	if (!IS_RICHACL(inode))
+		return -EOPNOTSUPP;
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+	acl = get_richacl(inode);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl == NULL)
+		return -ENODATA;
+	error = richacl_to_xattr(current_user_ns(), acl, buffer, buffer_size);
+	richacl_put(acl);
+	return error;
+}
+
+static int
+richacl_xattr_set(const struct xattr_handler *handler,
+		  struct dentry *dentry, const char *name,
+		  const void *value, size_t size, int flags)
+{
+	struct inode *inode = d_backing_inode(dentry);
+	struct richacl *acl = NULL;
+	int ret;
+
+	if (*name)
+		return -EINVAL;
+	if (!IS_RICHACL(inode))
+		return -EOPNOTSUPP;
+	if (!inode->i_op->set_richacl)
+		return -EOPNOTSUPP;
+
+	if (!uid_eq(current_fsuid(), inode->i_uid) &&
+	    inode_permission(inode, MAY_CHMOD) &&
+	    !capable(CAP_FOWNER))
+		return -EPERM;
+
+	if (value) {
+		acl = richacl_from_xattr(current_user_ns(), value, size);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+	}
+
+	ret = inode->i_op->set_richacl(inode, acl);
+	richacl_put(acl);
+	return ret;
+}
+
+struct xattr_handler richacl_xattr_handler = {
+	.name = XATTR_NAME_RICHACL,
+	.list = richacl_xattr_list,
+	.get = richacl_xattr_get,
+	.set = richacl_xattr_set,
+};
+EXPORT_SYMBOL(richacl_xattr_handler);
diff --git a/include/linux/richacl_xattr.h b/include/linux/richacl_xattr.h
index ab67af2..ad4a56e 100644
--- a/include/linux/richacl_xattr.h
+++ b/include/linux/richacl_xattr.h
@@ -26,4 +26,6 @@ extern size_t richacl_xattr_size(const struct richacl *);
 extern int richacl_to_xattr(struct user_namespace *, const struct richacl *,
 			    void *, size_t);
 
+extern struct xattr_handler richacl_xattr_handler;
+
 #endif /* __RICHACL_XATTR_H */
-- 
2.4.3
