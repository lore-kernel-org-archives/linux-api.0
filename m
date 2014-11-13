From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] ARM: cacheflush: disallow pending signals during
 cacheflush
Date: Thu, 13 Nov 2014 11:26:34 +0000
Message-ID: <20141113112633.GE13350@arm.com>
References: <1415863793-6219-1-git-send-email-chanho.min@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1415863793-6219-1-git-send-email-chanho.min-Hm3cg6mZ9cc@public.gmane.org>
Content-Language: en-US
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chanho Min <chanho.min-Hm3cg6mZ9cc@public.gmane.org>
Cc: Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Jon Medhurst <tixy-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Taras Kondratiuk <taras.kondratiuk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Gunho Lee <gunho.lee-Hm3cg6mZ9cc@public.gmane.org>, HyoJun Im <hyojun.im-Hm3cg6mZ9cc@public.gmane.org>, Jongsung Kim <neidhard.kim-Hm3cg6mZ9cc@public.gmane.org>, "peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello,

[adding linux-api, linux-man]

On Thu, Nov 13, 2014 at 07:29:53AM +0000, Chanho Min wrote:
> Since commit 28256d612726 ("ARM: cacheflush: split user cache-flushing
> into interruptible chunks"), cacheflush can be interrupted by signal.
> 
> But, cacheflush doesn't resume from where we left off if process has
> user-defined signal handlers. It returns -EINTR then cacheflush
> should be re-invoked from the start of address until cache-flushing
> of whole address ranges is completed (restart_syscall isn't available
> in userspace). It may cause regression. So I suggest to disallow
> pending signals during cacheflush.
> 
> This partially reverts commit 28256d612726a28a8b9d3c49f2b74198c4423d6a.

Whilst I don't think this is the correct solution, I agree that there's
a potential issue here. We could change the restart return value to
-ERESTARTNOINTR instead, but I can imagine something like a periodic
SIGALRM which could prevent a large cacheflush from ever completing.
Do we actually care about making forward progress in such a scenario?

It is interesting to note that this change has been in mainline since
May last year without any reported issues. That could be down to a number
of reasons:

  (1) People are using old kernels on ARM

  (2) Code doesn't check the return value from the cacheflush system call,
      because it historically always returned 0

  (3) People are getting lucky with timing, as this is likely difficult
      to hit

Related to (2) is that a `man cacheflush' invocation returns something
about the MIPs system call, that doesn't match what we do for ARM. The
(relatively recent) history of the system call on ARM is:

  < v3.5 [*]

    - Always returns 0
    - Restricts virtual address range to a single VMA
    - Page-aligns the region limits (over flushing for smaller ranges)
    - Terminates on the first fault
    - Flags are ignored but must "ALWAYS be passed as ZERO"

  v3.5 - v3.12
    - Returns -EINVAL if flags is set or if end < start
    - Returns -EINVAL if we couldn't find a vma
    - Terminates on the first fault and returns -EFAULT

  v3.12 - HEAD

    - No longer page-aligns region
    - Removes VMA checking as this had a deadlock bug with mmap_sem
      and we could handle faults by this point anyway
    - Returns -EINVAL if !access_ok for the range
    - Splits the range into PAGE_SIZE chunks, checking for reschedule
      and pending signals to avoid DoSing the system (the hardware can
      only clean by cacheline). This is where the -ERESTART_RESTARTBLOCK
      behaviour came in, potentially returning -EINTR to userspace.

This leaves me with the following questions:

  - Has this change been shown to break anything in practice?
  - Can we change the internal return value to -ERESTARTNOINTR?
  - What do we do about kernels that *do* return -EINTR? (>=3.12?)
  - Can we get a manpage put together to describe this mess?

Cheers,

Will

[*] rmk may have some more ancient history kicking around, if you like!

> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
> index abd2fc0..275e086 100644
> --- a/arch/arm/kernel/traps.c
> +++ b/arch/arm/kernel/traps.c
> @@ -521,25 +521,6 @@ __do_cache_op(unsigned long start, unsigned long end)
>  	do {
>  		unsigned long chunk = min(PAGE_SIZE, end - start);
>  
> -		if (signal_pending(current)) {
> -			struct thread_info *ti = current_thread_info();
> -
> -			ti->restart_block = (struct restart_block) {
> -				.fn	= do_cache_op_restart,
> -			};
> -
> -			ti->arm_restart_block = (struct arm_restart_block) {
> -				{
> -					.cache = {
> -						.start	= start,
> -						.end	= end,
> -					},
> -				},
> -			};
> -
> -			return -ERESTART_RESTARTBLOCK;
> -		}
> -
>  		ret = flush_cache_user_range(start, start + chunk);
>  		if (ret)
>  			return ret;
> -- 
> 1.7.9.5
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
