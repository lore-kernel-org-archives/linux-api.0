From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v13 00/12] support "task_isolation" mode
Date: Mon, 18 Jul 2016 15:11:42 -0700
Message-ID: <CALCETrXp-Km0+ASxgJRgq+30pG=1n+s+=sc=sGGa9ucfMaiUwg@mail.gmail.com>
References: <1468529299-27929-1-git-send-email-cmetcalf@mellanox.com>
 <CALCETrVddfd7ZDGpYs4CdkAMEmQCb6a-_5Um9bb4FO+XwWzOAA@mail.gmail.com> <2a88da0c-b1a9-aec3-f5a6-d524e69e4731@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <2a88da0c-b1a9-aec3-f5a6-d524e69e4731@mellanox.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Daniel Lezcano <daniel.lezcano@linaro.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 14, 2016 at 2:22 PM, Chris Metcalf <cmetcalf@mellanox.com> wrote:
> On 7/14/2016 5:03 PM, Andy Lutomirski wrote:
>>
>> On Thu, Jul 14, 2016 at 1:48 PM, Chris Metcalf <cmetcalf@mellanox.com>
>> wrote:
>>>
>>> Here is a respin of the task-isolation patch set.  This primarily
>>> reflects feedback from Frederic and Peter Z.
>>
>> I still think this is the wrong approach, at least at this point.  The
>> first step should be to instrument things if necessary and fix the
>> obvious cases where the kernel gets entered asynchronously.
>
>
> Note, however, that the task_isolation_debug mode is a very convenient
> way of discovering what is going on when things do go wrong for task
> isolation.
>
>> Only once
>> there's a credible reason to believe it can work well should any form
>> of strictness be applied.
>
>
> I'm not sure what criteria you need for this, though.  Certainly we've been
> shipping our version of task isolation to customers since 2008, and there
> are quite a few customer applications in production that are working well.
> I'd argue that's a credible reason.
>
>> As an example, enough vmalloc/vfree activity will eventually cause
>> flush_tlb_kernel_range to be called and *boom*, there goes your shiny
>> production dataplane application.
>
>
> Well, that's actually a refinement that I did not inflict on this patch
> series.

Submit it separately, perhaps?

The "kill the process if it goofs" think while there are known goofs
in the kernel, apparently with patches written but unsent, seems
questionable.
