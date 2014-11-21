From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
Subject: RFC: renameat(): Add a RENAME_REMOVE flag to unlink hardlinks
Date: Fri, 21 Nov 2014 14:17:37 +0000
Message-ID: <546F4981.8080907@draigBrady.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030709050308060007090807"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is a multi-part message in MIME format.
--------------030709050308060007090807
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

If 'a' and 'b' are hardlinks, then the command `mv a b & mv b a`
can result in both being removed as mv needs to emulate the
move with an unlink of the source file.  This can only be done
without races in the kernel and so mv was recently changed
to not allow this operation at all.  mv could safely reintroduce
this feature by leveraging a new flag for renameat() for which
an illustrative/untested patch is attached.

thanks,
Pádraig.

--------------030709050308060007090807
Content-Type: text/x-patch;
 name="renameat_REMOVE.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="renameat_REMOVE.patch"

>From 26d552617b00b3ffcd3b4646467cab5cb02f33ad Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?P=C3=A1draig=20Brady?= <P@draigBrady.com>
Date: Fri, 21 Nov 2014 14:09:54 +0000
Subject: [PATCH] renameat: Add RENAME_REMOVE flag to unlink source if hardlink
 to dest

This operation can't be done in userspace with unlink without races,
as overlapping rename operations could remove both hardlinks.
---
 Documentation/filesystems/vfs.txt |  1 +
 fs/namei.c                        | 11 +++++++----
 include/uapi/linux/fs.h           |  1 +
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 20bf204..2daa41a 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -430,6 +430,7 @@ otherwise noted.
 	(2) RENAME_EXCHANGE: exchange source and target.  Both must
 	exist; this is checked by the VFS.  Unlike plain rename,
 	source and target may be of different type.
+	(4) RENAME_REMOVE: unlink source even if a hardlink to dest.
 
   readlink: called by the readlink(2) system call. Only required if
 	you want to support reading symbolic links
diff --git a/fs/namei.c b/fs/namei.c
index db5fe86..caed596 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4074,8 +4074,10 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	bool new_is_dir = false;
 	unsigned max_links = new_dir->i_sb->s_max_links;
 
-	if (source == target)
-		return 0;
+	if (source == target) {
+		if (old_dentry == new_dentry || !(flags & RENAME_REMOVE))
+			return 0;
+        }
 
 	error = may_delete(old_dir, old_dentry, is_dir);
 	if (error)
@@ -4210,10 +4212,11 @@ SYSCALL_DEFINE5(renameat2, int, olddfd, const char __user *, oldname,
 	bool should_retry = false;
 	int error;
 
-	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
+	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE |
+		      RENAME_WHITEOUT | RENAME_REMOVE))
 		return -EINVAL;
 
-	if ((flags & (RENAME_NOREPLACE | RENAME_WHITEOUT)) &&
+	if ((flags & (RENAME_NOREPLACE | RENAME_WHITEOUT | RENAME_REMOVE)) &&
 	    (flags & RENAME_EXCHANGE))
 		return -EINVAL;
 
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 3735fa0..601d901 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -38,6 +38,7 @@
 #define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
 #define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
 #define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
+#define RENAME_REMOVE		(1 << 3)	/* Remove source hardlink */
 
 struct fstrim_range {
 	__u64 start;
-- 
2.1.0


--------------030709050308060007090807--
