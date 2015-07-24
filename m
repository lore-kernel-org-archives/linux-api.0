From: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 1/5] nohz_full: add support for "cpu_isolated" mode
Date: Fri, 24 Jul 2015 16:21:29 -0400
Message-ID: <55B29E49.5090305@ezchip.com>
References: <1436817481-8732-1-git-send-email-cmetcalf@ezchip.com>
 <1436817481-8732-2-git-send-email-cmetcalf@ezchip.com>
 <20150724132659.GA20091@lerouge>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150724132659.GA20091@lerouge>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 07/24/2015 09:27 AM, Frederic Weisbecker wrote:
> On Mon, Jul 13, 2015 at 03:57:57PM -0400, Chris Metcalf wrote:
>> +{
>> +	struct clock_event_device *dev =
>> +		__this_cpu_read(tick_cpu_device.evtdev);
>> +	struct task_struct *task = current;
>> +	unsigned long start = jiffies;
>> +	bool warned = false;
>> +
>> +	/* Drain the pagevecs to avoid unnecessary IPI flushes later. */
>> +	lru_add_drain();
>> +
>> +	while (READ_ONCE(dev->next_event.tv64) != KTIME_MAX) {
>> +		if (!warned && (jiffies - start) >= (5 * HZ)) {
>> +			pr_warn("%s/%d: cpu %d: cpu_isolated task blocked for %ld seconds\n",
>> +				task->comm, task->pid, smp_processor_id(),
>> +				(jiffies - start) / HZ);
>> +			warned = true;
>> +		}
>> +		if (should_resched())
>> +			schedule();
>> +		if (test_thread_flag(TIF_SIGPENDING))
>> +			break;
>> +		tick_nohz_cpu_isolated_wait();
> If we call cpu_idle(), what is going to wake the CPU up if no further interrupt happen?
>
> We could either implement some sort of tick waiters with proper wake up once the CPU sees
> no tick to schedule. Arguably this is all risky because this involve a scheduler wake up
> and thus the risk for new noise. But it might work.
>
> Another possibility is an msleep() based wait. But that's about the same, maybe even worse
> due to repetitive wake ups.

The presumption here is that it is not possible to have
tick_cpu_device have a pending next_event without also
having a timer interrupt pending to go off.  That certainly
seems to be true on the architectures I have looked at.
Do we think that might ever not be the case?

We are running here with interrupts disabled, so this core won't
transition from "timer interrupt scheduled" to "no timer interrupt
scheduled" before we spin or idle, and presumably no other core
can reach across and turn off our timer interrupt either.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
