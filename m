From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH] Introduce v3 namespaced file capabilities
Date: Fri, 21 Apr 2017 18:58:05 -0500
Message-ID: <87wpadpb3m.fsf@xmission.com>
References: <20170419164824.GA27843@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170419164824.GA27843-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org> (Serge E. Hallyn's
        message of "Wed, 19 Apr 2017 11:48:24 -0500")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


"Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:

> Root in a non-initial user ns cannot be trusted to write a traditional
> security.capability xattr.  If it were allowed to do so, then any
> unprivileged user on the host could map his own uid to root in a private
> namespace, write the xattr, and execute the file with privilege on the
> host.
>
> However supporting file capabilities in a user namespace is very
> desirable.  Not doing so means that any programs designed to run with
> limited privilege must continue to support other methods of gaining and
> dropping privilege.  For instance a program installer must detect
> whether file capabilities can be assigned, and assign them if so but set
> setuid-root otherwise.  The program in turn must know how to drop
> partial capabilities, and do so only if setuid-root.
>
> This patch introduces v3 of the security.capability xattr.  It builds a
> vfs_ns_cap_data struct by appending a uid_t rootid to struct
> vfs_cap_data.  This is the absolute uid_t (that is, the uid_t in user
> namespace which mounted the filesystem, usually init_user_ns) of the
> root id in whose namespaces the file capabilities may take effect.
>
> When a task asks to write a v2 security.capability xattr, if it is
> privileged with respect to the userns which mounted the filesystem, then
> nothing should change.  Otherwise, the kernel will transparently rewrite
> the xattr as a v3 with the appropriate rootid.  Subsequently, any task
> executing the file which has the noted kuid as its root uid, or which is
> in a descendent user_ns of such a user_ns, will run the file with
> capabilities.
>
> Similarly when asking to read file capabilities, a v3 capability will
> be presented as v2 if it applies to the caller's namespace.
>
> If a task writes a v3 security.capability, then it can provide a uid for
> the xattr so long as the uid is valid in its own user namespace, and it
> is privileged with CAP_SETFCAP over its namespace.  The kernel will
> translate that rootid to an absolute uid, and write that to disk.  After
> this, a task in the writer's namespace will not be able to use those
> capabilities (unless rootid was 0), but a task in a namespace where the
> given uid is root will.
>
> Only a single security.capability xattr may exist at a time for a given
> file.  A task may overwrite an existing xattr so long as it is
> privileged over the inode.  Note this is a departure from previous
> semantics, which required privilege to remove a security.capability
> xattr.  This check can be re-added if deemed useful.
>
> This allows a simple setcap/setxattr to work, should allow tar to work,
> and should allow us to support tar in one namespace and untar in another
> while preserving the capability, without risking leaking privilege into
> a parent namespace.
>
> A patch to linux-test-project adding a new set of tests for this
> functionality is in the nsfscaps branch at github.com/hallyn/ltp
>
> Changelog:
>    Nov 02 2016: fix invalid check at refuse_fcap_overwrite()
>    Nov 07 2016: convert rootid from and to fs user_ns
>    (From ebiederm: mar 28 2017)
>      commoncap.c: fix typos - s/v4/v3
>      get_vfs_caps_from_disk: clarify the fs_ns root access check
>      nsfscaps: change the code split for cap_inode_setxattr()
>    Apr 09 2017:
>        don't return v3 cap for caps owned by current root.
>       return a v2 cap for a true v2 cap in non-init ns
>    Apr 18 2017:
>       . Change the flow of fscap writing to support s_user_ns writing.
>       . Remove refuse_fcap_overwrite().  The value of the previous
>         xattr doesn't matter.

Overall this looks quite reasonable.

My only big concern was the lack of verifying of magic_etc.  As without
that the code might not be future compatible with new versions of the
capability xattrs.  It it tends to be nice to be able to boot old
kernels when regression testing etc.  Even if they can't make use of
all of the features of a new filesystem.

> diff --git a/fs/xattr.c b/fs/xattr.c
> index 7e3317c..75cc65a 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -170,12 +170,29 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
>  		const void *value, size_t size, int flags)
>  {
>  	struct inode *inode = dentry->d_inode;
> -	int error = -EAGAIN;
> +	int error;
> +	void *wvalue = NULL;
> +	size_t wsize = 0;
>  	int issec = !strncmp(name, XATTR_SECURITY_PREFIX,
>  				   XATTR_SECURITY_PREFIX_LEN);
>  
> -	if (issec)
> +	if (issec) {
>  		inode->i_flags &= ~S_NOSEC;
> +
> +		if (!strcmp(name, "security.capability")) {
> +			error = cap_setxattr_convert_nscap(dentry, value, size,
> +					&wvalue, &wsize);
> +			if (error < 0)
> +				return error;
> +			if (wvalue) {
> +				value = wvalue;
> +				size = wsize;
> +			}
> +		}
> +	}
> +
> +	error = -EAGAIN;
> +

Why is the conversion in __vfs_setxattr_noperm and not in setattr as
was done for posix_acl_fix_xattr_from_user?


>  	if (inode->i_opflags & IOP_XATTR) {
>  		error = __vfs_setxattr(dentry, inode, name, value, size, flags);
>  		if (!error) {
> @@ -184,8 +201,10 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
>  						     size, flags);
>  		}
>  	} else {
> -		if (unlikely(is_bad_inode(inode)))
> -			return -EIO;
> +		if (unlikely(is_bad_inode(inode))) {
> +			error = -EIO;
> +			goto out;
> +		}
>  	}
>  	if (error == -EAGAIN) {
>  		error = -EOPNOTSUPP;
> @@ -200,10 +219,11 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
>  		}
>  	}
>  
> +out:
> +	kfree(wvalue);
>  	return error;
>  }
>  
> -
>  int
>  vfs_setxattr(struct dentry *dentry, const char *name, const void *value,
>  		size_t size, int flags)

The rest of my comments I am going to express as an incremental diff.
Using "security.capability" directly looks like a typo waiting to
happen.

You have an unnecessary include of linux/uidgid.h

Missing version checks on the magic_etc field.
And the wrong error code when the code deliberately refuses to return a
capability.

Eric

diff --git a/fs/xattr.c b/fs/xattr.c
index 75cc65ac7ea9..f6d5ce3e1030 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -179,7 +179,7 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
 	if (issec) {
 		inode->i_flags &= ~S_NOSEC;
 
-		if (!strcmp(name, "security.capability")) {
+		if (!strcmp(name, XATTR_NAME_CAPS)) {
 			error = cap_setxattr_convert_nscap(dentry, value, size,
 					&wvalue, &wsize);
 			if (error < 0)
diff --git a/include/linux/capability.h b/include/linux/capability.h
index b97343353a11..c47febf8448b 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -13,7 +13,6 @@
 #define _LINUX_CAPABILITY_H
 
 #include <uapi/linux/capability.h>
-#include <linux/uidgid.h>
 
 #define _KERNEL_CAPABILITY_VERSION _LINUX_CAPABILITY_VERSION_3
 #define _KERNEL_CAPABILITY_U32S    _LINUX_CAPABILITY_U32S_3
diff --git a/security/commoncap.c b/security/commoncap.c
index 8abb9bf4ec17..32e32f437ef5 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -367,6 +367,7 @@ int cap_inode_getsecurity(struct inode *inode, const char *name, void **buffer,
 	kuid_t kroot;
 	uid_t root, mappedroot;
 	char *tmpbuf = NULL;
+	struct vfs_cap_data *cap;
 	struct vfs_ns_cap_data *nscap;
 	struct dentry *dentry;
 	struct user_namespace *fs_ns;
@@ -379,14 +380,16 @@ int cap_inode_getsecurity(struct inode *inode, const char *name, void **buffer,
 		return -EINVAL;
 
 	size = sizeof(struct vfs_ns_cap_data);
-	ret = vfs_getxattr_alloc(dentry, "security.capability",
+	ret = vfs_getxattr_alloc(dentry, XATTR_NAME_CAPS,
 				 &tmpbuf, size, GFP_NOFS);
 
 	if (ret < 0)
 		return ret;
 
 	fs_ns = inode->i_sb->s_user_ns;
-	if (ret == sizeof(struct vfs_cap_data)) {
+	cap = (struct vfs_cap_data *) tmpbuf;
+	if ((ret == sizeof(struct vfs_cap_data)) &&
+	    (cap->magic_etc == cpu_to_le32(VFS_CAP_REVISION_2))) {
 		/* If this is sizeof(vfs_cap_data) then we're ok with the
 		 * on-disk value, so return that.  */
 		if (alloc)
@@ -394,7 +397,8 @@ int cap_inode_getsecurity(struct inode *inode, const char *name, void **buffer,
 		else
 			kfree(tmpbuf);
 		return ret;
-	} else if (ret != sizeof(struct vfs_ns_cap_data)) {
+	} else if ((ret != sizeof(struct vfs_ns_cap_data)) ||
+		    (cap->magic_etc != cpu_to_le32(VFS_CAP_REVISION_3))) {
 		kfree(tmpbuf);
 		return -EINVAL;
 	}
@@ -417,7 +421,7 @@ int cap_inode_getsecurity(struct inode *inode, const char *name, void **buffer,
 
 	if (!rootid_owns_currentns(kroot)) {
 		kfree(tmpbuf);
-		return -EOPNOTSUPP;
+		return -ENODATA;
 	}
 
 	/* This comes from a parent namespace.  Return as a v2 capability */
@@ -474,11 +478,17 @@ int cap_setxattr_convert_nscap(struct dentry *dentry, const void *value, size_t
 		return -EINVAL;
 	if (size != XATTR_CAPS_SZ_2 && size != XATTR_CAPS_SZ_3)
 		return -EINVAL;
+	if ((size == XATTR_CAPS_SZ_2) &&
+	    (cap->magic_etc != cpu_to_le32(VFS_CAP_REVISION_2)))
+		return -EINVAL;
+	if ((size == XATTR_CAPS_SZ_3) &&
+	    (cap->magic_etc != cpu_to_le32(VFS_CAP_REVISION_3)))
+		return -EINVAL;
 	if (!capable_wrt_inode_uidgid(inode, CAP_SETFCAP))
 		return -EPERM;
 	if (size == XATTR_CAPS_SZ_2)
 		if (ns_capable(inode->i_sb->s_user_ns, CAP_SETFCAP))
-			// user is privileged, just write the v2
+			/* user is privileged, just write the v2 */
 			return 0;
 
 	rootid = rootid_from_xattr(value, size, task_ns);
@@ -855,7 +865,10 @@ int cap_inode_setxattr(struct dentry *dentry, const char *name,
 			sizeof(XATTR_SECURITY_PREFIX) - 1) != 0)
 		return 0;
 
-	// For XATTR_NAME_CAPS the check will be done in __vfs_setxattr_noperm()
+	/*
+	 * For XATTR_NAME_CAPS the check will be done in
+	 * __vfs_setxattr_noperm()
+	 */
 	if (strcmp(name, XATTR_NAME_CAPS) == 0)
 		return 0;
 
