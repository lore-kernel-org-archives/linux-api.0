From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH 4/6] nohz: support PR_DATAPLANE_QUIESCE
Date: Thu, 14 May 2015 16:54:32 -0400
Message-ID: <55550B88.8030306@ezchip.com>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com> <1431107927-13998-5-git-send-email-cmetcalf@ezchip.com> <20150512093349.GH21418@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150512093349.GH21418@twins.programming.kicks-ass.net>
Sender: linux-doc-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Frederic Weisbecker <fweisbec@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 05/12/2015 05:33 AM, Peter Zijlstra wrote:
> On Fri, May 08, 2015 at 01:58:45PM -0400, Chris Metcalf wrote:
>> This prctl() flag for PR_SET_DATAPLANE sets a mode that requires the
>> kernel to quiesce any pending timer interrupts prior to returning
>> to userspace.  When running with this mode set, sys calls (and page
>> faults, etc.) can be inordinately slow.  However, user applications
>> that want to guarantee that no unexpected interrupts will occur
>> (even if they call into the kernel) can set this flag to guarantee
>> that semantics.
> Currently people hot-unplug and hot-plug the CPU to do this. Obviously
> that's a wee bit horrible :-)
>
> Not sure if a prctl like this is any better though. This is a CPU
> properly not a process one.

The CPU property aspects, I think, should be largely handled by
fixing kernel bugs that let work end up running on nohz_full cores
without having been explicitly requested to run there.

As you said in a follow-up email:

On 05/12/2015 06:38 AM, Peter Zijlstra wrote:
> Ideally we'd never have to clear the state because it should be
> impossible to get into this predicament in the first place.

What my prctl() proposal does is quiesce things that end up
happening specifically because the user process called on purpose
into the kernel.  For example, perhaps RCU was invoked in the
kernel, and the core has to wait a timer tick to quiesce RCU.
Whatever causes it, the intent is that you're not allowed back into
userspace until everything has settled down from your call into
the kernel; the presumption is that it's all due to the kernel entry
that was just made, and not from other stray work.

In that sense, it's very appropriate for it to be a process property.

> ISTR people talking about 'quiesce' sysfs file, along side the hotplug
> stuff, I can't quite remember.

It seems somewhat similar (adding Viresh to the cc's) but does
seem like it might have been more intended to address the
CPU properties rather than process properties:

   https://lkml.org/lkml/2014/4/4/99

One thing the original Tilera dataplane code did was to require
setting dataplane flags to succeed only on dataplane cores,
and only when the task had been affinitized to that single core.
This did not protect the task from later being re-affinitized in
a way that broke those assumptions, but I suppose you could
also imagine make sched_setaffinity() fail for such a process.
Somewhat unrelated, but it occurred to me in the context of this
reply, so what do you think?  I can certainly add this to the
patch series if it seems like it makes setting the prctl() flags
more conservative.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

