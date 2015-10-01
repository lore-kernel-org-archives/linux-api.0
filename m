From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v7 02/11] task_isolation: add initial support
Date: Thu, 1 Oct 2015 14:23:39 +0200
Message-ID: <20151001122339.GD3432@lerouge>
References: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
 <1443453446-7827-3-git-send-email-cmetcalf@ezchip.com>
 <20151001121414.GB3432@lerouge>
 <alpine.DEB.2.11.1510011416160.4500@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1510011416160.4500@nanos>
Sender: linux-doc-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Metcalf <cmetcalf@ezchip.com>, Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 01, 2015 at 02:18:42PM +0200, Thomas Gleixner wrote:
> On Thu, 1 Oct 2015, Frederic Weisbecker wrote:
> > On Mon, Sep 28, 2015 at 11:17:17AM -0400, Chris Metcalf wrote:
> > > +
> > > +	while (READ_ONCE(dev->next_event.tv64) != KTIME_MAX) {
> > 
> > You should add a function in tick-sched.c to get the next tick. This
> > is supposed to be a private field.
> 
> Just to make it clear. Neither the above nor a similar check in
> tick-sched.c is going to happen.
> 
> This busy waiting is just horrible. Get your act together and solve
> the problems at the root and do not inflict your quick and dirty
> 'solutions' on us.

That's why I proposed a wait-wake scheme instead with the tick stop
code. What's your opinion about such direction?
