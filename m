From: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH RFC 5/6] epoll: Add implementation for epoll_mod_wait
Date: Tue, 20 Jan 2015 23:56:17 -0800
Message-ID: <20150121075617.GA21266@mew>
References: <1421747878-30744-1-git-send-email-famz@redhat.com>
 <1421747878-30744-6-git-send-email-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1421747878-30744-6-git-send-email-famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <peterz@>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 20, 2015 at 05:57:57PM +0800, Fam Zheng wrote:
> This syscall is a sequence of
> 
> 1) a number of epoll_ctl calls
> 2) a epoll_pwait, with timeout enhancement.
> 
> The epoll_ctl operations are embeded so that application doesn't have to use
> separate syscalls to insert/delete/update the fds before poll. It is more
> efficient if the set of fds varies from one poll to another, which is the
> common pattern for certain applications. For example, depending on the input
> buffer status, a data reading program may decide to temporarily not polling an
> fd.
> 
> Because the enablement of batching in this interface, even that regular
> epoll_ctl call sequence, which manipulates several fds, can be optimized to one
> single epoll_ctl_wait (while specifying spec=NULL to skip the poll part).
> 
> The only complexity is returning the result of each operation.  For each
> epoll_mod_cmd in cmds, the field "error" is an output field that will be stored
> the return code *iff* the command is executed (0 for success and -errno of the
> equivalent epoll_ctl call), and will be left unchanged if the command is not
> executed because some earlier error, for example due to failure of
> copy_from_user to copy the array.
> 
> Applications can utilize this fact to do error handling: they could initialize
> all the epoll_mod_wait.error to a positive value, which is by definition not a
> possible output value from epoll_mod_wait. Then when the syscall returned, they
> know whether or not the command is executed by comparing each error with the
> init value, if they're different, they have the result of the command.
> More roughly, they can put any non-zero and not distinguish "not run" from
> failure.
> 
> Also, timeout parameter is enhanced: timespec is used, compared to the old ms
> scalar. This provides higher precision. The parameter field in struct
> epoll_wait_spec, "clockid", also makes it possible for users to use a different
> clock than the default when it makes more sense.
> 
> Signed-off-by: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/eventpoll.c           | 60 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/syscalls.h |  5 ++++
>  2 files changed, 65 insertions(+)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index e7a116d..2cc22c9 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -2067,6 +2067,66 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
>  			      sigmask ? &ksigmask : NULL);
>  }
>  
> +SYSCALL_DEFINE5(epoll_mod_wait, int, epfd, int, flags,
> +		int, ncmds, struct epoll_mod_cmd __user *, cmds,
> +		struct epoll_wait_spec __user *, spec)
> +{
> +	struct epoll_mod_cmd *kcmds = NULL;
> +	int i, ret = 0;
> +	int cmd_size = sizeof(struct epoll_mod_cmd) * ncmds;
> +
> +	if (flags)
> +		return -EINVAL;
> +	if (ncmds) {
> +		if (!cmds)
> +			return -EINVAL;
> +		kcmds = kmalloc(cmd_size, GFP_KERNEL);
> +		if (!kcmds)
> +			return -ENOMEM;
> +		if (copy_from_user(kcmds, cmds, cmd_size)) {
> +			ret = -EFAULT;
> +			goto out;
> +		}
> +	}
> +	for (i = 0; i < ncmds; i++) {
> +		struct epoll_event ev = (struct epoll_event) {
> +			.events = kcmds[i].events,
> +			.data = kcmds[i].data,
> +		};
> +		if (kcmds[i].flags) {
> +			kcmds[i].error = ret = -EINVAL;
> +			goto out;
> +		}
> +		kcmds[i].error = ret = ep_ctl_do(epfd, kcmds[i].op, kcmds[i].fd, ev);
> +		if (ret)
> +			goto out;
> +	}
> +	if (spec) {
> +		sigset_t ksigmask;
> +		struct epoll_wait_spec kspec;
> +		ktime_t timeout;
> +
> +		if(copy_from_user(&kspec, spec, sizeof(struct epoll_wait_spec)))
> +			return -EFAULT;
This should probably be goto out, or you'll leak kcmds.

> +		if (kspec.sigmask) {
> +			if (kspec.sigsetsize != sizeof(sigset_t))
> +				return -EINVAL;
Same here...

> +			if (copy_from_user(&ksigmask, kspec.sigmask, sizeof(ksigmask)))
> +				return -EFAULT;
and here.

> +		}
> +		timeout = timespec_to_ktime(kspec.timeout);
> +		ret = epoll_pwait_do(epfd, kspec.events, kspec.maxevents,
> +				     kspec.clockid, timeout,
> +				     kspec.sigmask ? &ksigmask : NULL);
> +	}
> +
> +out:
> +	if (ncmds && copy_to_user(cmds, kcmds, cmd_size))
> +		return -EFAULT;
This will also leak kcmds, it should be ret = -EFAULT. This case, however, seems
to lead to a weird corner case: if cmds is read-only, we'll end up executing
every command but fail to copy out the return values, so when userspace gets the
EFAULT, it won't know whether anything was executed. But, getting an EFAULT here
means you're probably doing something wrong anyways, so maybe not the biggest
concern.

> +	kfree(kcmds);
> +	return ret;
> +}
> +
>  #ifdef CONFIG_COMPAT
>  COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
>  		       struct epoll_event __user *, events,
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 85893d7..7156c80 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -12,6 +12,8 @@
>  #define _LINUX_SYSCALLS_H
>  
>  struct epoll_event;
> +struct epoll_mod_cmd;
> +struct epoll_wait_spec;
>  struct iattr;
>  struct inode;
>  struct iocb;
> @@ -630,6 +632,9 @@ asmlinkage long sys_epoll_pwait(int epfd, struct epoll_event __user *events,
>  				int maxevents, int timeout,
>  				const sigset_t __user *sigmask,
>  				size_t sigsetsize);
> +asmlinkage long sys_epoll_mod_wait(int epfd, int flags,
> +				   int ncmds, struct epoll_mod_cmd __user * cmds,
> +				   struct epoll_wait_spec __user * spec);
>  asmlinkage long sys_gethostname(char __user *name, int len);
>  asmlinkage long sys_sethostname(char __user *name, int len);
>  asmlinkage long sys_setdomainname(char __user *name, int len);
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Omar
