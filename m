From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: new ...at() flag: AT_NO_JUMPS
Date: Sat, 29 Apr 2017 23:04:14 +0100
Message-ID: <20170429220414.GT29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

New AT_... flag - AT_NO_JUMPS

Semantics: pathname resolution must not involve
	* traversals of absolute symlinks
	* traversals of procfs-style symlinks
	* traversals of mountpoints (including bindings, referrals, etc.)
	* traversal of .. in the starting point of pathname resolution.

All of those lead to failure with -ELOOP.  Relative symlinks are fine,
as long as their resolution does not end up stepping into the conditions
above.

It guarantees that result of successful pathname resolution will be on the
same filesystem as its starting point and within the subtree rooted at
the starting point.

Right now I have it hooked only for fstatat() and friends; it could be
easily extended to any ...at() syscalls.  Objections?

commit 2765f14b0cbb4240a6a3dda353d7014b6de19db9
Author: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Date:   Sat Mar 18 16:27:55 2017 -0400

    namei: new flag (LOOKUP_NO_JUMPS)
    
    semantics: fail with -ELOOP upon
            * attempt to cross mountpoint (including bindings)
            * attempt to traverse a non-relative symlink
            * attempt to cross the starting point by ".." traversal
    
    Matching AT_... flag: AT_NO_JUMPS introduced, fstatat(2) (and
    corresponding statx/stat64 variants) taught about it.
    
    Signed-off-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

diff --git a/fs/namei.c b/fs/namei.c
index d41fab78798b..de1f07ec8ccd 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -874,6 +874,8 @@ static int nd_jump_root(struct nameidata *nd)
 		path_get(&nd->path);
 		nd->inode = nd->path.dentry->d_inode;
 	}
+	if (unlikely(nd->flags & LOOKUP_NO_JUMPS))
+		return -ELOOP;
 	nd->flags |= LOOKUP_JUMPED;
 	return 0;
 }
@@ -1054,14 +1056,18 @@ const char *get_link(struct nameidata *nd)
 		} else {
 			res = get(dentry, inode, &last->done);
 		}
+		if (unlikely(nd->flags & LOOKUP_NO_JUMPS) &&
+		    unlikely(nd->flags & LOOKUP_JUMPED))
+			return ERR_PTR(-ELOOP);
 		if (IS_ERR_OR_NULL(res))
 			return res;
 	}
 	if (*res == '/') {
 		if (!nd->root.mnt)
 			set_root(nd);
-		if (unlikely(nd_jump_root(nd)))
-			return ERR_PTR(-ECHILD);
+		error = nd_jump_root(nd);
+		if (unlikely(error))
+			return ERR_PTR(error);
 		while (unlikely(*++res == '/'))
 			;
 	}
@@ -1245,12 +1251,16 @@ static int follow_managed(struct path *path, struct nameidata *nd)
 		break;
 	}
 
-	if (need_mntput && path->mnt == mnt)
-		mntput(path->mnt);
+	if (need_mntput) {
+		if (path->mnt == mnt)
+			mntput(path->mnt);
+		if (unlikely(nd->flags & LOOKUP_NO_JUMPS))
+			ret = -ELOOP;
+		else
+			nd->flags |= LOOKUP_JUMPED;
+	}
 	if (ret == -EISDIR || !ret)
 		ret = 1;
-	if (need_mntput)
-		nd->flags |= LOOKUP_JUMPED;
 	if (unlikely(ret < 0))
 		path_put_conditional(path, nd);
 	return ret;
@@ -1307,6 +1317,8 @@ static bool __follow_mount_rcu(struct nameidata *nd, struct path *path,
 		mounted = __lookup_mnt(path->mnt, path->dentry);
 		if (!mounted)
 			break;
+		if (unlikely(nd->flags & LOOKUP_NO_JUMPS))
+			return false;
 		path->mnt = &mounted->mnt;
 		path->dentry = mounted->mnt.mnt_root;
 		nd->flags |= LOOKUP_JUMPED;
@@ -1327,8 +1339,11 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 	struct inode *inode = nd->inode;
 
 	while (1) {
-		if (path_equal(&nd->path, &nd->root))
+		if (unlikely(path_equal(&nd->path, &nd->root))) {
+			if (nd->flags & LOOKUP_NO_JUMPS)
+				return -ELOOP;
 			break;
+		}
 		if (nd->path.dentry != nd->path.mnt->mnt_root) {
 			struct dentry *old = nd->path.dentry;
 			struct dentry *parent = old->d_parent;
@@ -1455,8 +1470,9 @@ static int path_parent_directory(struct path *path)
 static int follow_dotdot(struct nameidata *nd)
 {
 	while(1) {
-		if (nd->path.dentry == nd->root.dentry &&
-		    nd->path.mnt == nd->root.mnt) {
+		if (unlikely(path_equal(&nd->path, &nd->root))) {
+			if (nd->flags & LOOKUP_NO_JUMPS)
+				return -ELOOP;
 			break;
 		}
 		if (nd->path.dentry != nd->path.mnt->mnt_root) {
@@ -2177,14 +2193,16 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 
 	nd->m_seq = read_seqbegin(&mount_lock);
 	if (*s == '/') {
+		int error;
 		if (flags & LOOKUP_RCU)
 			rcu_read_lock();
 		set_root(nd);
-		if (likely(!nd_jump_root(nd)))
-			return s;
-		nd->root.mnt = NULL;
-		rcu_read_unlock();
-		return ERR_PTR(-ECHILD);
+		error = nd_jump_root(nd);
+		if (unlikely(error)) {
+			terminate_walk(nd);
+			s = ERR_PTR(error);
+		}
+		return s;
 	} else if (nd->dfd == AT_FDCWD) {
 		if (flags & LOOKUP_RCU) {
 			struct fs_struct *fs = current->fs;
@@ -2202,6 +2220,11 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 			get_fs_pwd(current->fs, &nd->path);
 			nd->inode = nd->path.dentry->d_inode;
 		}
+		if (unlikely(flags & LOOKUP_NO_JUMPS)) {
+			nd->root = nd->path;
+			if (!(flags & LOOKUP_RCU))
+				path_get(&nd->root);
+		}
 		return s;
 	} else {
 		/* Caller must check execute permissions on the starting path component */
@@ -2229,6 +2252,11 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 			path_get(&nd->path);
 			nd->inode = nd->path.dentry->d_inode;
 		}
+		if (unlikely(flags & LOOKUP_NO_JUMPS)) {
+			nd->root = nd->path;
+			if (!(flags & LOOKUP_RCU))
+				path_get(&nd->root);
+		}
 		fdput(f);
 		return s;
 	}
diff --git a/fs/stat.c b/fs/stat.c
index fa0be59340cc..1999ce5f77c9 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -168,7 +168,7 @@ int vfs_statx(int dfd, const char __user *filename, int flags,
 	unsigned int lookup_flags = LOOKUP_FOLLOW | LOOKUP_AUTOMOUNT;
 
 	if ((flags & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT |
-		       AT_EMPTY_PATH | KSTAT_QUERY_FLAGS)) != 0)
+		       AT_EMPTY_PATH | KSTAT_QUERY_FLAGS | AT_NO_JUMPS)) != 0)
 		return -EINVAL;
 
 	if (flags & AT_SYMLINK_NOFOLLOW)
@@ -177,6 +177,8 @@ int vfs_statx(int dfd, const char __user *filename, int flags,
 		lookup_flags &= ~LOOKUP_AUTOMOUNT;
 	if (flags & AT_EMPTY_PATH)
 		lookup_flags |= LOOKUP_EMPTY;
+	if (flags & AT_NO_JUMPS)
+		lookup_flags |= LOOKUP_NO_JUMPS;
 
 retry:
 	error = user_path_at(dfd, filename, lookup_flags, &path);
diff --git a/include/linux/namei.h b/include/linux/namei.h
index f29abda31e6d..3cefb90f38ca 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -45,6 +45,8 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 #define LOOKUP_ROOT		0x2000
 #define LOOKUP_EMPTY		0x4000
 
+#define LOOKUP_NO_JUMPS		0x10000
+
 extern int path_pts(struct path *path);
 
 extern int user_path_at_empty(int, const char __user *, unsigned, struct path *, int *empty);
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index 813afd6eee71..ca35ef523e40 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -68,5 +68,6 @@
 #define AT_STATX_FORCE_SYNC	0x2000	/* - Force the attributes to be sync'd with the server */
 #define AT_STATX_DONT_SYNC	0x4000	/* - Don't sync attributes with the server */
 
+#define AT_NO_JUMPS		0x8000	/* No mountpoint crossing, no abs symlinks */
 
 #endif /* _UAPI_LINUX_FCNTL_H */
