From: Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Fri, 23 Jan 2015 19:19:05 +0100
Message-ID: <1422037145.27573.0.camel@triegel.csb>
References: <537346E5.4050407@gmail.com>
	 <CF98E3EF.90564%dvhart@linux.intel.com>
	 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
	 <5373D0CA.2050204@redhat.com>
	 <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de>
	 <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com>
	 <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de>
	 <54B7D87C.3090901@gmail.com> <alpine.DEB.2.11.1501152313330.5526@nanos>
	 <54B92B71.2090509@gmail.com> <alpine.DEB.2.11.1501161618080.5526@nanos>
	 <54B97A72.2050205@gmail.com>  <D0DEECA2.B7EAD%dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D0DEECA2.B7EAD%dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Petr Baudis <pasky-AlSwsSmVLrQ@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2015-01-16 at 16:46 -0800, Darren Hart wrote:
> On 1/16/15, 12:54 PM, "Michael Kerrisk (man-pages)"
> <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> >Color me stupid, but I can't see this in futex_requeue(). Where is that
> >check that is "independent of the requeue type (normal/pi)"?
> >
> >When I look through futex_requeue(), all the likely looking sources
> >of EINVAL are governed by a check on the 'requeue_pi' argument.
> 
> 
> Right, in the non-PI case, I believe there are valid use cases: move to
> the back of the FIFO, for example (OK, maybe the only example?).

But we never guarantee a futex is a FIFO, or do we?  If we don't, then
such a requeue could be implemented as a no-op by the kernel, which
would sort of invalidate the use case.

(And I guess we don't want to guarantee FIFO behavior for futexes.)


--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
