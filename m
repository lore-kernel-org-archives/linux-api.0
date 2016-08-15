From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: Re: clocksource_watchdog causing scheduling of timers every second
 (was [v13] support "task_isolation" mode)
Date: Mon, 15 Aug 2016 11:03:54 -0400
Message-ID: <142f7676-0a0f-897c-0482-69d52511df57@mellanox.com>
References: <1468529299-27929-1-git-send-email-cmetcalf@mellanox.com>
 <alpine.DEB.2.20.1607202059180.25838@east.gentwo.org>
 <e60d7fd1-022d-c823-52e6-d44a49d274b1@mellanox.com>
 <alpine.DEB.2.20.1607212118210.12213@east.gentwo.org>
 <7a3f66f7-5011-7d59-2e0e-f57e4e42e6b6@mellanox.com>
 <alpine.DEB.2.20.1607251133450.25354@east.gentwo.org>
 <alpine.DEB.2.20.1607270847460.24843@east.gentwo.org>
 <20160810221656.GC19757@lerouge>
 <20160811084002.GV30192@twins.programming.kicks-ass.net>
 <20160811115845.GA4214@lerouge>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160811115845.GA4214@lerouge>
Sender: linux-kernel-owner@vger.kernel.org
To: Frederic Weisbecker <fweisbec@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Christoph Lameter <cl@linux.com>
Cc: Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 8/11/2016 7:58 AM, Frederic Weisbecker wrote:
>> Arguably we should issue a boot time warning if NOHZ_FULL is configured
>> >and the TSC watchdog is running.
> That's a very good idea! We do that when tsc is unstable but indeed we can't
> seriously run NOHZ_FULL on a non-reliable tsc.
>
> I'll take care of that warning.

Thanks.  So I will drop Christoph's patch to run the TSC watchdog on just
housekeeping cores and we will rely on the "boot time warning" instead.

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com
