From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of
 running thread
Date: Fri, 26 Feb 2016 17:47:05 +0000 (UTC)
Message-ID: <668290565.8970.1456508825358.JavaMail.zimbra@efficios.com>
References: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com> <1456270120-7560-2-git-send-email-mathieu.desnoyers@efficios.com> <alpine.DEB.2.11.1602241206020.3670@nanos> <87egc0l62k.fsf@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87egc0l62k.fsf@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

----- On Feb 25, 2016, at 6:32 PM, Rasmus Villemoes linux@rasmusvillemo=
es.dk wrote:

> On Wed, Feb 24 2016, Mathieu Desnoyers <mathieu.desnoyers@efficios.co=
m> wrote:
>=20
>>
>>        Typically, a library or application will keep the cpu  number
>>        cache  in  a  thread-local  storage variable, or other memory
>>        areas belonging to each thread. It is recommended to  perform
>>        a  volatile  read of the cpu number cache to prevent the com=E2=
=80=90
>>        piler from doing load tearing. An alternative approach is  to
>>        read  the  cpu  number cache from inline assembly in a single
>>        instruction.
>>
>>        Each thread is responsible for registering its own cpu number
>>        cache.   Only  one  cpu  cache  address can be registered per
>>        thread.
>>
>>        The symbol  __getcpu_cache_tls  is  recommended  to  be  used
>>        across  libraries  and  applications  wishing  to  register a
>>        thread-local getcpu_cache. The  attribute  "weak"  is  recom=E2=
=80=90
>>        mended  when  declaring this variable in libraries.  Applica=E2=
=80=90
>>        tions can choose to define their own version of  this  symbol
>>        without the weak attribute as a performance improvement.
>>
>>        In  a  typical usage scenario, the thread registering the cpu
>>        number cache will be performing reads from that cache. It  is
>>        however  also allowed to read the cpu number cache from other
>>        threads. The cpu number cache updates performed by the kernel
>>        provide single-copy atomicity semantics, which guarantee that
>>        other threads performing single-copy atomic reads of the  cpu
>>        number cache will always observe a consistent value.
>>
>>        Memory registered as cpu number cache should never be deallo=E2=
=80=90
>>        cated before the thread which registered it  exits:  specifi=E2=
=80=90
>>        cally, it should not be freed, and the library containing the
>>        registered thread-local storage should not be dlclose'd.
>=20
> Maybe spell out the consequence if this is violated - since the SIGSE=
GV
> only happens on migration, it may take a while to strike.

Good point.

>=20
> Random thoughts: The current implementation ensures that getcpu_cache=
 is
> "idempotent" from within a single thread - once set, it can never get
> unset nor set to some other pointer. I think that can be useful, sinc=
e
> it means a library can reliably use the TLS variable itself (initiali=
zed
> with some negative number) as an indicator of whether
> getcpu_cache(GETCPU_CACHE_SET) has been called. So if a single test o=
n a
> fast path where the library would need to load __getcpu_cache_tls any=
way
> is acceptable, it can avoid requiring some library init function to b=
e
> called in each thread - which can sometimes be hard to arrange. Is th=
is
> something we want to guarantee - that is, will we never implement
> GETCPU_CACHE_UNSET or a "force" flag to _SET? Either way, I think we
> should spend a few words on it to avoid the current behaviour becomin=
g
> accidental ABI.

Yes, I would be tempted to state that once set, the address is idempote=
nt
for a thread.

>=20
> In another thread:
>=20
>> However, there are other use-cases for having a fast mechanism for
>> reading the current CPU number, besides restartable sequences.  For
>> instance, it can be used by glibc to implement a faster sched_getcpu=
=2E
>=20
> Will glibc do that? It may be a little contentious for glibc to claim=
 a
> unique resource such as task_struct::cpu_cache for itself, even if
> everybody is supposed to use the same symbol. Hm, maybe one could say
> that if an application does define the symbol __getcpu_cache_tls (whi=
ch
> is techically in the implementation namespace), that gives glibc (and
> any other library) license to do getcpu_cache(SET, &&__getcpu_cache_t=
ls)
> (pseudo-code, of course). If a library initializes its own weak versi=
on
> with -2 it can check whether the application defined
> __getcpu_cache_tls. Ok, I'm probably overthinking this...

I've had the exact same thoughts a few days ago then thinking about
how lttng-ust could do a "lazy binding" of the getcpu_cache without
requiring an explicit initialization at thread start. We're reaching
very similar conclusions. We could recommend/require that userspace
does this whenever it defines a __getcpu_cache_tls:

Declare as

__thread __attribute__((weak)) volatile int32_t __getcpu_cache_tls =3D =
-1;

Then whenever it loads it, "-1" would mean "uninitialized", and "-2"
could mean "this thread tried to initialize it, but fail, so you
should directly go to a fallback". ">=3D 0" would mean initialized and
working.

static inline int32_t getcpu_cache_read(void)
{
    int32_t cachev =3D __getcpu_cache_tls;

    if (likely(cachev >=3D 0))
        return cachev;

    if (cachev =3D=3D -1) {
        volatile int32_t *cpu_cache =3D &__getcpu_cache_tls;

        if (!getcpu_cache(GETCPU_CACHE_SET, &cpu_cache, 0))
            return __getcpu_cache_tls;
        __getcpu_cache_tls =3D -2;
    }
    /* Fallback on sched_getcpu(). */
    return sched_getcpu();
}

This could be documented in the getcpu_cache system call man page.

Thoughts ?

Thanks,

Mathieu

--=20
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
