From: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2 tip/core/rcu 01/22] smpboot: Add common code for
 notification from dying CPU
Date: Tue, 17 Mar 2015 10:32:58 -0700
Message-ID: <20150317173258.GP3589@linux.vnet.ibm.com>
References: <20150316183743.GA21453@linux.vnet.ibm.com>
 <1426531086-23825-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20150317081807.GQ2896@worktop.programming.kicks-ass.net>
 <20150317113648.GC3589@linux.vnet.ibm.com>
 <20150317140846.GB23123@twins.programming.kicks-ass.net>
 <20150317165621.GF24151@twins.programming.kicks-ass.net>
Reply-To: paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150317165621.GF24151-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, dipankar-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Mar 17, 2015 at 05:56:21PM +0100, Peter Zijlstra wrote:
> On Tue, Mar 17, 2015 at 03:08:46PM +0100, Peter Zijlstra wrote:
> > On Tue, Mar 17, 2015 at 04:36:48AM -0700, Paul E. McKenney wrote:
> > > On Tue, Mar 17, 2015 at 09:18:07AM +0100, Peter Zijlstra wrote:
> > > > On Mon, Mar 16, 2015 at 11:37:45AM -0700, Paul E. McKenney wrote:
> > > > > From: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > > > > 
> > > > > RCU ignores offlined CPUs, so they cannot safely run RCU read-side code.
> > > > > (They -can- use SRCU, but not RCU.)  This means that any use of RCU
> > > > > during or after the call to arch_cpu_idle_dead().  Unfortunately,
> > > > > commit 2ed53c0d6cc99 added a complete() call, which will contain RCU
> > > > > read-side critical sections if there is a task waiting to be awakened.
> > > > 
> > > > Got a little more detail there?
> > > 
> > > Quite possibly.  But exactly what sort of detail are you looking for?
> > 
> > What exact RCU usage you ran into that was problematic. It seems to
> > imply that calling complete() -- from a dead cpu -- which ends up in
> > try_to_wake_up() was the problem?
> 
> Hmm, I'm thinking its select_task_rq_*(). And yes, 'fixing' this in the
> wake-up path will penalize everybody for the benefit of the very rare
> case someone is doing a hotplug.
> 
> So yeah, maybe this is the best solution.. Ulgy though :/

Ugly indeed!  I end up doing a polling loop for the generic code.  For the
first round, I updated only architectures that were calling complete().
If that goes well, I will probably update some of the other architecture
as a code-consolidation measure.  Some architectures have special hardware
and firmware hooks, for example, s390 uses a special instruction to do
the wakeup directly.  Those will of course continue doing their own thing.

The ARM guys are trying to do something specific to their hardware, but
I have not heard from them lately.  I should ping them...

							Thanx, Paul
