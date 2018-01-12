From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 32/32] aio: implement io_pgetevents
Date: Fri, 12 Jan 2018 15:44:52 -0500
Message-ID: <x49k1wmdcxn.fsf@segfault.boston.devel.redhat.com>
References: <20180110155853.32348-1-hch@lst.de>
        <20180110155853.32348-33-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180110155853.32348-33-hch-jcswGhMUV9g@public.gmane.org> (Christoph Hellwig's message
        of "Wed, 10 Jan 2018 16:58:53 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> writes:

> This is the io_getevents equivalent of ppoll/pselect and allows to
> properly mix signals and aio completions (especially with IOCB_CMD_POLL)
> and atomically executes the following sequence:
>
> 	sigset_t origmask;
>
> 	pthread_sigmask(SIG_SETMASK, &sigmask, &origmask);
> 	ret = io_getevents(ctx, min_nr, nr, events, timeout);
> 	pthread_sigmask(SIG_SETMASK, &origmask, NULL);
>
> Note that unlike many other signal related calls we do not pass a sigmask
> size, as that would get us to 7 arguments, which aren't easily supported
> by the syscall infrastructure.  It seems a lot less painful to just add a
> new syscall variant in the unlikely case we're going to increase the
> sigset size.

pselect, as an example, crams the sigmask and size together.  Why not
just do that?  libaio can take care of setting that up.

Cheers,
Jeff


>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  arch/x86/entry/syscalls/syscall_32.tbl |  1 +
>  arch/x86/entry/syscalls/syscall_64.tbl |  1 +
>  fs/aio.c                               | 96 ++++++++++++++++++++++++++++++----
>  include/linux/compat.h                 |  6 +++
>  include/linux/syscalls.h               |  6 +++
>  include/uapi/asm-generic/unistd.h      |  4 +-
>  kernel/sys_ni.c                        |  2 +
>  7 files changed, 105 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
> index 448ac2161112..5997c3e9ac3e 100644
> --- a/arch/x86/entry/syscalls/syscall_32.tbl
> +++ b/arch/x86/entry/syscalls/syscall_32.tbl
> @@ -391,3 +391,4 @@
>  382	i386	pkey_free		sys_pkey_free
>  383	i386	statx			sys_statx
>  384	i386	arch_prctl		sys_arch_prctl			compat_sys_arch_prctl
> +385	i386	io_pgetevents		sys_io_pgetevents		compat_sys_io_pgetevents
> diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
> index 5aef183e2f85..e995cd2b4e65 100644
> --- a/arch/x86/entry/syscalls/syscall_64.tbl
> +++ b/arch/x86/entry/syscalls/syscall_64.tbl
> @@ -339,6 +339,7 @@
>  330	common	pkey_alloc		sys_pkey_alloc
>  331	common	pkey_free		sys_pkey_free
>  332	common	statx			sys_statx
> +333	common	io_pgetevents		sys_io_pgetevents
>  
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> diff --git a/fs/aio.c b/fs/aio.c
> index cae90ac6e4a3..57a4e8d89f78 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1299,10 +1299,6 @@ static long read_events(struct kioctx *ctx, long min_nr, long nr,
>  		wait_event_interruptible_hrtimeout(ctx->wait,
>  				aio_read_events(ctx, min_nr, nr, event, &ret),
>  				until);
> -
> -	if (!ret && signal_pending(current))
> -		ret = -EINTR;
> -
>  	return ret;
>  }
>  
> @@ -1978,13 +1974,54 @@ SYSCALL_DEFINE5(io_getevents, aio_context_t, ctx_id,
>  		struct timespec __user *, timeout)
>  {
>  	struct timespec64	ts;
> +	int			ret;
> +
> +	if (timeout && unlikely(get_timespec64(&ts, timeout)))
> +		return -EFAULT;
>  
> -	if (timeout) {
> -		if (unlikely(get_timespec64(&ts, timeout)))
> +	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
> +	if (!ret && signal_pending(current))
> +		ret = -EINTR;
> +	return ret;
> +}
> +
> +SYSCALL_DEFINE6(io_pgetevents,
> +		aio_context_t, ctx_id,
> +		long, min_nr,
> +		long, nr,
> +		struct io_event __user *, events,
> +		struct timespec __user *, timeout,
> +		const sigset_t __user *, sigmask)
> +{
> +	sigset_t		ksigmask, sigsaved;
> +	struct timespec64	ts;
> +	int ret;
> +
> +	if (timeout && unlikely(get_timespec64(&ts, timeout)))
> +		return -EFAULT;
> +
> +	if (sigmask) {
> +		if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
>  			return -EFAULT;
> +		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
> +		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
>  	}
>  
> -	return do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
> +	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
> +	if (signal_pending(current)) {
> +		if (sigmask) {
> +			current->saved_sigmask = sigsaved;
> +			set_restore_sigmask();
> +		}
> +
> +		if (!ret)
> +			ret = -ERESTARTNOHAND;
> +	} else {
> +		if (sigmask)
> +			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
> +	}
> +
> +	return ret;
>  }
>  
>  #ifdef CONFIG_COMPAT
> @@ -1995,13 +2032,52 @@ COMPAT_SYSCALL_DEFINE5(io_getevents, compat_aio_context_t, ctx_id,
>  		       struct compat_timespec __user *, timeout)
>  {
>  	struct timespec64 t;
> +	int ret;
> +
> +	if (timeout && compat_get_timespec64(&t, timeout))
> +		return -EFAULT;
> +
> +	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
> +	if (!ret && signal_pending(current))
> +		ret = -EINTR;
> +	return ret;
> +}
> +
> +COMPAT_SYSCALL_DEFINE6(io_pgetevents,
> +		compat_aio_context_t, ctx_id,
> +		compat_long_t, min_nr,
> +		compat_long_t, nr,
> +		struct io_event __user *, events,
> +		struct compat_timespec __user *, timeout,
> +		const compat_sigset_t __user *, sigmask)
> +{
> +	sigset_t ksigmask, sigsaved;
> +	struct timespec64 t;
> +	int ret;
>  
> -	if (timeout) {
> -		if (compat_get_timespec64(&t, timeout))
> +	if (timeout && compat_get_timespec64(&t, timeout))
> +		return -EFAULT;
> +
> +	if (sigmask) {
> +		if (get_compat_sigset(&ksigmask, sigmask))
>  			return -EFAULT;
> +		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
> +		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
> +	}
>  
> +	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
> +	if (signal_pending(current)) {
> +		if (sigmask) {
> +			current->saved_sigmask = sigsaved;
> +			set_restore_sigmask();
> +		}
> +		if (!ret)
> +			ret = -ERESTARTNOHAND;
> +	} else {
> +		if (sigmask)
> +			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
>  	}
>  
> -	return do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
> +	return ret;
>  }
>  #endif
> diff --git a/include/linux/compat.h b/include/linux/compat.h
> index 0fc36406f32c..a4cda98073f1 100644
> --- a/include/linux/compat.h
> +++ b/include/linux/compat.h
> @@ -536,6 +536,12 @@ asmlinkage long compat_sys_io_getevents(compat_aio_context_t ctx_id,
>  					compat_long_t nr,
>  					struct io_event __user *events,
>  					struct compat_timespec __user *timeout);
> +asmlinkage long compat_sys_io_pgetevents(compat_aio_context_t ctx_id,
> +					compat_long_t min_nr,
> +					compat_long_t nr,
> +					struct io_event __user *events,
> +					struct compat_timespec __user *timeout,
> +					const compat_sigset_t __user *sigmask);
>  asmlinkage long compat_sys_io_submit(compat_aio_context_t ctx_id, int nr,
>  				     u32 __user *iocb);
>  asmlinkage long compat_sys_mount(const char __user *dev_name,
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index a78186d826d7..3bc9a130f4a9 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -539,6 +539,12 @@ asmlinkage long sys_io_getevents(aio_context_t ctx_id,
>  				long nr,
>  				struct io_event __user *events,
>  				struct timespec __user *timeout);
> +asmlinkage long sys_io_pgetevents(aio_context_t ctx_id,
> +				long min_nr,
> +				long nr,
> +				struct io_event __user *events,
> +				struct timespec __user *timeout,
> +				const sigset_t __user *sigmask);
>  asmlinkage long sys_io_submit(aio_context_t, long,
>  				struct iocb __user * __user *);
>  asmlinkage long sys_io_cancel(aio_context_t ctx_id, struct iocb __user *iocb,
> diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
> index 8b87de067bc7..ce2ebbeece10 100644
> --- a/include/uapi/asm-generic/unistd.h
> +++ b/include/uapi/asm-generic/unistd.h
> @@ -732,9 +732,11 @@ __SYSCALL(__NR_pkey_alloc,    sys_pkey_alloc)
>  __SYSCALL(__NR_pkey_free,     sys_pkey_free)
>  #define __NR_statx 291
>  __SYSCALL(__NR_statx,     sys_statx)
> +#define __NR_io_pgetevents 292
> +__SC_COMP(__NR_io_pgetevents, sys_io_pgetevents, compat_sys_io_pgetevents)
>  
>  #undef __NR_syscalls
> -#define __NR_syscalls 292
> +#define __NR_syscalls 293
>  
>  /*
>   * All syscalls below here should go away really,
> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
> index b5189762d275..8f7705559b38 100644
> --- a/kernel/sys_ni.c
> +++ b/kernel/sys_ni.c
> @@ -151,9 +151,11 @@ cond_syscall(sys_io_destroy);
>  cond_syscall(sys_io_submit);
>  cond_syscall(sys_io_cancel);
>  cond_syscall(sys_io_getevents);
> +cond_syscall(sys_io_pgetevents);
>  cond_syscall(compat_sys_io_setup);
>  cond_syscall(compat_sys_io_submit);
>  cond_syscall(compat_sys_io_getevents);
> +cond_syscall(compat_sys_io_pgetevents);
>  cond_syscall(sys_sysfs);
>  cond_syscall(sys_syslog);
>  cond_syscall(sys_process_vm_readv);
