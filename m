From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: handle_exit_race && PF_EXITING
Date: Wed, 6 Nov 2019 11:35:10 +0100
Message-ID: <20191106103509.GB12575@redhat.com>
References: <20191104002909.25783-1-shawn@git.icu>
 <87woceslfs.fsf@oldenburg2.str.redhat.com>
 <alpine.DEB.2.21.1911051053470.17054@nanos.tec.linutronix.de>
 <20191105152728.GA5666@redhat.com>
 <alpine.DEB.2.21.1911051800070.1869@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.1911051851380.1869@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.1911051920420.1869@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.1911051959260.1869@nanos.tec.linutronix.de>
 <20191106085529.GA12575@redhat.com>
 <alpine.DEB.2.21.1911061028020.1869@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1911061028020.1869@nanos.tec.linutronix.de>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Florian Weimer <fweimer@redhat.com>, Shawn Landden <shawn@git.icu>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Deepa Dinamani <deepa.kernel@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Keith Packard <keithp@keithp.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

On 11/06, Thomas Gleixner wrote:
>
> > @@ -716,11 +716,13 @@ void exit_pi_state_list(struct task_struct *curr)
> >
> >  =09if (!futex_cmpxchg_enabled)
> >  =09=09return;
> > +
> >  =09/*
> > -=09 * We are a ZOMBIE and nobody can enqueue itself on
> > -=09 * pi_state_list anymore, but we have to be careful
> > -=09 * versus waiters unqueueing themselves:
> > +=09 * attach_to_pi_owner() can no longer add the new entry. But
> > +=09 * we have to be careful versus waiters unqueueing themselves.
> >  =09 */
> > +=09curr->flags |=3D PF_EXITPIDONE;
>
> This obviously would need a barrier or would have to be moved inside of t=
he
> pi_lock region.

probably yes,

> > +=09if (unlikely(p->flags & PF_EXITPIDONE)) {
> > +=09=09/* exit_pi_state_list() was already called */
> >  =09=09raw_spin_unlock_irq(&p->pi_lock);
> >  =09=09put_task_struct(p);
> > -=09=09return ret;
> > +=09=09return -ESRCH;
>
> But, this is incorrect because we'd return -ESRCH to user space while the
> futex value still has the TID of the exiting task set which will
> subsequently cleanout the futex and set the owner died bit.

Heh. Of course this is not correct. As I said, this patch should be adapted
to the current code. See below.

> See da791a667536 ("futex: Cure exit race") for example.

Thomas, I simply can't resist ;)

I reported this race when I sent this patch in 2015,

https://lore.kernel.org/lkml/20150205181014.GA20244@redhat.com/

but somehow that discussion died with no result.

> Guess why that code has more corner case handling than actual
> functionality. :)

I know why. To confuse me!

Oleg.
