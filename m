From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: Re: [PATCH v13 00/12] support "task_isolation" mode
Date: Mon, 18 Jul 2016 18:50:32 -0400
Message-ID: <947dc28d-c860-7fcf-210c-41a6e5a86844@mellanox.com>
References: <1468529299-27929-1-git-send-email-cmetcalf@mellanox.com>
 <CALCETrVddfd7ZDGpYs4CdkAMEmQCb6a-_5Um9bb4FO+XwWzOAA@mail.gmail.com>
 <2a88da0c-b1a9-aec3-f5a6-d524e69e4731@mellanox.com>
 <CALCETrXp-Km0+ASxgJRgq+30pG=1n+s+=sc=sGGa9ucfMaiUwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CALCETrXp-Km0+ASxgJRgq+30pG=1n+s+=sc=sGGa9ucfMaiUwg@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Daniel Lezcano <daniel.lezcano@linaro.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 7/18/2016 6:11 PM, Andy Lutomirski wrote:
>>> As an example, enough vmalloc/vfree activity will eventually cause
>>> flush_tlb_kernel_range to be called and*boom*, there goes your shiny
>>> production dataplane application.
>>
>> Well, that's actually a refinement that I did not inflict on this patch
>> series.
> Submit it separately, perhaps?
>
> The "kill the process if it goofs" thing while there are known goofs
> in the kernel, apparently with patches written but unsent, seems
> questionable.

Sure, that's a good idea.

I think what I will plan to do is, once the patch series is accepted into
some tree, return to this piece.  I'll have to go back and look at the internal
Tilera version of this code, since we have diverged quite a ways from that
in the 13 versions of the patch series, but my memory is that the kernel TLB
flush management was the only substantial piece of additional code not in
the initial batch of changes.  The extra requirement is the need to have a
hook very early on in the kernel entry path that you can hook in all paths;
arm64 has the ct_user_exit macro and tile has the finish_interrupt_save macro,
but I'm not sure there's something equivalent on x86 to catch all entries.

It's worth noting that the typical target application for task isolation, though
(at least in our experience) is a pretty dedicated machine, with the primary
application running in task isolation mode almost all of the time, and so
you are generally in pretty good control of all aspects of the system, including
whether or not you are generating kernel TLB flushes from your non task
isolation cores.  So I would argue the kernel TLB flush management piece is
an improvement to, not a requirement for, the main patch series.

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com

