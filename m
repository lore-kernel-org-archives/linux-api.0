From: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v13 00/12] support "task_isolation" mode
Date: Thu, 14 Jul 2016 17:22:17 -0400
Message-ID: <2a88da0c-b1a9-aec3-f5a6-d524e69e4731@mellanox.com>
References: <1468529299-27929-1-git-send-email-cmetcalf@mellanox.com>
 <CALCETrVddfd7ZDGpYs4CdkAMEmQCb6a-_5Um9bb4FO+XwWzOAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVddfd7ZDGpYs4CdkAMEmQCb6a-_5Um9bb4FO+XwWzOAA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 7/14/2016 5:03 PM, Andy Lutomirski wrote:
> On Thu, Jul 14, 2016 at 1:48 PM, Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> Here is a respin of the task-isolation patch set.  This primarily
>> reflects feedback from Frederic and Peter Z.
> I still think this is the wrong approach, at least at this point.  The
> first step should be to instrument things if necessary and fix the
> obvious cases where the kernel gets entered asynchronously.

Note, however, that the task_isolation_debug mode is a very convenient
way of discovering what is going on when things do go wrong for task isolation.

> Only once
> there's a credible reason to believe it can work well should any form
> of strictness be applied.

I'm not sure what criteria you need for this, though.  Certainly we've been
shipping our version of task isolation to customers since 2008, and there
are quite a few customer applications in production that are working well.
I'd argue that's a credible reason.

> As an example, enough vmalloc/vfree activity will eventually cause
> flush_tlb_kernel_range to be called and *boom*, there goes your shiny
> production dataplane application.

Well, that's actually a refinement that I did not inflict on this patch series.

In our code base, we have a hook for kernel TLB flushes that defers such
flushes for cores that are running in userspace, because, after all, they
don't yet care about such flushes.  Instead, we atomically set a flag that
is checked on entry to the kernel, and that causes the TLB flush to occur
at that point.

> On very brief inspection, __kmem_cache_shutdown will be a problem on
> some workloads as well.

That looks like it should be amenable to a version of the same fix I pushed
upstream in 5fbc461636c32efd ("mm: make lru_add_drain_all() selective").
You would basically check which cores have non-empty caches, and only
interrupt those cores.  For extra credit, you empty the cache on your local cpu
when you are entering task isolation mode.  Now you don't get interrupted.

To be fair, I've never seen this particular path cause an interruption.  And I
think this speaks to the fact that there really can't be a black and white
decision about when you have removed enough possible interrupt paths.
It really does depend on what else is running on your machine in addition
to the task isolation code, and that will vary from application to application.
And, as the kernel evolves, new ways of interrupting task isolation cores
will get added and need to be dealt with.  There really isn't a perfect time
you can wait for and then declare that all the asynchronous entry cases
have been dealt with and now things are safe for task isolation.

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com
