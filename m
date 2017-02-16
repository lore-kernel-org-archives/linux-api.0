From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH] groups: don't return unmapped gids in getgroups(2)
Date: Fri, 17 Feb 2017 07:19:36 +1300
Message-ID: <87a89mm213.fsf@xmission.com>
References: <20170216174750.4995-1-asarai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170216174750.4995-1-asarai-l3A5Bk7waGM@public.gmane.org> (Aleksa Sarai's message of
        "Fri, 17 Feb 2017 04:47:50 +1100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Added a few more relevant mailing-lists to the CC list.

Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org> writes:

> One thing overlooked by commit 9cc46516ddf4 ("userns: Add a knob to
> disable setgroups on a per user namespace basis") is that because
> setgroups(2) no longer works in user namespaces it doesn't make any
> sense to be returning weird group IDs that the process cannot do
> anything with.

This code works the same weather or not setgroups is enabled.

> This change, along with the other changes made to require unprivileged
> users to always disable setgroups(2), means that userspace programs such
> as apt break inside rootless containers. While this change does change
> the userspace ABI, any userspace program that has to deal with
> getgroups(2) would have to filter out these "fake" group IDs anyway.
> This just makes it so that less applications will have to handle this
> broken API.

Is it broken?  Unless I am mistaken if we have a 16bit getgroups
call and we 32bit group ids  getgroups it behaves exactly the same way.

The value we is (u16)-2.  The traditional linux group id for this
purpose.

In all other contexts the best we can do for applications has been to
return the user id or group id that says the value you are looking for
does not fit in this context.  Which makes me suspect this is not the
right solution for getgroups.

I don't know why apt breaks.  You have not described that.  Perhaps apt
is seeing something misconfigured and complaining properly.

I can be persauded but I need a better argument than this change makes
one applicaiton work for me.

Eric


> Fixes: 9cc46516ddf4 ("userns: Add a knob to disable setgroups on a per user namespace basis")
> Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> Cc: <dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org>
> Signed-off-by: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
> ---
>  kernel/groups.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
>
> diff --git a/kernel/groups.c b/kernel/groups.c
> index 8dd7a61b7115..ebd01fff37d6 100644
> --- a/kernel/groups.c
> +++ b/kernel/groups.c
> @@ -41,16 +41,27 @@ static int groups_to_user(gid_t __user *grouplist,
>  			  const struct group_info *group_info)
>  {
>  	struct user_namespace *user_ns = current_user_ns();
> -	int i;
> +	int i, j = 0;
>  	unsigned int count = group_info->ngroups;
>  
>  	for (i = 0; i < count; i++) {
> +		kgid_t kgid = group_info->gid[i];
>  		gid_t gid;
> -		gid = from_kgid_munged(user_ns, group_info->gid[i]);
> -		if (put_user(gid, grouplist+i))
> +
> +		/*
> +		 * Don't return unmapped gids, since there's nothing userspace
> +		 * can do about them and they are very confusing -- since
> +		 * setgroups(2) is disabled in user namespaces.
> +		 */
> +		if (!kgid_has_mapping(user_ns, kgid))
> +			continue;
> +
> +		gid = from_kgid(user_ns, kgid);
> +		if (put_user(gid, grouplist+j))
>  			return -EFAULT;
> +		j++;
>  	}
> -	return 0;
> +	return j;
>  }
>  
>  /* fill a group_info from a user-space array - it must be allocated already */
> @@ -177,10 +188,10 @@ SYSCALL_DEFINE2(getgroups, int, gidsetsize, gid_t __user *, grouplist)
>  			i = -EINVAL;
>  			goto out;
>  		}
> -		if (groups_to_user(grouplist, cred->group_info)) {
> -			i = -EFAULT;
> +
> +		i = groups_to_user(grouplist, cred->group_info);
> +		if (i < 0)
>  			goto out;
> -		}
>  	}
>  out:
>  	return i;
