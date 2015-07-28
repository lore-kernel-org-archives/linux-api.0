From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: Re: Revised futex(2) man page for review
Date: Mon, 27 Jul 2015 20:16:17 -0700
Message-ID: <1438053377.2249.25.camel@stgolabs.net>
References: <55166C01.7000803@gmail.com>
	 <20150328114725.GJ27490@worktop.programming.kicks-ass.net>
	 <1427813146.20009.2.camel@stgolabs.net> <55B611B3.7030005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55B611B3.7030005-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, bert hubert <bert.hubert-dxZxOz86jR8sYtaaK7K+xw@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Heinrich
List-Id: linux-api@vger.kernel.org

On Mon, 2015-07-27 at 13:10 +0200, Michael Kerrisk (man-pages) wrote:
> Hi David,
>=20
> On 03/31/2015 04:45 PM, Davidlohr Bueso wrote:
> > On Sat, 2015-03-28 at 12:47 +0100, Peter Zijlstra wrote:
> >=20
> >>        The condition is represented by the futex word, which is an=
 address  in
> >>        memory  supplied to the futex() system call, and the value =
at this mem=E2=80=90
> >>        ory location.  (While the virtual addresses for the same me=
mory in sep=E2=80=90
> >>        arate  processes  may  not be equal, the kernel maps them i=
nternally so
> >>        that the same memory mapped in different locations will cor=
respond  for
> >>        futex() calls.)
> >>
> >>        When  executing  a futex operation that requests to block a=
 thread, the
> >>        kernel will only block if the futex word has the value that=
 the calling
> >=20
> > Given the use of "word", you should probably state right away that
> > futexes are only 32bit.
>=20
> So, I made the opening sentence here:
>=20
>        The  condition  is  represented  by  the  futex word, which is=
 an
>        address in memory supplied to the futex() system  call,  and  =
the
>        32-bit  value  at  this  memory  location.=20
>=20
> Okay?

I think we can still improve :)

I've re-read the whole first paragraphs, and have a few comments that
touch upon this specific wording. Lets see. You have:

>        The  futex()  system call provides a method for waiting until =
a certain
>        condition becomes true.  It is typically used as a  blocking  =
construct
>        in the context of shared-memory synchronization: The program i=
mplements
>        the majority of the synchronization in user  space,  and  uses=
  one  of
>        operations  of  the  system call when it is likely that it has=
 to block
>        for a longer time until the condition becomes true.  The  prog=
ram  uses
>        another  operation of the system call to wake anyone waiting f=
or a par=E2=80=90
>        ticular condition.

I've rephrased the next paragraph. How about adding this to follow?

       A futex is in essence a 32-bit user-space address. All futex ope=
rations and
       conditions are governed by this variable, from now on referred t=
o as 'futex
       word'. As such, a futex is identified by the address in shared m=
emory, which
       may or may not be shared between different processes. For virtua=
l memory, the
       kernel will internally handle and resolve the later. This futex =
word, along
       with the value at its the memory location, are supplied to the f=
utex() system
       call.

=46eel free to reword however you think is better.

Thanks,
Davidlohr

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
