From: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/6] nohz: support PR_DATAPLANE_QUIESCE
Date: Thu, 14 May 2015 16:55:01 -0400
Message-ID: <55550BA5.4040905@ezchip.com>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com> <1431107927-13998-5-git-send-email-cmetcalf@ezchip.com> <20150512093349.GH21418@twins.programming.kicks-ass.net> <20150512095030.GD11477@gmail.com> <20150512103805.GJ21418@twins.programming.kicks-ass.net> <20150512125200.GB17244@gmail.com> <CALCETrXGb1_JXLBb62KU=Hb8FZfCuRT1e60xW2KTBEPsYiaAXg@mail.gmail.com> <20150513175150.GL6776@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150513175150.GL6776-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 05/12/2015 08:52 AM, Ingo Molnar wrote:
> What I suggested is that it might make sense to offer a system call,
> for example a sched_setparam() variant, that makes such guarantees.
>
> Say if user-space does:
>
> 	ret = sched_setscheduler(0, BIND_ISOLATED, &isolation_params);
>
> ... then we would get the task moved to an isolated domain and get a 0
> return code if the kernel is able to do all that and if the current
> uid/namespace/etc. has the required permissions and such.

Unfortunately I don't know nearly as much about the scheduler
and scheduler policies as I might, since I mostly focused on
make the scheduler stay out of the way.  :-)  This does seem like
another way to set a policy bit on a process.  I assume you
could only validly issue this call on a nohz_full core, and that
you're not assuming it migrates the cpu to such a core?

You suggested that BIND_ISOLATED would not replace the usual
scheduler policies, but perhaps SCHED_ISOLATED as a full
replacement would make sense - it would make it an error
to have any other schedulable task on that core.  I guess that
brings it around to whether the "cpu_isolated" task just loses when
another task is scheduled on the core with it (the current
approach I'm proposing) or if it ends up truly owning the core
and other processes can be denied the right to run there:
which in that case clearly does get us into the area of requiring
privileges to set up, as Andy pointed out later.

This would leave the notion of "strict" as proposed elsewhere
as a separate thing, but presumably it could still be a prctl()
as originally proposed.

I admit I don't know enough to say whether this sounds like
a better approach than just using a prctl() to set the
cpu_isolated state.  My instinct is that it's cleanest to avoid
requiring permissions to do this, and to simply enable the
quiescing semantics the process requested when it happens
to be alone on a core.  If so, it's somewhat orthogonal to the
actual scheduler policy in force, so best not to conflate it with
the notion of scheduler code at all via sched_setscheduler()?

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
