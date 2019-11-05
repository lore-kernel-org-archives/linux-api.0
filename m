From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: handle_exit_race && PF_EXITING
Date: Tue, 5 Nov 2019 19:56:01 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1911051920420.1869@nanos.tec.linutronix.de>
References: <20191104002909.25783-1-shawn@git.icu> <87woceslfs.fsf@oldenburg2.str.redhat.com> <alpine.DEB.2.21.1911051053470.17054@nanos.tec.linutronix.de> <20191105152728.GA5666@redhat.com> <alpine.DEB.2.21.1911051800070.1869@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.1911051851380.1869@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1911051851380.1869@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Florian Weimer <fweimer@redhat.com>, Shawn Landden <shawn@git.icu>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Deepa Dinamani <deepa.kernel@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Keith Packard <keithp@keithp.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

On Tue, 5 Nov 2019, Thomas Gleixner wrote:
> On Tue, 5 Nov 2019, Thomas Gleixner wrote:
> > On Tue, 5 Nov 2019, Oleg Nesterov wrote:
> > > On 11/05, Thomas Gleixner wrote:
> > > >
> > > > Out of curiosity, what's the race issue vs. robust list which you are
> > > > trying to solve?
> > > 
> > > Off-topic, but this reminds me...
> > > 
> > > 	#include <sched.h>
> > > 	#include <assert.h>
> > > 	#include <unistd.h>
> > > 	#include <syscall.h>
> > > 
> > > 	#define FUTEX_LOCK_PI		6
> > > 
> > > 	int main(void)
> > > 	{
> > > 		struct sched_param sp = {};
> > > 
> > > 		sp.sched_priority = 2;
> > > 		assert(sched_setscheduler(0, SCHED_FIFO, &sp) == 0);
> > > 
> > > 		int lock = vfork();
> > > 		if (!lock) {
> > > 			sp.sched_priority = 1;
> > > 			assert(sched_setscheduler(0, SCHED_FIFO, &sp) == 0);
> > > 			_exit(0);
> > > 		}
> > > 
> > > 		syscall(__NR_futex, &lock, FUTEX_LOCK_PI, 0,0,0);
> > > 		return 0;
> > > 	}
> > > 
> > > this creates the unkillable RT process spinning in futex_lock_pi() on
> > > a single CPU machine (or you can use taskset).
> > 
> > Uuurgh.
> 
> But staring more at it. That's a scheduler bug.
> 
> parent	    	    	child
> 
>  set FIFO prio 2
> 
>  fork()	         ->	set FIFO prio 1
>  		 	 sched_setscheduler(...)
> 			   return from syscall		<= BUG
> 
>  		 	_exit()
> 
> When the child lowers its priority from 2 to 1, then the parent _must_
> preempt the child simply because the parent is now the top priority task on
> that CPU. Child should never reach exit before the parent blocks on the
> futex.

I'm a moron. It's vfork() not fork() so the behaviour is expected.

Staring more at the trace which shows me where this goes down the drain.

Thanks,

	tglx
