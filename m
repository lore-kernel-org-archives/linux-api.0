From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: Re: Revised futex(2) man page for review
Date: Tue, 31 Mar 2015 13:36:45 -0700
Message-ID: <1427834205.20009.19.camel@stgolabs.net>
References: <55166C01.7000803@gmail.com>
	 <20150328114725.GJ27490@worktop.programming.kicks-ass.net>
	 <20150328120337.GB32047@worktop.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150328120337.GB32047-IIpfhp3q70xoDWY/xQGDymt3HXsI98Cx0E9HWUfgJXw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, bert hubert <bert.hubert-dxZxOz86jR8sYtaaK7K+xw@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb8U04JRNCRQjg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, 2015-03-28 at 13:03 +0100, Peter Zijlstra wrote:
> >               If the timeout argument is non-NULL, its contents spe=
cify a rel=E2=80=90
> >               ative   timeout   for   the  wait,  measured  accordi=
ng  to  the
> >               CLOCK_MONOTONIC clock.  (This interval will be rounde=
d up to the
> >               system clock granularity, and kernel scheduling delay=
s mean that
> >               the blocking interval may overrun by a small amount.)=
  If  time=E2=80=90
> >               out is NULL, the call blocks indefinitely.
>=20
> Would it not be better to only state that the wait will not return
> before the timeout -- unless woken -- and not bother with clock
> granularity and scheduling delays?

Yeah, similarly we also have this:

     FUTEX_PRIVATE_FLAG (since Linux 2.6.22)
              This option bit can be employed with all futex  operation=
s.   It
              tells  the  kernel  that  the  futex  is process-private =
and not
              shared with another process (i.e., it is  only  being  us=
ed  for
              synchronization  between  threads  of  the  same process)=
=2E  This
              allows the kernel to choose the fast  path  for  validati=
ng  the
              user-space address and avoids expensive VMA lookups, taki=
ng ref=E2=80=90
              erence counts on file backing store, and so on.

This to me reads a bit too much into the kernel (fastpath, refcnt,
vmas). Why not just mention that it avoids overhead in the kernel or
something? I don't recall any manpage mentioning such details, but I
could be wrong. In any case its a nit, the whole doc is pretty good and
I hope you can merge it soon and then just increment ;)

Thanks,
Davidlohr
