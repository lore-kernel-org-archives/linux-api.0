From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH v5 2/6] cpu_isolated: add initial support
Date: Wed, 26 Aug 2015 11:55:14 -0400
Message-ID: <55DDE162.1060804@ezchip.com>
References: <1438112980-9981-1-git-send-email-cmetcalf@ezchip.com>
 <1438112980-9981-3-git-send-email-cmetcalf@ezchip.com>
 <20150812160020.GG21542@lerouge> <55CB8ED1.6030806@ezchip.com>
 <20150826152651.GA11992@lerouge>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150826152651.GA11992@lerouge>
Sender: linux-kernel-owner@vger.kernel.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 08/26/2015 11:26 AM, Frederic Weisbecker wrote:
> On Wed, Aug 12, 2015 at 02:22:09PM -0400, Chris Metcalf wrote:
>> On 08/12/2015 12:00 PM, Frederic Weisbecker wrote:
>>>> +#ifdef CONFIG_CPU_ISOLATED
>>>> +void cpu_isolated_wait(void)
>>>> +{
>>>> +	set_current_state(TASK_INTERRUPTIBLE);
>>>> +	_cpu_idle();
>>>> +	set_current_state(TASK_RUNNING);
>>>> +}
>>> I'm still uncomfortable with that. A wake up model could work?
>> I don't know exactly what you have in mind.  The theory is that
>> at this point we're ready to return to user space and we're just
>> waiting for a timer tick that is guaranteed to arrive, since there
>> is something pending for the timer.
> Hmm, ok I'm going to discuss that in the new version. One worry is that
> it gets racy and we sleep there for ever.
>
>> And, this is an arch-specific method anyway; the generic method
>> is actually checking to see if a signal has been delivered,
>> scheduling is needed, etc., each time around the loop, so if
>> you're not sure your architecture will do the right thing, just
>> don't provide a method that idles while waiting.  For tilegx I'm
>> sure it works correctly, so I'm OK providing that method.
> Yes but we do busy waiting on all other archs then. And since we can wait
> for a while there, it doesn't look sane.

We can wait for a while (potentially multiple ticks), which is
certainly a long time, but that's what the user asked for.

Since we're checking signals and scheduling in the busy loop,
we definitely won't get into some nasty unkillable state, which
would be the real worst-case.

I think the question is, could a process just get stuck there
somehow in the normal course of events, where there is a
future event on the tick_cpu_device, but no interrupt is
enabled that will eventually deal with it?  This seems like it
would be a pretty fundamental timekeeping bug, so my
assumption here is that can't happen, but maybe...?

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
