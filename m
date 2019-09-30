From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH RESEND v3 2/4] clone3: switch to copy_struct_from_user()
Date: Mon, 30 Sep 2019 16:42:38 -0700
Message-ID: <201909301640.4FC92294FF@keescook>
References: <20190930191526.19544-1-asarai@suse.de>
 <20190930191526.19544-3-asarai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190930191526.19544-3-asarai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <asarai@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Christian Brauner <christian@brauner.io>, Aleksa Sarai <cyphar@cyphar.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 01, 2019 at 05:15:24AM +1000, Aleksa Sarai wrote:
> From: Aleksa Sarai <cyphar@cyphar.com>
> 
> The change is very straightforward, and helps unify the syscall
> interface for struct-from-userspace syscalls. Additionally, explicitly
> define CLONE_ARGS_SIZE_VER0 to match the other users of the
> struct-extension pattern.
> 
> Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
> ---
>  include/uapi/linux/sched.h |  2 ++
>  kernel/fork.c              | 34 +++++++---------------------------
>  2 files changed, 9 insertions(+), 27 deletions(-)
> 
> diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
> index b3105ac1381a..0945805982b4 100644
> --- a/include/uapi/linux/sched.h
> +++ b/include/uapi/linux/sched.h
> @@ -47,6 +47,8 @@ struct clone_args {
>  	__aligned_u64 tls;
>  };
>  
> +#define CLONE_ARGS_SIZE_VER0 64 /* sizeof first published struct */
> +
>  /*
>   * Scheduling policies
>   */
> diff --git a/kernel/fork.c b/kernel/fork.c
> index f9572f416126..2ef529869c64 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2525,39 +2525,19 @@ SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
>  #ifdef __ARCH_WANT_SYS_CLONE3
>  noinline static int copy_clone_args_from_user(struct kernel_clone_args *kargs,
>  					      struct clone_args __user *uargs,
> -					      size_t size)
> +					      size_t usize)
>  {
> +	int err;
>  	struct clone_args args;
>  
> -	if (unlikely(size > PAGE_SIZE))
> +	if (unlikely(usize > PAGE_SIZE))
>  		return -E2BIG;

I quickly looked through the earlier threads and couldn't find it, but
I have a memory of some discussion about moving this test into the
copy_struct_from_user() function itself? That would seems like a
reasonable idea? ("4k should be enough for any structure!")

Either way:

Reviewed-by: Kees Cook <keescook@chromium.org>


> -
> -	if (unlikely(size < sizeof(struct clone_args)))
> +	if (unlikely(usize < CLONE_ARGS_SIZE_VER0))
>  		return -EINVAL;
>  
> -	if (unlikely(!access_ok(uargs, size)))
> -		return -EFAULT;
> -
> -	if (size > sizeof(struct clone_args)) {
> -		unsigned char __user *addr;
> -		unsigned char __user *end;
> -		unsigned char val;
> -
> -		addr = (void __user *)uargs + sizeof(struct clone_args);
> -		end = (void __user *)uargs + size;
> -
> -		for (; addr < end; addr++) {
> -			if (get_user(val, addr))
> -				return -EFAULT;
> -			if (val)
> -				return -E2BIG;
> -		}
> -
> -		size = sizeof(struct clone_args);
> -	}
> -
> -	if (copy_from_user(&args, uargs, size))
> -		return -EFAULT;
> +	err = copy_struct_from_user(&args, sizeof(args), uargs, usize);
> +	if (err)
> +		return err;
>  
>  	/*
>  	 * Verify that higher 32bits of exit_signal are unset and that
> -- 
> 2.23.0
> 

-- 
Kees Cook
