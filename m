From: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Thu, 4 Aug 2016 12:27:10 +0800
Message-ID: <20160804042710.GA13232@tardis.cn.ibm.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com>
 <CALCETrVq3hgLbADcx_4g6gGgp7Hf-WnnWA8gg68tPZTv2wfbDg@mail.gmail.com>
 <1806206514.82247.1469502139408.JavaMail.zimbra@efficios.com>
 <20160803122717.GL6862@twins.programming.kicks-ass.net>
 <CALCETrWw0M9YLWTR7_ruxY8cW9_5XRONdw1QN+_pBp0Y63L8pA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWw0M9YLWTR7_ruxY8cW9_5XRONdw1QN+_pBp0Y63L8pA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 03, 2016 at 09:37:57AM -0700, Andy Lutomirski wrote:
> On Wed, Aug 3, 2016 at 5:27 AM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wro=
te:
> > On Tue, Jul 26, 2016 at 03:02:19AM +0000, Mathieu Desnoyers wrote:
> >> We really care about preemption here. Every migration implies a
> >> preemption from a user-space perspective. If we would only care
> >> about keeping the CPU id up-to-date, hooking into migration would be
> >> enough. But since we want atomicity guarantees for restartable
> >> sequences, we need to hook into preemption.
> >
> >> It allows user-space to perform update operations on per-cpu data with=
out
> >> requiring heavy-weight atomic operations.
> >
> > Well, a CMPXCHG without LOCK prefix isn't all that expensive on x86.
> >
> > It is however on PPC and possibly other architectures, so in name of
> > simplicity supporting only the one variant makes sense.
> >
>=20
> I wouldn't want to depend on CMPXCHG.  But imagine we had primitives
> that were narrower than the full abort-on-preemption primitive.
> Specifically, suppose we had abort if (actual cpu !=3D expected_cpu ||
> *aptr !=3D aval).  We could do things like:
>=20
> expected_cpu =3D cpu;
> aval =3D NULL;  // disarm for now
> begin();
> aval =3D event_count[cpu] + 1;
> event_count[cpu] =3D aval;
> event_count[cpu]++;

This line is redundant, right? Because it will guarantee a failure even
in no-contention cases.

>=20
> ... compute something ...
>=20
> // arm the rest of it
> aptr =3D &event_count[cpu];
> if (*aptr !=3D aval)
>   goto fail;
>=20
> *thing_im_writing =3D value_i_computed;
> end();
>=20
> The idea here is that we don't rely on the scheduler to increment the
> event count at all, which means that we get to determine the scope of
> what kinds of access conflicts we care about ourselves.
>=20

If we increase the event count in userspace, how could we prevent two
userspace threads from racing on the event_count[cpu] field? For
example:

	CPU 0
	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
	{event_count[0] is initially 0}

	[Thread 1]
	begin();
	aval =3D event_count[cpu] + 1; // 1

	(preempted)
	[Thread 2]
	begin();
	aval =3D event_count[cpu] + 1; // 1, too
	event_count[cpu] =3D aval; // event_count[0] is 1

	(preempted)
	[Thread 1]
	event_count[cpu] =3D aval; // event_count[0] is 1

	...=20

	aptr =3D &event_count[cpu];
	if (*aptr !=3D aval) // false.
		...

	[Thread 2]
	aptr =3D &event_count[cpu];
	if (*aptr !=3D aval) // false.
		...

, in which case, both the critical sections are successful, and Thread 1
and Thread 2 will race on *thing_im_writing.

Am I missing your point here?

Regards,
Boqun

> This has an obvious downside: it's more complicated.
>=20
> It has several benefits, I think.  It's debuggable without hassle
> (unless someone, accidentally or otherwise, sets aval incorrectly).
> It also allows much longer critical sections to work well, as merely
> being preempted in the middle won't cause an abort any more.
>=20
> So I'm hoping to understand whether we could make something like this
> work.  This whole thing is roughly equivalent to abort-if-migrated
> plus an atomic "if (*aptr =3D=3D aval) *b =3D c;" operation.
>=20
> (I think that, if this worked, we could improve it a bit by making the
> abort operation jump back to the "if (*aptr !=3D aval) goto fail;" code,
> which should reduce the scope for error a bit and also reduces the
> need for extra code paths that only execute on an abort.)

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXosQaAAoJEEl56MO1B/q4I/cH/imLp60FVq8N5xKbF2o9JVXb
dCfM77FTImR3uo700cckqgSnDNAkL8O66nx5iFnk6NRQu1hVUXknHj6OX6TMSjyW
FqjaJtnGSvpoE2YvNgUOph3QxBErYlAnJqTn6wfbfDDhIwdGfUnPp/dO28b89QOW
WLawf5IyqxilJrJLZcxoqYm7U2cU9t1dl+SMq1QRMwnTiVckz1zcTUMnWNE315Dc
a1ttkf0zaTXcUWEa3KU59I11XNrFRTF8+9ro6BMACCP3sFdgHBea9qUVvN9AHH/A
UR0mVIShzw4EUHhlZvRPp7T5yYxMp78bIcuo3L+zpqdNGTP52wEdCBU4zubp0YM=
=tNDW
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
