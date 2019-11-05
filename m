From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: handle_exit_race && PF_EXITING
Date: Tue, 5 Nov 2019 18:28:33 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1911051800070.1869@nanos.tec.linutronix.de>
References: <20191104002909.25783-1-shawn@git.icu> <87woceslfs.fsf@oldenburg2.str.redhat.com> <alpine.DEB.2.21.1911051053470.17054@nanos.tec.linutronix.de> <20191105152728.GA5666@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191105152728.GA5666@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Florian Weimer <fweimer@redhat.com>, Shawn Landden <shawn@git.icu>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Deepa Dinamani <deepa.kernel@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Keith Packard <keithp@keithp.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

On Tue, 5 Nov 2019, Oleg Nesterov wrote:
> On 11/05, Thomas Gleixner wrote:
> >
> > Out of curiosity, what's the race issue vs. robust list which you are
> > trying to solve?
> 
> Off-topic, but this reminds me...
> 
> 	#include <sched.h>
> 	#include <assert.h>
> 	#include <unistd.h>
> 	#include <syscall.h>
> 
> 	#define FUTEX_LOCK_PI		6
> 
> 	int main(void)
> 	{
> 		struct sched_param sp = {};
> 
> 		sp.sched_priority = 2;
> 		assert(sched_setscheduler(0, SCHED_FIFO, &sp) == 0);
> 
> 		int lock = vfork();
> 		if (!lock) {
> 			sp.sched_priority = 1;
> 			assert(sched_setscheduler(0, SCHED_FIFO, &sp) == 0);
> 			_exit(0);
> 		}
> 
> 		syscall(__NR_futex, &lock, FUTEX_LOCK_PI, 0,0,0);
> 		return 0;
> 	}
> 
> this creates the unkillable RT process spinning in futex_lock_pi() on
> a single CPU machine (or you can use taskset).

Uuurgh.

> Probably the patch below makes sense anyway, but of course it doesn't
> solve the real problem: futex_lock_pi() should not spin in this case.

Obviously not.

> It seems to me I even sent the fix a long ago, but I can't recall what
> exactly it did. Probably the PF_EXITING check in attach_to_pi_owner()
> must simply die, I'll try to recall...

We can't do that. The task might have released the futex already, so the
waiter would operate on inconsistent state :(

The problem with that exit race is that there is no form of serialization
which might be used to address that. We can't abuse any of the task locks
for this.

I was working on a patch set some time ago to fix another more esoteric
futex exit issue. Let me resurrect that.

Vs. the signal pending check. That makes sense on its own, but we should
not restrict it to fatal signals. Futexes are interruptible by definition.

Thanks,

	tglx
