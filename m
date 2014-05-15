From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Thu, 15 May 2014 22:19:35 +0200
Message-ID: <53752157.9070803@gmail.com>
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com> <5373D0CA.2050204@redhat.com> <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de> <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com> <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1405151144390.6261-3cz04HxQygjZikZi3RtOZ1XZhhPuCNm+@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 05/15/2014 04:14 PM, Thomas Gleixner wrote:
> On Thu, 15 May 2014, Michael Kerrisk (man-pages) wrote:
>> And that universe would love to have your documentation of
>> FUTEX_WAKE_BITSET and FUTEX_WAIT_BITSET ;-),
> 
> I give you almost the full treatment, but I leave REQUEUE_PI to Darren
> and FUTEX_WAKE_OP to Jakub. :)

Thanks Thomas--that's fantastic! Hopefully, Darren and Jakub fill in those
missing pieces...

Cheers,

Michael


> FUTEX_WAIT
> 
> 	< Existing blurb seems ok >
> 
> 	Related return values
> 
> 	[EFAULT] Kernel was unable to access the futex value at uaddr.
> 
> 	[EINVAL] The supplied uaddr argument does not point to a valid
> 		 object, i.e. pointer is not 4 byte aligned
> 
> 	[EINVAL] The supplied timeout argument is not normalized.
> 
> 	[EWOULDBLOCK] The atomic enqueueing failed. User space value
> 		      at uaddr is not equal val argument.
> 
> 	[ETIMEDOUT] timeout expired 
> 
> 
> FUTEX_WAKE
> 
> 	< Existing blurb seems ok >
> 
> 	Related return values
> 
> 	[EFAULT] Kernel was unable to access the futex value at uaddr.
> 
> 	[EINVAL] The supplied uaddr argument does not point to a valid
> 		 object, i.e. pointer is not 4 byte aligned
> 
> 	[EINVAL] The kernel detected inconsistent state between the
> 		 user space state at uaddr and the kernel state,
> 		 i.e. it detected a waiter which waits in
> 		 FUTEX_LOCK_PI
> 
> FUTEX_REQUEUE
> 
> 	Existing blurb seems ok , except for this:
> 
> 	The argument val contains the number of waiters on uaddr which
> 	are immediately woken up.
> 
> 	The timeout argument is abused to transport the number of
> 	waiters which are requeued to the futex at uaddr2. The pointer
> 	is typecasted to u32.
> 
> 
> 	[EFAULT] Kernel was unable to access the futex value at uaddr or uaddr2
> 
> 	[EINVAL] The supplied uaddr/uaddr2 arguments do not point to a
> 		 valid object, i.e. pointer is not 4 byte aligned
> 
> 	[EINVAL] The kernel detected inconsistent state between the
> 		 user space state at uaddr and the kernel state,
> 		 i.e. it detected a waiter which waits in
> 		 FUTEX_LOCK_PI on uaddr
> 
> 	[EINVAL] uaddr equal uaddr2. Requeue to same futex.
> 
> FUTEX_REQUEUE_CMP
> 
> 	Existing blurb seems ok , except for this:
> 
> 	The argument val is contains the number of waiters on uaddr
> 	which are immediately woken up.
> 
> 	The timeout argument is abused to transport the number of
> 	waiters which are requeued to the futex at uaddr2. The pointer
> 	is typecasted to u32.
> 
> 	Related return values
> 
> 	[EFAULT] Kernel was unable to access the futex value at uaddr or uaddr2
> 
> 	[EINVAL] The supplied uaddr/uaddr2 arguments do not point to a
> 		 valid object, i.e. pointer is not 4 byte aligned
> 
> 	[EINVAL] uaddr equal uaddr2. Requeue to same futex.
> 
> 	[EINVAL] The kernel detected inconsistent state between the
> 		 user space state at uaddr and the kernel state,
> 		 i.e. it detected a waiter which waits in
> 		 FUTEX_LOCK_PI on uaddr
> 
> 	[EAGAIN] uaddr1 readout is not equal the compare value in
> 		 argument val3
> 
> FUTEX_WAKE_OP
> 
> 
> Jakub, can you please explain it? I'm lost :)
> 
> 
> 	The argument val contains the maximum number of waiters on
> 	uaddr which are immediately woken up.
> 
> 	The timeout argument is abused to transport the maximum
> 	number of waiters on uaddr2 which are woken up. The pointer
> 	is typecasted to u32.
> 
> 	Related return values
> 
> 	[EFAULT] Kernel was unable to access the futex values at uaddr
> 		 or uaddr2
> 
> 	[EINVAL] The supplied uaddr or uaddr2 argument does not point
> 		 to a valid object, i.e. pointer is not 4 byte aligned
> 
> 	[EINVAL] The kernel detected inconsistent state between the
> 		 user space state at uaddr and the kernel state,
> 		 i.e. it detected a waiter which waits in
> 		 FUTEX_LOCK_PI on uaddr
> 
> 
> FUTEX_WAIT_BITSET
> 
> 	The same as FUTEX_WAIT except that val3 is used to provide a
> 	32bit bitset to the kernel. This bitset is stored in the
> 	kernel internal state of the waiter.
> 
> 	This futex op also allows to have the option bit
> 	FUTEX_CLOCK_REALTIME set.
> 
> 	Related return values
> 
> 	[EFAULT] Kernel was unable to access the futex value at uaddr.
> 
> 	[EINVAL] The supplied uaddr argument does not point to a valid
> 		 object, i.e. pointer is not 4 byte aligned
> 
>   	[EINVAL] The supplied bitset is zero.
> 
> 	[EINVAL] The supplied timeout argument is not normalized.
> 
> 	[ETIMEDOUT] timeout expired 
> 
> 
> FUTEX_WAKE_BITSET
> 
> 	The same as FUTEX_WAKE except that val3 is used to provide a
> 	32bit bitset to the kernel. This bitset is used to select
> 	waiters on the futex. The selection is done by a bitwise AND
> 	of the wake side supplied bitset and the bitset which is
> 	stored in the kernel internal state of the waiters. If the
> 	result is non zero, the waiter is woken, otherwise left
> 	waiting.
> 
> 	[EFAULT] Kernel was unable to access the futex value at uaddr.
> 
> 	[EINVAL] The supplied uaddr argument does not point to a valid
> 		 object, i.e. pointer is not 4 byte aligned
> 
>   	[EINVAL] The supplied bitset is zero.
> 
> 	[EINVAL] The kernel detected inconsistent state between the
> 		 user space state at uaddr and the kernel state,
> 		 i.e. it detected a waiter which waits in
> 		 FUTEX_LOCK_PI
> 
> FUTEX_LOCK_PI
> 
> 	This operation reads from the futex address provided by the
> 	uaddr argument, which contains the namespace specific TID of
> 	the lock owner. If the TID is 0, then the kernel tries to set
> 	the waiters TID atomically. If the TID is nonzero or the take
> 	over fails the kernel sets atomically the FUTEX_WAITERS bit
> 	which signals the owner, that it cannot unlock the futex in
> 	user space atomically by transitioning from TID to 0. After
> 	that the kernel tries to find the task which is associated to
> 	the owner TID, creates or reuses kernel state on behalf of the
> 	owner and attaches the waiter to it. The enqueing of the
> 	waiter is in descending priority order if more than one waiter
> 	exists. The owner inherits either the priority or the
> 	bandwidth of the waiter. This inheritance follows the lock
> 	chain in the case of nested locking and performs deadlock
> 	detection.
> 
> 	The timeout argument is handled as described in FUTEX_WAIT.
> 	The arguments uaddr2, val, and val3 are ignored.
> 
> 	Related return values
> 
> 	[EFAULT] Kernel was unable to access the futex value at uaddr.
> 
> 	[ENOMEM] Kernel could not allocate state
> 
> 	[EINVAL] The supplied uaddr argument does not point to a valid
> 		 object, i.e. pointer is not 4 byte aligned
> 
> 	[EINVAL] The supplied timeout argument is not normalized.
> 		 
> 	[EINVAL] The kernel detected inconsistent state between the
> 		 user space state at uaddr and the kernel state. Thats
> 		 either state corruption or it found a waiter on uaddr
> 		 which is waiting on FUTEX_WAIT[_BITSET]
> 
> 	[EPERM]  Caller is not allowed to attach itself to the futex.
> 		 Can be a legitimate issue or a hint for state
> 		 corruption in user space
> 
> 	[ESRCH]	 The TID in the user space value does not exist
> 
> 	[EAGAIN] The futex owner TID is about to exit, but has not yet
> 		 handled the internal state cleanup. Try again.	 
> 
> 	[ETIMEDOUT] timeout expired 
> 
> 	[EDEADLOCK] The futex is already locked by the caller or the kernel
> 		    detected a deadlock scenario in a nested lock chain
> 
> 	[EOWNERDIED] The owner of the futex died and the kernel made the
> 		     caller the new owner. The kernel sets the
> 		     FUTEX_OWNER_DIED bit in the futex userspace value.
> 		     Caller is responsible for cleanup
> 
>         [ENOSYS] Not implemented on all architectures and not supported
> 		 on some CPU variants  (runtime detection)
> 		     
> FUTEX_TRYLOCK_PI
> 
> 	This operation tries to acquire the futex at uaddr. It deals
> 	with the situation where the TID value at uaddr is 0, but the
> 	FUTEX_HAS_WAITER bit is set. User space cannot handle this
> 	race free.
> 
> 	The arguments uaddr2, val, timeout and val3 are ignored.
> 
> 	Return values:
> 
> 	[EFAULT] Kernel was unable to access the futex value at uaddr.
> 
> 	[ENOMEM] Kernel could not allocate state
> 
> 	[EINVAL] The supplied uaddr argument does not point to a valid
> 		 object, i.e. pointer is not 4 byte aligned
> 
> 	[EINVAL] The kernel detected inconsistent state between the user
> 		 space state at uaddr and the kernel state
> 
> 	[EPERM]  Caller is not allowed to attach itself to the futex.
> 		 Can be a legitimate issue or a hint for state
> 		 corruption in user space
> 
> 	[ESRCH]	 The TID in the user space value does not exist
> 
> 	[EAGAIN] The futex owner TID is about to exit, but has not yet
> 		 handled the internal state cleanup. Try again.	 
> 
> 	[EDEADLOCK] The futex is already locked by the caller.
> 
> 	[EOWNERDIED] The owner of the futex died and the kernel made the
> 		     caller the new owner. The kernel sets the
> 		     FUTEX_OWNER_DIED bit in the futex userspace value.
> 		     Caller is responsible for cleanup
> 
>         [ENOSYS] Not implemented on all architectures and not supported
> 		 on some CPU variants (runtime detection)
> 
> FUTEX_UNLOCK_PI
> 
> 	This operation wakes the top priority waiter which is waiting
> 	in FUTEX_LOCK_PI on the futex address provided by the uaddr
> 	argument.
> 
> 	This is called when the user space value at uaddr cannot be
> 	changed atomically from TID (of the owner) to 0.
> 
> 	The arguments uaddr2, val, timeout and val3 are ignored.
> 
> 	Related return values:
> 	
> 	[EINVAL] The kernel detected inconsistent state between the
> 		 user space state at uaddr and the kernel state,
> 		 i.e. it detected a waiter which waits in
> 		 FUTEX_WAIT[_BITSET].
> 
> 	[EPERM]  Caller does not own the futex.
> 
>         [ENOSYS] Not implemented on all architectures and not supported
> 		 on some CPU variants (runtime detection)
> 
> FUTEX_WAIT_REQUEUE_PI
> 
> 	Wait operation to wait on a non pi futex at uaddr and
> 	potentially be requeued on a pi futex at uaddr2. The wait
> 	operation on uaddr is the same as FUTEX_WAIT. The waiter can
> 	be removed from the wait on uaddr via FUTEX_WAKE without
> 	requeuing on uaddr2.
> 
> 	The timeout argument is handled as described in FUTEX_WAIT.
> 
> Darren, can you fill in the missing details?
> 
> 	Return values:
> 
> 	[EFAULT] Kernel was unable to access the futex value at uaddr
> 		 or uaddr2
> 
> 	[EINVAL] The supplied uaddr or uaddr2 argument does not point
> 		 to a valid object, i.e. pointer is not 4 byte aligned
> 
> 	[EINVAL] The supplied timeout argument is not normalized.
> 
>   	[EINVAL] The supplied bitset is zero.
> 
> 	[EWOULDBLOCK] The atomic enqueueing failed. User space value
> 		      at uaddr is not equal val argument.
> 
> 	[ETIMEDOUT] timeout expired 
> 
> 	[EOWNERDIED] The owner of the PI futex at uaddr2 died and the
> 		     kernel made the caller the new owner. The kernel
> 		     sets the FUTEX_OWNER_DIED bit in the uaddr2 futex
> 		     userspace value.  Caller is responsible for
> 		     cleanup
> 
>         [ENOSYS] Not implemented on all architectures and not supported
> 		 on some CPU variants (runtime detection)
> 
> 
> FUTEX_CMP_REQUEUE_PI
> 
> 	PI aware variant of FUTEX_CMP_REQUEUE. Inner futex at uaddr is
> 	a non PI futex. Outer futex to which is requeued is a PI futex
> 	at uaddr2.
> 
> 	The waiters on uaddr must wait in FUTEX_WAIT_REQUEUE_PI.
> 
> 	The argument val is contains the number of waiters on uaddr
> 	which are immediately woken up. Must be 1 for this opcode.
> 
> 	The timeout argument is abused to transport the number of
> 	waiters which are requeued on to the futex at uaddr2. The
> 	pointer is typecasted to u32.
> 
> Darren, can you fill in the missing details?
> 
> 	[EFAULT] Kernel was unable to access the futex value at uaddr
> 		 or uaddr2
> 
> 	[ENOMEM] Kernel could not allocate state
> 
> 	[EINVAL] The supplied uaddr/uaddr2 arguments do not point to a
> 		 valid object, i.e. pointer is not 4 byte aligned
> 
> 	[EINVAL] uaddr equal uaddr2. Requeue to same futex.
> 
> 	[EINVAL] The kernel detected inconsistent state between the
> 		 user space state at uaddr and the kernel state,
> 		 i.e. it detected a waiter which waits in
> 		 FUTEX_LOCK_PI on uaddr
> 
> 	[EINVAL] The kernel detected inconsistent state between the
> 		 user space state at uaddr and the kernel state,
> 		 i.e. it detected a waiter which waits in
> 		 FUTEX_WAIT[_BITSET] on uaddr
> 
> 	[EINVAL] The kernel detected inconsistent state between the
> 		 user space state at uaddr2 and the kernel state,
> 		 i.e. it detected a waiter which waits in
> 		 FUTEX_WAIT on uaddr2.
> 
>   	[EINVAL] The supplied bitset is zero.
> 
> 	[EAGAIN] uaddr1 readout is not equal the compare value in
> 		 argument val3
> 
> 	[EAGAIN] The futex owner TID of uaddr2 is about to exit, but
> 		 has not yet handled the internal state cleanup. Try
> 		 again.
> 
> 	[EPERM]  Caller is not allowed to attach the waiter to the
> 		 futex at uaddr2 Can be a legitimate issue or a hint
> 		 for state corruption in user space
> 
> 	[ESRCH]	 The TID in the user space value at uaddr2 does not exist
> 
> 	[EDEADLOCK] The requeuing of a waiter to the kernel representation
> 		    of the PI futex at uaddr2 detected a deadlock scenario.
> 
>         [ENOSYS] Not implemented on all architectures and not supported
> 		 on some CPU variants (runtime detection)
> 
> 
> The various option bits seem to be undocumented as well
> 
> FUTEX_PRIVATE_FLAG
> 
> 	This option bit can be ored on all futex ops.
> 
> 	It tells the kernel, that the futex is process private and not
> 	shared with another process. That allows the kernel to chose
> 	the fast path for validating the user space address and avoids
> 	expensive VMA lookup, taking refcounts on file backing store
> 	etc.
> 
> FUTEX_CLOCK_REALTIME
> 
> 	This option bit can be ored on the futex ops FUTEX_WAIT_BITSET
> 	and FUTEX_WAIT_REQUEUE_PI
> 
> 	If set the kernel treats the user space supplied timeout as
> 	absolute time based on CLOCK_REALTIME.
> 
> 	If not set the kernel treats the user space supplied timeout
> 	as relative time.
> 
> 	If this is set on any other op than the supported ones, kernel
> 	returns ENOSYS!
> 
> 
> Thanks,
> 
> 	tglx
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
