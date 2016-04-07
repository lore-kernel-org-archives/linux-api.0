From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC PATCH v6 1/5] Thread-local ABI system call: cache CPU number
 of running thread
Date: Thu, 7 Apr 2016 09:59:36 -0700
Message-ID: <CA+55aFyB98SrhVPL66DAb3+rbn7nHf6K2MmEQD2Uj7F6hNcQEQ@mail.gmail.com>
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
	<57068FCC.8000701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57068FCC.8000701-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 7, 2016 at 9:50 AM, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> (AFAICS set_robust_list was designed with such extensions in mind.)

This is a disease among people who have been taught computer science.
People think that "designing with extensions in mind" is a good idea.

It's a _horrible_ idea.

If you think that "design with extensions in mind" is a good idea,
you're basically saying "I don't know what I might want to do".

I'm not interested in those kinds of kernel interfaces. EVERY SINGLE
TIME when we add a new random non-standard interface that isn't
already used by lots and lots of people, the end result is the same:
nobody actually uses it. There might be one or two very obscure
libraries that use it, and then a couple of special applications that
use those libraries. And that's it.

So unless there is a clear use-case, and clear semantics that people
can agree on as being truly generic and useful for a lot of different
cases, excuse me for being less than impressed.

Anything with a "let's add feature fields" is broken shit. BY DEFINITION.

See my argument?

And btw, ask yourself how well that set_robust_list() extension worked?

(Answer sheet to the above question: it was pure garbage. Instead of
actually ever being extended, the "struct robust_list_head" not only
is fixed, it was horribly misdesigned to the point of requiring a
compat system call. Pure garbage, in other words, and an example of
how *not* to do user interfaces).

                 Linus
