From: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Subject: Re: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of running thread
Date: Fri, 26 Feb 2016 00:32:19 +0100
Message-ID: <87egc0l62k.fsf@rasmusvillemoes.dk>
References: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com>
	<1456270120-7560-2-git-send-email-mathieu.desnoyers@efficios.com>
	<alpine.DEB.2.11.1602241206020.3670@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1602241206020.3670@nanos> (Thomas Gleixner's
	message of "Wed, 24 Feb 2016 12:11:15 +0100 (CET)")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Feb 24 2016, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>=
 wrote:

>
>        Typically, a library or application will keep the cpu  number
>        cache  in  a  thread-local  storage variable, or other memory
>        areas belonging to each thread. It is recommended to  perform
>        a  volatile  read of the cpu number cache to prevent the com=E2=
=80=90
>        piler from doing load tearing. An alternative approach is  to
>        read  the  cpu  number cache from inline assembly in a single
>        instruction.
>
>        Each thread is responsible for registering its own cpu number
>        cache.   Only  one  cpu  cache  address can be registered per
>        thread.
>
>        The symbol  __getcpu_cache_tls  is  recommended  to  be  used
>        across  libraries  and  applications  wishing  to  register a
>        thread-local getcpu_cache. The  attribute  "weak"  is  recom=E2=
=80=90
>        mended  when  declaring this variable in libraries.  Applica=E2=
=80=90
>        tions can choose to define their own version of  this  symbol
>        without the weak attribute as a performance improvement.
>
>        In  a  typical usage scenario, the thread registering the cpu
>        number cache will be performing reads from that cache. It  is
>        however  also allowed to read the cpu number cache from other
>        threads. The cpu number cache updates performed by the kernel
>        provide single-copy atomicity semantics, which guarantee that
>        other threads performing single-copy atomic reads of the  cpu
>        number cache will always observe a consistent value.
>
>        Memory registered as cpu number cache should never be deallo=E2=
=80=90
>        cated before the thread which registered it  exits:  specifi=E2=
=80=90
>        cally, it should not be freed, and the library containing the
>        registered thread-local storage should not be dlclose'd.

Maybe spell out the consequence if this is violated - since the SIGSEGV
only happens on migration, it may take a while to strike.

Random thoughts: The current implementation ensures that getcpu_cache i=
s
"idempotent" from within a single thread - once set, it can never get
unset nor set to some other pointer. I think that can be useful, since
it means a library can reliably use the TLS variable itself (initialize=
d
with some negative number) as an indicator of whether
getcpu_cache(GETCPU_CACHE_SET) has been called. So if a single test on =
a
fast path where the library would need to load __getcpu_cache_tls anywa=
y
is acceptable, it can avoid requiring some library init function to be
called in each thread - which can sometimes be hard to arrange. Is this
something we want to guarantee - that is, will we never implement
GETCPU_CACHE_UNSET or a "force" flag to _SET? Either way, I think we
should spend a few words on it to avoid the current behaviour becoming
accidental ABI.

In another thread:

> However, there are other use-cases for having a fast mechanism for
> reading the current CPU number, besides restartable sequences.  For
> instance, it can be used by glibc to implement a faster sched_getcpu.

Will glibc do that? It may be a little contentious for glibc to claim a
unique resource such as task_struct::cpu_cache for itself, even if
everybody is supposed to use the same symbol. Hm, maybe one could say
that if an application does define the symbol __getcpu_cache_tls (which
is techically in the implementation namespace), that gives glibc (and
any other library) license to do getcpu_cache(SET, &&__getcpu_cache_tls=
)
(pseudo-code, of course). If a library initializes its own weak version
with -2 it can check whether the application defined
__getcpu_cache_tls. Ok, I'm probably overthinking this...

Rasmus
