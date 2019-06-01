From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: [PATCH v1 1/2] fork: add clone3
Date: Sat, 01 Jun 2019 10:49:38 +0200
Message-ID: <7ba353ba112ebbe1493fcc210795cf74a0e83f74.camel@opteya.com>
References: <20190529152237.10719-1-christian@brauner.io>
         <1058006e0df4b52b3e53c7b3202c04140899aeb5.camel@opteya.com>
         <20190531220815.owrc5kbbdemmwdhs@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190531220815.owrc5kbbdemmwdhs@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, jannh@google.com, fweimer@redhat.com, oleg@redhat.com, arnd@arndb.de, dhowells@redhat.com, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi,

Le samedi 01 juin 2019 à 00:08 +0200, Christian Brauner a écrit :
> On Wed, May 29, 2019 at 05:42:14PM +0200, Yann Droneaud wrote:
> > Le mercredi 29 mai 2019 à 17:22 +0200, Christian Brauner a écrit :
> > > This adds the clone3 system call.
> > > 
> > > 
> > > diff --git a/kernel/fork.c b/kernel/fork.c
> > > index b4cba953040a..6bc3e3d17150 100644
> > > --- a/kernel/fork.c
> > > +++ b/kernel/fork.c
> > > @@ -2472,7 +2475,96 @@ SYSCALL_DEFINE5(clone, unsigned long,
> > > clone_flags, unsigned long, newsp,
> > >  		 unsigned long, tls)
> > >  #endif
> > >  {
> > > -	return _do_fork(clone_flags, newsp, 0, parent_tidptr,
> > > child_tidptr, tls);
> > > +	struct kernel_clone_args args = {
> > > +		.flags = clone_flags,
> > > +		.stack = newsp,
> > > +		.pidfd = parent_tidptr,
> > > +		.parent_tidptr = parent_tidptr,
> > > +		.tls = tls,
> > > +		.child_tidptr = child_tidptr,
> > > +	};
> > > +
> > > +	/* clone(CLONE_PIDFD) uses parent_tidptr to return a pidfd */
> > > +	if ((clone_flags & CLONE_PIDFD) && (clone_flags &
> > > CLONE_PARENT_SETTID))
> > > +		return -EINVAL;
> > > +
> > > +	return _do_fork(&args);
> > > +}
> > > +
> > > +static bool clone3_flags_valid(u64 flags)
> > > +{
> > > +	if (flags & CLONE_DETACHED)
> > > +		return false;
> > > +
> > > +	if (flags & ~CLONE_MAX)
> > > +		return false;
> > > +
> > > +	return true;
> > > +}
> > > +
> > > +static int copy_clone_args_from_user(struct kernel_clone_args
> > > *kargs,
> > > +				     struct clone_args __user *uargs,
> > > +				     size_t size)
> > > +{
> > > +	struct clone_args args;
> > > +
> > > +	if (unlikely(size > PAGE_SIZE))
> > > +		return -E2BIG;
> > > +
> > > +	if (unlikely(size < sizeof(struct clone_args)))
> > > +		return -EINVAL;
> > > +
> > > +	if (unlikely(!access_ok(uargs, size)))
> > > +		return -EFAULT;
> > > +
> > > +	if (size > sizeof(struct clone_args)) {
> > > +		unsigned char __user *addr;
> > > +		unsigned char __user *end;
> > > +		unsigned char val;
> > > +
> > > +		addr = (void __user *)uargs + sizeof(struct
> > > clone_args);
> > > +		end = (void __user *)uargs + size;
> > > +
> > > +		for (; addr < end; addr++) {
> > > +			if (get_user(val, addr))
> > > +				return -EFAULT;
> > > +			if (val)
> > > +				return -E2BIG;
> > 
> > Should be -EINVAL: having something after the structure should be
> > handled just like an invalid flags, while still allowing future
> > userspace program to probe for support for newer feature.
> 
> (Traveling until Monday, so sorry for delayed responses.)
> 
> This copies what:
> 
> kernel/sched/core.c:sched_copy_attr()
> kernel/event/core.c:perf_copy_attr()
> 
> are already doing. Consistency might be good here but, I think.
> 

I would have prefer all the above to returns -EINVAL for consistency
with the unknown flags check ... 

"Designing the API: Planning for Extension" [1] doesn't mandate return
-EINVAL for that case, but does make perf_event_open() and
perf_copy_attr() the example to follow ... so you're right.

[1] 
https://www.kernel.org/doc/html/v5.1/process/adding-syscalls.html#designing-the-api-planning-for-extension

Regards.

-- 
Yann Droneaud
OPTEYA
