From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: Re: [PATCH v13 00/12] support "task_isolation" mode
Date: Fri, 22 Jul 2016 08:50:44 -0400
Message-ID: <7a3f66f7-5011-7d59-2e0e-f57e4e42e6b6@mellanox.com>
References: <1468529299-27929-1-git-send-email-cmetcalf@mellanox.com>
 <alpine.DEB.2.20.1607202059180.25838@east.gentwo.org>
 <e60d7fd1-022d-c823-52e6-d44a49d274b1@mellanox.com>
 <alpine.DEB.2.20.1607212118210.12213@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1607212118210.12213@east.gentwo.org>
Sender: linux-doc-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 7/21/2016 10:20 PM, Christoph Lameter wrote:
> On Thu, 21 Jul 2016, Chris Metcalf wrote:
>> On 7/20/2016 10:04 PM, Christoph Lameter wrote:
>> unstable, and then scheduling work to safely remove that timer.
>> I haven't looked at this code before (in kernel/time/clocksource.c
>> under CONFIG_CLOCKSOURCE_WATCHDOG) since the timers on
>> arm64 and tile aren't unstable.  Is it possible to boot your machine
>> with a stable clocksource?
> It already as a stable clocksource. Sorry but that was one of the criteria
> for the server when we ordered them. Could this be clock adjustments?

We probably need to get clock folks to jump in on this thread!

Maybe it's disabling some built-in unstable clock just as part of
falling back to using the better, stable clock that you also have?
So maybe there's a way of just disabling that clocksource from the
get-go instead of having it be marked unstable later.

If you run the test again after this storm of unstable marking, does
it all happen again?  Or is it a persistent state in the kernel?
If so, maybe you can just arrange to get to that state before starting
your application's task-isolation code.

Or, if you think it's clock adjustments, perhaps running your test with
ntpd disabled would make it work better?

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com

