From: Andrei Vagin <avagin@virtuozzo.com>
Subject: Re: [PATCH 2/2] nsfs: Add an ioctl() to return creator UID of a
 userns
Date: Tue, 20 Dec 2016 19:13:16 -0800
Message-ID: <20161221031315.GB20983@outlook.office365.com>
References: <fdce894d-8385-b4b4-da3c-6282a7e4ecba@gmail.com>
 <46b85444-dc97-17a3-4445-439923936450@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <46b85444-dc97-17a3-4445-439923936450@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, "W. Trevor King" <wking@tremily.us>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 19, 2016 at 03:38:35PM +0100, Michael Kerrisk (man-pages) wrote:
> # Some open questions about this patch below.
> #
> One of the rules regarding capabilities is:
> 
>     A process that resides in the parent of the user namespace and
>     whose effective user ID matches the owner of the namespace has
>     all capabilities in the namespace.
> 
> Therefore, in order to write code that discovers whether process X has
> capabilities in namespace Y, we need a way to find out who the creator
> of a user namespace is. This patch adds an NS_GET_CREATOR_UID ioctl()
> that returns the (munged) UID of the creator of the user namespace
> referred to by the specified file descriptor.
> 
> If the supplied file descriptor does not refer to a user namespace,
> the operation fails with the error EINVAL.
> 
> Signed-off-by: Michael Kerrisk <mtk-manpages@gmail.com>
> ---
>  fs/nsfs.c                 | 6 ++++++
>  include/uapi/linux/nsfs.h | 8 +++++---
>  2 files changed, 11 insertions(+), 3 deletions(-)
> 
> Open questions:
> 
> * Would it be preferabe to separate the logic for NS_GET_CREATOR_UID
>   into a small helper function?
> * Is this a correct use of container_of()? I did not immediately
>   see another way to get to the user_namespace struct, but I
>   may well have missed something.
> 
> diff --git a/fs/nsfs.c b/fs/nsfs.c
> index 5d53476..26f6d94 100644
> --- a/fs/nsfs.c
> +++ b/fs/nsfs.c
> @@ -163,6 +163,7 @@ int open_related_ns(struct ns_common *ns,
>  static long ns_ioctl(struct file *filp, unsigned int ioctl,
>  			unsigned long arg)
>  {
> +	struct user_namespace *user_ns;
>  	struct ns_common *ns = get_proc_ns(file_inode(filp));
>  
>  	switch (ioctl) {
> @@ -174,6 +175,11 @@ static long ns_ioctl(struct file *filp, unsigned int ioctl,
>  		return open_related_ns(ns, ns->ops->get_parent);
>  	case NS_GET_NSTYPE:
>  		return ns->ops->type;
> +	case NS_GET_CREATOR_UID:
> +		if (ns->ops->type != CLONE_NEWUSER)
> +			return -EINVAL;
> +		user_ns = container_of(ns, struct user_namespace, ns);
> +		return from_kuid_munged(current_user_ns(), user_ns->owner);

uid_t is "unsigned int", ioctl() returns long, so it may be hard to
distinguish user id-s from errors on x32.

off-topic: What is about user_ns->group? I can't find where it is used...

>  	default:
>  		return -ENOTTY;
>  	}
> diff --git a/include/uapi/linux/nsfs.h b/include/uapi/linux/nsfs.h
> index 2b48df1..b3c6c78 100644
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
> +/* Get creator UID for a user namespace */
> +#define NS_GET_CREATOR_UID	_IO(NSIO, 0x4)
>  
>  #endif /* __LINUX_NSFS_H */
> -- 
> 2.5.5
> 
