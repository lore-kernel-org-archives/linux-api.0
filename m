From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 1/4] statx: Add a system call to make enhanced file info
 available [ver #3]
Date: Sun, 4 Dec 2016 17:33:17 +0000
Message-ID: <20161204173317.GH1555@ZenIV.linux.org.uk>
References: <147986254484.19139.8038609825799670925.stgit@warthog.procyon.org.uk>
 <147986255194.19139.9583434946564699577.stgit@warthog.procyon.org.uk>
 <20161204043803.GA1022@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161204043803.GA1022-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Dec 04, 2016 at 04:38:05AM +0000, Al Viro wrote:

> I understand wanting to avoid extra arguments, but you are asking for trouble
> with that sort of calling conventions.  Verifying that all call chains have
> these fields initialized is bloody unpleasant and it *is* going to break,
> especially since the rules are "you need to initialize it for vfs_xgetattr(),
> but not for vfs_getattr()" - the names are similar enough for confusion,
> and that's not the only such pair.

FWIW, there's a bit of abuse of struct kstat in overlayfs object
creation paths - for one thing, it ends up with a very small subset
of struct kstat (mode + rdev), for another it also needs link in
case of symlinks and ends up passing it separately.

IMO it would be better to introduce a separate object for that; does anybody
have objections to something like the patch below?  In principle, we might
even lift that thing into general API and switch ->mkdir()/->mknod()/->symlink()
to identical calling conventions.  Hell knows, perhaps ->create() as well...
Comments?

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 36795ee..17ad2da 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -231,10 +231,15 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	struct inode *udir = upperdir->d_inode;
 	struct dentry *newdentry = NULL;
 	struct dentry *upper = NULL;
-	umode_t mode = stat->mode;
 	int err;
 	const struct cred *old_creds = NULL;
 	struct cred *new_creds = NULL;
+	struct cattr cattr = {
+		/* Can't properly set mode on creation because of the umask */
+		.mode = stat->mode & S_IFMT,
+		.rdev = stat->rdev,
+		.link = link
+	};
 
 	newdentry = ovl_lookup_temp(workdir, dentry);
 	err = PTR_ERR(newdentry);
@@ -254,10 +259,7 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	if (new_creds)
 		old_creds = override_creds(new_creds);
 
-	/* Can't properly set mode on creation because of the umask */
-	stat->mode &= S_IFMT;
-	err = ovl_create_real(wdir, newdentry, stat, link, NULL, true);
-	stat->mode = mode;
+	err = ovl_create_real(wdir, newdentry, &cattr, NULL, true);
 
 	if (new_creds) {
 		revert_creds(old_creds);
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 306b6c1..dc60a23 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -75,8 +75,8 @@ static struct dentry *ovl_whiteout(struct dentry *workdir,
 }
 
 int ovl_create_real(struct inode *dir, struct dentry *newdentry,
-		    struct kstat *stat, const char *link,
-		    struct dentry *hardlink, bool debug)
+		    struct cattr *attr, struct dentry *hardlink,
+		    bool debug)
 {
 	int err;
 
@@ -86,13 +86,13 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 	if (hardlink) {
 		err = ovl_do_link(hardlink, dir, newdentry, debug);
 	} else {
-		switch (stat->mode & S_IFMT) {
+		switch (attr->mode & S_IFMT) {
 		case S_IFREG:
-			err = ovl_do_create(dir, newdentry, stat->mode, debug);
+			err = ovl_do_create(dir, newdentry, attr->mode, debug);
 			break;
 
 		case S_IFDIR:
-			err = ovl_do_mkdir(dir, newdentry, stat->mode, debug);
+			err = ovl_do_mkdir(dir, newdentry, attr->mode, debug);
 			break;
 
 		case S_IFCHR:
@@ -100,11 +100,11 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		case S_IFIFO:
 		case S_IFSOCK:
 			err = ovl_do_mknod(dir, newdentry,
-					   stat->mode, stat->rdev, debug);
+					   attr->mode, attr->rdev, debug);
 			break;
 
 		case S_IFLNK:
-			err = ovl_do_symlink(dir, newdentry, link, debug);
+			err = ovl_do_symlink(dir, newdentry, attr->link, debug);
 			break;
 
 		default:
@@ -183,8 +183,7 @@ static void ovl_instantiate(struct dentry *dentry, struct inode *inode,
 }
 
 static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
-			    struct kstat *stat, const char *link,
-			    struct dentry *hardlink)
+			    struct cattr *attr, struct dentry *hardlink)
 {
 	struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
 	struct inode *udir = upperdir->d_inode;
@@ -192,7 +191,7 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 	int err;
 
 	if (!hardlink && !IS_POSIXACL(udir))
-		stat->mode &= ~current_umask();
+		attr->mode &= ~current_umask();
 
 	inode_lock_nested(udir, I_MUTEX_PARENT);
 	newdentry = lookup_one_len(dentry->d_name.name, upperdir,
@@ -200,7 +199,7 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 	err = PTR_ERR(newdentry);
 	if (IS_ERR(newdentry))
 		goto out_unlock;
-	err = ovl_create_real(udir, newdentry, stat, link, hardlink, false);
+	err = ovl_create_real(udir, newdentry, attr, hardlink, false);
 	if (err)
 		goto out_dput;
 
@@ -270,7 +269,8 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 	if (IS_ERR(opaquedir))
 		goto out_unlock;
 
-	err = ovl_create_real(wdir, opaquedir, &stat, NULL, NULL, true);
+	err = ovl_create_real(wdir, opaquedir,
+			      &(struct cattr){.mode = stat.mode}, NULL, true);
 	if (err)
 		goto out_dput;
 
@@ -370,8 +370,7 @@ static int ovl_set_upper_acl(struct dentry *upperdentry, const char *name,
 }
 
 static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
-				    struct kstat *stat, const char *link,
-				    struct dentry *hardlink)
+				    struct cattr *cattr, struct dentry *hardlink)
 {
 	struct dentry *workdir = ovl_workdir(dentry);
 	struct inode *wdir = workdir->d_inode;
@@ -387,7 +386,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 
 	if (!hardlink) {
 		err = posix_acl_create(dentry->d_parent->d_inode,
-				       &stat->mode, &default_acl, &acl);
+				       &cattr->mode, &default_acl, &acl);
 		if (err)
 			return err;
 	}
@@ -407,7 +406,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 	if (IS_ERR(upper))
 		goto out_dput;
 
-	err = ovl_create_real(wdir, newdentry, stat, link, hardlink, true);
+	err = ovl_create_real(wdir, newdentry, cattr, hardlink, true);
 	if (err)
 		goto out_dput2;
 
@@ -415,10 +414,10 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 	 * mode could have been mutilated due to umask (e.g. sgid directory)
 	 */
 	if (!hardlink &&
-	    !S_ISLNK(stat->mode) && newdentry->d_inode->i_mode != stat->mode) {
+	    !S_ISLNK(cattr->mode) && newdentry->d_inode->i_mode != cattr->mode) {
 		struct iattr attr = {
 			.ia_valid = ATTR_MODE,
-			.ia_mode = stat->mode,
+			.ia_mode = cattr->mode,
 		};
 		inode_lock(newdentry->d_inode);
 		err = notify_change(newdentry, &attr, NULL);
@@ -438,7 +437,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 			goto out_cleanup;
 	}
 
-	if (!hardlink && S_ISDIR(stat->mode)) {
+	if (!hardlink && S_ISDIR(cattr->mode)) {
 		err = ovl_set_opaque(newdentry);
 		if (err)
 			goto out_cleanup;
@@ -475,8 +474,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 }
 
 static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
-			      struct kstat *stat, const char *link,
-			      struct dentry *hardlink)
+			      struct cattr *attr, struct dentry *hardlink)
 {
 	int err;
 	const struct cred *old_cred;
@@ -494,7 +492,7 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 		override_cred->fsgid = inode->i_gid;
 		if (!hardlink) {
 			err = security_dentry_create_files_as(dentry,
-					stat->mode, &dentry->d_name, old_cred,
+					attr->mode, &dentry->d_name, old_cred,
 					override_cred);
 			if (err) {
 				put_cred(override_cred);
@@ -505,11 +503,11 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 		put_cred(override_cred);
 
 		if (!ovl_dentry_is_opaque(dentry))
-			err = ovl_create_upper(dentry, inode, stat, link,
+			err = ovl_create_upper(dentry, inode, attr,
 						hardlink);
 		else
-			err = ovl_create_over_whiteout(dentry, inode, stat,
-							link, hardlink);
+			err = ovl_create_over_whiteout(dentry, inode, attr,
+							hardlink);
 	}
 out_revert_creds:
 	revert_creds(old_cred);
@@ -528,8 +526,9 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
 {
 	int err;
 	struct inode *inode;
-	struct kstat stat = {
+	struct cattr attr = {
 		.rdev = rdev,
+		.link = link,
 	};
 
 	err = ovl_want_write(dentry);
@@ -542,9 +541,9 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
 		goto out_drop_write;
 
 	inode_init_owner(inode, dentry->d_parent->d_inode, mode);
-	stat.mode = inode->i_mode;
+	attr.mode = inode->i_mode;
 
-	err = ovl_create_or_link(dentry, inode, &stat, link, NULL);
+	err = ovl_create_or_link(dentry, inode, &attr, NULL);
 	if (err)
 		iput(inode);
 
@@ -598,7 +597,7 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 	inode = d_inode(old);
 	ihold(inode);
 
-	err = ovl_create_or_link(new, inode, NULL, NULL, ovl_dentry_upper(old));
+	err = ovl_create_or_link(new, inode, NULL, ovl_dentry_upper(old));
 	if (err)
 		iput(inode);
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e218e74..346b38b 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -210,8 +210,13 @@ static inline void ovl_copyattr(struct inode *from, struct inode *to)
 /* dir.c */
 extern const struct inode_operations ovl_dir_inode_operations;
 struct dentry *ovl_lookup_temp(struct dentry *workdir, struct dentry *dentry);
+struct cattr {
+	dev_t rdev;
+	umode_t mode;
+	const char *link;
+};
 int ovl_create_real(struct inode *dir, struct dentry *newdentry,
-		    struct kstat *stat, const char *link,
+		    struct cattr *attr,
 		    struct dentry *hardlink, bool debug);
 void ovl_cleanup(struct inode *dir, struct dentry *dentry);
 
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index edd46a0..c95e447 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -809,12 +809,9 @@ static struct dentry *ovl_workdir_create(struct vfsmount *mnt,
 			      strlen(OVL_WORKDIR_NAME));
 
 	if (!IS_ERR(work)) {
-		struct kstat stat = {
-			.mode = S_IFDIR | 0,
-		};
 		struct iattr attr = {
 			.ia_valid = ATTR_MODE,
-			.ia_mode = stat.mode,
+			.ia_mode = S_IFDIR | 0,
 		};
 
 		if (work->d_inode) {
@@ -828,7 +825,9 @@ static struct dentry *ovl_workdir_create(struct vfsmount *mnt,
 			goto retry;
 		}
 
-		err = ovl_create_real(dir, work, &stat, NULL, NULL, true);
+		err = ovl_create_real(dir, work,
+				      &(struct cattr){.mode = S_IFDIR | 0},
+				      NULL, true);
 		if (err)
 			goto out_dput;
 
