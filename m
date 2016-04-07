From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC PATCH v6 1/5] Thread-local ABI system call: cache CPU number
 of running thread
Date: Thu, 7 Apr 2016 09:39:02 -0700
Message-ID: <CA+55aFxrWx5pFN3LseaKpUHtB6nqXtkgP84seU3pjys-kq7utQ@mail.gmail.com>
References: <1459789313-4917-1-git-send-email-mathieu.desnoyers@efficios.com>
	<1459789313-4917-2-git-send-email-mathieu.desnoyers@efficios.com>
	<5702A037.60200@zytor.com>
	<492303698.44994.1459799188052.JavaMail.zimbra@efficios.com>
	<856357054.45028.1459802903401.JavaMail.zimbra@efficios.com>
	<5703E191.2040707@redhat.com>
	<20160405164722.GB3430@twins.programming.kicks-ass.net>
	<570621E5.7060306@redhat.com>
	<20160407103158.GP3430@twins.programming.kicks-ass.net>
	<570638D9.7010108@redhat.com>
	<20160407111938.GR3430@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160407111938.GR3430-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 7, 2016 at 4:19 AM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> People objected against the fixed size scheme, but it being possible to
> get a fixed TCB offset and reduce indirections is a big win IMO.

Guys, I'm going to just make an executive decision here, because this
whole "fixed vs some strange size that is a superset of kernel and
user mode knowledge" discussion has been going on for too long.

Here's the executive decision: I will not merge anything that doesn't
have a (small) fixed size as far as the kernel is concerned.

Why?

I don't think there is *any* possible reason for the kernel to care
about the size. There will be no future extensions. The kernel will
not magically start doing bigger things, and change more fields, or
anything like that.

Put another way: if the interface cannot be designed so that the
kernel simply DOES NOT HAVE TO CARE about the rest of the crap, I will
not merge this patch series. Ever.

So I don't want to hear more idiotic emails about "extensible sizes".
The people who want to push this interface had better be able to show
that the kernel will never care about what user space does, and *all*
the kernel has to do is to invalidate a single field when a thread is
moved.

In other words:

 - get rid of the stupid "abi features" bitfield. Anybody who feels it
is needed had better take a deep breath and ask themselves why.

 - that leaves us with *one* single 32-bit field that the kernel cares
about: "cpu_id".

 - we specify that the *only* thing the kernel will ever do is that single

      put_user(raw_smp_processor_id(), &t->tlabi->cpu_id)

   and absolutely nothing else.

End result?  That damn data structure is 32 bits. No more, no less.
I'm perfectly happy to make a strict requiremnt that it is some
16-byte aligned thing, and we can add padding values, but quite
frankly, I'm not really sure even that is required.

And if the kernel ever has to care about anything else, I say "no".

Can anybody give a *coherent* and actual *real* reason why the kernel
would ever care about anything else?

Because if not, then this discussion is done for. Stop with the
f*cking idiotic "let's look at some kernel size and user-space size
and try to match them up". The kernel doesn't care. The kernel MUST
NOT care. The kernel will touch one single word, and that's all the
kernel does, and user space had better be able make up their own
semantics around that.

                      Linus
