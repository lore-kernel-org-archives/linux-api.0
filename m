From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v7 03/41] vfs: Add MAY_DELETE_SELF and MAY_DELETE_CHILD permission flags
Date: Sat,  5 Sep 2015 12:26:58 +0200
Message-ID: <1441448856-13478-4-git-send-email-agruenba@redhat.com>
References: <1441448856-13478-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441448856-13478-1-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Normally, deleting a file requires MAY_WRITE access to the parent
directory.  With richacls, a file may be deleted with MAY_DELETE_CHILD access
to the parent directory or with MAY_DELETE_SELF access to the file.

To support that, pass the MAY_DELETE_CHILD mask flag to inode_permission()
when checking for delete access inside a directory, and MAY_DELETE_SELF
when checking for delete access to a file itelf.

The MAY_DELETE_SELF permission does not override the sticky directory
check.  It probably should.

Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: J. Bruce Fields <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/namei.c         | 19 +++++++++++++------
 include/linux/fs.h |  2 ++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 428b4a6..d7bd134 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -453,9 +453,9 @@ static int sb_permission(struct super_block *sb, struct inode *inode, int mask)
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
@@ -2528,7 +2528,7 @@ static int may_delete(struct inode *dir, struct dentry *victim,
 		      bool isdir, bool replace)
 {
 	struct inode *inode = d_backing_inode(victim);
-	int error, mask = MAY_WRITE | MAY_EXEC;
+	int error, mask = MAY_EXEC;
 
 	if (d_is_negative(victim))
 		return -ENOENT;
@@ -2538,8 +2538,15 @@ static int may_delete(struct inode *dir, struct dentry *victim,
 	audit_inode_child(dir, victim, AUDIT_TYPE_CHILD_DELETE);
 
 	if (replace)
-		mask |= isdir ? MAY_CREATE_DIR : MAY_CREATE_FILE;
-	error = inode_permission(dir, mask);
+		mask |= MAY_WRITE | (isdir ? MAY_CREATE_DIR : MAY_CREATE_FILE);
+	error = inode_permission(dir, mask | MAY_WRITE | MAY_DELETE_CHILD);
+	if (error && IS_RICHACL(inode)) {
+		/* Deleting is also permitted with MAY_EXEC on the directory
+		 * and MAY_DELETE_SELF on the inode.  */
+		if (!inode_permission(inode, MAY_DELETE_SELF) &&
+		    !inode_permission(dir, mask))
+			error = 0;
+	}
 	if (error)
 		return error;
 	if (IS_APPEND(dir))
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e4d701c..8e130e1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -84,6 +84,8 @@ typedef void (dax_iodone_t)(struct buffer_head *bh_map, int uptodate);
 #define MAY_NOT_BLOCK		0x00000080
 #define MAY_CREATE_FILE		0x00000100
 #define MAY_CREATE_DIR		0x00000200
+#define MAY_DELETE_CHILD	0x00000400
+#define MAY_DELETE_SELF		0x00000800
 
 /*
  * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
-- 
2.4.3
