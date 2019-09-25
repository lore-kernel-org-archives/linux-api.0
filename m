From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v1 2/4] clone3: switch to copy_struct_from_user()
Date: Wed, 25 Sep 2019 19:22:21 +0200
Message-ID: <20190925172221.ss6lmncog23uohep@wittgenstein>
References: <20190925165915.8135-1-cyphar@cyphar.com>
 <20190925165915.8135-3-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190925165915.8135-3-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Sep 25, 2019 at 06:59:13PM +0200, Aleksa Sarai wrote:
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
> index 541fd805fb88..a86e3841ee4e 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2530,39 +2530,19 @@ SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
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
> -
> -	if (unlikely(size < sizeof(struct clone_args)))
> +	if (unlikely(usize < CLONE_ARGS_SIZE_VER0))
>  		return -EINVAL;

You might want to rebase this patchset after the merge window closes on
rc1 since that code has changed right before the 5.3 release. But if you
can't don't worry I can also fix it up.

Christian
