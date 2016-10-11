From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v27 04/21] vfs: Add permission flags for setting file attributes
Date: Tue, 11 Oct 2016 14:50:39 +0200
Message-ID: <1476190256-1677-5-git-send-email-agruenba@redhat.com>
References: <1476190256-1677-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476190256-1677-1-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Richacls support permissions that allow to take ownership of a file,
change the file permissions, and set the file timestamps.  Support that
by introducing new permission mask flags and by checking for those mask
flags in setattr_prepare().

Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: J. Bruce Fields <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/attr.c          | 79 +++++++++++++++++++++++++++++++++++++++++++++---------
 include/linux/fs.h |  3 +++
 2 files changed, 70 insertions(+), 12 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index c902b3d..8fa9869 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -17,6 +17,65 @@
 #include <linux/ima.h>
 
 /**
+ * inode_extended_permission  -  permissions beyond read/write/execute
+ *
+ * Check for permissions that only richacls can currently grant.
+ */
+static int inode_extended_permission(struct inode *inode, int mask)
+{
+	if (!IS_RICHACL(inode))
+		return -EPERM;
+	return inode_permission(inode, mask);
+}
+
+static bool inode_uid_change_ok(struct inode *inode, kuid_t ia_uid)
+{
+	if (uid_eq(current_fsuid(), inode->i_uid) &&
+	    uid_eq(ia_uid, inode->i_uid))
+		return true;
+	if (uid_eq(current_fsuid(), ia_uid) &&
+	    inode_extended_permission(inode, MAY_TAKE_OWNERSHIP) == 0)
+		return true;
+	if (capable_wrt_inode_uidgid(inode, CAP_CHOWN))
+		return true;
+	return false;
+}
+
+static bool inode_gid_change_ok(struct inode *inode, kgid_t ia_gid)
+{
+	int in_group = in_group_p(ia_gid);
+	if (uid_eq(current_fsuid(), inode->i_uid) &&
+	    (in_group || gid_eq(ia_gid, inode->i_gid)))
+		return true;
+	if (in_group && inode_extended_permission(inode, MAY_TAKE_OWNERSHIP) == 0)
+		return true;
+	if (capable_wrt_inode_uidgid(inode, CAP_CHOWN))
+		return true;
+	return false;
+}
+
+/**
+ * inode_owner_permitted_or_capable
+ *
+ * Check for permissions implicitly granted to the owner, like MAY_CHMOD or
+ * MAY_SET_TIMES.  Equivalent to inode_owner_or_capable for file systems
+ * without support for those permissions.
+ */
+static bool inode_owner_permitted_or_capable(struct inode *inode, int mask)
+{
+	struct user_namespace *ns;
+
+	if (uid_eq(current_fsuid(), inode->i_uid))
+		return true;
+	if (inode_extended_permission(inode, mask) == 0)
+		return true;
+	ns = current_user_ns();
+	if (ns_capable(ns, CAP_FOWNER) && kuid_has_mapping(ns, inode->i_uid))
+		return true;
+	return false;
+}
+
+/**
  * setattr_prepare - check if attribute changes to a dentry are allowed
  * @dentry:	dentry to check
  * @attr:	attributes to change
@@ -50,22 +109,18 @@ int setattr_prepare(struct dentry *dentry, struct iattr *attr)
 		goto kill_priv;
 
 	/* Make sure a caller can chown. */
-	if ((ia_valid & ATTR_UID) &&
-	    (!uid_eq(current_fsuid(), inode->i_uid) ||
-	     !uid_eq(attr->ia_uid, inode->i_uid)) &&
-	    !capable_wrt_inode_uidgid(inode, CAP_CHOWN))
-		return -EPERM;
+	if (ia_valid & ATTR_UID)
+		if (!inode_uid_change_ok(inode, attr->ia_uid))
+			return -EPERM;
 
 	/* Make sure caller can chgrp. */
-	if ((ia_valid & ATTR_GID) &&
-	    (!uid_eq(current_fsuid(), inode->i_uid) ||
-	    (!in_group_p(attr->ia_gid) && !gid_eq(attr->ia_gid, inode->i_gid))) &&
-	    !capable_wrt_inode_uidgid(inode, CAP_CHOWN))
-		return -EPERM;
+	if (ia_valid & ATTR_GID)
+		if (!inode_gid_change_ok(inode, attr->ia_gid))
+			return -EPERM;
 
 	/* Make sure a caller can chmod. */
 	if (ia_valid & ATTR_MODE) {
-		if (!inode_owner_or_capable(inode))
+		if (!inode_owner_permitted_or_capable(inode, MAY_CHMOD))
 			return -EPERM;
 		/* Also check the setgid bit! */
 		if (!in_group_p((ia_valid & ATTR_GID) ? attr->ia_gid :
@@ -76,7 +131,7 @@ int setattr_prepare(struct dentry *dentry, struct iattr *attr)
 
 	/* Check for setting the inode time. */
 	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET | ATTR_TIMES_SET)) {
-		if (!inode_owner_or_capable(inode))
+		if (!inode_owner_permitted_or_capable(inode, MAY_SET_TIMES))
 			return -EPERM;
 	}
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1d6d920..8cc179d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -88,6 +88,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define MAY_CREATE_DIR		0x00000200
 #define MAY_DELETE_CHILD	0x00000400
 #define MAY_DELETE_SELF		0x00000800
+#define MAY_TAKE_OWNERSHIP	0x00001000
+#define MAY_CHMOD		0x00002000
+#define MAY_SET_TIMES		0x00004000
 
 /*
  * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
