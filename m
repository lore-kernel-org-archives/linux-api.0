From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Mon, 19 Jan 2015 11:45:48 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1501191144320.5526@nanos>
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com> <5373D0CA.2050204@redhat.com> <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de>
 <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com> <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de> <54B7D87C.3090901@gmail.com> <alpine.DEB.2.11.1501152313330.5526@nanos> <54B92B71.2090509@gmail.com> <alpine.DEB.2.11.1501161618080.5526@nanos>
 <54B97A72.2050205@gmail.com> <D0DEECA2.B7EAD%dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D0DEECA2.B7EAD%dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Petr Baudis <pasky-AlSwsSmVLrQ@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 16 Jan 2015, Darren Hart wrote:
> On 1/16/15, 12:54 PM, "Michael Kerrisk (man-pages)"
> <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> >On 01/16/2015 04:20 PM, Thomas Gleixner wrote:
> >> On Fri, 16 Jan 2015, Michael Kerrisk (man-pages) wrote:
> >> 
> >>> Hello Thomas,
> >>>
> >>> On 01/15/2015 11:23 PM, Thomas Gleixner wrote:
> >>>> On Thu, 15 Jan 2015, Michael Kerrisk (man-pages) wrote:
> >>>>>> [EINVAL] uaddr equal uaddr2. Requeue to same futex.
> >>>>>
> >>>>> ??? I added this, but does this error not occur only for PI requeues?
> >>>>
> >>>> It's equally wrong for normal futexes. And its actually the same code
> >>>> checking for this for all variants.
> >>>
> >>> I don't understand "equally wrong" in your reply, I'm sorry. Do you
> >>> mean:
> >>>
> >>> a) This error text should be there for both normal and PI requeues
> >> 
> >> It is there for both. The requeue code has that check independent of
> >> the requeue type (normal/pi). It never makes sense to requeue
> >> something to itself whether normal or pi futex. We added this for PI,
> >> because there it is harmful, but we did not special case it. So normal
> >> futexes get the same treatment.
> >
> >Hello Thomas, 
> >
> >Color me stupid, but I can't see this in futex_requeue(). Where is that
> >check that is "independent of the requeue type (normal/pi)"?
> >
> >When I look through futex_requeue(), all the likely looking sources
> >of EINVAL are governed by a check on the 'requeue_pi' argument.
> 
> 
> Right, in the non-PI case, I believe there are valid use cases: move to
> the back of the FIFO, for example (OK, maybe the only example?). Both
> tests ensuring uaddr1 != uaddr2 are under the requeue_pi conditional
> block. The second compares the keys in case they are not FUTEX_PRIVATE
> (uaddrs would be different, but still the same backing store).
> 
> Thomas, am I missing a test for this someplace else?

No, I had a short look at the code misread it. So, yes, it's a valid
operation for the non PI case. Sorry for the confusion.

Thanks,

	tglx
