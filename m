From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Introduce v3 namespaced file capabilities
Date: Sat, 22 Apr 2017 10:14:12 -0500
Message-ID: <20170422151412.GA14861@mail.hallyn.com>
References: <20170419164824.GA27843@mail.hallyn.com>
 <87wpadpb3m.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87wpadpb3m.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
> 
> "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:
> 
> Overall this looks quite reasonable.
> 
> My only big concern was the lack of verifying of magic_etc.  As without

Yes, I was relying too much on the size check.

> that the code might not be future compatible with new versions of the
> capability xattrs.  It it tends to be nice to be able to boot old
> kernels when regression testing etc.  Even if they can't make use of
> all of the features of a new filesystem.

That certainly was my intent.

> > diff --git a/fs/xattr.c b/fs/xattr.c
> > index 7e3317c..75cc65a 100644
> > --- a/fs/xattr.c
> > +++ b/fs/xattr.c
> > @@ -170,12 +170,29 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
> >  		const void *value, size_t size, int flags)
> >  {
> >  	struct inode *inode = dentry->d_inode;
> > -	int error = -EAGAIN;
> > +	int error;
> > +	void *wvalue = NULL;
> > +	size_t wsize = 0;
> >  	int issec = !strncmp(name, XATTR_SECURITY_PREFIX,
> >  				   XATTR_SECURITY_PREFIX_LEN);
> >  
> > -	if (issec)
> > +	if (issec) {
> >  		inode->i_flags &= ~S_NOSEC;
> > +
> > +		if (!strcmp(name, "security.capability")) {
> > +			error = cap_setxattr_convert_nscap(dentry, value, size,
> > +					&wvalue, &wsize);
> > +			if (error < 0)
> > +				return error;
> > +			if (wvalue) {
> > +				value = wvalue;
> > +				size = wsize;
> > +			}
> > +		}
> > +	}
> > +
> > +	error = -EAGAIN;
> > +
> 
> Why is the conversion in __vfs_setxattr_noperm and not in setattr as
> was done for posix_acl_fix_xattr_from_user?

I think I was thinking I wanted to catch all the vfs_setxattr operations,
but I don't think that's right.  Moving to setxattr seems right.  I'll
look around a bit more.

> >  	if (inode->i_opflags & IOP_XATTR) {
> >  		error = __vfs_setxattr(dentry, inode, name, value, size, flags);
> >  		if (!error) {
> > @@ -184,8 +201,10 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
> >  						     size, flags);
> >  		}
> >  	} else {
> > -		if (unlikely(is_bad_inode(inode)))
> > -			return -EIO;
> > +		if (unlikely(is_bad_inode(inode))) {
> > +			error = -EIO;
> > +			goto out;
> > +		}
> >  	}
> >  	if (error == -EAGAIN) {
> >  		error = -EOPNOTSUPP;
> > @@ -200,10 +219,11 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
> >  		}
> >  	}
> >  
> > +out:
> > +	kfree(wvalue);
> >  	return error;
> >  }
> >  
> > -
> >  int
> >  vfs_setxattr(struct dentry *dentry, const char *name, const void *value,
> >  		size_t size, int flags)
> 
> The rest of my comments I am going to express as an incremental diff.
> Using "security.capability" directly looks like a typo waiting to
> happen.
> 
> You have an unnecessary include of linux/uidgid.h
> 
> Missing version checks on the magic_etc field.
> And the wrong error code when the code deliberately refuses to return a
> capability.

Thanks, all looks good.  Did you want to just squash these yourself and
move on, keep them as separate patches, or have me incorporate into mine
and resend?

> Eric
> 
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 75cc65ac7ea9..f6d5ce3e1030 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -179,7 +179,7 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
>  	if (issec) {
>  		inode->i_flags &= ~S_NOSEC;
>  
> -		if (!strcmp(name, "security.capability")) {
> +		if (!strcmp(name, XATTR_NAME_CAPS)) {
>  			error = cap_setxattr_convert_nscap(dentry, value, size,
>  					&wvalue, &wsize);
>  			if (error < 0)
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index b97343353a11..c47febf8448b 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -13,7 +13,6 @@
>  #define _LINUX_CAPABILITY_H
>  
>  #include <uapi/linux/capability.h>
> -#include <linux/uidgid.h>
>  
>  #define _KERNEL_CAPABILITY_VERSION _LINUX_CAPABILITY_VERSION_3
>  #define _KERNEL_CAPABILITY_U32S    _LINUX_CAPABILITY_U32S_3
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 8abb9bf4ec17..32e32f437ef5 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -367,6 +367,7 @@ int cap_inode_getsecurity(struct inode *inode, const char *name, void **buffer,
>  	kuid_t kroot;
>  	uid_t root, mappedroot;
>  	char *tmpbuf = NULL;
> +	struct vfs_cap_data *cap;
>  	struct vfs_ns_cap_data *nscap;
>  	struct dentry *dentry;
>  	struct user_namespace *fs_ns;
> @@ -379,14 +380,16 @@ int cap_inode_getsecurity(struct inode *inode, const char *name, void **buffer,
>  		return -EINVAL;
>  
>  	size = sizeof(struct vfs_ns_cap_data);
> -	ret = vfs_getxattr_alloc(dentry, "security.capability",
> +	ret = vfs_getxattr_alloc(dentry, XATTR_NAME_CAPS,
>  				 &tmpbuf, size, GFP_NOFS);
>  
>  	if (ret < 0)
>  		return ret;
>  
>  	fs_ns = inode->i_sb->s_user_ns;
> -	if (ret == sizeof(struct vfs_cap_data)) {
> +	cap = (struct vfs_cap_data *) tmpbuf;
> +	if ((ret == sizeof(struct vfs_cap_data)) &&
> +	    (cap->magic_etc == cpu_to_le32(VFS_CAP_REVISION_2))) {
>  		/* If this is sizeof(vfs_cap_data) then we're ok with the
>  		 * on-disk value, so return that.  */
>  		if (alloc)
> @@ -394,7 +397,8 @@ int cap_inode_getsecurity(struct inode *inode, const char *name, void **buffer,
>  		else
>  			kfree(tmpbuf);
>  		return ret;
> -	} else if (ret != sizeof(struct vfs_ns_cap_data)) {
> +	} else if ((ret != sizeof(struct vfs_ns_cap_data)) ||
> +		    (cap->magic_etc != cpu_to_le32(VFS_CAP_REVISION_3))) {
>  		kfree(tmpbuf);
>  		return -EINVAL;
>  	}
> @@ -417,7 +421,7 @@ int cap_inode_getsecurity(struct inode *inode, const char *name, void **buffer,
>  
>  	if (!rootid_owns_currentns(kroot)) {
>  		kfree(tmpbuf);
> -		return -EOPNOTSUPP;
> +		return -ENODATA;
>  	}
>  
>  	/* This comes from a parent namespace.  Return as a v2 capability */
> @@ -474,11 +478,17 @@ int cap_setxattr_convert_nscap(struct dentry *dentry, const void *value, size_t
>  		return -EINVAL;
>  	if (size != XATTR_CAPS_SZ_2 && size != XATTR_CAPS_SZ_3)
>  		return -EINVAL;
> +	if ((size == XATTR_CAPS_SZ_2) &&
> +	    (cap->magic_etc != cpu_to_le32(VFS_CAP_REVISION_2)))
> +		return -EINVAL;
> +	if ((size == XATTR_CAPS_SZ_3) &&
> +	    (cap->magic_etc != cpu_to_le32(VFS_CAP_REVISION_3)))
> +		return -EINVAL;
>  	if (!capable_wrt_inode_uidgid(inode, CAP_SETFCAP))
>  		return -EPERM;
>  	if (size == XATTR_CAPS_SZ_2)
>  		if (ns_capable(inode->i_sb->s_user_ns, CAP_SETFCAP))
> -			// user is privileged, just write the v2
> +			/* user is privileged, just write the v2 */
>  			return 0;
>  
>  	rootid = rootid_from_xattr(value, size, task_ns);
> @@ -855,7 +865,10 @@ int cap_inode_setxattr(struct dentry *dentry, const char *name,
>  			sizeof(XATTR_SECURITY_PREFIX) - 1) != 0)
>  		return 0;
>  
> -	// For XATTR_NAME_CAPS the check will be done in __vfs_setxattr_noperm()
> +	/*
> +	 * For XATTR_NAME_CAPS the check will be done in
> +	 * __vfs_setxattr_noperm()
> +	 */
>  	if (strcmp(name, XATTR_NAME_CAPS) == 0)
>  		return 0;
>  
> 
