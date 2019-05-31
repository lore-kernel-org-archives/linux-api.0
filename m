From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup
 and thread creation (v10)
Date: Fri, 31 May 2019 14:10:57 -0400 (EDT)
Message-ID: <1528929896.22217.1559326257155.JavaMail.zimbra@efficios.com>
References: <20190503184219.19266-1-mathieu.desnoyers@efficios.com> <87h89gjgaf.fsf@oldenburg2.str.redhat.com> <1239705947.14878.1558985272873.JavaMail.zimbra@efficios.com> <140718133.18261.1559144710554.JavaMail.zimbra@efficios.com> <2022553041.20966.1559249801435.JavaMail.zimbra@efficios.com> <875zprm4jo.fsf@oldenburg2.str.redhat.com> <732661684.21584.1559314109886.JavaMail.zimbra@efficios.com> <87muj2k4ov.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87muj2k4ov.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



----- On May 31, 2019, at 11:46 AM, Florian Weimer fweimer@redhat.com wrote=
:

> * Mathieu Desnoyers:
>=20
>> Let's break this down into the various sub-issues involved:
>>
>> 1) How early do we need to setup rseq ? Should it be setup before:
>>    - LD_PRELOAD .so constructors ?
>>      - Without circular dependency,
>>      - With circular dependency,
>>    - audit libraries initialization ?
>>    - IFUNC resolvers ?
>>    - other callbacks ?
>>    - memory allocator calls ?
>>
>> We may end up in a situation where we need memory allocation to be setup
>> in order to initialize TLS before rseq can be registered for the main
>> thread. I suspect we will end up needing a fallbacks which always work
>> for the few cases that would try to use rseq too early in dl/libc startu=
p.
>=20
> I think the answer to that depends on whether it's okay to have an
> observable transition from =E2=80=9Cno rseq kernel support=E2=80=9D to =
=E2=80=9Ckernel supports
> rseq=E2=80=9D.

As far as my own use-cases are concerned, I only care that rseq is initiali=
zed
before LD_PRELOAD .so constructors are executed.

There appears to be some amount of documented limitations for what can be
done by the IFUNC resolvers. It might be acceptable to document that rseq
might not be initialized yet when those are executed.

I'd like to hear what others think about whether we should care about IFUNC
resolvers and audit libraries using restartable sequences TLS ?

[...]

>=20
>> 4) Inability to touch a TLS variable (__rseq_abi) from ld-linux-*.so.2
>>    - Should we extend the dynamic linker to allow such TLS variable to b=
e
>>      accessed ? If so, how much effort is required ?
>>    - Can we find an alternative way to initialize rseq early during
>>      dl init stages while still performing the TLS access from a functio=
n
>>      implemented within libc.so ?
>=20
> This is again related to the answer for (1).  There are various hacks we
> could implement to make the initialization invisible (e.g., computing
> the address of the variable using the equivalent of dlsym, after loading
> all the initial objects and before starting relocation).  If it's not
> too hard to add TLS support to ld.so, we can consider that as well.
> (The allocation side should be pretty easy, relocation support it could
> be more tricky.)
>=20
>> So far, I got rseq to be initialized before LD_PRELOADed library
>> constructors by doing the initialization in a constructor within
>> libc.so. I don't particularly like this approach, because the
>> constructor order is not guaranteed.
>=20
> Right.

One question related to use of constructors: AFAIU, if a library depends
on glibc, ELF guarantees that the glibc constructor will be executed first,
before the other library.

Which leaves us with the execution order of constructors within libc.so,
which is not guaranteed if we just use __attribute__ ((constructor)).
However, all gcc versions that are required to build recent glibc
seem to support a constructor with a "priority" value (lower gets
executed first, and those are executed before constructors without
priority).

Could we do e.g.:

--- a/include/libc-internal.h
+++ b/include/libc-internal.h
@@ -21,6 +21,12 @@
=20
 #include <hp-timing.h>
=20
+/* Libc constructor priority order. Lower is executed first.  */
+enum libc_constructor_prio {
+       /* Priorities between 0 and 100 are reserved.  */
+       LIBC_CONSTRUCTOR_PRIO_RSEQ_INIT =3D 1000,
+};
+
 /* Initialize the `__libc_enable_secure' flag.  */
 extern void __libc_init_secure (void);
=20
and

csu/libc-start.c:

static
__attribute__ ((constructor (LIBC_CONSTRUCTOR_PRIO_RSEQ_INIT)))
void __rseq_libc_init (void)
{
  rseq_init ();
  /* Register rseq ABI to the kernel.   */
  (void) rseq_register_current_thread ();
}

[...]

Thanks,

Mathieu




--=20
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
