From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 tip/core/rcu 01/22] smpboot: Add common code for
 notification from dying CPU
Date: Tue, 17 Mar 2015 09:34:58 -0700
Message-ID: <20150317163457.GI3589@linux.vnet.ibm.com>
References: <20150316183743.GA21453@linux.vnet.ibm.com>
 <1426531086-23825-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20150317081807.GQ2896@worktop.programming.kicks-ass.net>
 <20150317113648.GC3589@linux.vnet.ibm.com>
 <20150317140846.GB23123@twins.programming.kicks-ass.net>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150317140846.GB23123@twins.programming.kicks-ass.net>
Sender: linux-arch-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org, mathieu.desnoyers@efficios.com, josh@joshtriplett.org, tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com, bobby.prani@gmail.com, linux-api@vger.kernel.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Mar 17, 2015 at 03:08:46PM +0100, Peter Zijlstra wrote:
> On Tue, Mar 17, 2015 at 04:36:48AM -0700, Paul E. McKenney wrote:
> > On Tue, Mar 17, 2015 at 09:18:07AM +0100, Peter Zijlstra wrote:
> > > On Mon, Mar 16, 2015 at 11:37:45AM -0700, Paul E. McKenney wrote:
> > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > 
> > > > RCU ignores offlined CPUs, so they cannot safely run RCU read-side code.
> > > > (They -can- use SRCU, but not RCU.)  This means that any use of RCU
> > > > during or after the call to arch_cpu_idle_dead().  Unfortunately,
> > > > commit 2ed53c0d6cc99 added a complete() call, which will contain RCU
> > > > read-side critical sections if there is a task waiting to be awakened.
> > > 
> > > Got a little more detail there?
> > 
> > Quite possibly.  But exactly what sort of detail are you looking for?
> 
> What exact RCU usage you ran into that was problematic. It seems to
> imply that calling complete() -- from a dead cpu -- which ends up in
> try_to_wake_up() was the problem?

Yep, that was the one.  At that point, the CPU can disappear without
any chance to tell RCU anything, so RCU has to have started ignoring
it beforehand.  This bug has existed for a long time, masked by RCU's
waiting a jiffy before ignoring already-offline CPUs.  Which would be a
problem if the CPU took longer than one jiffy to get from stop_machine()
to arch_cpu_idle_dead().  Which could actually, happen, especially
in a guest OS.

In addition, any tracing or printk()s on that code path (for example,
via lockdep) can also result in RCU read-side critical sections from an
offline CPU that RCU is ignoring.

So you would like me to pull this info into the commit log?  Easy to
do if so.

Or am I missing your point?

							Thanx, Paul
