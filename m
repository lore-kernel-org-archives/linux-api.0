From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH RFC] user-namespaced file capabilities - now with even
	more magic
Date: Wed, 23 Nov 2016 17:01:23 -0600
Message-ID: <87r361ztq4.fsf@xmission.com>
References: <20161119151739.GA16398@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20161119151739.GA16398-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org> (Serge E. Hallyn's
	message of "Sat, 19 Nov 2016 09:17:39 -0600")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

"Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:

> Root in a user ns cannot be trusted to write a traditional
> security.capability xattr.  If it were allowed to do so, then any
> unprivileged user on the host could map his own uid to root in a
> namespace, write the xattr, and execute the file with privilege on the
> host.
>
> This patch introduces v3 of the security.capability xattr.  It builds a
> vfs_ns_cap_data struct by appending a uid_t rootid to struct
> vfs_cap_data.  This is the absolute uid_t (i.e. the uid_t in
> init_user_ns) of the root id (uid 0 in a namespace) in whose namespaces
> the file capabilities may take effect.
>
> When a task in a user ns (which is privileged with CAP_SETFCAP toward
> that user_ns) asks to write v2 security.capability, the kernel will
> transparently rewrite the xattr as a v3 with the appropriate rootid.
> Subsequently, any task executing the file which has the noted kuid as
> its root uid, or which is in a descendent user_ns of such a user_ns,
> will run the file with capabilities.
>
> If a task writes a v3 security.capability, then it can provide a
> uid (valid within its own user namespace, over which it has CAP_SETFCAP)
> for the xattr.  The kernel will translate that to the absolute uid, and
> write that to disk.  After this, a task in the writer's namespace will
> not be able to use those capabilities, but a task in a namespace where
> the given uid is root will.
>
> Only a single security.capability xattr may be written.  A task may
> overwrite the existing one so long as it was written by a user mapped
> into his own user_ns over which he has CAP_SETFCAP.
>
> This allows a simple setxattr to work, allows tar/untar to work, and
> allows us to tar in one namespace and untar in another while preserving
> the capability, without risking leaking privilege into a parent
> namespace.

Skimming through this, this looks good.  It is doing enough different
things I want to read through this carefully before applying it, but I
expect I will.

Thank you,
Eric


> Changelog:
>    Nov 02 2016: fix invalid check at refuse_fcap_overwrite()
>    Nov 07 2016: convert rootid from and to fs user_ns
> ---
>  fs/xattr.c                      |  27 +++-
>  include/linux/capability.h      |   5 +-
>  include/linux/security.h        |   2 +
>  include/uapi/linux/capability.h |  22 ++-
>  security/commoncap.c            | 335 ++++++++++++++++++++++++++++++++++++++--
>  5 files changed, 366 insertions(+), 25 deletions(-)
>
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 2d13b4e..e9e70f1 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -171,11 +171,27 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
>  {
>  	struct inode *inode = dentry->d_inode;
>  	int error = -EAGAIN;
> +	void *wvalue = NULL;
> +	size_t wsize = 0;
>  	int issec = !strncmp(name, XATTR_SECURITY_PREFIX,
>  				   XATTR_SECURITY_PREFIX_LEN);
>  
> -	if (issec)
> +	if (issec) {
>  		inode->i_flags &= ~S_NOSEC;
> +
> +		/* if root in a non-init user_ns tries to set
> +		 * security.capability, write the virtualized
> +		 * xattr in its place */
> +		if (!strcmp(name, "security.capability") &&
> +				current_user_ns() != &init_user_ns) {
> +			cap_setxattr_make_nscap(dentry, value, size, &wvalue, &wsize);
> +			if (!wvalue)
> +				return -EPERM;
> +			value = wvalue;
> +			size = wsize;
> +		}
> +	}
> +
>  	if (inode->i_opflags & IOP_XATTR) {
>  		error = __vfs_setxattr(dentry, inode, name, value, size, flags);
>  		if (!error) {
> @@ -184,8 +200,10 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
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
> @@ -200,10 +218,11 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
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
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index dbc21c7..edd5be1 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -13,7 +13,7 @@
>  #define _LINUX_CAPABILITY_H
>  
>  #include <uapi/linux/capability.h>
> -
> +#include <linux/uidgid.h>
>  
>  #define _KERNEL_CAPABILITY_VERSION _LINUX_CAPABILITY_VERSION_3
>  #define _KERNEL_CAPABILITY_U32S    _LINUX_CAPABILITY_U32S_3
> @@ -246,4 +246,7 @@ extern bool file_ns_capable(const struct file *file, struct user_namespace *ns,
>  /* audit system wants to get cap info from files as well */
>  extern int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps);
>  
> +extern void cap_setxattr_make_nscap(struct dentry *dentry, const void *value,
> +		size_t size, void **wvalue, size_t *wsize);
> +
>  #endif /* !_LINUX_CAPABILITY_H */
> diff --git a/include/linux/security.h b/include/linux/security.h
> index c2125e9..3127531 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -86,6 +86,8 @@ extern int cap_inode_setxattr(struct dentry *dentry, const char *name,
>  extern int cap_inode_removexattr(struct dentry *dentry, const char *name);
>  extern int cap_inode_need_killpriv(struct dentry *dentry);
>  extern int cap_inode_killpriv(struct dentry *dentry);
> +extern int cap_inode_getsecurity(struct inode *inode, const char *name,
> +				 void **buffer, bool alloc);
>  extern int cap_mmap_addr(unsigned long addr);
>  extern int cap_mmap_file(struct file *file, unsigned long reqprot,
>  			 unsigned long prot, unsigned long flags);
> diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
> index 49bc062..fd4f87d 100644
> --- a/include/uapi/linux/capability.h
> +++ b/include/uapi/linux/capability.h
> @@ -60,9 +60,13 @@ typedef struct __user_cap_data_struct {
>  #define VFS_CAP_U32_2           2
>  #define XATTR_CAPS_SZ_2         (sizeof(__le32)*(1 + 2*VFS_CAP_U32_2))
>  
> -#define XATTR_CAPS_SZ           XATTR_CAPS_SZ_2
> -#define VFS_CAP_U32             VFS_CAP_U32_2
> -#define VFS_CAP_REVISION	VFS_CAP_REVISION_2
> +#define VFS_CAP_REVISION_3	0x03000000
> +#define VFS_CAP_U32_3           2
> +#define XATTR_CAPS_SZ_3         (sizeof(__le32)*(2 + 2*VFS_CAP_U32_3))
> +
> +#define XATTR_CAPS_SZ           XATTR_CAPS_SZ_3
> +#define VFS_CAP_U32             VFS_CAP_U32_3
> +#define VFS_CAP_REVISION	VFS_CAP_REVISION_3
>  
>  struct vfs_cap_data {
>  	__le32 magic_etc;            /* Little endian */
> @@ -72,6 +76,18 @@ struct vfs_cap_data {
>  	} data[VFS_CAP_U32];
>  };
>  
> +/*
> + * same as vfs_cap_data but with a rootid at the end
> + */
> +struct vfs_ns_cap_data {
> +	__le32 magic_etc;
> +	struct {
> +		__le32 permitted;    /* Little endian */
> +		__le32 inheritable;  /* Little endian */
> +	} data[VFS_CAP_U32];
> +	__le32 rootid;
> +};
> +
>  #ifndef __KERNEL__
>  
>  /*
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 8df676f..1f189b2 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -332,6 +332,272 @@ int cap_inode_killpriv(struct dentry *dentry)
>  	return error;
>  }
>  
> +static bool rootid_owns_currentns(kuid_t kroot)
> +{
> +	struct user_namespace *ns;
> +
> +	if (!uid_valid(kroot))
> +		return false;
> +
> +	for (ns = current_user_ns(); ; ns = ns->parent) {
> +		if (from_kuid(ns, kroot) == 0) {
> +			return true;
> +		}
> +		if (ns == &init_user_ns)
> +			break;
> +	}
> +
> +	return false;
> +}
> +
> +static char *cap_convert_v2_v3(char *buf, struct inode *inode)
> +{
> +	char *ret;
> +	struct vfs_ns_cap_data *v3;
> +	struct vfs_cap_data *v2 = (struct vfs_cap_data *)buf;
> +	kuid_t krootid;
> +
> +	krootid = make_kuid(inode->i_sb->s_user_ns, 0);
> +	if (!uid_valid(krootid)) {
> +		ret = ERR_PTR(-EPERM);
> +		goto out;
> +	}
> +	ret = kmalloc(sizeof(struct vfs_ns_cap_data), GFP_NOFS);
> +	if (!ret) {
> +		ret = ERR_PTR(-ENOMEM);
> +		goto out;
> +	}
> +	v3 = (struct vfs_ns_cap_data *)ret;
> +
> +	memcpy(&v3->data, &v2->data, sizeof(v2->data));
> +	v3->magic_etc = VFS_CAP_REVISION_3;
> +	if (v2->magic_etc & VFS_CAP_FLAGS_EFFECTIVE)
> +		v3->magic_etc |= VFS_CAP_FLAGS_EFFECTIVE;
> +	v3->rootid = from_kuid(&init_user_ns, krootid);
> +
> +out:
> +	kfree(buf);
> +	return ret;
> +}
> +
> +/*
> + * getsecurity: We are called for security.* before any attempt to read the
> + * xattr from the inode itself.
> + *
> + * This gives us a chance to read the on-disk value and convert it.  If we
> + * return -EOPNOTSUPP, then vfs_getxattr() will call the i_op handler.
> + *
> + * Note we are not called by vfs_getxattr_alloc(), but that is only called
> + * by the integrity subsystem, which really wants the unconverted values -
> + * so that's good.
> + */
> +int cap_inode_getsecurity(struct inode *inode, const char *name, void **buffer,
> +			  bool alloc)
> +{
> +	int size, ret;
> +	kuid_t kroot;
> +	uid_t root, mappedroot;
> +	char *tmpbuf = NULL;
> +	struct vfs_ns_cap_data *nscap;
> +	struct dentry *dentry;
> +	struct user_namespace *fs_ns;
> +
> +	if (!inode->i_op->getxattr)
> +		return -EOPNOTSUPP;
> +
> +	if (strcmp(name, "capability") != 0)
> +		return -EOPNOTSUPP;
> +
> +	dentry = d_find_alias(inode);
> +	if (!dentry)
> +		return -EINVAL;
> +
> +	size = sizeof(struct vfs_ns_cap_data);
> +	ret = vfs_getxattr_alloc(dentry, "security.capability",
> +				 &tmpbuf, size, GFP_NOFS);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	fs_ns = inode->i_sb->s_user_ns;
> +	if (ret == sizeof(struct vfs_cap_data) && fs_ns == &init_user_ns) {
> +		/* If this is sizeof(vfs_cap_data) then we're ok with the
> +		 * on-disk value, so return that.  */
> +		if (alloc)
> +			*buffer = tmpbuf;
> +		else
> +			kfree(tmpbuf);
> +		return ret;
> +	} else if (ret == sizeof(struct vfs_cap_data)) {
> +		tmpbuf = cap_convert_v2_v3(tmpbuf, inode);
> +		if (!tmpbuf)
> +			return -EPERM;
> +	} else if (ret != size) {
> +		kfree(tmpbuf);
> +		return -EINVAL;
> +	}
> +
> +	nscap = (struct vfs_ns_cap_data *) tmpbuf;
> +	root = le32_to_cpu(nscap->rootid);
> +	kroot = make_kuid(fs_ns, root);
> +
> +	/* If the root kuid maps to a valid uid in current ns, then return
> +	 * this as a nscap. */
> +	mappedroot = from_kuid(current_user_ns(), kroot);
> +	if (mappedroot != (uid_t)-1) {
> +		if (alloc) {
> +			*buffer = tmpbuf;
> +			nscap->rootid = cpu_to_le32(mappedroot);
> +		} else
> +			kfree(tmpbuf);
> +		return size;
> +	}
> +
> +	if (!rootid_owns_currentns(kroot)) {
> +		kfree(tmpbuf);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	/* This comes from a parent namespace.  Return as a v2 capability */
> +	size = sizeof(struct vfs_cap_data);
> +	if (alloc) {
> +		*buffer = kmalloc(size, GFP_ATOMIC);
> +		if (*buffer) {
> +			struct vfs_cap_data *cap = *buffer;
> +			__le32 nsmagic, magic;
> +			magic = VFS_CAP_REVISION_2;
> +			nsmagic = le32_to_cpu(nscap->magic_etc);
> +			if (nsmagic & VFS_CAP_FLAGS_EFFECTIVE)
> +				magic |= VFS_CAP_FLAGS_EFFECTIVE;
> +			memcpy(&cap->data, &nscap->data, sizeof(__le32) * 2 * VFS_CAP_U32);
> +			cap->magic_etc = cpu_to_le32(magic);
> +		}
> +	}
> +	kfree(tmpbuf);
> +	return size;
> +}
> +
> +/*
> + * Root can only overwite an existing security.capability xattr
> + * if it is privileged over the root listed in the xattr
> + * Note we've already checked for ns_capable(CAP_SETFCAP) in the
> + * !capable_wrt_inode_uidgid() call by the caller, so we do not
> + * check for that here.
> + */
> +static bool refuse_fcap_overwrite(struct inode *inode)
> +{
> +	void *tmpbuf;
> +	int ret;
> +	uid_t root;
> +	kuid_t kroot;
> +	struct vfs_ns_cap_data *nscap;
> +	__u32 magic_etc;
> +	bool should_refuse;
> +	struct user_namespace *fs_ns = inode->i_sb->s_user_ns;
> +
> +	ret = cap_inode_getsecurity(inode, "capability", &tmpbuf, true);
> +	if (ret < 0)
> +		return false;
> +	if (ret == sizeof(struct vfs_cap_data) && fs_ns == &init_user_ns) {
> +		/*
> +		 * host-root-installed capability, user-namespace-root may
> +		 * not overwrite this.
> +		 * TODO - if inode->i_sb->s_user_ns != &init_user_ns we do
> +		 * in fact want to allow it.
> +		 */
> +		kfree(tmpbuf);
> +		return true;
> +	}
> +	if (ret < sizeof(struct vfs_ns_cap_data)) {
> +		/* Corrupt fscap.  Caller is privileged wrt inode, permit fixup */
> +		kfree(tmpbuf);
> +		return false;
> +	}
> +
> +	nscap = (struct vfs_ns_cap_data *)tmpbuf;
> +
> +	magic_etc = le32_to_cpu(nscap->magic_etc);
> +	if ((magic_etc & VFS_CAP_REVISION_MASK) != VFS_CAP_REVISION_3) {
> +		/*
> +		 * This version is newer than we know about - i.e. from a newer
> +		 * kernel.  Don't overwrite.
> +		*/
> +		kfree(tmpbuf);
> +		return true;
> +	}
> +	if (ret != sizeof(struct vfs_ns_cap_data)) {
> +		/* Corrupt v4 fscap.  Permit fixup */
> +		kfree(tmpbuf);
> +		return false;
> +	}
> +	root = le32_to_cpu(nscap->rootid);
> +	kroot = make_kuid(&init_user_ns, root);
> +	should_refuse = !kuid_has_mapping(current_user_ns(), kroot);
> +	kfree(tmpbuf);
> +	return should_refuse;
> +}
> +
> +static kuid_t rootid_from_xattr(const void *value, size_t size,
> +				struct user_namespace *task_ns)
> +{
> +	const struct vfs_ns_cap_data *nscap = value;
> +	uid_t rootid = 0;
> +
> +	if (size == XATTR_CAPS_SZ_3)
> +		rootid = le32_to_cpu(nscap->rootid);
> +
> +	return make_kuid(task_ns, rootid);
> +}
> +
> +/*
> + * Use requested a write of security.capability but is in a non-init
> + * userns.  So we construct and write a v4.
> + *
> + * If all is ok, wvalue has an allocated new value.  Otherwise, wvalue
> + * is NULL.
> + */
> +void cap_setxattr_make_nscap(struct dentry *dentry, const void *value, size_t size,
> +				    void **wvalue, size_t *wsize)
> +{
> +	struct vfs_ns_cap_data *nscap;
> +	const struct vfs_cap_data *cap = value;
> +	__u32 magic, nsmagic;
> +	struct inode *inode = d_backing_inode(dentry);
> +	struct user_namespace *task_ns = current_user_ns(),
> +		*fs_ns = inode->i_sb->s_user_ns;
> +	kuid_t rootid;
> +
> +	if (!value)
> +		return;
> +	if (size != XATTR_CAPS_SZ_2 && size != XATTR_CAPS_SZ_3)
> +		return;
> +	if (!capable_wrt_inode_uidgid(inode, CAP_SETFCAP))
> +		return;
> +
> +	/* refuse if security.capability exists */
> +	if (refuse_fcap_overwrite(inode))
> +		return;
> +
> +	rootid = rootid_from_xattr(value, size, task_ns);
> +	if (!uid_valid(rootid))
> +		return;
> +
> +	*wsize = sizeof(struct vfs_ns_cap_data);
> +	nscap = kmalloc(*wsize, GFP_ATOMIC);
> +	if (!nscap)
> +		return;
> +	nscap->rootid = cpu_to_le32(from_kuid(fs_ns, rootid));
> +	nsmagic = VFS_CAP_REVISION_3;
> +	magic = le32_to_cpu(cap->magic_etc);
> +	if (magic & VFS_CAP_FLAGS_EFFECTIVE)
> +		nsmagic |= VFS_CAP_FLAGS_EFFECTIVE;
> +	nscap->magic_etc = cpu_to_le32(nsmagic);
> +	memcpy(&nscap->data, &cap->data, sizeof(__le32) * 2 * VFS_CAP_U32);
> +
> +	*wvalue = nscap;
> +	return;
> +}
> +
>  /*
>   * Calculate the new process capability sets from the capability sets attached
>   * to a file.
> @@ -385,7 +651,10 @@ int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data
>  	__u32 magic_etc;
>  	unsigned tocopy, i;
>  	int size;
> -	struct vfs_cap_data caps;
> +	struct vfs_ns_cap_data data, *nscaps = &data;
> +	struct vfs_cap_data *caps = (struct vfs_cap_data *) &data;
> +	kuid_t rootkuid;
> +	struct user_namespace *fs_ns = inode->i_sb->s_user_ns;
>  
>  	memset(cpu_caps, 0, sizeof(struct cpu_vfs_cap_data));
>  
> @@ -393,17 +662,18 @@ int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data
>  		return -ENODATA;
>  
>  	size = __vfs_getxattr((struct dentry *)dentry, inode,
> -			      XATTR_NAME_CAPS, &caps, XATTR_CAPS_SZ);
> +			      XATTR_NAME_CAPS, &data, XATTR_CAPS_SZ);
>  	if (size == -ENODATA || size == -EOPNOTSUPP)
>  		/* no data, that's ok */
>  		return -ENODATA;
> +
>  	if (size < 0)
>  		return size;
>  
>  	if (size < sizeof(magic_etc))
>  		return -EINVAL;
>  
> -	cpu_caps->magic_etc = magic_etc = le32_to_cpu(caps.magic_etc);
> +	cpu_caps->magic_etc = magic_etc = le32_to_cpu(caps->magic_etc);
>  
>  	switch (magic_etc & VFS_CAP_REVISION_MASK) {
>  	case VFS_CAP_REVISION_1:
> @@ -414,8 +684,25 @@ int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data
>  	case VFS_CAP_REVISION_2:
>  		if (size != XATTR_CAPS_SZ_2)
>  			return -EINVAL;
> +		if (fs_ns != &init_user_ns) {
> +			/* unpriv user mounted this fs;  make sure they
> +			 * own current user_ns */
> +			rootkuid = make_kuid(fs_ns, 0);
> +			if (!rootid_owns_currentns(rootkuid))
> +				return -ENODATA;
> +		}
>  		tocopy = VFS_CAP_U32_2;
>  		break;
> +	case VFS_CAP_REVISION_3:
> +		if (size != XATTR_CAPS_SZ_3)
> +			return -EINVAL;
> +		tocopy = VFS_CAP_U32_3;
> +
> +		rootkuid = make_kuid(fs_ns, le32_to_cpu(nscaps->rootid));
> +		if (!rootid_owns_currentns(rootkuid))
> +			return -ENODATA;
> +		break;
> +
>  	default:
>  		return -EINVAL;
>  	}
> @@ -423,8 +710,8 @@ int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data
>  	CAP_FOR_EACH_U32(i) {
>  		if (i >= tocopy)
>  			break;
> -		cpu_caps->permitted.cap[i] = le32_to_cpu(caps.data[i].permitted);
> -		cpu_caps->inheritable.cap[i] = le32_to_cpu(caps.data[i].inheritable);
> +		cpu_caps->permitted.cap[i] = le32_to_cpu(caps->data[i].permitted);
> +		cpu_caps->inheritable.cap[i] = le32_to_cpu(caps->data[i].inheritable);
>  	}
>  
>  	cpu_caps->permitted.cap[CAP_LAST_U32] &= CAP_LAST_U32_VALID_MASK;
> @@ -462,8 +749,8 @@ static int get_file_caps(struct linux_binprm *bprm, bool *effective, bool *has_c
>  	rc = get_vfs_caps_from_disk(bprm->file->f_path.dentry, &vcaps);
>  	if (rc < 0) {
>  		if (rc == -EINVAL)
> -			printk(KERN_NOTICE "%s: get_vfs_caps_from_disk returned %d for %s\n",
> -				__func__, rc, bprm->filename);
> +			printk(KERN_NOTICE "Invalid argument reading file caps for %s\n",
> +					bprm->filename);
>  		else if (rc == -ENODATA)
>  			rc = 0;
>  		goto out;
> @@ -659,15 +946,21 @@ int cap_bprm_secureexec(struct linux_binprm *bprm)
>  int cap_inode_setxattr(struct dentry *dentry, const char *name,
>  		       const void *value, size_t size, int flags)
>  {
> -	if (!strcmp(name, XATTR_NAME_CAPS)) {
> -		if (!capable(CAP_SETFCAP))
> +	/* Ignore non-security xattrs */
> +	if (strncmp(name, XATTR_SECURITY_PREFIX,
> +			sizeof(XATTR_SECURITY_PREFIX) - 1) != 0)
> +		return 0;
> +
> +	if (strcmp(name, XATTR_NAME_CAPS) == 0) {
> +		/* Write from initial user_ns will in * __vfs_setxattr_noperm()
> +		 * be diverted to a nscap write.  But from initial user_ns we
> +		 * require CAP_SETFCAP targeted at init_user_ns */
> +		if (current_user_ns() == &init_user_ns && !capable(CAP_SETFCAP))
>  			return -EPERM;
>  		return 0;
>  	}
>  
> -	if (!strncmp(name, XATTR_SECURITY_PREFIX,
> -		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
> -	    !capable(CAP_SYS_ADMIN))
> +	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  	return 0;
>  }
> @@ -685,15 +978,22 @@ int cap_inode_setxattr(struct dentry *dentry, const char *name,
>   */
>  int cap_inode_removexattr(struct dentry *dentry, const char *name)
>  {
> -	if (!strcmp(name, XATTR_NAME_CAPS)) {
> -		if (!capable(CAP_SETFCAP))
> +	/* Ignore non-security xattrs */
> +	if (strncmp(name, XATTR_SECURITY_PREFIX,
> +			sizeof(XATTR_SECURITY_PREFIX) - 1) != 0)
> +		return 0;
> +
> +	if (strcmp(name, XATTR_NAME_CAPS) == 0) {
> +		/* security.capability gets namespaced */
> +		struct inode *inode = d_backing_inode(dentry);
> +		if (!inode)
> +			return -EINVAL;
> +		if (!capable_wrt_inode_uidgid(inode, CAP_SETFCAP))
>  			return -EPERM;
>  		return 0;
>  	}
>  
> -	if (!strncmp(name, XATTR_SECURITY_PREFIX,
> -		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
> -	    !capable(CAP_SYS_ADMIN))
> +	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  	return 0;
>  }
> @@ -1081,6 +1381,7 @@ struct security_hook_list capability_hooks[] = {
>  	LSM_HOOK_INIT(bprm_secureexec, cap_bprm_secureexec),
>  	LSM_HOOK_INIT(inode_need_killpriv, cap_inode_need_killpriv),
>  	LSM_HOOK_INIT(inode_killpriv, cap_inode_killpriv),
> +	LSM_HOOK_INIT(inode_getsecurity, cap_inode_getsecurity),
>  	LSM_HOOK_INIT(mmap_addr, cap_mmap_addr),
>  	LSM_HOOK_INIT(mmap_file, cap_mmap_file),
>  	LSM_HOOK_INIT(task_fix_setuid, cap_task_fix_setuid),
