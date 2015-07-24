From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH v4 1/5] nohz_full: add support for "cpu_isolated" mode
Date: Fri, 24 Jul 2015 16:22:07 -0400
Message-ID: <55B29E6F.7020600@ezchip.com>
References: <1436817481-8732-1-git-send-email-cmetcalf@ezchip.com>
 <1436817481-8732-2-git-send-email-cmetcalf@ezchip.com>
 <CALCETrWaBe10u1X+AqYM7TsbguL=aF-TyuN3xjqgR5Cg2=FiAA@mail.gmail.com>
 <55A4271B.9040506@ezchip.com>
 <CALCETrUMGx+ZC9rtAAErKaGg-LEtYXMOSVD1dCi7im3b1SMrVg@mail.gmail.com>
 <55AE993E.6040501@ezchip.com>
 <CALCETrVoHvofNHG81Q2Vb2i1qc7f2dy=qgkyb5NWNfUgYxhE8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVoHvofNHG81Q2Vb2i1qc7f2dy=qgkyb5NWNfUgYxhE8Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 07/21/2015 03:26 PM, Andy Lutomirski wrote:
> On Tue, Jul 21, 2015 at 12:10 PM, Chris Metcalf <cmetcalf@ezchip.com> wrote:
>> So just for the sake of precision, the thing I'm talking about
>> is the lru_add_drain() call on kernel exit.  Are you proposing
>> that we call that for every nohz_full core on kernel exit?
>> I'm not opposed to this, but I don't know if other nohz
>> developers feel like this is the right tradeoff.
> I'm proposing either that we do that or that we arrange for other cpus
> to be able to steal our LRU list while we're in RCU user/idle.

That seems challenging; there is a lot that has to be done in
lru_add_drain() and we may not want to do it for the "soft
isolation" mode Frederic alludes to in a later email.  And, we
would have to add a bunch of locking to allow another process
to steal the list from under us, so that's not obviously going
to be a performance win in terms of the per-cpu page cache
for normal operations.

Perhaps there could be a lock taken that nohz_full processes
have to take just to exit from userspace, and that other tasks
could take to do things on behalf of the nohz_full process that
it thinks it can do locklessly.  It gets complicated, since you'd
want to tie that to whether the nohz_full process was currently
in the kernel or not, so some kind of atomic update on the
context_tracking state or some such, perhaps.  Still not really
clear if that overhead is worth it (both from a maintenance
point of view and the possible performance hit).

Limiting it just to the hard isolation mode seems like a good
answer since there we really know that userspace does not
care about the performance implications of kernel/userspace
transitions, and it doesn't cause slowdowns to anyone else.

For now I will bundle it in with my respin as part of the
"hard isolation" mode Frederic proposed.

>> Well, in principle if we accepted my proposed patch series
>> and then over time came to decide that it was reasonable
>> for nohz_full to have these complete cpu isolation
>> semantics, the one proposed ABI simply becomes a no-op.
>> So it's not as problematic an ABI as some.
> What if we made it a debugfs thing instead of a prctl?  Have a mode
> where the system tries really hard to quiesce itself even at the cost
> of performance.

No, since it's really a mode within an individual task that you'd
like to switch on and off depending on what the task is trying
to do - strict mode while it's running its main fast-path userspace
code, but certainly not strict mode during its setup, and possibly
leaving strict mode to run some kinds of slow-path, diagnostic,
or error-handling code.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
