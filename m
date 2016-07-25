From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v13 00/12] support "task_isolation" mode
Date: Mon, 25 Jul 2016 11:35:30 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1607251133450.25354@east.gentwo.org>
References: <1468529299-27929-1-git-send-email-cmetcalf@mellanox.com> <alpine.DEB.2.20.1607202059180.25838@east.gentwo.org> <e60d7fd1-022d-c823-52e6-d44a49d274b1@mellanox.com> <alpine.DEB.2.20.1607212118210.12213@east.gentwo.org>
 <7a3f66f7-5011-7d59-2e0e-f57e4e42e6b6@mellanox.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <7a3f66f7-5011-7d59-2e0e-f57e4e42e6b6@mellanox.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 22 Jul 2016, Chris Metcalf wrote:

> > It already as a stable clocksource. Sorry but that was one of the criteria
> > for the server when we ordered them. Could this be clock adjustments?
>
> We probably need to get clock folks to jump in on this thread!

Guess so. I will have a look at this when I get some time again.

> Maybe it's disabling some built-in unstable clock just as part of
> falling back to using the better, stable clock that you also have?
> So maybe there's a way of just disabling that clocksource from the
> get-go instead of having it be marked unstable later.

This is a standard Dell server. No clocksources are marked as unstable as
far as I can tell.

> If you run the test again after this storm of unstable marking, does
> it all happen again?  Or is it a persistent state in the kernel?

This happens anytime we try to run with prctl().

I hope to get some more detail once I get some time to look at this. But
this is likely an x86 specific problem.

