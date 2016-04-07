From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC PATCH v6 1/5] Thread-local ABI system call: cache CPU number
 of running thread
Date: Thu, 7 Apr 2016 09:52:11 -0700
Message-ID: <CA+55aFyB6CPNiMKGWoaV7vxFWWBTgqOTqG4u2aNnq6uq1cHWZA@mail.gmail.com>
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
	<CA+55aFxrWx5pFN3LseaKpUHtB6nqXtkgP84seU3pjys-kq7utQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFxrWx5pFN3LseaKpUHtB6nqXtkgP84seU3pjys-kq7utQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 7, 2016 at 9:39 AM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> Because if not, then this discussion is done for. Stop with the
> f*cking idiotic "let's look at some kernel size and user-space size
> and try to match them up". The kernel doesn't care. The kernel MUST
> NOT care. The kernel will touch one single word, and that's all the
> kernel does, and user space had better be able make up their own
> semantics around that.

.. and btw - if people aren't sure that that is a "good enough"
interface, then I'm sure as hell not going to merge that patch anyway.
Andy mentions rseq. Yeah, I'm not going to merge anything where part
of the discussion is "and we might want to do something else for X".

Either the suggested patches are useful and generic enough that people
can do this, or they aren't.

If people can agree that "yes, this whole cpu id cache is a great
interface that we can build up interesting user-space constructs
around", then great. Such a new kernel interface may be worth merging.

But if people cannot be convinced that it is sufficient, then I don't
want to merge some half-arsed interface that generates these kinds of
discussions.

So the fact that currently makes me go "no way will I merge any of
this" is the very fact that these discussions continue and are still
going on.

                Linus
