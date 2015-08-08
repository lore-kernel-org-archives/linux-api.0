From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Next round: revised futex(2) man page for review
Date: Sat, 08 Aug 2015 08:56:02 +0200
Message-ID: <55C5A802.7050602@gmail.com>
References: <55B61EF3.7080302@gmail.com> <alpine.DEB.2.11.1507282054370.3825@nanos> <20150728204508.GG19282@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1507282303290.3825@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1507282303290.3825@nanos>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, bert hubert <bert.hubert-dxZxOz86jR8sYtaaK7K+xw@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 07/28/2015 11:03 PM, Thomas Gleixner wrote:
> On Tue, 28 Jul 2015, Peter Zijlstra wrote:
>=20
>> On Tue, Jul 28, 2015 at 10:23:51PM +0200, Thomas Gleixner wrote:
>>
>>>>        FUTEX_WAKE (since Linux 2.6.0)
>>>>               This  operation  wakes at most val of the waiters th=
at are
>>>>               waiting (e.g., inside FUTEX_WAIT) on the futex word =
at the
>>>>               address  uaddr.  Most commonly, val is specified as =
either
>>>>               1 (wake up a single waiter) or INT_MAX (wake up all =
 wait=E2=80=90
>>>>               ers).   No  guarantee  is provided about which waite=
rs are
>>>>               awoken (e.g., a waiter with a higher  scheduling  pr=
iority
>>>>               is  not  guaranteed to be awoken in preference to a =
waiter
>>>>               with a lower priority).
>>>
>>> That's only correct up to Linux 2.6.21.
>>>
>>> Since 2.6.22 we have a priority ordered wakeup. For SCHED_OTHER
>>> threads this takes the nice level into account. Threads with the sa=
me
>>> priority are woken in FIFO order.
>>
>> Maybe don't mention the effects of SCHED_OTHER, order by nice value =
is
>> 'wrong'.
>=20
> Indeed.
> =20
>> Also, this code seems to use plist, which means it won't do the righ=
t
>> thing for SCHED_DEADLINE either.
>>
>> Do we want to go fix that?
>=20
> I think so.

So, no change to this piece of text then?

Cheers,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
