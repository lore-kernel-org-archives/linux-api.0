From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] signalfd: add ability to return siginfo in a raw
	format (v2)
Date: Fri, 28 Dec 2012 17:14:36 +0100
Message-ID: <20121228161436.GA30459@redhat.com>
References: <1356690181-1796-1-git-send-email-avagin@openvz.org> <1356690181-1796-3-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1356690181-1796-3-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 12/28, Andrey Vagin wrote:
>
> signalfd should be called with the flag SFD_RAW for that.
>
> signalfd_siginfo is not full for siginfo with a negative si_code.
> copy_siginfo_to_user() is copied a full siginfo to user-space, if
> si_code is negative.  signalfd_copyinfo() doesn't do that and can't be
> expanded, because it has not compatible format with siginfo_t.
>
> Another problem is that a constant __SI_* is removed from si_code.
> It's not a problem for usual applications, because they expect
> a defined type of siginfo (internal logic).
> When we want to dump pending signals, we can't predict a type of
> siginfo, so we should get it from kernel.
>
> The main idea of the raw format is that it should be enough for
> restoring exactly the same siginfo for the current process.
>
> This functionality is required for checkpointing pending signals.

And this should be used along with pread().

I won't argue, but perhaps we should simply postulate that pread()
always dumps siginfo in raw format and avoid the new flag?

> @@ -272,20 +311,35 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
>  	signotset(&sigmask);
>  
>  	if (ufd == -1) {
> +		struct file *file;
>  		ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
>  		if (!ctx)
>  			return -ENOMEM;
>  
>  		ctx->sigmask = sigmask;
>  
> +		ufd = get_unused_fd_flags(flags);
> +		if (ufd < 0) {
> +			kfree(ctx);
> +			goto out;
> +		}
> +
>  		/*
>  		 * When we call this, the initialization must be complete, since
>  		 * anon_inode_getfd() will install the fd.
>  		 */
> -		ufd = anon_inode_getfd("[signalfd]", &signalfd_fops, ctx,
> +		file = anon_inode_getfile("[signalfd]", &signalfd_fops, ctx,
>  				       O_RDWR | (flags & (O_CLOEXEC | O_NONBLOCK)));
> -		if (ufd < 0)
> +		if (IS_ERR(file)) {
> +			put_unused_fd(ufd);
> +			ufd = PTR_ERR(file);
>  			kfree(ctx);
> +			goto out;
> +		}
> +
> +		file->f_flags |= flags & SFD_RAW;
> +
> +		fd_install(ufd, file);

And this is needed because we want to set more bits in f_flags/f_mode.

I am wondering if we can change anon_inode_getfd/getfile somehow so
that the user can pass more flags...

Or. Currently fops->open() is never used if this file_operations is used
by anon_inode_get*. So perhaps we can change anon_inode_getfile() to call
fops->open() if it is not zero before return?

OK, this is almost off-topic, please ignore.

Oleg.
