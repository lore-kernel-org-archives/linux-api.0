From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Revised futex(2) man page for review
Date: Mon, 27 Jul 2015 13:00:50 +0200
Message-ID: <55B60F62.6010303@gmail.com>
References: <55166C01.7000803@gmail.com>	 <20150328114725.GJ27490@worktop.programming.kicks-ass.net>	 <20150328120337.GB32047@worktop.ger.corp.intel.com> <1427834205.20009.19.camel@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427834205.20009.19.camel-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, bert hubert <bert.hubert-dxZxOz86jR8sYtaaK7K+xw@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Heinrich Schuchardt <xypron>
List-Id: linux-api@vger.kernel.org

Hi David,

On 03/31/2015 10:36 PM, Davidlohr Bueso wrote:
> On Sat, 2015-03-28 at 13:03 +0100, Peter Zijlstra wrote:
>>>               If the timeout argument is non-NULL, its contents spe=
cify a rel=E2=80=90
>>>               ative   timeout   for   the  wait,  measured  accordi=
ng  to  the
>>>               CLOCK_MONOTONIC clock.  (This interval will be rounde=
d up to the
>>>               system clock granularity, and kernel scheduling delay=
s mean that
>>>               the blocking interval may overrun by a small amount.)=
  If  time=E2=80=90
>>>               out is NULL, the call blocks indefinitely.
>>
>> Would it not be better to only state that the wait will not return
>> before the timeout -- unless woken -- and not bother with clock
>> granularity and scheduling delays?
>=20
> Yeah, similarly we also have this:
>=20
>      FUTEX_PRIVATE_FLAG (since Linux 2.6.22)
>               This option bit can be employed with all futex  operati=
ons.   It
>               tells  the  kernel  that  the  futex  is process-privat=
e and not
>               shared with another process (i.e., it is  only  being  =
used  for
>               synchronization  between  threads  of  the  same proces=
s).  This
>               allows the kernel to choose the fast  path  for  valida=
ting  the
>               user-space address and avoids expensive VMA lookups, ta=
king ref=E2=80=90
>               erence counts on file backing store, and so on.
>=20
> This to me reads a bit too much into the kernel (fastpath, refcnt,
> vmas). Why not just mention that it avoids overhead in the kernel or
> something? I don't recall any manpage mentioning such details, but I
> could be wrong.=20

Thanks. Agreed. I changed this to

    This allows the kernel to make some additional performance optimiza=
tions.

> In any case its a nit, the whole doc is pretty good and
> I hope you can merge it soon and then just increment ;)

I ran out of time and energy at a certain point. And also got a little
disheartened that I got more people complaining about groff markup
than actually looked looked at the FIXMEs in the page source :-).=20
I'll try to reboot the process.

Cheers,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
