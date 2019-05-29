From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: [PATCH v1 1/2] fork: add clone3
Date: Wed, 29 May 2019 17:42:14 +0200
Message-ID: <1058006e0df4b52b3e53c7b3202c04140899aeb5.camel@opteya.com>
References: <20190529152237.10719-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190529152237.10719-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, jannh@google.com
Cc: fweimer@redhat.com, oleg@redhat.com, arnd@arndb.de, dhowells@redhat.com, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Le mercredi 29 mai 2019 à 17:22 +0200, Christian Brauner a écrit :
> This adds the clone3 system call.
> 
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index b4cba953040a..6bc3e3d17150 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2472,7 +2475,96 @@ SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
>  		 unsigned long, tls)
>  #endif
>  {
> -	return _do_fork(clone_flags, newsp, 0, parent_tidptr, child_tidptr, tls);
> +	struct kernel_clone_args args = {
> +		.flags = clone_flags,
> +		.stack = newsp,
> +		.pidfd = parent_tidptr,
> +		.parent_tidptr = parent_tidptr,
> +		.tls = tls,
> +		.child_tidptr = child_tidptr,
> +	};
> +
> +	/* clone(CLONE_PIDFD) uses parent_tidptr to return a pidfd */
> +	if ((clone_flags & CLONE_PIDFD) && (clone_flags & CLONE_PARENT_SETTID))
> +		return -EINVAL;
> +
> +	return _do_fork(&args);
> +}
> +
> +static bool clone3_flags_valid(u64 flags)
> +{
> +	if (flags & CLONE_DETACHED)
> +		return false;
> +
> +	if (flags & ~CLONE_MAX)
> +		return false;
> +
> +	return true;
> +}
> +
> +static int copy_clone_args_from_user(struct kernel_clone_args *kargs,
> +				     struct clone_args __user *uargs,
> +				     size_t size)
> +{
> +	struct clone_args args;
> +
> +	if (unlikely(size > PAGE_SIZE))
> +		return -E2BIG;
> +
> +	if (unlikely(size < sizeof(struct clone_args)))
> +		return -EINVAL;
> +
> +	if (unlikely(!access_ok(uargs, size)))
> +		return -EFAULT;
> +
> +	if (size > sizeof(struct clone_args)) {
> +		unsigned char __user *addr;
> +		unsigned char __user *end;
> +		unsigned char val;
> +
> +		addr = (void __user *)uargs + sizeof(struct clone_args);
> +		end = (void __user *)uargs + size;
> +
> +		for (; addr < end; addr++) {
> +			if (get_user(val, addr))
> +				return -EFAULT;
> +			if (val)
> +				return -E2BIG;

Should be -EINVAL: having something after the structure should be
handled just like an invalid flags, while still allowing future
userspace program to probe for support for newer feature.

> +		}
> +
> +		size = sizeof(struct clone_args);
> +	}
> +
> +	if (copy_from_user(&args, uargs, size))
> +		return -EFAULT;
> +
> +	if (!clone3_flags_valid(args.flags))
> +		return -EINVAL;
> +
> +	memset(kargs, 0, sizeof(*kargs));
> +
> +	kargs->flags = args.flags;
> +	kargs->child_tidptr = u64_to_user_ptr(args.child_tidptr);
> +	kargs->parent_tidptr = u64_to_user_ptr(args.parent_tidptr);
> +	kargs->pidfd = u64_to_user_ptr(args.pidfd);
> +	kargs->stack = args.stack;
> +	kargs->stack_size = args.stack_size;
> +	kargs->tls = args.tls;
> +
> +	return 0;
> +}
> +
> +SYSCALL_DEFINE2(clone3, struct clone_args __user *, uargs, size_t, size)
> +{
> +	int err;
> +
> +	struct kernel_clone_args kargs;
> +
> +	err = copy_clone_args_from_user(&kargs, uargs, size);
> +	if (err)
> +		return err;
> +
> +	return _do_fork(&kargs);
>  }
>  #endif
>  

Regards.

-- 
Yann Droneaud
OPTEYA
