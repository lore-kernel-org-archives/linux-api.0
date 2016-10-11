From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v27 03/21] vfs: Add MAY_DELETE_SELF and MAY_DELETE_CHILD permission flags
Date: Tue, 11 Oct 2016 14:50:38 +0200
Message-ID: <1476190256-1677-4-git-send-email-agruenba@redhat.com>
References: <1476190256-1677-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476190256-1677-1-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Normally, deleting a file requires MAY_WRITE access to the parent
directory.  With richacls, a file may be deleted with MAY_DELETE_CHILD access
to the parent directory or with MAY_DELETE_SELF access to the file.

To support that, pass the MAY_DELETE_CHILD mask flag to inode_permission()
when checking for delete access inside a directory, and MAY_DELETE_SELF
when checking for delete access to a file itself.

The MAY_DELETE_SELF permission overrides the sticky directory check.

Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: J. Bruce Fields <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/namei.c         | 20 +++++++++++++-------
 include/linux/fs.h |  2 ++
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 7290dea..c8bc9fd 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -463,9 +463,9 @@ static int sb_permission(struct super_block *sb, struct inode *inode, int mask)
  * this, letting us set arbitrary permissions for filesystem access without
  * changing the "normal" UIDs which are used for other things.
  *
- * MAY_WRITE must be set in @mask whenever MAY_APPEND, MAY_CREATE_FILE, or
- * MAY_CREATE_DIR are set.  That way, file systems that don't support these
- * permissions will check for MAY_WRITE instead.
+ * MAY_WRITE must be set in @mask whenever MAY_APPEND, MAY_CREATE_FILE,
+ * MAY_CREATE_DIR, or MAY_DELETE_CHILD are set.  That way, file systems that
+ * don't support these permissions will check for MAY_WRITE instead.
  */
 int inode_permission(struct inode *inode, int mask)
 {
@@ -2780,14 +2780,20 @@ static int may_delete_or_replace(struct inode *dir, struct dentry *victim,
 	BUG_ON(victim->d_parent->d_inode != dir);
 	audit_inode_child(dir, victim, AUDIT_TYPE_CHILD_DELETE);
 
-	error = inode_permission(dir, mask);
+	error = inode_permission(dir, mask | MAY_WRITE | MAY_DELETE_CHILD);
+	if (!error && check_sticky(dir, inode))
+		error = -EPERM;
+	if (error && IS_RICHACL(inode) &&
+	    inode_permission(inode, MAY_DELETE_SELF) == 0 &&
+	    inode_permission(dir, mask) == 0)
+		error = 0;
 	if (error)
 		return error;
 	if (IS_APPEND(dir))
 		return -EPERM;
 
-	if (check_sticky(dir, inode) || IS_APPEND(inode) ||
-	    IS_IMMUTABLE(inode) || IS_SWAPFILE(inode) || HAS_UNMAPPED_ID(inode))
+	if (IS_APPEND(inode) || IS_IMMUTABLE(inode) ||
+	    IS_SWAPFILE(inode) || HAS_UNMAPPED_ID(inode))
 		return -EPERM;
 	if (isdir) {
 		if (!d_is_dir(victim))
@@ -2805,7 +2811,7 @@ static int may_delete_or_replace(struct inode *dir, struct dentry *victim,
 
 static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
 {
-	return may_delete_or_replace(dir, victim, isdir, MAY_WRITE | MAY_EXEC);
+	return may_delete_or_replace(dir, victim, isdir, MAY_EXEC);
 }
 
 static int may_replace(struct inode *dir, struct dentry *victim, bool isdir)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 26455c6..1d6d920 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -86,6 +86,8 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define MAY_NOT_BLOCK		0x00000080
 #define MAY_CREATE_FILE		0x00000100
 #define MAY_CREATE_DIR		0x00000200
+#define MAY_DELETE_CHILD	0x00000400
+#define MAY_DELETE_SELF		0x00000800
 
 /*
  * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
