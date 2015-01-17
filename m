From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: futex(2) man page update help request
Date: Fri, 16 Jan 2015 16:56:56 -0800
Message-ID: <1421456216.27134.2.camel@stgolabs.net>
References: <537346E5.4050407@gmail.com>
	 <CF98E3EF.90564%dvhart@linux.intel.com>
	 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
	 <5373D0CA.2050204@redhat.com>
	 <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de>
	 <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com>
	 <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de>
	 <54B7D87C.3090901@gmail.com> <alpine.DEB.2.11.1501152313330.5526@nanos>
	 <54B92B71.2090509@gmail.com> <alpine.DEB.2.11.1501161618080.5526@nanos>
	 <54B97A72.2050205@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54B97A72.2050205@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carlos O'Donell <carlos@redhat.com>, Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Linux API <linux-api@vger.kernel.org>, Torvald Riegel <triegel@redhat.com>, Roland McGrath <roland@redhat.com>, Darren Hart <dvhart@infradead.org>, Anton Blanchard <anton@samba.org>, Petr Baudis <pasky@suse.cz>, Eric Dumazet <edumazet@google.com>, bill o gallmeister <bgallmeister@gmail.com>, Jan Kiszka <jan.kiszka@siemens.com>, Daniel Wagner <wagi@monom.org>, Rich Felker <dalias@libc.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2015-01-16 at 21:54 +0100, Michael Kerrisk (man-pages) wrote:
> On 01/16/2015 04:20 PM, Thomas Gleixner wrote:
> > On Fri, 16 Jan 2015, Michael Kerrisk (man-pages) wrote:
> > 
> >> Hello Thomas,
> >>
> >> On 01/15/2015 11:23 PM, Thomas Gleixner wrote:
> >>> On Thu, 15 Jan 2015, Michael Kerrisk (man-pages) wrote:
> >>>>> [EINVAL] uaddr equal uaddr2. Requeue to same futex.
> >>>>
> >>>> ??? I added this, but does this error not occur only for PI requeues?
> >>>
> >>> It's equally wrong for normal futexes. And its actually the same code
> >>> checking for this for all variants.
> >>
> >> I don't understand "equally wrong" in your reply, I'm sorry. Do you
> >> mean:
> >>
> >> a) This error text should be there for both normal and PI requeues
> > 
> > It is there for both. The requeue code has that check independent of
> > the requeue type (normal/pi). It never makes sense to requeue
> > something to itself whether normal or pi futex. We added this for PI,
> > because there it is harmful, but we did not special case it. So normal
> > futexes get the same treatment.
> 
> Hello Thomas, 
> 
> Color me stupid, but I can't see this in futex_requeue(). Where is that
> check that is "independent of the requeue type (normal/pi)"?
> 
> When I look through futex_requeue(), all the likely looking sources
> of EINVAL are governed by a check on the 'requeue_pi' argument.

Yeah, its not very straightforward, I was also scratching my head. First
we do:

	if (requeue_pi) {
		/*
		 * Requeue PI only works on two distinct uaddrs. This
		 * check is only valid for private futexes. See below.
		 */
		if (uaddr1 == uaddr2)
			return -EINVAL;

Then:

	/*
	 * The check above which compares uaddrs is not sufficient for
	 * shared futexes. We need to compare the keys:
	 */
	if (requeue_pi && match_futex(&key1, &key2)) {
		ret = -EINVAL;
		goto out_put_keys;
	}

I wonder why we're checking for requeue_pi again, when, at least
according to the comments, it should be for shared. I guess it would
make sense depending on the mappings as the keys are the only true way
of determining if both futexes are the same, so perhaps:

	if ((requeue_pi || (flags & FLAGS_SHARED)) && match_futex())

That would also align with the retry labels.

Thanks,
Davidlohr
