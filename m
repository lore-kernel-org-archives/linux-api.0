From: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH] cgroup mount: ignore nsroot=
Date: Wed, 30 Mar 2016 12:09:31 -0600
Message-ID: <20160330180931.GL16629@smitten>
References: <20160321234133.GA22463@mail.hallyn.com>
 <20160329135851.GN8544@smitten>
 <20160329200018.GA21908@mail.hallyn.com>
 <20160330172100.GA11373@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160330172100.GA11373-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Linux Containers <containers-qjLDD68F18O7TbgM5vRIOg@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 30, 2016 at 12:21:00PM -0500, Serge E. Hallyn wrote:
> As of the patch "cgroup namespaces: add a 'nsroot=' mountinfo field", 
> cgroupfs mountinfo output shows 'nsroot='.  If userspace like criu
> copy/pastes mount options from there into a new mount command, we should
> ignore it.
> 
> Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Tested-by: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Thanks, Serge.

> ---
>  kernel/cgroup.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index ef0c25d..69fb112 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1680,6 +1680,10 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
>  			opts->none = true;
>  			continue;
>  		}
> +		if (!strncmp(token, "nsroot=", 7)) {
> +			/* ignore nsroot= copied from mountinfo */
> +			continue;
> +		}
>  		if (!strcmp(token, "all")) {
>  			/* Mutually exclusive option 'all' + subsystem name */
>  			if (one_ss)
> -- 
> 2.7.0
> 
