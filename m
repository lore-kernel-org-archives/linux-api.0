From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Thu, 15 Jan 2015 16:10:52 +0100
Message-ID: <54B7D87C.3090901@gmail.com>
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com> <5373D0CA.2050204@redhat.com> <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de> <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com> <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1405151144390.6261-3cz04HxQygjZikZi3RtOZ1XZhhPuCNm+@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Petr Baudis <pasky-AlSwsSmVLrQ@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[Adding a few people to CC that have expressed interest in the 
progress of the updates of this page, or who may be able to
provide review feedback. Eventually, you'll all get CCed on
the new draft of the page.]

Hello Thomas,

On 05/15/2014 04:14 PM, Thomas Gleixner wrote:
> On Thu, 15 May 2014, Michael Kerrisk (man-pages) wrote:
>> And that universe would love to have your documentation of 
>> FUTEX_WAKE_BITSET and FUTEX_WAIT_BITSET ;-),
> 
> I give you almost the full treatment, but I leave REQUEUE_PI to
> Darren and FUTEX_WAKE_OP to Jakub. :)

Thank you for the great effort you put into compiling the
text below, and apologies for my long delay in following up.

I've integrated almost all of your suggestions into the 
manual page. I will shortly send out a new draft of the
page that contains various FIXMEs for points that remain 
unclear.

Most of the rest of this mail is just a checklist noting
what I did with your comments. No response is needed 
in most cases, but there are a very few open questions in 
this mail that, to help you find them, I have marked with
"???". If you (or someone else) could reply to those, I 
would be grateful.

In the next day or two, I hope to send out the new version
of the futex(2) page for review. The new draft is a bit
bigger (okay -- 4 x bigger) than the current page. And there 
are a quite number of FIXMEs that I've placed in the page 
for various points--some minor, but a few major--that need
to be checked or fixed. Would you have some time to review
that page? 

For that matter, if anyone else would have time for
reviewing the page, could they shout out now. It's perhaps
unlikely, but I am worried about getting a thundering herd
of comments, and bringing the page to the state where I have 
it now has already been a fairly demanding task.

==========

> FUTEX_WAIT
> 
> < Existing blurb seems ok >
> 
> Related return values
> 
> [EFAULT] Kernel was unable to access the futex value at uaddr.

Added/reworked.

> [EINVAL] The supplied uaddr argument does not pouint to a valid 
> object, i.e. pointer is not 4 byte aligned

Added.

> [EINVAL] The supplied timeout argument is not normalized.

Added, but with more detail.

> [EWOULDBLOCK] The atomic enqueueing failed. 

Added.

Note, however, that for consistency, I'll use EAGAIN throughout 
the page.

>  User space value at uaddr
> is not equal val argument.

Was already present.

> [ETIMEDOUT] timeout expired

Was present, but I have now added more detail.

==========

> FUTEX_WAKE
> 
> < Existing blurb seems ok >
> 
> Related return values
> 
> [EFAULT] Kernel was unable to access the futex value at uaddr.

Added/reworked.

> [EINVAL] The supplied uaddr argument does not point to a valid 
> object, i.e. pointer is not 4 byte aligned

Added.

> [EINVAL] The kernel detected inconsistent state between the user
> space state at uaddr and the kernel state, i.e. it detected a waiter
> which waits in FUTEX_LOCK_PI

Added.

==========

> FUTEX_REQUEUE
> 
> Existing blurb seems ok , except for this:
> 
> The argument val contains the number of waiters on uaddr which are
> immediately woken up.
> The timeout argument is abused to transport the number of waiters
> which are requeued to the futex at uaddr2. The pointer is typecasted
> to u32.

What I've actually done with the main text for FUTEX_REQUEUE is defer 
to the (now-expanded) discussion of FUTEX_CMP_REQUEUE. 

> [EFAULT] Kernel was unable to access the futex value at uaddr or
> uaddr2

Added/reworked.

> [EINVAL] The supplied uaddr/uaddr2 arguments do not point to a valid
> object, i.e. pointer is not 4 byte aligned

Added.

> [EINVAL] The kernel detected inconsistent state between the user
> space state at uaddr and the kernel state, i.e. it detected a waiter
> which waits in FUTEX_LOCK_PI on uaddr

Added.

> [EINVAL] uaddr equal uaddr2. Requeue to same futex.

??? I added this, but does this error not occur only for PI requeues?

==========

> FUTEX_REQUEUE_CMP
> 
> Existing blurb seems ok , except for this:

[[
> The argument val is contains the number of waiters on uaddr which are
> immediately woken up.
> 
> The timeout argument is abused to transport the number of waiters
> which are requeued to the futex at uaddr2. The pointer is typecasted
> to u32.
]]

Covered now (in more detail).

> Related return values
> 
> [EFAULT] Kernel was unable to access the futex value at uaddr or
> uaddr2

Added/reworked.

> [EINVAL] The supplied uaddr/uaddr2 arguments do not point to a valid
> object, i.e. pointer is not 4 byte aligned

Added.

> [EINVAL] uaddr equal uaddr2. Requeue to same futex.

Added.

> [EINVAL] The kernel detected inconsistent state between the user
> space state at uaddr and the kernel state, i.e. it detected a waiter
> which waits in FUTEX_LOCK_PI on uaddr

Added

> [EAGAIN] uaddr1 readout is not equal the compare value in argument
> val3

Was already present.

==========

> FUTEX_WAKE_OP
> 
> 
> Jakub, can you please explain it? I'm lost :)

I had a read of Ulrich Drepper's "Futexes are Tricky", and the source 
code, and took a shot at it. I'd like to have someone check what 
I wrote though. See the draft that I will soon send out.

> The argument val contains the maximum number of waiters on uaddr
> which are immediately woken up.

Covered in my new text.

> The timeout argument is abused to transport the maximum number of
> waiters on uaddr2 which are woken up. The pointer is typecasted to
> u32.

Covered in my new text.

> Related return values
> 
> [EFAULT] Kernel was unable to access the futex values at uaddr or
> uaddr2

This point was covered already in ERRORS.

> [EINVAL] The supplied uaddr or uaddr2 argument does not point to a
> valid object, i.e. pointer is not 4 byte aligned

This point was covered already in ERRORS.

> [EINVAL] The kernel detected inconsistent state between the user
> space state at uaddr and the kernel state, i.e. it detected a waiter
> which waits in FUTEX_LOCK_PI on uaddr

I added this point.

==========

> FUTEX_WAIT_BITSET
> 
> The same as FUTEX_WAIT except that val3 is used to provide a 32bit
> bitset to the kernel. This bitset is stored in the kernel internal
> state of the waiter.

Added.

> This futex op also allows to have the option bit FUTEX_CLOCK_REALTIME
> set.

Added.

> Related return values
> 
> [EFAULT] Kernel was unable to access the futex value at uaddr.

Already covered.

> [EINVAL] The supplied uaddr argument does not point to a valid 
> object, i.e. pointer is not 4 byte aligned

Already covered.

> [EINVAL] The supplied bitset is zero.

Added.

> [EINVAL] The supplied timeout argument is not normalized.

Already covered.

> [ETIMEDOUT] timeout expired

Already covered.

==========

> FUTEX_WAKE_BITSET
> 
> The same as FUTEX_WAKE except that val3 is used to provide a 32bit
> bitset to the kernel. This bitset is used to select waiters on the
> futex. The selection is done by a bitwise AND of the wake side
> supplied bitset and the bitset which is stored in the kernel internal
> state of the waiters. If the result is non zero, the waiter is woken,
> otherwise left waiting.

Added (along with quite a bit of other detail).

> [EFAULT] Kernel was unable to access the futex value at uaddr.

Covered already.

> [EINVAL] The supplied uaddr argument does not point to a valid 
> object, i.e. pointer is not 4 byte aligned

Covered already.

> [EINVAL] The supplied bitset is zero.

Added.

> [EINVAL] The kernel detected inconsistent state between the user
> space state at uaddr and the kernel state, i.e. it detected a waiter
> which waits in FUTEX_LOCK_PI

Added.

==========

> FUTEX_LOCK_PI
> 
> This operation reads from the futex address provided by the uaddr
> argument, which contains the namespace specific TID of the lock
> owner. If the TID is 0, then the kernel tries to set the waiters TID
> atomically. If the TID is nonzero or the take over fails the kernel
> sets atomically the FUTEX_WAITERS bit which signals the owner, that
> it cannot unlock the futex in user space atomically by transitioning
> from TID to 0. After that the kernel tries to find the task which is
> associated to the owner TID, creates or reuses kernel state on behalf
> of the owner and attaches the waiter to it. The enqueing of the 
> waiter is in descending priority order if more than one waiter 
> exists. The owner inherits either the priority or the bandwidth of
> the waiter. This inheritance follows the lock chain in the case of
> nested locking and performs deadlock detection.

Added.

> The timeout argument is handled as described in FUTEX_WAIT. The
> arguments uaddr2, val, and val3 are ignored.

Added. Note, though, that some crufty code gives the impression
that FUTEX_LOCK_PI uses 'val'. I'll send a patch separately.

> Related return values
> 
> [EFAULT] Kernel was unable to access the futex value at uaddr.

Already covered.

> [ENOMEM] Kernel could not allocate state

Added

> [EINVAL] The supplied uaddr argument does not point to a valid 
> object, i.e. pointer is not 4 byte aligned

Already covered.

> [EINVAL] The supplied timeout argument is not normalized.

Already covered.

> [EINVAL]
> The kernel detected inconsistent state between the user space state
> at uaddr and the kernel state. Thats either state corruption or it
> found a waiter on uaddr which is waiting on FUTEX_WAIT[_BITSET]

Added.

> [EPERM]  Caller is not allowed to attach itself to the futex. Can be
> a legitimate issue or a hint for state corruption in user space

Added.

> [ESRCH]	 The TID in the user space value does not exist

Added.

> [EAGAIN] The futex owner TID is about to exit, but has not yet 
> handled the internal state cleanup. Try again.

Added.

> [ETIMEDOUT] timeout expired

Already covered.

> [EDEADLOCK] The futex is already locked by the caller or the kernel 
> detected a deadlock scenario in a nested lock chain

Added.

> [EOWNERDIED] The owner of the futex died and the kernel made the 
> caller the new owner. The kernel sets the FUTEX_OWNER_DIED bit in the
> futex userspace value. Caller is responsible for cleanup

There is no such thing as an EOWNERDIED error. I had a look
through the kernel source for the FUTEX_OWNER_DIED cases and didn't 
see an obvious error associated with them. Can you clarify? (I think 
the point is that this condition, which is described in
Documentation/robust-futexes.txt, is not an error as such. However, I'm
not yet sure of how to describe it in the man page.)
I will add this point as a FIXME in the new draft man page.

> [ENOSYS] Not implemented on all architectures and not supported on
> some CPU variants  (runtime detection)  

Added.

==========

> FUTEX_TRYLOCK_PI
> 
> This operation tries to acquire the futex at uaddr. It deals with the
> situation where the TID value at uaddr is 0, but the FUTEX_HAS_WAITER
> bit is set. User space cannot handle this race free.

Added.

> The arguments uaddr2, val, timeout and val3 are ignored.

??? But the code reads:

        case FUTEX_TRYLOCK_PI:
                return futex_lock_pi(uaddr, flags, 0, timeout, 1);
 
which momentarily misleads one into thinking that 'timeout' is used.
And: it's not quite ignored, since in futex_lock_pi() a non-NULL
'timeout' is unconditionally dereferenced (meaning you could get
an EFAULT error for a bad 'timeout' pointer).
I'm confused....

Maybe the above code should be

        case FUTEX_TRYLOCK_PI:
                return futex_lock_pi(uaddr, flags, 0, NULL, 1);
?

> Return values:
> 
> [EFAULT] Kernel was unable to access the futex value at uaddr.

Already covered.

> [ENOMEM] Kernel could not allocate state

Added.

> [EINVAL] The supplied uaddr argument does not point to a valid 
> object, i.e. pointer is not 4 byte aligned

Already covered.

> [EINVAL] The kernel detected inconsistent state between the user 
> space state at uaddr and the kernel state

Added, but with the same text as for FUTEX_LOCK_PI above. I.e., the text
"Thats either state corruption or it found a waiter on uaddr which is
waiting on FUTEX_WAIT[_BITSET]" is also included.

> [EPERM]  Caller is not allowed to attach itself to the futex. Can be
> a legitimate issue or a hint for state corruption in user space

Added.

> [ESRCH]	 The TID in the user space value does not exist

Added.

> [EAGAIN] The futex owner TID is about to exit, but has not yet 
> handled the internal state cleanup. Try again.

Added.

> [EDEADLOCK] The futex is already locked by the caller.

Added.

> [EOWNERDIED] The owner of the futex died and the kernel made the 
> caller the new owner. The kernel sets the FUTEX_OWNER_DIED bit in the
> futex userspace value. Caller is responsible for cleanup

See comment above concerning EOWNERDIED for FUTEX_LOCK_PI

> [ENOSYS] Not implemented on all architectures and not supported on
> some CPU variants (runtime detection)

Added.

==========

> FUTEX_UNLOCK_PI
> 
> This operation wakes the top priority waiter which is waiting in
> FUTEX_LOCK_PI on the futex address provided by the uaddr argument.
> 
> This is called when the user space value at uaddr cannot be changed
> atomically from TID (of the owner) to 0.
> 
> The arguments uaddr2, val, timeout and val3 are ignored.

Added.

> Related return values:  
> [EINVAL] The kernel detected inconsistent
> state between the user space state at uaddr and the kernel state, 
> i.e. it detected a waiter which waits in FUTEX_WAIT[_BITSET].

Added (but with a question in a FIXME).

> [EPERM]  Caller does not own the futex.

Added.

> [ENOSYS] Not implemented on all architectures and not supported on
> some CPU variants (runtime detection)

Added.

==========

> FUTEX_WAIT_REQUEUE_PI
> 
> Wait operation to wait on a non pi futex at uaddr and potentially be
> requeued on a pi futex at uaddr2. The wait operation on uaddr is the
> same as FUTEX_WAIT. The waiter can be removed from the wait on uaddr
> via FUTEX_WAKE without requeuing on uaddr2.

Added.

> The timeout argument is handled as described in FUTEX_WAIT.

The above seems not to be correct. I've written the discussion of
'timeout' up as I understand it, and added a FIXME to the draft page.

> Darren, can you fill in the missing details?

> Return values:
> 
> [EFAULT] Kernel was unable to access the futex value at uaddr or
> uaddr2

Already covered.

> [EINVAL] The supplied uaddr or uaddr2 argument does not point to a
> valid object, i.e. pointer is not 4 byte aligned

Already covered.

> [EINVAL] The supplied timeout argument is not normalized.

Already covered.

> [EINVAL] The supplied bitset is zero.

??? I don't believe this can happen. 'val3' is internally set to
FUTEX_BITSET_MATCH_ANY. Can you confirm?

> [EWOULDBLOCK] The atomic enqueueing failed. User space value at uaddr
> is not equal val argument.

Added using the same text as FUTEX_WAIT:

       EAGAIN (FUTEX_WAIT, FUTEX_WAIT_REQUEUE_PI) The value pointed to
              by  uaddr was not equal to the expected value val at the
              time of the call.

> [ETIMEDOUT] timeout expired

Already covered.

> [EOWNERDIED] The owner of the PI futex at uaddr2 died and the kernel
> made the caller the new owner. The kernel sets the FUTEX_OWNER_DIED
> bit in the uaddr2 futex userspace value.  Caller is responsible for 
> cleanup

See comment above concerning EOWNERDIED for FUTEX_LOCK_PI

> [ENOSYS] Not implemented on all architectures and not supported on
> some CPU variants (runtime detection)

Added.

==========

> FUTEX_CMP_REQUEUE_PI
> 
> PI aware variant of FUTEX_CMP_REQUEUE. Inner futex at uaddr is a non
> PI futex. Outer futex to which is requeued is a PI futex at uaddr2.

I instead used Darren's proposed text:
 
# PI aware variant for FUTEX_CMP_REQUEUE. Requeue tasks blocked on uaddr via
# FUTEX_WAIT_REQUEUE_PI from a non-PI source futex (uaddr) to a PI target
# futex (uaddr2).

> The waiters on uaddr must wait in FUTEX_WAIT_REQUEUE_PI.

Covered above.

> The argument val is contains the number of waiters on uaddr which are
> immediately woken up. Must be 1 for this opcode.

Added.

> The timeout argument is abused to transport the number of waiters
> which are requeued on to the futex at uaddr2. The pointer is
> typecasted to u32.

Added.

> Darren, can you fill in the missing details?
> 
> [EFAULT] Kernel was unable to access the futex value at uaddr or
> uaddr2

Already covered.

> [ENOMEM] Kernel could not allocate state

Added.

> [EINVAL] The supplied uaddr/uaddr2 arguments do not point to a valid
> object, i.e. pointer is not 4 byte aligned

Already covered.

> [EINVAL] uaddr equal uaddr2. Requeue to same futex.

Added.

> [EINVAL] The kernel detected inconsistent state between the user
> space state at uaddr and the kernel state, i.e. it detected a waiter
> which waits in FUTEX_LOCK_PI on uaddr

Added

> [EINVAL] The kernel detected inconsistent state between the user
> space state at uaddr and the kernel state, i.e. it detected a waiter
> which waits in FUTEX_WAIT[_BITSET] on uaddr

Added.

> [EINVAL] The kernel detected inconsistent state between the user
> space state at uaddr2 and the kernel state, i.e. it detected a waiter
> which waits in FUTEX_WAIT on uaddr2.

Added.

> [EINVAL] The supplied bitset is zero.

Darren Hart noted: Bitset doesn't apply to FUTEX_CMP_REQUEUE_PI.

> [EAGAIN] uaddr1 readout is not equal the compare value in argument
> val3

Added.

> [EAGAIN] The futex owner TID of uaddr2 is about to exit, but has not
> yet handled the internal state cleanup. Try again.

Added.

> [EPERM]  Caller is not allowed to attach the waiter to the futex at
> uaddr2 Can be a legitimate issue or a hint for state corruption in
> user space

Added.

> [ESRCH]	 The TID in the user space value at uaddr2 does not exist

Added.

> [EDEADLOCK] The requeuing of a waiter to the kernel representation of
> the PI futex at uaddr2 detected a deadlock scenario.

Added.

> [ENOSYS] Not implemented on all architectures and not supported on
> some CPU variants (runtime detection)

Added.

==========

> The various option bits seem to be undocumented as well

Yes, thanks for that.

> FUTEX_PRIVATE_FLAG

I've added this one, along with the detail "(since Linux 2.6.22)"

> This option bit can be ored on all futex ops.
> 
> It tells the kernel, that the futex is process private and not shared
> with another process. That allows the kernel to chose the fast path
> for validating the user space address and avoids expensive VMA
> lookup, taking refcounts on file backing store etc.
> 
> FUTEX_CLOCK_REALTIME

I've added this one, along with the detail "(since Linux 2.6.28)"

> This option bit can be ored on the futex ops FUTEX_WAIT_BITSET and
> FUTEX_WAIT_REQUEUE_PI
> 
> If set the kernel treats the user space supplied timeout as absolute
> time based on CLOCK_REALTIME.
> 
> If not set the kernel treats the user space supplied timeout as
> relative time.
> 
> If this is set on any other op than the supported ones, kernel 
> returns ENOSYS!

The details in the preceding 4 paragraphs have been integrated.

Thanks,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
