From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v15 04/13] task_isolation: add initial support
Date: Tue, 27 Sep 2016 16:22:20 +0200
Message-ID: <20160927142219.GC6242@lerouge>
References: <fe4b8667-57d5-7767-657a-d89c8b62f8e3@mellanox.com>
 <20160830075854.GZ10153@twins.programming.kicks-ass.net>
 <a321c8a7-fa9c-21f7-61f8-54a8f80763fe@mellanox.com>
 <CALCETrWyKExm9Od3VJ2P9xbL23NPKScgxdQ4R1v5QdNuNXKjmA@mail.gmail.com>
 <e659a498-d951-7d9f-dc0c-9734be3fd826@mellanox.com>
 <CALCETrXA38kv_PEd65j8RHvJKkW5mMxXEmYSr5mec1h3X1hj1w@mail.gmail.com>
 <d15b35ce-5c5d-c451-e47e-d2f915bf70f3@mellanox.com>
 <CALCETrX80akvpLNRQfJsDV560npSa33hSsUB5OYkAtnAn8R7Dg@mail.gmail.com>
 <3f84f736-ed7f-adff-d5f0-4f7db664208f@mellanox.com>
 <CALCETrXrsZjMjdd1jACbrz8GMXQC5FmF8BbkHobmMCbG5GPN7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXrsZjMjdd1jACbrz8GMXQC5FmF8BbkHobmMCbG5GPN7w@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Chris Metcalf <cmetcalf@mellanox.com>, Thomas Gleixner <tglx@linutronix.de>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Christoph Lameter <cl@linux.com>, Michal Hocko <mhocko@suse.com>, Gilad Ben Yossef <giladb@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, Viresh Kumar <viresh.kumar@linaro.org>, Linux API <linux-api@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>, Rik van Riel <riel@redhat.com>, Will Deacon <will.deacon@arm.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 02, 2016 at 10:28:00AM -0700, Andy Lutomirski wrote:
> 
> Unless I'm missing something (which is reasonably likely), couldn't
> the isolation code just force or require rcu_nocbs on the isolated
> CPUs to avoid this problem entirely.

rcu_nocb is already implied by nohz_full. Which means that RCU callbacks
are offlined outside the nohz_full set of CPUs.

> 
> I admit I still don't understand why the RCU context tracking code
> can't just run the callback right away instead of waiting however many
> microseconds in general.  I feel like paulmck has explained it to me
> at least once, but that doesn't mean I remember the answer.

The RCU context tracking doesn't take care of callbacks. It's only there
to tell the RCU core whether the CPU runs code that may or may not run
RCU read side critical sections. This is assumed by "kernel may use RCU,
userspace can't".
