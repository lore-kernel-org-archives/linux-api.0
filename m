From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] sched: new clone flag CLONE_NEWCGROUP for cgroup
 namespace
Date: Thu, 24 Jul 2014 17:01:19 +0000
Message-ID: <20140724170119.GR26600@ubuntumail>
References: <adityakali-cgroupns>
 <1405626731-12220-1-git-send-email-adityakali@google.com>
 <1405626731-12220-3-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1405626731-12220-3-git-send-email-adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Aditya Kali (adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> CLONE_NEWCGROUP will be used to create new cgroup namespace.
> 

This is fine and I'm not looking to bikeshed, but am wondering - did
you consider any other ways beside unshare (i.e. a new mount option
to cgroupfs)?  If so, do you have a list of the downsides of those?
(I mainly ask bc clone flags are still a scarce commodity)

> Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

> ---
>  include/uapi/linux/sched.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
> index 34f9d73..2f90d00 100644
> --- a/include/uapi/linux/sched.h
> +++ b/include/uapi/linux/sched.h
> @@ -21,8 +21,7 @@
>  #define CLONE_DETACHED		0x00400000	/* Unused, ignored */
>  #define CLONE_UNTRACED		0x00800000	/* set if the tracing process can't force CLONE_PTRACE on this clone */
>  #define CLONE_CHILD_SETTID	0x01000000	/* set the TID in the child */
> -/* 0x02000000 was previously the unused CLONE_STOPPED (Start in stopped state)
> -   and is now available for re-use. */
> +#define CLONE_NEWCGROUP		0x02000000	/* New cgroup namespace */
>  #define CLONE_NEWUTS		0x04000000	/* New utsname group? */
>  #define CLONE_NEWIPC		0x08000000	/* New ipcs */
>  #define CLONE_NEWUSER		0x10000000	/* New user namespace */
> -- 
> 2.0.0.526.g5318336
> 
> _______________________________________________
> Containers mailing list
> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
