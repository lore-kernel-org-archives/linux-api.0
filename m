From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH v2] userns: Disallow setgroups unless the gid_map writer
	is privileged
Date: Tue, 02 Dec 2014 06:09:51 -0600
Message-ID: <87h9xez20g.fsf@x220.int.ebiederm.org>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
	(Andy Lutomirski's message of "Sat, 29 Nov 2014 09:26:37 -0800")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:

> Classic unix permission checks have an interesting feature.  The
> group permissions for a file can be set to less than the other
> permissions on a file.  Occasionally this is used deliberately to
> give a certain group of users fewer permissions than the default.
>
> User namespaces break this usage.  Groups set in rgid or egid are
> unaffected because an unprivileged user namespace creator can only
> map a single group, so setresgid inside and outside the namespace
> have the same effect.  However, an unprivileged user namespace
> creator can currently use setgroups(2) to drop all supplementary
> groups, so, if a supplementary group denies access to some resource,
> user namespaces can be used to bypass that restriction.
>
> To fix this issue, this introduces a new user namespace flag
> USERNS_SETGROUPS_ALLOWED.  If that flag is not set, then
> setgroups(2) will fail regardless of the caller's capabilities.
>
> USERNS_SETGROUPS_ALLOWED is cleared in a new user namespace.  By
> default, if the writer of gid_map has CAP_SETGID in the parent
> userns and the parent userns has USERNS_SETGROUPS_ALLOWED, then the
> USERNS_SETGROUPS_ALLOWED will be set in the child.  If the writer is
> not so privileged, then writing to gid_map will fail unless the
> writer adds "setgroups deny" to gid_map, in which case the check is
> skipped but USERNS_SETGROUPS_ALLOWED will remain cleared.
>
> The full semantics are:
>
> If "setgroups allow" is present or no explicit "setgroups" setting
> is written to gid_map, then writing to gid_map will fail with -EPERM
> unless the opener and writer have CAP_SETGID in the parent namespace
> and the parent namespace has USERNS_SETGROUPS_ALLOWED.
>
> If "setgroups deny" is present, then writing gid_map will work as
> before, but USERNS_SETGROUPS_ALLOWED will remain cleared.  This will
> result in processes in the userns that have CAP_SETGID to be
> nontheless unable to use setgroups(2).  If this breaks something
> inside the userns, then this is okay -- the userns creator
> specifically requested this behavior.

I think we need to do this but I also think setgroups allow/deny
should be a separate knob than the uid/gid mapping.

If for no other reason than you missed at least two implementations of
setgroups, in your implementation.

> While it could be safe to set USERNS_SETGROUPS_ALLOWED if the user
> namespace creator has no supplementary groups, doing so could be
> surprising and could have unpleasant interactions with setns(2).
>
> Any application that uses newgidmap(1) should be unaffected by this
> fix, but unprivileged users that create user namespaces to
> manipulate mounts or sandbox themselves will break until they start
> using "setgroups deny".
>
> This should fix CVE-2014-8989.
>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> ---
>
> Unlike v1, this *will* break things like Sandstorm.  Fixing them will be
> easy.  I agree that this will result in better long-term semantics, but
> I'm not so happy about breaking working software.

I know what you mean.   One of the pieces of software broken by all of
this is my test to verify the remount semantics.   Which makes all of
this very unfortunate.

> If this is unpalatable, here's a different option: get rid of all these
> permission checks and just change setgroups.  Specifically, make it so
> that setgroups(2) in a userns will succeed but will silently refuse to
> remove unmapped groups.

Nope silently refusing to remove unmapped groups is not enough.  I can
make any gid in my supplemental groups my egid, it takes a sgid helper
application but I don't need any special privileges to create that.
Once that group is my egid I can map it.  Which means I could drop
any one group of my choosing without privielges.  Which out and out
breaks negative groups :(

I got to looking and I have a significant piece of code that all of this
breaks.

tools/testing/selftests/mount/unprivileged-remount-test.c

So I am extra motivated to figure out at find a way to preserve most of
the existing functionality.  My regression tests won't pass until I can
find something pallateable.

It is very annoying that every option I have considered so far breaks
something useful.

Having a write once setgroups disable, and the allowing unprivileged
mappings after that seems the most palatable option I have seen,
semantically.  Which means existing software that doesn't care about
setgroups can just add the disable code and then work otherwise
unmodified.

The other option that I have played with is forcing a set of groups
in setgroups if your user namespace was created without privilege,
that winds up requiring that verify you don't have any other
supplementary groups, and is generally messy whichever way I look at it.

*Pounds head on desk*

What a mess.

Eric

> Changes from v1:
>  - Userns flags are now properly atomic.
>  - "setgroups allow" is now the default, so legacy unprivileged gid_map
>    writers will start to fail.
>
>  include/linux/user_namespace.h |  3 +++
>  kernel/groups.c                |  3 +++
>  kernel/user.c                  |  1 +
>  kernel/user_namespace.c        | 42 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 49 insertions(+)
>
> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
> index e95372654f09..0ae4a8c97165 100644
> --- a/include/linux/user_namespace.h
> +++ b/include/linux/user_namespace.h
> @@ -17,6 +17,8 @@ struct uid_gid_map {	/* 64 bytes -- 1 cache line */
>  	} extent[UID_GID_MAP_MAX_EXTENTS];
>  };
>  
> +#define USERNS_SETGROUPS_ALLOWED 0
> +
>  struct user_namespace {
>  	struct uid_gid_map	uid_map;
>  	struct uid_gid_map	gid_map;
> @@ -27,6 +29,7 @@ struct user_namespace {
>  	kuid_t			owner;
>  	kgid_t			group;
>  	unsigned int		proc_inum;
> +	unsigned long		flags;
>  
>  	/* Register of per-UID persistent keyrings for this namespace */
>  #ifdef CONFIG_PERSISTENT_KEYRINGS
> diff --git a/kernel/groups.c b/kernel/groups.c
> index 451698f86cfa..b5ec42423202 100644
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
> +	if (!test_bit(USERNS_SETGROUPS_ALLOWED, &current_user_ns()->flags))
> +		return -EPERM;
>  	if (!ns_capable(current_user_ns(), CAP_SETGID))
>  		return -EPERM;
>  	if ((unsigned)gidsetsize > NGROUPS_MAX)
> diff --git a/kernel/user.c b/kernel/user.c
> index 4efa39350e44..58fba8ea0845 100644
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -51,6 +51,7 @@ struct user_namespace init_user_ns = {
>  	.owner = GLOBAL_ROOT_UID,
>  	.group = GLOBAL_ROOT_GID,
>  	.proc_inum = PROC_USER_INIT_INO,
> +	.flags = (1 << USERNS_SETGROUPS_ALLOWED),
>  #ifdef CONFIG_PERSISTENT_KEYRINGS
>  	.persistent_keyring_register_sem =
>  	__RWSEM_INITIALIZER(init_user_ns.persistent_keyring_register_sem),
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index aa312b0dc3ec..1f63935483e9 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -601,6 +601,10 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>  	char *kbuf, *pos, *next_line;
>  	ssize_t ret = -EINVAL;
>  
> +	bool may_setgroups = false;
> +	bool setgroups_requested = true;
> +	bool seen_explicit_setgroups = false;
> +
>  	/*
>  	 * The id_map_mutex serializes all writes to any given map.
>  	 *
> @@ -633,6 +637,18 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>  	if (cap_valid(cap_setid) && !file_ns_capable(file, ns, CAP_SYS_ADMIN))
>  		goto out;
>  
> +	if (map == &ns->gid_map) {
> +		/*
> +		 * Setgroups is permitted if the writer and the
> +		 * parent ns are privileged.
> +		 */
> +		may_setgroups =
> +			test_bit(USERNS_SETGROUPS_ALLOWED,
> +				 &ns->parent->flags) &&
> +			file_ns_capable(file, ns->parent, CAP_SETGID) &&
> +			ns_capable(ns->parent, CAP_SETGID);
> +	}
> +
>  	/* Get a buffer */
>  	ret = -ENOMEM;
>  	page = __get_free_page(GFP_TEMPORARY);
> @@ -667,6 +683,23 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>  				next_line = NULL;
>  		}
>  
> +		/* Is this line a gid_map option? */
> +		if (map == &ns->gid_map) {
> +			if (!strcmp(pos, "setgroups deny")) {
> +				if (seen_explicit_setgroups)
> +					goto out;
> +				seen_explicit_setgroups = true;
> +				setgroups_requested = false;
> +				continue;
> +			} else if (!strcmp(pos, "setgroups allow")) {
> +				if (seen_explicit_setgroups)
> +					goto out;
> +				seen_explicit_setgroups = true;
> +				setgroups_requested = true;
> +				continue;
> +			}
> +		}
> +
>  		pos = skip_spaces(pos);
>  		extent->first = simple_strtoul(pos, &pos, 10);
>  		if (!isspace(*pos))
> @@ -741,6 +774,15 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>  		extent->lower_first = lower_first;
>  	}
>  
> +	/* Validate and install setgroups permission. */
> +	if (map == &ns->gid_map && setgroups_requested) {
> +		if (!may_setgroups) {
> +			ret = -EPERM;
> +			goto out;
> +		}
> +		set_bit(USERNS_SETGROUPS_ALLOWED, &ns->flags);
> +	}
> +
>  	/* Install the map */
>  	memcpy(map->extent, new_map.extent,
>  		new_map.nr_extents*sizeof(new_map.extent[0]));
