From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: Next round: revised futex(2) man page for review
Date: Tue, 28 Jul 2015 23:03:52 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1507282303290.3825@nanos>
References: <55B61EF3.7080302@gmail.com> <alpine.DEB.2.11.1507282054370.3825@nanos> <20150728204508.GG19282@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1673709282-1438117434=:3825"
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150728204508.GG19282-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, bert hubert <bert.hubert-dxZxOz86jR8sYtaaK7K+xw@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1673709282-1438117434=:3825
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 28 Jul 2015, Peter Zijlstra wrote:

> On Tue, Jul 28, 2015 at 10:23:51PM +0200, Thomas Gleixner wrote:
> 
> > >        FUTEX_WAKE (since Linux 2.6.0)
> > >               This  operation  wakes at most val of the waiters that are
> > >               waiting (e.g., inside FUTEX_WAIT) on the futex word at the
> > >               address  uaddr.  Most commonly, val is specified as either
> > >               1 (wake up a single waiter) or INT_MAX (wake up all  wait‐
> > >               ers).   No  guarantee  is provided about which waiters are
> > >               awoken (e.g., a waiter with a higher  scheduling  priority
> > >               is  not  guaranteed to be awoken in preference to a waiter
> > >               with a lower priority).
> > 
> > That's only correct up to Linux 2.6.21.
> > 
> > Since 2.6.22 we have a priority ordered wakeup. For SCHED_OTHER
> > threads this takes the nice level into account. Threads with the same
> > priority are woken in FIFO order.
> 
> Maybe don't mention the effects of SCHED_OTHER, order by nice value is
> 'wrong'.

Indeed.
 
> Also, this code seems to use plist, which means it won't do the right
> thing for SCHED_DEADLINE either.
> 
> Do we want to go fix that?

I think so.

Thanks,

	tglx

--8323329-1673709282-1438117434=:3825--
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
