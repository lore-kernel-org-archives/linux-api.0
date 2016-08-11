From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v13 00/12] support "task_isolation" mode
Date: Thu, 11 Aug 2016 10:27:33 +0200
Message-ID: <20160811082733.GU30192@twins.programming.kicks-ass.net>
References: <1468529299-27929-1-git-send-email-cmetcalf@mellanox.com>
 <alpine.DEB.2.20.1607202059180.25838@east.gentwo.org>
 <e60d7fd1-022d-c823-52e6-d44a49d274b1@mellanox.com>
 <alpine.DEB.2.20.1607212118210.12213@east.gentwo.org>
 <7a3f66f7-5011-7d59-2e0e-f57e4e42e6b6@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7a3f66f7-5011-7d59-2e0e-f57e4e42e6b6@mellanox.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Christoph Lameter <cl@linux.com>, Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jul 22, 2016 at 08:50:44AM -0400, Chris Metcalf wrote:
> On 7/21/2016 10:20 PM, Christoph Lameter wrote:
> >On Thu, 21 Jul 2016, Chris Metcalf wrote:
> >>On 7/20/2016 10:04 PM, Christoph Lameter wrote:
> >>unstable, and then scheduling work to safely remove that timer.
> >>I haven't looked at this code before (in kernel/time/clocksource.c
> >>under CONFIG_CLOCKSOURCE_WATCHDOG) since the timers on
> >>arm64 and tile aren't unstable.  Is it possible to boot your machine
> >>with a stable clocksource?
> >It already as a stable clocksource. Sorry but that was one of the criteria
> >for the server when we ordered them. Could this be clock adjustments?
> 
> We probably need to get clock folks to jump in on this thread!

Boot with: tsc=reliable, this disables the watchdog.

We (sadly) have to have this thing running on most x86 because TSC, even
if initially stable, can do weird things once its running.

We have seen:

 - SMI
 - hotplug
 - suspend
 - multi-socket

mess up the TSC, even if it was deemed 'good' at boot time.

If you _know_ your TSC to be solid, boot with tsc=reliable and be happy.
