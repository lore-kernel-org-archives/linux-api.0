From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH v4 2/5] nohz: support PR_CPU_ISOLATED_STRICT mode
Date: Fri, 24 Jul 2015 16:29:51 -0400
Message-ID: <55B2A03F.4070009@ezchip.com>
References: <1436817481-8732-1-git-send-email-cmetcalf@ezchip.com>
 <1436817481-8732-3-git-send-email-cmetcalf@ezchip.com>
 <CALCETrUvg+Dix=jG2_1J=mgQC+uRk4dthCYDcb4E5ooEfQjqtQ@mail.gmail.com>
 <55AE9EAC.4010202@ezchip.com>
 <CALCETrXR46RXiSfb-wWx4BdSDCgc7Dse+h3u7OdD02A6+yaD9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CALCETrXR46RXiSfb-wWx4BdSDCgc7Dse+h3u7OdD02A6+yaD9Q@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 07/21/2015 03:42 PM, Andy Lutomirski wrote:
> On Tue, Jul 21, 2015 at 12:34 PM, Chris Metcalf <cmetcalf@ezchip.com> wrote:
>> Second, you suggest a tracepoint.  I'm OK with creating a tracepoint
>> dedicated to cpu_isolated strict failures and making that the only
>> way this mechanism works.  But, earlier community feedback seemed to
>> suggest that the signal mechanism was OK; one piece of feedback
>> just requested being able to set which signal was delivered.  Do you
>> think the signal idea is a bad one?  Are you proposing potentially
>> having a signal and/or a tracepoint?
> I prefer the tracepoint.  It's friendlier to debuggers, and it's
> really about diagnosing a kernel problem, not a userspace problem.
> Also, I really doubt that people should deploy a signal thing in
> production.  What if an NMI fires and kills their realtime program?

No, this piece of the patch series is about diagnosing bugs in the
userspace program (likely in third-party code, in our customers'
experience).  When you violate strict mode, you get a signal and
you have a nice pointer to what instruction it was that caused
you to enter the kernel.

You are right that running this in production is likely not a great
idea, as is true for other debugging mechanisms.  But you might
really want to have it as a signal with a signal handler that fires
to generate a trace of some kind into the application's existing
tracing mechanisms, so the app doesn't just report "wow, I lost
a bunch of time in here somewhere, sorry about those packets
I dropped on the floor", but "here's where I took a strict signal".
You probably drop a few additional packets due to the signal
handling and logging, but given you've already fallen away from
100% in this case, the extra diagnostics are almost certainly
worth it.

In this case it's probably not as helpful to have a tracepoint-based
solution, just because you really do want to be able to easily
integrate into the app's existing logging framework.

My sense, I think, is that we can easily add tracepoints to the
strict failure code in the future, so it may not be worth trying to
widen the scope of the patch series just now.

>> Last, you mention systemwide configuration for monitoring.  Can you
>> expand on what you mean by that?  We already support the monitoring
>> only on the nohz_full cores, so to that extent it's already systemwide.
>> And the per-task flag has to be set by the running process when it's
>> ready for this state, so that can't really be systemwide configuration.
>> I don't understand your suggestion on this point.
> I'm really thinking about systemwide configuration for isolation.  I
> think we'll always (at least in the nearish term) need the admin's
> help to set up isolated CPUs.  If the admin makes a whole CPU be
> isolated, then monitoring just that CPU and monitoring it all the time
> seems sensible.  If we really do think that isolating a CPU should
> require a syscall of some sort because it's too expensive otherwise,
> then we can do it that way, too.  And if full isolation requires some
> user help (e.g. don't do certain things that break isolation), then
> having a per-task monitoring flag seems reasonable.
>
> We may always need the user's help to avoid IPIs.  For example, if one
> thread calls munmap, the other thread is going to get an IPI.  There's
> nothing we can do about that.

I think we're mostly agreed on this stuff, though your use of
"monitored" doesn't really match the "strict" mode in this patch.

It's certainly true that, for example, we advise customers not to
run the slow-path code on a housekeeping cpu as a thread in the
same process space as the fast-path code on the nohz_full cores,
just because things like fclose() on a file descriptor will lead to
free() which can lead to munmap() and an IPI to the fast path.

>> I'm certainly OK with rebasing on top of 4.3 after the context
>> tracking stuff is better.  That said, I think it makes sense to continue
>> to debate the intent of the patch series even if we pull this one
>> patch out and defer it until after 4.3, or having it end up pulled
>> into some other repo that includes the improvements and
>> is being pulled for 4.3.
> Sure, no problem.

I will add a comment to the patch and a note to the series about
this, but for now I'll keep it in the series.  If we can arrange to pull
it into Frederic's tree after the context_tracking changes, we can
respin it at that point to layer it on top.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

