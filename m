From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: memcg && uaccess (Was: [PATCH 1/2] kernel/fork: handle put_user
 errors for CLONE_CHILD_SETTID/CLEARTID)
Date: Tue, 10 Feb 2015 11:19:41 -0500
Message-ID: <20150210161941.GB11212@phnom.home.cmpxchg.org>
References: <20150206162301.18031.32251.stgit@buzz>
 <20150206194405.GA13960@redhat.com>
 <20150206195529.GA15517@redhat.com>
 <20150206203246.GA16924@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150206203246.GA16924-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Nikita Vetoshkin <nekto0n-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 06, 2015 at 09:32:46PM +0100, Oleg Nesterov wrote:
> Add cc's.
> 
> On 02/06, Oleg Nesterov wrote:
> >
> > And in fact I think that this is not set_child_tid/etc-specific. Perhaps
> > I am totally confused, but I think that put_user() simply should not fail
> > this way. Say, why a syscall should return -EFAULT if memory allocation
> > "silently" fails? Confused.
> 
> Seriously. I must have missed something, but I can't understand 519e52473eb
> "mm: memcg: enable memcg OOM killer only for user faults".
> 
> The changelog says:
> 
> 	System calls and kernel faults (uaccess, gup) can handle an out of
> 	memory situation gracefully and just return -ENOMEM.

The cover letter of the original patch series is hidden in the
changelog a few commits before this one:

commit 94bce453c78996cc4373d5da6cfabe07fcc6d9f9
Author: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Date:   Thu Sep 12 15:13:36 2013 -0700

    arch: mm: remove obsolete init OOM protection
    
    The memcg code can trap tasks in the context of the failing allocation
    until an OOM situation is resolved.  They can hold all kinds of locks
    (fs, mm) at this point, which makes it prone to deadlocking.
    
    This series converts memcg OOM handling into a two step process that is
    started in the charge context, but any waiting is done after the fault
    stack is fully unwound.
    
    Patches 1-4 prepare architecture handlers to support the new memcg
    requirements, but in doing so they also remove old cruft and unify
    out-of-memory behavior across architectures.
    
    Patch 5 disables the memcg OOM handling for syscalls, readahead, kernel
    faults, because they can gracefully unwind the stack with -ENOMEM.  OOM
    handling is restricted to user triggered faults that have no other
    option.

We had reports of systems deadlocking because the allocating task
would wait for the OOM killer to make progress, and the OOM-killed
task would wait for a lock held by the allocating task.  It's
important to note here that the OOM killer currently does not kill a
second task until the current victim has exited, because that victim
has special rights to access to emergency reserves and we don't want
to risk overcommitting those.

To address that deadlock, I decided to no longer invoke memcg OOM
handling from the allocation context directly, but instead remember
the situation in the task_struct and handle it before restarting the
fault.  However, in-kernel faults do not restart, maybe even succeed
despite allocation failures (i.e. readahead), so under the assumption
that they have to handle error returns anyway, I disabled invoking the
memcg OOM killer for in-kernel faults altogether.

> How can a system call know it should return -ENOMEM if put_user() can only
> return -EFAULT ?

I see the problem, but allocations can not be guaranteed to succeed,
not even the OOM killer can reliably make progress, depending on the
state the faulting process is in, the locks it is holding.  So what
can we do if that allocation fails?  Even if we go the route that
Linus proposes and make OOM situations more generic and check them on
*every* return to userspace, the OOM handler at that point might still
kill a task more suited to free memory than the faulting one, and so
we still have to communicate the proper error value to the syscall.

However, I think we could go back to invoking OOM from all allocation
contexts again as long as we change allocator and OOM killer to not
wait for individual OOM victims to exit indefinitely (unless it's a
__GFP_NOFAIL context).  Maybe wait for some time on the first victim
before moving on to the next one.  That would reduce the likelihood of
failing allocations without reinstating the original deadlock.
put_user() could still technically fail due to allocation failure, but
it wouldn't be a very likely event.  Would that be okay?

This does not just apply to memcg allocations, btw.  Physical page
allocations have recently been reported to deadlock in a similar
fashion because of low orders implying __GFP_NOFAIL.  Making the OOM
killer more robust and more eager to make progress would allow us to
remove the implied __GFP_NOFAIL while maintaining reasonable quality
of service in the allocator.

What do you think?
