From: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Wed, 3 Aug 2016 23:45:22 +0800
Message-ID: <20160803154522.GA19969@insomnia>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com>
 <20160803131940.GM6862@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160803131940.GM6862-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 03, 2016 at 03:19:40PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 21, 2016 at 05:14:16PM -0400, Mathieu Desnoyers wrote:
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 1209323..daef027 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -5085,6 +5085,13 @@ M:	Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
> >  S:	Maintained
> >  F:	scripts/get_maintainer.pl
> > =20
> > +RESTARTABLE SEQUENCES SUPPORT
> > +M:	Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>=20
> It would be good to have multiple people here, if we lack volunteers I'd
> be willing. Paul, Andrew any of you guys willing?
>=20

I volunteer to review related patches, do tests/benchmarks(esp. on PPC)
and try to fix/improve any issue as I can.

Mathieu, may I join the party? ;-)

Regards,
Boqun

> > +L:	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > +S:	Supported
> > +F:	kernel/rseq.c
> > +F:	include/uapi/linux/rseq.h
> > +
> >  GFS2 FILE SYSTEM
> >  M:	Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >  M:	Bob Peterson <rpeterso-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>=20
[...]

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXohGNAAoJEEl56MO1B/q4EJQIAJpX20NQs0u0zY+aO9+u/mUl
S9WSGZsqdSDy67h5NJHN0Bla5dkeaWdfyxUAUto+9XxHjZwdlzibJwsiFaohwhDE
T6Bj1Rn6wcvSm5OncZUggLVdJrKIGwbGdWMWIEzpM5KlEOgnUivvKx7WYwn1UoQ9
YZrqo9KfzuU4viThKXYTpU3YV1lZ/GQD1vp/X6cZAgldrr0oCQ0j3/CIJEefROHO
ciWXM2yMlGJ+WQFNxa2PaboQBvuvOhTgsVz1mMGIni+A27xJskNplcb3crkFEq3B
vcijewA/ac9RKtTfim4sGNcG7D04rl+t1/3PIpVLBtRkAJ2Btt6anC3F5fjgCzc=
=um1f
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
