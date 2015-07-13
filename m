From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v4 1/5] nohz_full: add support for "cpu_isolated" mode
Date: Mon, 13 Jul 2015 14:45:19 -0700
Message-ID: <CALCETrUMGx+ZC9rtAAErKaGg-LEtYXMOSVD1dCi7im3b1SMrVg@mail.gmail.com>
References: <1436817481-8732-1-git-send-email-cmetcalf@ezchip.com>
 <1436817481-8732-2-git-send-email-cmetcalf@ezchip.com> <CALCETrWaBe10u1X+AqYM7TsbguL=aF-TyuN3xjqgR5Cg2=FiAA@mail.gmail.com>
 <55A4271B.9040506@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <55A4271B.9040506@ezchip.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 13, 2015 at 2:01 PM, Chris Metcalf <cmetcalf@ezchip.com> wrote:
> On 07/13/2015 04:40 PM, Andy Lutomirski wrote:
>>
>> On Mon, Jul 13, 2015 at 12:57 PM, Chris Metcalf <cmetcalf@ezchip.com>
>> wrote:
>>>
>>> The existing nohz_full mode makes tradeoffs to minimize userspace
>>> interruptions while still attempting to avoid overheads in the
>>> kernel entry/exit path, to provide 100% kernel semantics, etc.
>>>
>>> However, some applications require a stronger commitment from the
>>> kernel to avoid interruptions, in particular userspace device
>>> driver style applications, such as high-speed networking code.
>>>
>>> This change introduces a framework to allow applications to elect
>>> to have the stronger semantics as needed, specifying
>>> prctl(PR_SET_CPU_ISOLATED, PR_CPU_ISOLATED_ENABLE) to do so.
>>> Subsequent commits will add additional flags and additional
>>> semantics.
>>
>> I thought the general consensus was that this should be the default
>> behavior and that any associated bugs should be fixed.
>
>
> I think it comes down to dividing the set of use cases in two:
>
> - "Regular" nohz_full, as used to improve performance and limit
>   interruptions, possibly for power benefits, etc.  But, stray
>   interrupts are not particularly bad, and you don't want to take
>   extreme measures to avoid them.
>
> - What I'm calling "cpu_isolated" mode where when you return to
>   userspace, you expect that by God, the kernel doesn't interrupt you
>   again, and if it does, it's a flat-out bug.
>
> There are a few things that cpu_isolated mode currently does to
> accomplish its goals that are pretty heavy-weight:
>
> Processes are held in kernel space until ticks are quiesced; this is
> not necessarily what every nohz_full task wants.  If a task makes a
> kernel call, there may well be arbitrary timer fallout, and having a
> way to select whether or not you are willing to take a timer tick after
> return to userspace is pretty important.

Then shouldn't deferred work be done immediately in nohz_full mode
regardless?  What is this delayed work that's being done?

>
> Likewise, there are things that you may want to do on return to
> userspace that are designed to prevent further interruptions in
> cpu_isolated mode, even at a possible future performance cost if and
> when you return to the kernel, such as flushing the per-cpu free page
> list so that you won't be interrupted by an IPI to flush it later.
>

Why not just kick the per-cpu free page over to whatever cpu is
monitoring your RCU state, etc?  That should be very quick.

> If you're arguing that the cpu_isolated semantic is really the only
> one that makes sense for nohz_full, my sense is that it might be
> surprising to many of the folks who do nohz_full work.  But, I'm happy
> to be wrong on this point, and maybe all the nohz_full community is
> interested in making the same tradeoffs for nohz_full generally that
> I've proposed in this patch series just for cpu_isolated?

nohz_full is currently dog slow for no particularly good reasons.  I
suspect that the interrupts you're seeing are also there for no
particularly good reasons as well.

Let's fix them instead of adding new ABIs to work around them.

--Andy
