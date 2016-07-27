From: Christoph Lameter <cl@linux.com>
Subject: Re: clocksource_watchdog causing scheduling of timers every second
 (was [v13] support "task_isolation" mode)
Date: Wed, 27 Jul 2016 14:53:47 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1607271452530.9567@east.gentwo.org>
References: <1468529299-27929-1-git-send-email-cmetcalf@mellanox.com> <alpine.DEB.2.20.1607202059180.25838@east.gentwo.org> <e60d7fd1-022d-c823-52e6-d44a49d274b1@mellanox.com> <alpine.DEB.2.20.1607212118210.12213@east.gentwo.org> <7a3f66f7-5011-7d59-2e0e-f57e4e42e6b6@mellanox.com>
 <alpine.DEB.2.20.1607251133450.25354@east.gentwo.org> <alpine.DEB.2.20.1607270847460.24843@east.gentwo.org> <f8d72e47-7e84-cbd0-869f-69bf452a8bfb@mellanox.com> <alpine.DEB.2.20.1607271022130.25729@east.gentwo.org> <alpine.DEB.2.20.1607271030020.25729@east.gentwo.org>
 <f7553d2a-f4ab-b218-bb93-fcb436db1770@mellanox.com> <alpine.DEB.2.20.1607271355320.5760@east.gentwo.org> <eacd22ec-fc87-290e-ee5f-21b8e879b059@mellanox.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <eacd22ec-fc87-290e-ee5f-21b8e879b059@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 27 Jul 2016, Chris Metcalf wrote:

> Looks good.  Did you omit the equivalent fix in clocksource_start_watchdog()
> on purpose?  For now I just took your change, but tweaked it to add the
> equivalent diff with cpumask_first_and() there.

Can the watchdog be started on an isolated cpu at all? I would expect that
the code would start a watchdog only on a housekeeping cpu.
