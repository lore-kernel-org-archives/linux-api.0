From: "Chanho Min" <chanho.min@lge.com>
Subject: RE: [PATCH] ARM: cacheflush: disallow pending signals during
 cacheflush
Date: Fri, 14 Nov 2014 17:40:49 +0900
Message-ID: <42023.6625163399$1415954530@news.gmane.org>
References: <1415863793-6219-1-git-send-email-chanho.min@lge.com>
 <20141113112633.GE13350@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20141113112633.GE13350@arm.com>
Content-Language: ko
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: 'Will Deacon' <will.deacon@arm.com>
Cc: 'Jon Medhurst' <tixy@linaro.org>, 'HyoJun Im' <hyojun.im@lge.com>, 'Russell King' <linux@arm.linux.org.uk>, 'Jongsung Kim' <neidhard.kim@lge.com>, peter.maydell@linaro.org, 'Taras Kondratiuk' <taras.kondratiuk@linaro.org>, linux-kernel@vger.kernel.org, mtk.manpages@gmail.com, 'Gunho Lee' <gunho.lee@lge.com>, 'Olof Johansson' <olof@lixom.net>, linux-api@vger.kernel.org, linux-man@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

> -----Original Message-----
> From: Will Deacon [mailto:will.deacon@arm.com]

> Whilst I don't think this is the correct solution, I agree that there's
> a potential issue here. We could change the restart return value to
> -ERESTARTNOINTR instead, but I can imagine something like a periodic
> SIGALRM which could prevent a large cacheflush from ever completing.
> Do we actually care about making forward progress in such a scenario?
It's not complete solution. But, I don't think this is incorrect solution
as well. Potential issue could be more serious than improvement of signal
responsiveness.

> 
> It is interesting to note that this change has been in mainline since
> May last year without any reported issues. That could be down to a number
> of reasons:
> 
>   (1) People are using old kernels on ARM
> 
>   (2) Code doesn't check the return value from the cacheflush system call,
>       because it historically always returned 0
> 
>   (3) People are getting lucky with timing, as this is likely difficult
>       to hit
> 
> Related to (2) is that a `man cacheflush' invocation returns something
> about the MIPs system call, that doesn't match what we do for ARM. The
> (relatively recent) history of the system call on ARM is:
> 
>   < v3.5 [*]
> 
>     - Always returns 0
>     - Restricts virtual address range to a single VMA
>     - Page-aligns the region limits (over flushing for smaller ranges)
>     - Terminates on the first fault
>     - Flags are ignored but must "ALWAYS be passed as ZERO"
> 
>   v3.5 - v3.12
>     - Returns -EINVAL if flags is set or if end < start
>     - Returns -EINVAL if we couldn't find a vma
>     - Terminates on the first fault and returns -EFAULT
> 
>   v3.12 - HEAD
> 
>     - No longer page-aligns region
>     - Removes VMA checking as this had a deadlock bug with mmap_sem
>       and we could handle faults by this point anyway
>     - Returns -EINVAL if !access_ok for the range
>     - Splits the range into PAGE_SIZE chunks, checking for reschedule
>       and pending signals to avoid DoSing the system (the hardware can
>       only clean by cacheline). This is where the -ERESTART_RESTARTBLOCK
>       behaviour came in, potentially returning -EINTR to userspace.
> 
> This leaves me with the following questions:
> 
>   - Has this change been shown to break anything in practice?
In practice, node.js (Currently, It doesn't check -EINTR of cacheflush)
crashes occasionally and non-reproducibly at some point some while after
the cacheflush call. At that time, strace tells cacheflush returns -EINTR.

>   - Can we change the internal return value to -ERESTARTNOINTR?
In worst case, I can imagine that periodic signal interrupts cacheflush
and it repeats restart of syscall from start of address with unlucky timing.

>   - What do we do about kernels that *do* return -EINTR? (>=3.12?)
>   - Can we get a manpage put together to describe this mess?
> 
> Cheers,
> 
> Will
> 
> [*] rmk may have some more ancient history kicking around, if you like!
> 
> > diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
> > index abd2fc0..275e086 100644
> > --- a/arch/arm/kernel/traps.c
> > +++ b/arch/arm/kernel/traps.c
> > @@ -521,25 +521,6 @@ __do_cache_op(unsigned long start, unsigned long end)
> >  	do {
> >  		unsigned long chunk = min(PAGE_SIZE, end - start);
> >
> > -		if (signal_pending(current)) {
> > -			struct thread_info *ti = current_thread_info();
> > -
> > -			ti->restart_block = (struct restart_block) {
> > -				.fn	= do_cache_op_restart,
> > -			};
> > -
> > -			ti->arm_restart_block = (struct arm_restart_block) {
> > -				{
> > -					.cache = {
> > -						.start	= start,
> > -						.end	= end,
> > -					},
> > -				},
> > -			};
> > -
> > -			return -ERESTART_RESTARTBLOCK;
> > -		}
> > -
> >  		ret = flush_cache_user_range(start, start + chunk);
> >  		if (ret)
> >  			return ret;
> > --
> > 1.7.9.5
> >
> >
