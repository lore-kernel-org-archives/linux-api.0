From: Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [RFC PATCH v8 1/9] Restartable sequences system call
Date: Tue, 30 Aug 2016 10:01:42 +0800
Message-ID: <20160830020142.GC28226@tardis.cn.ibm.com>
References: <1471637274-13583-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1471637274-13583-2-git-send-email-mathieu.desnoyers@efficios.com>
 <CA+55aFz+Q33m1+ju3ANaznBwYCcWo9D9WDr2=p0YLEF4gJF12g@mail.gmail.com>
 <545371402.19191.1472144912215.JavaMail.zimbra@efficios.com>
 <1BD94294-23AD-40CC-8227-43AE1AD8092F@fb.com>
 <20160827042226.akfaq4wku2gdpxsi@x>
 <91715400.22162.1472483812389.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0vzXIDBeUiKkjNJl"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <91715400.22162.1472483812389.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Josh Triplett <josh@joshtriplett.org>, Ben Maurer <bmaurer@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Watson <davejwatson@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org


--0vzXIDBeUiKkjNJl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 29, 2016 at 03:16:52PM +0000, Mathieu Desnoyers wrote:
> ----- On Aug 27, 2016, at 12:22 AM, Josh Triplett josh@joshtriplett.org w=
rote:
>=20
> > On Thu, Aug 25, 2016 at 05:56:25PM +0000, Ben Maurer wrote:
> >> rseq opens up a whole world of algorithms to userspace =E2=80=93 algor=
ithms
> >> that are O(num CPUs) and where one can have an extremely fast fastpath
> >> at the cost of a slower slow path. Many of these algorithms are in use
> >> in the kernel today =E2=80=93 per-cpu allocators, RCU, light-weight re=
ader
> >> writer locks, etc. Even in cases where these APIs can be implemented
> >> today, a rseq implementation is often superior in terms of
> >> predictability and usability (eg per-thread counters consume more
> >> memory and are more expensive to read than per-cpu counters).
> >>
> >> Isn=E2=80=99t the large number of uses of rseq-like algorithms in the =
kernel a
> >> pretty substantial sign that there would be demand for similar
> >> algorithms by user-space systems programmers?
> >=20
> > Yes and no.  It provides a substantial sign that such algorithms could
> > and should exist; however "someone should do this" doesn't demonstrate
> > that someone *will*.  I do think we need a concrete example of a
> > userspace user with benchmark numbers that demonstrate the value of this
> > approach.
> >=20
> > Mathieu, do you have a version of URCU that can use rseq to work per-CPU
> > rather than per-thread?  URCU's data structures would work as a
> > benchmark.
>=20
> I currently don't have a per-cpu flavor of liburcu. All the flavors are
> per-thread, because currently the alternative requires atomic operations
> on the fast-path. We could indeed re-implement something similar to SRCU
> (although under LGPLv2.1 license). I've looked at what would be required
> over the weekend, and it seems feasible, but in the short term my custome=
rs
> expect me to focus my work on speeding up the LTTng-UST tracer per-cpu
> ring buffer by adapting it to rseq. Completing the liburcu per-cpu flavor
> will be in my spare time for now.
>=20

Just for you information.

I have been working on the new SRCU-like flavor of liburcu since last
week, but it took me a while to understand the directory architecture of
urcu...

I wrote only implemetion for rcu_read_{un}lock() and synchronize_rcu(),
and just is able to run the simplest multiflavor test case. My plan is
to post the code and some numbers(on x86 and ppc) by the end of this
week.

Regards,
Boqun

> I expect liburcu per-cpu flavor to improve the slow path in many-threads
> use-cases (smaller grace period overhead), but not the fast path much,
> except perhaps by allowing faster memory reclaim in update-heavy workload=
s,
> which could then lead to better use of the cache even for reads.
>=20

[...]

--0vzXIDBeUiKkjNJl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXxOkBAAoJEEl56MO1B/q4g2gH/284eMZd47dpEoGafF10B3RH
sNU02KbuNDPlnNeQFv8dgzZGei/PiS6hxcv2eDkcLOmXbVVT4zwbWDiNqT+8v65k
5CT+d7eG9/g8Xp5JRMnkwtfVlZSn6HYnDfcgw5ZQFyjg8ONJA9DatjbsjlG5wwXS
QMz7BSBU6jG7WeiZqn7SpD59+YtKZFOKWnxbcLgDv5PNp5tJGN/ypDzYjCrnQugp
G47wlcBjqqsUNon+1wjmQiHydmH8mGvjgnkqNmFB1wKD6zKuqCGVdLrApJ2/1FEG
bHsj6jV72w4rKxYuToJsoC+yoHvPxCcaPfu9y+2uIetPS/FbUrWRjsisdVepNeg=
=opCB
-----END PGP SIGNATURE-----

--0vzXIDBeUiKkjNJl--
