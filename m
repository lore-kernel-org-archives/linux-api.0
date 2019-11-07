From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: handle_exit_race && PF_EXITING
Date: Thu, 7 Nov 2019 16:51:30 +0100
Message-ID: <20191107155130.GB24042@redhat.com>
References: <alpine.DEB.2.21.1911051800070.1869@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.1911051851380.1869@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.1911051920420.1869@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.1911051959260.1869@nanos.tec.linutronix.de>
 <20191106085529.GA12575@redhat.com>
 <alpine.DEB.2.21.1911061028020.1869@nanos.tec.linutronix.de>
 <20191106103509.GB12575@redhat.com>
 <alpine.DEB.2.21.1911061154520.1869@nanos.tec.linutronix.de>
 <20191106121111.GC12575@redhat.com>
 <alpine.DEB.2.21.1911061808030.1869@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1911061808030.1869@nanos.tec.linutronix.de>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Florian Weimer <fweimer@redhat.com>, Shawn Landden <shawn@git.icu>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Deepa Dinamani <deepa.kernel@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Keith Packard <keithp@keithp.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

On 11/06, Thomas Gleixner wrote:
>
> On Wed, 6 Nov 2019, Oleg Nesterov wrote:
> >
> > I think that (with or without this fix) handle_exit_race() logic needs
> > cleanups, there is no reason for get_futex_value_locked(), we can drop
> > ->pi_lock right after we see PF_EXITPIDONE. Lets discuss this later.
>
> Which still is in atomic because the hash bucket lock is held, ergo
> get_futex_value_locked() needs to stay for now.

Indeed, you are right.

> Same explanation as before just not prosa this time:
>
> exit()=09=09=09=09=09lock_pi(futex2)
>   exit_pi_state_list()
>    lock(tsk->pi_lock)
>    tsk->flags |=3D PF_EXITPIDONE;=09=09 attach_to_pi_owner()
> =09=09=09=09=09  ...
>   // Loop unrolled for clarity
>   while(!list_empty())=09=09=09  lock(tsk->pi_lock);
>      cleanup(futex1)
>        unlock(tsk->pi_lock)
         ^^^^^^^^^^^^^^^^^^^^
Ah! Thanks.


Hmm. In particular, exit_pi_state() drops pi_lock if refcount_inc_not_zero(=
) fails.

Isn't this another potential source of livelock ?

Suppose that a realtime lock owner X sleeps somewhere, another task T
calls put_pi_state(), refcount_dec_and_test() succeeds.

What if, say, X is killed right after that and preempts T on the same
CPU?

Oleg.
