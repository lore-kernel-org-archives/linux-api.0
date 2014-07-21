From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Date: Mon, 21 Jul 2014 20:24:56 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1407212021540.20847@nanos>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com> <8761iq3bp3.fsf@tassilo.jf.intel.com> <871tte3bjw.fsf@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <871tte3bjw.fsf@tassilo.jf.intel.com>
Sender: linux-doc-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@linux.intel.com>, Davidlohr Bueso <davidlohr@hp.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>
List-Id: linux-api@vger.kernel.org

On Mon, 21 Jul 2014, Andi Kleen wrote:

> Andi Kleen <andi@firstfloor.org> writes:
> 
> > Waiman Long <Waiman.Long@hp.com> writes:
> >
> >> This patch series introduces two new futex command codes to support
> >> a new optimistic spinning futex for implementing an exclusive lock
> >> primitive that should perform better than the same primitive using
> >> the wait-wake futex in cases where the lock owner is actively working
> >> instead of waiting for I/O completion.
> >
> > How would you distinguish those two cases automatically?
> 
> Also BTW traditionally the spinning was just done in user space.

And traditionally that is based on heuristics, because user space
cannot figure out whether the lock owner is on the CPU or not. 
 
And heuristics suck no matter what.

There have been attempts to expose that information to user space, but
that sucks as well, as it requires updates of that information from
the guts of the scheduler, does not scale at all and what's worse, it
has security implications.

Thanks,

	tglx
