From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: handle_exit_race && PF_EXITING
Date: Wed, 6 Nov 2019 12:07:29 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1911061154520.1869@nanos.tec.linutronix.de>
References: <20191104002909.25783-1-shawn@git.icu> <87woceslfs.fsf@oldenburg2.str.redhat.com> <alpine.DEB.2.21.1911051053470.17054@nanos.tec.linutronix.de> <20191105152728.GA5666@redhat.com> <alpine.DEB.2.21.1911051800070.1869@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.1911051851380.1869@nanos.tec.linutronix.de> <alpine.DEB.2.21.1911051920420.1869@nanos.tec.linutronix.de> <alpine.DEB.2.21.1911051959260.1869@nanos.tec.linutronix.de> <20191106085529.GA12575@redhat.com> <alpine.DEB.2.21.1911061028020.1869@nanos.tec.linutronix.de>
 <20191106103509.GB12575@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191106103509.GB12575@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Florian Weimer <fweimer@redhat.com>, Shawn Landden <shawn@git.icu>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Deepa Dinamani <deepa.kernel@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Keith Packard <keithp@keithp.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

On Wed, 6 Nov 2019, Oleg Nesterov wrote:
> On 11/06, Thomas Gleixner wrote:
> > > +	if (unlikely(p->flags & PF_EXITPIDONE)) {
> > > +		/* exit_pi_state_list() was already called */
> > >  		raw_spin_unlock_irq(&p->pi_lock);
> > >  		put_task_struct(p);
> > > -		return ret;
> > > +		return -ESRCH;
> >
> > But, this is incorrect because we'd return -ESRCH to user space while the
> > futex value still has the TID of the exiting task set which will
> > subsequently cleanout the futex and set the owner died bit.
> 
> Heh. Of course this is not correct. As I said, this patch should be adapted
> to the current code. See below.
> 
> > See da791a667536 ("futex: Cure exit race") for example.
> 
> Thomas, I simply can't resist ;)
> 
> I reported this race when I sent this patch in 2015,
> 
> https://lore.kernel.org/lkml/20150205181014.GA20244@redhat.com/
> 
> but somehow that discussion died with no result.

Yes. I was not paying attention for some reason. Don't ask me what happened
in Feb. 2015 :)

But even if we adapt that patch to the current code it won't solve the
-ESRCH issue I described above.

> > Guess why that code has more corner case handling than actual
> > functionality. :)
> 
> I know why. To confuse me!

Of course. As Rusty said: "Futexes are also cursed"

Thanks,

	tglx
