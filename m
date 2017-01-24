From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH v3 2/2] nsfs: Add an ioctl() to return owner UID of a userns
Date: Wed, 25 Jan 2017 11:35:15 +1300
Message-ID: <87sho8gk7w.fsf@xmission.com>
References: <69550fe9-5347-309c-b421-79c16a6300f6@gmail.com>
        <daac6f7d-bc1e-bd61-355b-e47cf93e2535@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <daac6f7d-bc1e-bd61-355b-e47cf93e2535-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> (Michael
        Kerrisk's message of "Tue, 17 Jan 2017 14:03:29 +1300")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> I'd like to write code that discovers the user namespace hierarchy on
> a running system, and also shows who owns the various user namespaces.
> Currently, there is no way of getting the owner UID of a user
> namespace. Therefore, this patch adds an NS_GET_CREATOR_UID ioctl()
> that fetches the (munged) UID of the creator of the user namespace
> referred to by the specified file descriptor.
>
> If the supplied file descriptor does not refer to a user namespace,
> the operation fails with the error EINVAL.
>
> Acked-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> Signed-off-by: Michael Kerrisk <mtk-manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> ---
> Open questions:
>
> Should the type for the ioctl() argument be changed? I mean,
> make the following changes to the patch below:
>
> -       unsigned int __user *argp;
> +       uid_t __user *argp;
>
> And further below, change:
>
> -             argp = (unsigned int __user *) arg;
> +             argp = (uid_t __user *) arg;
>
> ?
>
> V3 changes:
> * Fixed data type of local variable 'uid'; thanks to Andrei Vagin
>
> V2 changes:
> * Renamed ioctl() from NS_CREATOR_UID to NS_OWNER_UID, at the
>   suggestion of Eric Biederman.
> * Make ioctl() return UID via buffer pointed to by argp. (Returning
>   the UID via the result value could lead to problems since a large
>   unsigned int UID might be misinterpreted as an error.) Thanks to
>   Andrei Vagin for pointing this out.
> ---
>  fs/nsfs.c                 | 11 +++++++++++
>  include/uapi/linux/nsfs.h |  8 +++++---
>  2 files changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/fs/nsfs.c b/fs/nsfs.c
> index 5d53476..63a4ad4 100644
> --- a/fs/nsfs.c
> +++ b/fs/nsfs.c
> @@ -7,6 +7,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/user_namespace.h>
>  #include <linux/nsfs.h>
> +#include <linux/uaccess.h>
>  
>  static struct vfsmount *nsfs_mnt;
>  
> @@ -163,7 +164,10 @@ int open_related_ns(struct ns_common *ns,
>  static long ns_ioctl(struct file *filp, unsigned int ioctl,
>  			unsigned long arg)
>  {
> +	struct user_namespace *user_ns;
>  	struct ns_common *ns = get_proc_ns(file_inode(filp));
> +	unsigned int __user *argp;
> +	uid_t uid;
>  
>  	switch (ioctl) {
>  	case NS_GET_USERNS:
> @@ -174,6 +178,13 @@ static long ns_ioctl(struct file *filp, unsigned int ioctl,
>  		return open_related_ns(ns, ns->ops->get_parent);
>  	case NS_GET_NSTYPE:
>  		return ns->ops->type;
> +	case NS_GET_OWNER_UID:
> +		if (ns->ops->type != CLONE_NEWUSER)
> +			return -EINVAL;
> +		user_ns = container_of(ns, struct user_namespace, ns);
> +		argp = (unsigned int __user *) arg;
> +		uid = from_kuid_munged(current_user_ns(), user_ns->owner);
> +		return put_user(uid, argp);

There is a question of how do we want to handle a uid that does not map.
For most interfaces that return uids the uid is one small part of
it so it is better if return the unmapped uid value.

Does this applie to NS_GET_OWNER_UID or do we perhaps want to do:

		user_ns = container_of(ns, struct user_namespace, ns);
                argp = (unsigned int __user *) arg;
                uid = from_kuid(current_user_ns(), user_ns->owner);
                if (uid == (uid_t)-1)
                	return -EOVERFLOW;
                return put_user(uid, argp);

Which of these variants would make handling this error easiest in your
introspection code?

I suspect return -EOVERFLOW would be easiest to handle.

Eric

                
>  	default:
>  		return -ENOTTY;
>  	}
> diff --git a/include/uapi/linux/nsfs.h b/include/uapi/linux/nsfs.h
> index 2b48df1..c4a925e 100644
> --- a/include/uapi/linux/nsfs.h
> +++ b/include/uapi/linux/nsfs.h
> @@ -6,11 +6,13 @@
>  #define NSIO	0xb7
>  
>  /* Returns a file descriptor that refers to an owning user namespace */
> -#define NS_GET_USERNS	_IO(NSIO, 0x1)
> +#define NS_GET_USERNS		_IO(NSIO, 0x1)
>  /* Returns a file descriptor that refers to a parent namespace */
> -#define NS_GET_PARENT	_IO(NSIO, 0x2)
> +#define NS_GET_PARENT		_IO(NSIO, 0x2)
>  /* Returns the type of namespace (CLONE_NEW* value) referred to by
>     file descriptor */
> -#define NS_GET_NSTYPE	_IO(NSIO, 0x3)
> +#define NS_GET_NSTYPE		_IO(NSIO, 0x3)
> +/* Get owner UID for a user namespace */
> +#define NS_GET_OWNER_UID	_IO(NSIO, 0x4)
>  
>  #endif /* __LINUX_NSFS_H */
