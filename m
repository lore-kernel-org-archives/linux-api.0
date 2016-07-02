From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH review 06/11] vfs: Don't modify inodes with a uid or gid unknown to the vfs
Date: Sat,  2 Jul 2016 12:20:30 -0500
Message-ID: <20160702172035.19568-6-ebiederm@xmission.com>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
 <20160702172035.19568-1-ebiederm@xmission.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160702172035.19568-1-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

When a filesystem outside of init_user_ns is mounted it could have
uids and gids stored in it that do not map to init_user_ns.

The plan is to allow those filesystems to set i_uid to INVALID_UID and
i_gid to INVALID_GID for unmapped uids and gids and then to handle
that strange case in the vfs to ensure there is consistent robust
handling of the weirdness.

Upon a careful review of the vfs and filesystems about the only case
where there is any possibility of confusion or trouble is when the
inode is written back to disk.  In that case filesystems typically
read the inode->i_uid and inode->i_gid and write them to disk even
when just an inode timestamp is being updated.

Which leads to a rule that is very simple to implement and understand
inodes whose i_uid or i_gid is not valid may not be written.

In dealing with access times this means treat those inodes as if the
inode flag S_NOATIME was set.  Reads of the inodes appear safe and
useful, but any write or modification is disallowed.  The only inode
write that is allowed is a chown that sets the uid and gid on the
inode to valid values.  After such a chown the inode is normal and may
be treated as such.

Denying all writes to inodes with uids or gids unknown to the vfs also
prevents several oddball cases where corruption would have occurred
because the vfs does not have complete information.

One problem case that is prevented is attempting to use the gid of a
directory for new inodes where the directories sgid bit is set but the
directories gid is not mapped.

Another problem case avoided is attempting to update the evm hash
after setxattr, removexattr, and setattr.  As the evm hash includeds
the inode->i_uid or inode->i_gid not knowning the uid or gid prevents
a correct evm hash from being computed.  evm hash verification also
fails when i_uid or i_gid is unknown but that is essentially harmless
as it does not cause filesystem corruption.

Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 fs/attr.c          |  8 ++++++++
 fs/inode.c         |  7 +++++++
 fs/namei.c         | 26 +++++++++++++++++++++-----
 fs/xattr.c         |  7 +++++++
 include/linux/fs.h |  5 +++++
 5 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index dd723578ddce..42bb42bb3c72 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -266,6 +266,14 @@ int notify_change(struct dentry * dentry, struct iattr * attr, struct inode **de
 	    !kgid_has_mapping(inode->i_sb->s_user_ns, attr->ia_gid))
 		return -EOVERFLOW;
 
+	/* Don't allow modifications of files with invalid uids or
+	 * gids unless those uids & gids are being made valid.
+	 */
+	if (!(ia_valid & ATTR_UID) && !uid_valid(inode->i_uid))
+		return -EOVERFLOW;
+	if (!(ia_valid & ATTR_GID) && !gid_valid(inode->i_gid))
+		return -EOVERFLOW;
+
 	error = security_inode_setattr(dentry, attr);
 	if (error)
 		return error;
diff --git a/fs/inode.c b/fs/inode.c
index 4ccbc21b30ce..c0ebb97fb085 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1617,6 +1617,13 @@ bool atime_needs_update(const struct path *path, struct inode *inode)
 
 	if (inode->i_flags & S_NOATIME)
 		return false;
+
+	/* Atime updates will likely cause i_uid and i_gid to be written
+	 * back improprely if their true value is unknown to the vfs.
+	 */
+	if (HAS_UNMAPPED_ID(inode))
+		return false;
+
 	if (IS_NOATIME(inode))
 		return false;
 	if ((inode->i_sb->s_flags & MS_NODIRATIME) && S_ISDIR(inode->i_mode))
diff --git a/fs/namei.c b/fs/namei.c
index 8701bd9a5270..840201c4c290 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -410,6 +410,14 @@ int __inode_permission(struct inode *inode, int mask)
 		 */
 		if (IS_IMMUTABLE(inode))
 			return -EACCES;
+
+		/*
+		 * Updating mtime will likely cause i_uid and i_gid to be
+		 * written back improperly if their true value is unknown
+		 * to the vfs.
+		 */
+		if (HAS_UNMAPPED_ID(inode))
+			return -EACCES;
 	}
 
 	retval = do_inode_permission(inode, mask);
@@ -2759,10 +2767,11 @@ EXPORT_SYMBOL(__check_sticky);
  *	c. have CAP_FOWNER capability
  *  6. If the victim is append-only or immutable we can't do antyhing with
  *     links pointing to it.
- *  7. If we were asked to remove a directory and victim isn't one - ENOTDIR.
- *  8. If we were asked to remove a non-directory and victim isn't one - EISDIR.
- *  9. We can't remove a root or mountpoint.
- * 10. We don't allow removal of NFS sillyrenamed files; it's handled by
+ *  7. If the victim has an unknown uid or gid we can't change the inode.
+ *  8. If we were asked to remove a directory and victim isn't one - ENOTDIR.
+ *  9. If we were asked to remove a non-directory and victim isn't one - EISDIR.
+ * 10. We can't remove a root or mountpoint.
+ * 11. We don't allow removal of NFS sillyrenamed files; it's handled by
  *     nfs_async_unlink().
  */
 static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
@@ -2784,7 +2793,7 @@ static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
 		return -EPERM;
 
 	if (check_sticky(dir, inode) || IS_APPEND(inode) ||
-	    IS_IMMUTABLE(inode) || IS_SWAPFILE(inode))
+	    IS_IMMUTABLE(inode) || IS_SWAPFILE(inode) || HAS_UNMAPPED_ID(inode))
 		return -EPERM;
 	if (isdir) {
 		if (!d_is_dir(victim))
@@ -4190,6 +4199,13 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
 	 */
 	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
 		return -EPERM;
+	/*
+	 * Updating the link count will likely cause i_uid and i_gid to
+	 * be writen back improperly if their true value is unknown to
+	 * the vfs.
+	 */
+	if (HAS_UNMAPPED_ID(inode))
+		return -EPERM;
 	if (!dir->i_op->link)
 		return -EPERM;
 	if (S_ISDIR(inode->i_mode))
diff --git a/fs/xattr.c b/fs/xattr.c
index 4beafc43daa5..c243905835ab 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -38,6 +38,13 @@ xattr_permission(struct inode *inode, const char *name, int mask)
 	if (mask & MAY_WRITE) {
 		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 			return -EPERM;
+		/*
+		 * Updating an xattr will likely cause i_uid and i_gid
+		 * to be writen back improperly if their true value is
+		 * unknown to the vfs.
+		 */
+		if (HAS_UNMAPPED_ID(inode))
+			return -EPERM;
 	}
 
 	/*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 375e37f42cdf..cb25ceb6d1ef 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1874,6 +1874,11 @@ struct super_operations {
 #define IS_WHITEOUT(inode)	(S_ISCHR(inode->i_mode) && \
 				 (inode)->i_rdev == WHITEOUT_DEV)
 
+static inline bool HAS_UNMAPPED_ID(struct inode *inode)
+{
+	return !uid_valid(inode->i_uid) || !gid_valid(inode->i_gid);
+}
+
 /*
  * Inode state bits.  Protected by inode->i_lock
  *
-- 
2.8.3
