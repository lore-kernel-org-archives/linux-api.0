From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v13 00/12] support "task_isolation" mode
Date: Thu, 14 Jul 2016 14:03:24 -0700
Message-ID: <CALCETrVddfd7ZDGpYs4CdkAMEmQCb6a-_5Um9bb4FO+XwWzOAA@mail.gmail.com>
References: <1468529299-27929-1-git-send-email-cmetcalf@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468529299-27929-1-git-send-email-cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 14, 2016 at 1:48 PM, Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Here is a respin of the task-isolation patch set.  This primarily
> reflects feedback from Frederic and Peter Z.

I still think this is the wrong approach, at least at this point.  The
first step should be to instrument things if necessary and fix the
obvious cases where the kernel gets entered asynchronously.  Only once
there's a credible reason to believe it can work well should any form
of strictness be applied.

As an example, enough vmalloc/vfree activity will eventually cause
flush_tlb_kernel_range to be called and *boom*, there goes your shiny
production dataplane application.  Once virtually mapped kernel stacks
happen, the frequency with which this happens will only increase.

On very brief inspection, __kmem_cache_shutdown will be a problem on
some workloads as well.

--Andy
