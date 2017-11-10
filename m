From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] x86: Fix missing core serialization on migration
Date: Fri, 10 Nov 2017 14:12:59 -0800
Message-ID: <CA+55aFxdzip-cnTvG_g6CrwXrLKzExngQT9cj5tg0WUqn5xTHA@mail.gmail.com>
References: <20171110211249.10742-1-mathieu.desnoyers@efficios.com>
 <CA+55aFzbroWqi+FTdYhRVSwUZ-M0wDVxjXqDbh40JEnXc2LdgQ@mail.gmail.com> <885227610.13045.1510351034488.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <885227610.13045.1510351034488.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, maged michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Russell King, ARM Linux" <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will
List-Id: linux-api@vger.kernel.org

On Fri, Nov 10, 2017 at 1:57 PM, Mathieu Desnoyers
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>
> That core serializing instruction is not that much about I$ vs D$
> consistency, but rather about the processor speculatively executing code
> ahead of its retirement point. Ref. Intel Architecture Software Developer's
> Manual, Volume 3: System Programming.

Oh, I know.

I'm just saying that the Intel docs wrt cross-modifying code are most
likely crap and overly defensive.

The sequence they _say_ is required can not possibly be required,
simply because people already depend on it not being required. We've
never had the serializing instruction in various other circumstances
when we switched from the old "iret" to "sysret".

I think it's kind of like the old memory ordering: Intel didn't really
document the real rules. They only started truly documenting what they
*really* did about ten years ago.

Remember when we thought you needed a locked instruction or a memory
barrier in between two reads, and our "smp_rmb()" was an actual
barrier instruction?

Yeah, that was always bogus, but it was what the (bad) intel
documentation said you had to do. Then they started fixing their docs,
and now smp_rmb() is just a compiler barrier on x86.

It's about ten years ago that we committed b6c7347fffa6 ("x86:
optimise barriers") as a response to the Intel/AMD memory ordering
whitepaper (which is now part of the standard architecture manual, but
it

               Linus
