From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v7 00/10] kthread: Kthread worker API improvements
Date: Mon, 30 May 2016 16:59:21 +0200
Message-ID: <1464620371-31346-1-git-send-email-pmladek@suse.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, linux-watchdog-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Corey Minyard <minyard-HInyCGIudOg@public.gmane.org>, openipmi-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maxim Levitsky <maximlevitsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Zhang Rui <rui.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eduardo Valentin <edubezval-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pa>
List-Id: linux-api@vger.kernel.org

I send the kthread worker API improvements separately as discussed
in v6, see
https://lkml.kernel.org/g/<20160511105224.GE2749-KsEp0d+Q8qECVLCxKZUutA@public.gmane.org>
They seem to be ready for inclusion in 4.8.

I will send the conversion of the particular kthreads once
the API changes are in some maintainers three (-mm?) and
visible in linux-next. If nobody suggests some other approach.

Also I plan to continue with conversion of more kthreads.

Just to remember. The intention of this patchset is to make
it easier to manipulate and maintain kthreads. Especially, I want
to replace all the custom main cycles with a generic one.
Also I want to make the kthreads sleep in a consistent
state in a common place when there is no work.


Changes against v6:

  + no changes.


Changes against v5:

  + removed spin_trylock() from delayed_kthread_work_timer_fn();
    instead temporary released worked->lock() when calling
    del_timer_sync(); made sure that any queueing was blocked
    by work->canceling in the meatime

  + used 0th byte for KTW_FREEZABLE to reduce confusion

  + fixed warnings in comments reported by make htmldocs

  + sigh, there was no easy way to create an empty va_list
    that would work on all architectures; decided to make
    @namefmt generic in create_kthread_worker_on_cpu()

  + converted khungtaskd a better way; it was inspired by
    the recent changes that appeared in 4.6-rc1


Changes against v4:

  + added worker->delayed_work_list; it simplified the check
    for pending work; we do not longer need the new timer_active()
    function; also we do not need the link work->timer. On the
    other hand we need to distinguish between the normal and
    the delayed work by a boolean parameter passed to
    the common functions, e.g. __cancel_kthread_work_sync()
    
  + replaced most try_lock repeat cycles with a WARN_ON();
    the API does not allow to use the work with more workers;
    so such a situation would be a bug; it removed the
    complex try_lock_kthread_work() function that supported
    more modes;

  + renamed kthread_work_pending() to queuing_blocked();
    added this function later when really needed

  + renamed try_to_cancel_kthread_work() to __cancel_kthread_work();
    in fact, this a common implementation for the async cancel()
    function

  + removed a dull check for invalid cpu number in
    create_kthread_worker_on_cpu(); removed some other unnecessary
    code structures as suggested by Tejun

  + consistently used bool return value in all new __cancel functions

  + fixed ordering of cpu and flags parameters in
    create_kthread_worker_on_cpu() vs. create_kthread_worker()

  + used memset in the init_kthread_worker()

  + updated many comments as suggested by Tejun and as
    required the above changes

  + removed obsolete patch adding timer_active()

  + removed obsolete patch for using try_lock in flush_kthread_worker()

  + double checked all existing users of kthread worker API
    that they reinitialized the work when the worker was started
    and would not print false warnings; all looked fine

  + added taken acks for the Intel Powerclamp conversion
    

Changes against v3:

  + allow to free struct kthread_work from its callback; do not touch
    the struct from the worker post-mortem; as a side effect, the structure
    must be reinitialized when the worker gets restarted; updated
    khugepaged, and kmemleak accordingly

  + call del_timer_sync() with worker->lock; instead, detect canceling
    in the timer callback and give up an attempt to get the lock there;
    do busy loop with spin_is_locked() to reduce cache bouncing

  + renamed ipmi+func() -> ipmi_kthread_worker_func() as suggested
    by Corey

  + added some collected Reviewed-by

  
Changes against v2:

  + used worker->lock to synchronize the operations with the work
    instead of the PENDING bit as suggested by Tejun Heo; it simplified
    the implementation in several ways

  + added timer_active(); used it together with del_timer_sync()
    to cancel the work a less tricky way

  + removed the controversial conversion of the RCU kthreads

  + added several other examples: hung_task, kmemleak, ipmi,
    IB/fmr_pool, memstick/r592, intel_powerclamp

  + the helper fixes for the ring buffer benchmark has been improved
    as suggested by Steven; they already are in the Linus tree now

  + fixed a possible race between the check for existing khugepaged
    worker and queuing the work
 

Changes against v1:

  + remove wrappers to manipulate the scheduling policy and priority

  + remove questionable wakeup_and_destroy_kthread_worker() variant

  + do not check for chained work when draining the queue

  + allocate struct kthread worker in create_kthread_work() and
    use more simple checks for running worker

  + add support for delayed kthread works and use them instead
    of waiting inside the works

  + rework the "unrelated" fixes for the ring buffer benchmark
    as discussed in the 1st RFC; also sent separately

  + convert also the consumer in the ring buffer benchmark


I have tested this patch set against the stable Linus tree
for 4.7-rc1.

Comments against v6 can be found at
https://lkml.kernel.org/g/<1460646879-617-1-git-send-email-pmladek-IBi9RG/b67k@public.gmane.org>

Petr Mladek (10):
  kthread/smpboot: Do not park in kthread_create_on_cpu()
  kthread: Allow to call __kthread_create_on_node() with va_list args
  kthread: Add create_kthread_worker*()
  kthread: Add drain_kthread_worker()
  kthread: Add destroy_kthread_worker()
  kthread: Detect when a kthread work is used by more workers
  kthread: Initial support for delayed kthread work
  kthread: Allow to cancel kthread work
  kthread: Allow to modify delayed kthread work
  kthread: Better support freezable kthread workers

 include/linux/kthread.h |  57 +++++
 kernel/kthread.c        | 571 +++++++++++++++++++++++++++++++++++++++++++-----
 kernel/smpboot.c        |   5 +
 3 files changed, 581 insertions(+), 52 deletions(-)

CC: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
CC: linux-watchdog-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: Corey Minyard <minyard-HInyCGIudOg@public.gmane.org>
CC: openipmi-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
CC: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: Maxim Levitsky <maximlevitsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Zhang Rui <rui.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Eduardo Valentin <edubezval-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
CC: linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
