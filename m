From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 00/24] Restartable sequences and CPU op
 vector v11
Date: Tue, 14 Nov 2017 20:12:23 -0800
Message-ID: <CALCETrX4dzY_kyZmqR+srKZf7vVYzODH5i9bguFAzdm0dcU3ZQ@mail.gmail.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com>
 <CA+55aFzZcQKEvu5S3TwD9MscqDhqq3pKa0Kam79NncjP8RnvoQ@mail.gmail.com>
 <CALCETrVMvk0dsBMF8F-gPZCGnfJt=RQOvTnVzJhVaAFhEFbq2w@mail.gmail.com> <2115146800.15215.1510695175687.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2115146800.15215.1510695175687.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

> On Nov 14, 2017, at 1:32 PM, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>
> ----- On Nov 14, 2017, at 4:15 PM, Andy Lutomirski luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org wrote:
>
>
> One thing I kept however that diverge from your recommendation is the
> "sign" parameter to the rseq syscall. I prefer this flexible
> approach to a hardcoded signature value. We never know when we may
> need to randomize or change this in the future.
>
> Regarding abort target signature the vs x86 disassemblers, I used a
> 5-byte no-op on x86 32/64:
>
>  x86-32: nopl <sig>
>  x86-64: nopl <sig>(%rip)

I still don't see how this can possibly work well with libraries.  If
glibc or whatever issues the syscall and registers some signature,
that signature *must* match the expectation of all libraries used in
that thread or it's not going to work.  I can see two reasonable ways
to handle it:

1. The signature is just a well-known constant.  If you have an rseq
abort landing site, you end up with something like:

nopl $11223344(%rip)
landing_site:

or whatever the constant is.

2. The signature varies depending on the rseq_cs in use.  So you get:

static struct rseq_cs this_cs = {
  .signature = 0x55667788;
  ...
};

and then the abort landing site has:

nopl $11223344(%rip)
nopl $55667788(%rax)
landing_site:

The former is a bit easier to deal with.  The latter has the nice
property that you can't subvert one rseq_cs to land somewhere else,
but it's not clear to me how what actual attack this prevents, so I
think I prefer #1.  I just think that your variant is asking for
trouble down the road with incompatible userspace.

--Andy
