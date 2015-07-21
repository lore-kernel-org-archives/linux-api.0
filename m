From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v4 2/5] nohz: support PR_CPU_ISOLATED_STRICT mode
Date: Tue, 21 Jul 2015 12:42:06 -0700
Message-ID: <CALCETrXR46RXiSfb-wWx4BdSDCgc7Dse+h3u7OdD02A6+yaD9Q@mail.gmail.com>
References: <1436817481-8732-1-git-send-email-cmetcalf@ezchip.com>
 <1436817481-8732-3-git-send-email-cmetcalf@ezchip.com> <CALCETrUvg+Dix=jG2_1J=mgQC+uRk4dthCYDcb4E5ooEfQjqtQ@mail.gmail.com>
 <55AE9EAC.4010202@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55AE9EAC.4010202-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 21, 2015 at 12:34 PM, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org> wrote:
> On 07/13/2015 05:47 PM, Andy Lutomirski wrote:
>>
>> On Mon, Jul 13, 2015 at 12:57 PM, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
>> wrote:
>>>
>>> With cpu_isolated mode, the task is in principle guaranteed not to be
>>> interrupted by the kernel, but only if it behaves.  In particular, if it
>>> enters the kernel via system call, page fault, or any of a number of
>>> other
>>> synchronous traps, it may be unexpectedly exposed to long latencies.
>>> Add a simple flag that puts the process into a state where any such
>>> kernel entry is fatal.
>>>
>> To me, this seems like the wrong design.  If nothing else, it seems
>> too much like an abusable anti-debugging mechanism.  I can imagine
>> some per-task flag "I think I shouldn't be interrupted now" and a
>> tracepoint that fires if the task is interrupted with that flag set.
>> But the strong cpu isolation stuff requires systemwide configuration,
>> and I think that monitoring that it works should work similarly.
>
>
> First, you mention a per-task flag, but not specifically whether the
> proposed prctl() mechanism is a reasonable way to set that flag.
> Just wanted to clarify that this wasn't an issue in and of itself for you.

I think I'm okay with a per-task flag for this and, if you add one,
then prctl() is presumably the way to go.  Unless people think that
nohz should be 100% reliable always, in which case might as well make
the flag per-cpu.

>
> Second, you suggest a tracepoint.  I'm OK with creating a tracepoint
> dedicated to cpu_isolated strict failures and making that the only
> way this mechanism works.  But, earlier community feedback seemed to
> suggest that the signal mechanism was OK; one piece of feedback
> just requested being able to set which signal was delivered.  Do you
> think the signal idea is a bad one?  Are you proposing potentially
> having a signal and/or a tracepoint?

I prefer the tracepoint.  It's friendlier to debuggers, and it's
really about diagnosing a kernel problem, not a userspace problem.
Also, I really doubt that people should deploy a signal thing in
production.  What if an NMI fires and kills their realtime program?

>
> Last, you mention systemwide configuration for monitoring.  Can you
> expand on what you mean by that?  We already support the monitoring
> only on the nohz_full cores, so to that extent it's already systemwide.
> And the per-task flag has to be set by the running process when it's
> ready for this state, so that can't really be systemwide configuration.
> I don't understand your suggestion on this point.

I'm really thinking about systemwide configuration for isolation.  I
think we'll always (at least in the nearish term) need the admin's
help to set up isolated CPUs.  If the admin makes a whole CPU be
isolated, then monitoring just that CPU and monitoring it all the time
seems sensible.  If we really do think that isolating a CPU should
require a syscall of some sort because it's too expensive otherwise,
then we can do it that way, too.  And if full isolation requires some
user help (e.g. don't do certain things that break isolation), then
having a per-task monitoring flag seems reasonable.

We may always need the user's help to avoid IPIs.  For example, if one
thread calls munmap, the other thread is going to get an IPI.  There's
nothing we can do about that.

> I'm certainly OK with rebasing on top of 4.3 after the context
> tracking stuff is better.  That said, I think it makes sense to continue
> to debate the intent of the patch series even if we pull this one
> patch out and defer it until after 4.3, or having it end up pulled
> into some other repo that includes the improvements and
> is being pulled for 4.3.

Sure, no problem.

--Andy
