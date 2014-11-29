From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFC PATCH] userns: Disallow setgroups unless the gid_map writer is privileged
Date: Sat, 29 Nov 2014 10:16:23 -0600
Message-ID: <87vblym17s.fsf@x220.int.ebiederm.org>
References: <81ba656ffbdc62a7f7e94ad17f0238ee063fe6b3.1417214430.git.luto@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <81ba656ffbdc62a7f7e94ad17f0238ee063fe6b3.1417214430.git.luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
	(Andy Lutomirski's message of "Fri, 28 Nov 2014 14:53:20 -0800")
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:

The patch is buggy.

Nacked-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>

> ---
>
> Eric, this is an alternative to your patch.  I think it will cause
> less breakage, and it will keep unprivileged user namespaces
> more or less fully functional.
>
> Kenton, I think that neither run-bundle nor supervisor-main will be
> broken by this patch.
>
>  include/linux/user_namespace.h |  3 +++
>  kernel/groups.c                |  3 +++
>  kernel/user.c                  |  1 +
>  kernel/user_namespace.c        | 36 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 43 insertions(+)
>
> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
> index e95372654f09..a74c1f3d44fe 100644
> --- a/include/linux/user_namespace.h
> +++ b/include/linux/user_namespace.h
> @@ -17,6 +17,8 @@ struct uid_gid_map {	/* 64 bytes -- 1 cache line */
>  	} extent[UID_GID_MAP_MAX_EXTENTS];
>  };
>  
> +#define USERNS_SETGROUPS_ALLOWED 1
> +
>  struct user_namespace {
>  	struct uid_gid_map	uid_map;
>  	struct uid_gid_map	gid_map;
> @@ -27,6 +29,7 @@ struct user_namespace {
>  	kuid_t			owner;
>  	kgid_t			group;
>  	unsigned int		proc_inum;
> +	unsigned int		flags;

If you are going to add a flags field it needs to be atomic as otherwise
changing or reading individual flags won't be safe without a lock.

>  	/* Register of per-UID persistent keyrings for this namespace */
>  #ifdef CONFIG_PERSISTENT_KEYRINGS
> diff --git a/kernel/groups.c b/kernel/groups.c
> index 451698f86cfa..e27433809978 100644
> --- a/kernel/groups.c
> +++ b/kernel/groups.c
> @@ -6,6 +6,7 @@
>  #include <linux/slab.h>
>  #include <linux/security.h>
>  #include <linux/syscalls.h>
> +#include <linux/user_namespace.h>
>  #include <asm/uaccess.h>
>  
>  /* init to 2 - one for init_task, one to ensure it is never freed */
> @@ -223,6 +224,8 @@ SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
>  	struct group_info *group_info;
>  	int retval;
>  
> +	if (!(current_user_ns()->flags & USERNS_SETGROUPS_ALLOWED))
> +		return -EPERM;
>  	if (!ns_capable(current_user_ns(), CAP_SETGID))
>  		return -EPERM;
>  	if ((unsigned)gidsetsize > NGROUPS_MAX)
> diff --git a/kernel/user.c b/kernel/user.c
> index 4efa39350e44..f8cdb1ec6049 100644
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -51,6 +51,7 @@ struct user_namespace init_user_ns = {
>  	.owner = GLOBAL_ROOT_UID,
>  	.group = GLOBAL_ROOT_GID,
>  	.proc_inum = PROC_USER_INIT_INO,
> +	.flags = USERNS_SETGROUPS_ALLOWED,
>  #ifdef CONFIG_PERSISTENT_KEYRINGS
>  	.persistent_keyring_register_sem =
>  	__RWSEM_INITIALIZER(init_user_ns.persistent_keyring_register_sem),
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index aa312b0dc3ec..6e7b9ee5bddc 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -600,6 +600,8 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>  	unsigned long page = 0;
>  	char *kbuf, *pos, *next_line;
>  	ssize_t ret = -EINVAL;
> +	unsigned int gid_flags = 0;
> +	bool seen_explicit_gid_flag = false;
>  
>  	/*
>  	 * The id_map_mutex serializes all writes to any given map.
> @@ -633,6 +635,19 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>  	if (cap_valid(cap_setid) && !file_ns_capable(file, ns, CAP_SYS_ADMIN))
>  		goto out;
>  
> +	/* Deal with supplementary groups. */
> +	if (map == &ns->gid_map) {
> +		/*
> +		 * By default, setgroups is allowed inside the userns
> +		 * if the writer has no supplementary groups (making
> +		 * it useless) or if the writer is privileged.
> +		 */
> +		if ((ns->parent->flags & USERNS_SETGROUPS_ALLOWED) &&
> +		    file_ns_capable(file, ns->parent, CAP_SETGID) &&
> +		    ns_capable(ns->parent, CAP_SETGID))
> +			gid_flags = USERNS_SETGROUPS_ALLOWED;

We can't do this.

It is wrong to mix permissions and flags to request functionality.

That way lies madness, and impossible maintenance, and it will silently
break every application that expects setgroups to work if they have
CAP_SETGID after a mapping has been established.

> +	}
> +
>  	/* Get a buffer */
>  	ret = -ENOMEM;
>  	page = __get_free_page(GFP_TEMPORARY);
> @@ -667,6 +682,25 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>  				next_line = NULL;
>  		}
>  
> +		/* Is this line a gid_map option? */
> +		if (map == &ns->gid_map) {
> +			if (!strcmp(pos, "setgroups deny")) {
> +				if (seen_explicit_gid_flag)
> +					goto out;
> +				seen_explicit_gid_flag = 1;
> +				gid_flags = 0;
> +				continue;
> +			} else if (!strcmp(pos, "setgroups allow")) {
> +				if (seen_explicit_gid_flag)
> +					goto out;
> +				if (!(gid_flags & USERNS_SETGROUPS_ALLOWED)) {
> +					ret = -EPERM;
> +					goto out;
> +				}
> +				continue;
> +			}
> +		}
> +
>  		pos = skip_spaces(pos);
>  		extent->first = simple_strtoul(pos, &pos, 10);
>  		if (!isspace(*pos))
> @@ -746,6 +780,8 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>  		new_map.nr_extents*sizeof(new_map.extent[0]));
>  	smp_wmb();
>  	map->nr_extents = new_map.nr_extents;
> +	if (map == &ns->gid_map)
> +		ns->flags |= gid_flags;
>  
>  	*ppos = count;
>  	ret = count;

Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
