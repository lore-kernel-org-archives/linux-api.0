From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: futex(2) man page update help request
Date: Sat, 24 Jan 2015 11:05:29 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1501241102450.5526@nanos>
References: <537346E5.4050407@gmail.com>  <CF98E3EF.90564%dvhart@linux.intel.com>  <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>  <5373D0CA.2050204@redhat.com>  <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de>
 <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com>  <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de>  <54B7D87C.3090901@gmail.com> <alpine.DEB.2.11.1501152313330.5526@nanos>  <54B92B71.2090509@gmail.com> <alpine.DEB.2.11.1501161618080.5526@nanos>
  <54B97A72.2050205@gmail.com>  <D0DEECA2.B7EAD%dvhart@linux.intel.com> <1422037145.27573.0.camel@triegel.csb>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1422037145.27573.0.camel@triegel.csb>
Sender: linux-kernel-owner@vger.kernel.org
To: Torvald Riegel <triegel@redhat.com>
Cc: Darren Hart <dvhart@linux.intel.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Carlos O'Donell <carlos@redhat.com>, Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Davidlohr Bueso <davidlohr.bueso@hp.com>, Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Linux API <linux-api@vger.kernel.org>, Darren Hart <dvhart@infradead.org>, Anton Blanchard <anton@samba.org>, Petr Baudis <pasky@suse.cz>, Eric Dumazet <edumazet@google.com>, bill o gallmeister <bgallmeister@gmail.com>, Jan Kiszka <jan.kiszka@siemens.com>, Daniel Wagner <wagi@monom.org>, Rich Felker <dalias@libc.org>
List-Id: linux-api@vger.kernel.org

On Fri, 23 Jan 2015, Torvald Riegel wrote:

> On Fri, 2015-01-16 at 16:46 -0800, Darren Hart wrote:
> > On 1/16/15, 12:54 PM, "Michael Kerrisk (man-pages)"
> > <mtk.manpages@gmail.com> wrote:
> > 
> > >Color me stupid, but I can't see this in futex_requeue(). Where is that
> > >check that is "independent of the requeue type (normal/pi)"?
> > >
> > >When I look through futex_requeue(), all the likely looking sources
> > >of EINVAL are governed by a check on the 'requeue_pi' argument.
> > 
> > 
> > Right, in the non-PI case, I believe there are valid use cases: move to
> > the back of the FIFO, for example (OK, maybe the only example?).
> 
> But we never guarantee a futex is a FIFO, or do we?  If we don't, then
> such a requeue could be implemented as a no-op by the kernel, which
> would sort of invalidate the use case.
> 
> (And I guess we don't want to guarantee FIFO behavior for futexes.)

The (current) behaviour is:

    real-time threads:   FIFO per priority level
    sched-other threads: FIFO independent of nice level

The wakeup is priority ordered. Highest priority level first.

Thanks,

	tglx
