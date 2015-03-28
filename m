From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: Revised futex(2) man page for review
Date: Sat, 28 Mar 2015 13:03:37 +0100
Message-ID: <20150328120337.GB32047@worktop.ger.corp.intel.com>
References: <55166C01.7000803@gmail.com>
 <20150328114725.GJ27490@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150328114725.GJ27490-IIpfhp3q70z/8w/KjCw3T+5/BudmfyzbbVWyRVo5IupeoWH0uzbU5w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, bert hubert <bert.hubert-dxZxOz86jR8sYtaaK7K+xw@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Heinrich
List-Id: linux-api@vger.kernel.org

On Sat, Mar 28, 2015 at 12:47:25PM +0100, Peter Zijlstra wrote:
>        FUTEX_WAIT (since Linux 2.6.0)
>               This operation tests that the value at the futex word p=
ointed to
>               by the address uaddr still contains the expected value =
val,  and
>               if  so,  then sleeps awaiting FUTEX_WAKE on the futex w=
ord.  The
>               load of the value of the futex word is an atomic  memor=
y  access
>               (i.e.,  using  atomic  machine  instructions  of  the r=
espective
>               architecture).  This load,  the  comparison  with  the =
 expected
>               value,  and  starting  to  sleep  are  performed  atomi=
cally and
>               totally ordered with respect to other futex  operations=
  on  the
>               same  futex  word.  If the thread starts to sleep, it i=
s consid=E2=80=90
>               ered a waiter on this futex word.  If the futex value  =
does  not
>               match  val,  then  the  call  fails  immediately  with =
the error
>               EAGAIN.
>=20
>               The purpose of the comparison with the expected value i=
s to pre=E2=80=90
>               vent  lost  wake-ups: If another thread changed the val=
ue of the
>               futex word after the calling thread decided to  block  =
based  on
>               the  prior  value, and if the other thread executed a F=
UTEX_WAKE
>               operation (or similar wake-up) after the value change a=
nd before
>               this  FUTEX_WAIT  operation,  then  the  latter will ob=
serve the
>               value change and will not start to sleep.
>=20
>               If the timeout argument is non-NULL, its contents speci=
fy a rel=E2=80=90
>               ative   timeout   for   the  wait,  measured  according=
  to  the
>               CLOCK_MONOTONIC clock.  (This interval will be rounded =
up to the
>               system clock granularity, and kernel scheduling delays =
mean that
>               the blocking interval may overrun by a small amount.)  =
If  time=E2=80=90
>               out is NULL, the call blocks indefinitely.

Would it not be better to only state that the wait will not return
before the timeout -- unless woken -- and not bother with clock
granularity and scheduling delays?
