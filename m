From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v4 1/5] nohz_full: add support for "cpu_isolated" mode
Date: Tue, 21 Jul 2015 12:26:17 -0700
Message-ID: <CALCETrVoHvofNHG81Q2Vb2i1qc7f2dy=qgkyb5NWNfUgYxhE8Q@mail.gmail.com>
References: <1436817481-8732-1-git-send-email-cmetcalf@ezchip.com>
 <1436817481-8732-2-git-send-email-cmetcalf@ezchip.com> <CALCETrWaBe10u1X+AqYM7TsbguL=aF-TyuN3xjqgR5Cg2=FiAA@mail.gmail.com>
 <55A4271B.9040506@ezchip.com> <CALCETrUMGx+ZC9rtAAErKaGg-LEtYXMOSVD1dCi7im3b1SMrVg@mail.gmail.com>
 <55AE993E.6040501@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <55AE993E.6040501@ezchip.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 21, 2015 at 12:10 PM, Chris Metcalf <cmetcalf@ezchip.com> wrote:
> Sorry for the delay in responding; some other priorities came up internally.
>
> On 07/13/2015 05:45 PM, Andy Lutomirski wrote:
>>
>> On Mon, Jul 13, 2015 at 2:01 PM, Chris Metcalf <cmetcalf@ezchip.com>
>> wrote:
>>>
>>> On 07/13/2015 04:40 PM, Andy Lutomirski wrote:
>>>>
>>>> On Mon, Jul 13, 2015 at 12:57 PM, Chris Metcalf <cmetcalf@ezchip.com>
>>>>
>>>> wrote:
>>>>>
>>>>> The existing nohz_full mode makes tradeoffs to minimize userspace
>>>>> interruptions while still attempting to avoid overheads in the
>>>>> kernel entry/exit path, to provide 100% kernel semantics, etc.
>>>>>
>>>>> However, some applications require a stronger commitment from the
>>>>> kernel to avoid interruptions, in particular userspace device
>>>>> driver style applications, such as high-speed networking code.
>>>>>
>>>>> This change introduces a framework to allow applications to elect
>>>>> to have the stronger semantics as needed, specifying
>>>>> prctl(PR_SET_CPU_ISOLATED, PR_CPU_ISOLATED_ENABLE) to do so.
>>>>> Subsequent commits will add additional flags and additional
>>>>> semantics.
>>>>
>>>> I thought the general consensus was that this should be the default
>>>> behavior and that any associated bugs should be fixed.
>>>
>>>
>>> I think it comes down to dividing the set of use cases in two:
>>>
>>> - "Regular" nohz_full, as used to improve performance and limit
>>>    interruptions, possibly for power benefits, etc.  But, stray
>>>    interrupts are not particularly bad, and you don't want to take
>>>    extreme measures to avoid them.
>>>
>>> - What I'm calling "cpu_isolated" mode where when you return to
>>>    userspace, you expect that by God, the kernel doesn't interrupt you
>>>    again, and if it does, it's a flat-out bug.
>>>
>>> There are a few things that cpu_isolated mode currently does to
>>> accomplish its goals that are pretty heavy-weight:
>>>
>>> Processes are held in kernel space until ticks are quiesced; this is
>>> not necessarily what every nohz_full task wants.  If a task makes a
>>> kernel call, there may well be arbitrary timer fallout, and having a
>>> way to select whether or not you are willing to take a timer tick after
>>> return to userspace is pretty important.
>>
>> Then shouldn't deferred work be done immediately in nohz_full mode
>> regardless?  What is this delayed work that's being done?
>
>
> I'm thinking of things like needing to wait for an RCU quiesce
> period to complete.

rcu_nocbs does this, right?

>
> In the current version, there's also the vmstat_update() that
> may schedule delayed work and interrupt the core again
> shortly before realizing that there are no more counter updates
> happening, at which point it quiesces.  Currently we handle
> this in cpu_isolated mode simply by spinning and waiting for
> the timer interrupts to complete.

Perhaps we should fix that?

>
>>> Likewise, there are things that you may want to do on return to
>>> userspace that are designed to prevent further interruptions in
>>> cpu_isolated mode, even at a possible future performance cost if and
>>> when you return to the kernel, such as flushing the per-cpu free page
>>> list so that you won't be interrupted by an IPI to flush it later.
>>
>> Why not just kick the per-cpu free page over to whatever cpu is
>> monitoring your RCU state, etc?  That should be very quick.
>
>
> So just for the sake of precision, the thing I'm talking about
> is the lru_add_drain() call on kernel exit.  Are you proposing
> that we call that for every nohz_full core on kernel exit?
> I'm not opposed to this, but I don't know if other nohz
> developers feel like this is the right tradeoff.

I'm proposing either that we do that or that we arrange for other cpus
to be able to steal our LRU list while we're in RCU user/idle.

>> Let's fix them instead of adding new ABIs to work around them.
>
>
> Well, in principle if we accepted my proposed patch series
> and then over time came to decide that it was reasonable
> for nohz_full to have these complete cpu isolation
> semantics, the one proposed ABI simply becomes a no-op.
> So it's not as problematic an ABI as some.

What if we made it a debugfs thing instead of a prctl?  Have a mode
where the system tries really hard to quiesce itself even at the cost
of performance.

>
> My issue is this: I'm totally happy with submitting a revised
> patch series that does all the stuff for pure nohz_full that
> I'm currently proposing for cpu_isolated.  But, is it what
> the community wants?  Should I propose it and see?
>
> Frederic, do you have any insight here?  Thanks!
>
> --
> Chris Metcalf, EZChip Semiconductor
> http://www.ezchip.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Andy Lutomirski
AMA Capital Management, LLC
