From: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC PATCH 1/3] fs: add AT_REPLACE flag for linkat() which replaces the target
Date: Tue, 22 Nov 2016 00:25:01 -0800
Message-ID: <6b3b7387538efd1a582fc34da2a15ae37cf59429.1479802448.git.osandov@fb.com>
References: <cover.1479802448.git.osandov@fb.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1479802448.git.osandov-b10kYP2dOMg@public.gmane.org>
In-Reply-To: <cover.1479802448.git.osandov-b10kYP2dOMg@public.gmane.org>
References: <cover.1479802448.git.osandov-b10kYP2dOMg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Xi Wang <xi-GmWTxIRN22iJaUV4rX00uodd74u8MsAO@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>

One of the most common uses of temporary files is the classic atomic
replacement pattern, i.e.,

- write temporary file
- fsync temporary file
- rename temporary file over real file
- fsync parent directory

Now, we have O_TMPFILE, which gives us a much better way to create
temporary files, but it's not possible to use it for this pattern.

This patch introduces an AT_REPLACE flag which allows linkat() to
replace the target file. Now, the temporary file in the pattern above
can be a proper O_TMPFILE. Even without O_TMPFILE, this is a new
primitive which might be useful in other contexts.

Cc: Xi Wang <xi-GmWTxIRN22iJaUV4rX00uodd74u8MsAO@public.gmane.org>
Signed-off-by: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>
---
 fs/ecryptfs/inode.c        |   2 +-
 fs/namei.c                 | 180 +++++++++++++++++++++++++++++++++++----------
 fs/nfsd/vfs.c              |   2 +-
 fs/overlayfs/overlayfs.h   |   2 +-
 include/linux/fs.h         |   3 +-
 include/uapi/linux/fcntl.h |   1 +
 6 files changed, 149 insertions(+), 41 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index cf390dc..d38c24a 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -442,7 +442,7 @@ static int ecryptfs_link(struct dentry *old_dentry, struct inode *dir,
 	dget(lower_new_dentry);
 	lower_dir_dentry = lock_parent(lower_new_dentry);
 	rc = vfs_link(lower_old_dentry, d_inode(lower_dir_dentry),
-		      lower_new_dentry, NULL);
+		      lower_new_dentry, NULL, 0);
 	if (rc || d_really_is_negative(lower_new_dentry))
 		goto out_lock;
 	rc = ecryptfs_interpose(lower_new_dentry, new_dentry, dir->i_sb);
diff --git a/fs/namei.c b/fs/namei.c
index 5b4eed2..94681be 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4144,16 +4144,26 @@ SYSCALL_DEFINE2(symlink, const char __user *, oldname, const char __user *, newn
  * be appropriate for callers that expect the underlying filesystem not
  * to be NFS exported.
  */
-int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_dentry, struct inode **delegated_inode)
+int vfs_link(struct dentry *old_dentry, struct inode *dir,
+	     struct dentry *new_dentry, struct inode **delegated_inode,
+	     unsigned int flags)
 {
 	struct inode *inode = old_dentry->d_inode;
+	struct inode *target = new_dentry->d_inode;
 	unsigned max_links = dir->i_sb->s_max_links;
 	int error;
 
 	if (!inode)
 		return -ENOENT;
 
-	error = may_create(dir, new_dentry);
+	if (target) {
+		if (flags & AT_REPLACE)
+			error = may_delete(dir, new_dentry, d_is_dir(old_dentry));
+		else
+			error = -EEXIST;
+	} else {
+		error = may_create(dir, new_dentry);
+	}
 	if (error)
 		return error;
 
@@ -4172,8 +4182,10 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
 	 */
 	if (HAS_UNMAPPED_ID(inode))
 		return -EPERM;
-	if (!dir->i_op->link)
+	if (!dir->i_op->link && !dir->i_op->link2)
 		return -EPERM;
+	if (flags && !dir->i_op->link2)
+		return -EINVAL;
 	if (S_ISDIR(inode->i_mode))
 		return -EPERM;
 
@@ -4181,26 +4193,58 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
 	if (error)
 		return error;
 
-	inode_lock(inode);
+	dget(new_dentry);
+	lock_two_nondirectories(inode, target);
+
+	if (is_local_mountpoint(new_dentry)) {
+		error = -EBUSY;
+		goto out;
+	}
+
 	/* Make sure we don't allow creating hardlink to an unlinked file */
-	if (inode->i_nlink == 0 && !(inode->i_state & I_LINKABLE))
+	if (inode->i_nlink == 0 && !(inode->i_state & I_LINKABLE)) {
 		error =  -ENOENT;
-	else if (max_links && inode->i_nlink >= max_links)
+		goto out;
+	}
+	if (max_links && inode->i_nlink >= max_links) {
 		error = -EMLINK;
-	else {
-		error = try_break_deleg(inode, delegated_inode);
-		if (!error)
-			error = dir->i_op->link(old_dentry, dir, new_dentry);
+		goto out;
+	}
+
+	error = try_break_deleg(inode, delegated_inode);
+	if (error)
+		goto out;
+	if (target) {
+		error = try_break_deleg(target, delegated_inode);
+		if (error)
+			goto out;
+	}
+
+	if (dir->i_op->link)
+		error = dir->i_op->link(old_dentry, dir, new_dentry);
+	else
+		error = dir->i_op->link2(old_dentry, dir, new_dentry, flags);
+	if (error)
+		goto out;
+
+	if (target) {
+		dont_mount(new_dentry);
+		detach_mounts(new_dentry);
 	}
 
-	if (!error && (inode->i_state & I_LINKABLE)) {
+	if (inode->i_state & I_LINKABLE) {
 		spin_lock(&inode->i_lock);
 		inode->i_state &= ~I_LINKABLE;
 		spin_unlock(&inode->i_lock);
 	}
-	inode_unlock(inode);
-	if (!error)
+out:
+	unlock_two_nondirectories(inode, target);
+	dput(new_dentry);
+	if (!error) {
+		if (target)
+			fsnotify_link_count(target);
 		fsnotify_link(dir, inode, new_dentry);
+	}
 	return error;
 }
 EXPORT_SYMBOL(vfs_link);
@@ -4219,11 +4263,15 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 {
 	struct dentry *new_dentry;
 	struct path old_path, new_path;
+	struct qstr new_last;
+	int new_type;
 	struct inode *delegated_inode = NULL;
-	int how = 0;
+	struct filename *to;
+	unsigned int how = 0, target_flags;
+	bool should_retry = false;
 	int error;
 
-	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH)) != 0)
+	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH | AT_REPLACE)) != 0)
 		return -EINVAL;
 	/*
 	 * To use null names we require CAP_DAC_READ_SEARCH
@@ -4238,44 +4286,102 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 
 	if (flags & AT_SYMLINK_FOLLOW)
 		how |= LOOKUP_FOLLOW;
+
+	if (flags & AT_REPLACE)
+		target_flags = LOOKUP_RENAME_TARGET;
+	else
+		target_flags = LOOKUP_CREATE | LOOKUP_EXCL;
 retry:
 	error = user_path_at(olddfd, oldname, how, &old_path);
 	if (error)
 		return error;
 
-	new_dentry = user_path_create(newdfd, newname, &new_path,
-					(how & LOOKUP_REVAL));
-	error = PTR_ERR(new_dentry);
-	if (IS_ERR(new_dentry))
-		goto out;
+	to = user_path_parent(newdfd, newname, &new_path, &new_last, &new_type,
+			      (how & LOOKUP_REVAL));
+	if (IS_ERR(to)) {
+		error = PTR_ERR(to);
+		goto exit1;
+	}
+
+	if (old_path.mnt != new_path.mnt) {
+		error = -EXDEV;
+		goto exit2;
+	}
+
+	if (new_type != LAST_NORM) {
+		if (flags & AT_REPLACE)
+			error = -EBUSY;
+		else
+			error = -EEXIST;
+		goto exit2;
+	}
+
+	error = mnt_want_write(old_path.mnt);
+	if (error)
+		goto exit2;
+
+retry_deleg:
+	inode_lock_nested(new_path.dentry->d_inode, I_MUTEX_PARENT);
+
+	new_dentry = __lookup_hash(&new_last, new_path.dentry,
+				   (how & LOOKUP_REVAL) | target_flags);
+	if (IS_ERR(new_dentry)) {
+		error = PTR_ERR(new_dentry);
+		goto exit3;
+	}
+	if (!(flags & AT_REPLACE) && d_is_positive(new_dentry)) {
+		error = -EEXIST;
+		goto exit4;
+	}
+	if (new_last.name[new_last.len]) {
+		/* trailing slash on negative dentry gives -ENOENT */
+		if (d_is_negative(new_dentry)) {
+			error = -ENOENT;
+			goto exit4;
+		}
+
+		/*
+		 * unless the source is a directory, trailing slash gives
+		 * -ENOTDIR (this can only happen in the AT_REPLACE case, so we
+		 * make this consistent with sys_renameat2() even though a
+		 * source directory will fail later with -EPERM)
+		 */
+		if (!d_is_dir(old_path.dentry)) {
+			error = -ENOTDIR;
+			goto exit4;
+		}
+	}
 
-	error = -EXDEV;
-	if (old_path.mnt != new_path.mnt)
-		goto out_dput;
 	error = may_linkat(&old_path);
 	if (unlikely(error))
-		goto out_dput;
+		goto exit4;
 	error = security_path_link(old_path.dentry, &new_path, new_dentry);
 	if (error)
-		goto out_dput;
-	error = vfs_link(old_path.dentry, new_path.dentry->d_inode, new_dentry, &delegated_inode);
-out_dput:
-	done_path_create(&new_path, new_dentry);
+		goto exit4;
+	error = vfs_link(old_path.dentry, new_path.dentry->d_inode, new_dentry,
+			 &delegated_inode, flags & AT_REPLACE);
+exit4:
+	dput(new_dentry);
+exit3:
+	inode_unlock(new_path.dentry->d_inode);
 	if (delegated_inode) {
 		error = break_deleg_wait(&delegated_inode);
-		if (!error) {
-			path_put(&old_path);
-			goto retry;
-		}
+		if (!error)
+			goto retry_deleg;
 	}
-	if (retry_estale(error, how)) {
-		path_put(&old_path);
+	mnt_drop_write(old_path.mnt);
+exit2:
+	if (retry_estale(error, how))
+		should_retry = true;
+	path_put(&new_path);
+	putname(to);
+exit1:
+	path_put(&old_path);
+	if (should_retry) {
+		should_retry = false;
 		how |= LOOKUP_REVAL;
 		goto retry;
 	}
-out:
-	path_put(&old_path);
-
 	return error;
 }
 
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 8ca642f..0a16599 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1594,7 +1594,7 @@ nfsd_link(struct svc_rqst *rqstp, struct svc_fh *ffhp,
 	err = nfserr_noent;
 	if (d_really_is_negative(dold))
 		goto out_dput;
-	host_err = vfs_link(dold, dirp, dnew, NULL);
+	host_err = vfs_link(dold, dirp, dnew, NULL, 0);
 	if (!host_err) {
 		err = nfserrno(commit_metadata(ffhp));
 		if (!err)
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e218e74..71b2f52 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -46,7 +46,7 @@ static inline int ovl_do_unlink(struct inode *dir, struct dentry *dentry)
 static inline int ovl_do_link(struct dentry *old_dentry, struct inode *dir,
 			      struct dentry *new_dentry, bool debug)
 {
-	int err = vfs_link(old_dentry, dir, new_dentry, NULL);
+	int err = vfs_link(old_dentry, dir, new_dentry, NULL, 0);
 	if (debug) {
 		pr_debug("link(%pd2, %pd2) = %i\n",
 			 old_dentry, new_dentry, err);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dc0478c..2efa6c1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1606,7 +1606,7 @@ extern int vfs_create(struct inode *, struct dentry *, umode_t, bool);
 extern int vfs_mkdir(struct inode *, struct dentry *, umode_t);
 extern int vfs_mknod(struct inode *, struct dentry *, umode_t, dev_t);
 extern int vfs_symlink(struct inode *, struct dentry *, const char *);
-extern int vfs_link(struct dentry *, struct inode *, struct dentry *, struct inode **);
+extern int vfs_link(struct dentry *, struct inode *, struct dentry *, struct inode **, unsigned int);
 extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *, struct inode **);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *, struct inode **, unsigned int);
@@ -1743,6 +1743,7 @@ struct inode_operations {
 
 	int (*create) (struct inode *,struct dentry *, umode_t, bool);
 	int (*link) (struct dentry *,struct inode *,struct dentry *);
+	int (*link2) (struct dentry *,struct inode *,struct dentry *,unsigned int);
 	int (*unlink) (struct inode *,struct dentry *);
 	int (*symlink) (struct inode *,struct dentry *,const char *);
 	int (*mkdir) (struct inode *,struct dentry *,umode_t);
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index beed138..6c1f293 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -62,6 +62,7 @@
 #define AT_SYMLINK_FOLLOW	0x400   /* Follow symbolic links.  */
 #define AT_NO_AUTOMOUNT		0x800	/* Suppress terminal automount traversal */
 #define AT_EMPTY_PATH		0x1000	/* Allow empty relative pathname */
+#define AT_REPLACE		0x2000	/* Replace new path */
 
 
 #endif /* _UAPI_LINUX_FCNTL_H */
-- 
2.10.2
