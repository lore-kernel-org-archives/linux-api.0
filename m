From: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v7 7/7] Restartable sequences: self-tests
Date: Fri, 12 Aug 2016 09:28:54 +0800
Message-ID: <20160812012854.GC1740@tardis.cn.ibm.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1469135662-31512-8-git-send-email-mathieu.desnoyers@efficios.com>
 <CO1PR15MB09822FC140F84DCEEF2004CDDD0B0@CO1PR15MB0982.namprd15.prod.outlook.com>
 <1590181502.79032.1469329777708.JavaMail.zimbra@efficios.com>
 <CO1PR15MB09825505EBF36E0C56AA037ADD0C0@CO1PR15MB0982.namprd15.prod.outlook.com>
 <374861479.8581.1470957990793.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="yVhtmJPUSI46BTXb"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <374861479.8581.1470957990793.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--yVhtmJPUSI46BTXb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 11, 2016 at 11:26:30PM +0000, Mathieu Desnoyers wrote:
> ----- On Jul 24, 2016, at 2:01 PM, Dave Watson davejwatson-b10kYP2dOMg@public.gmane.org wrote:
>=20
> >>> +static inline __attribute__((always_inline))
> >>> +bool rseq_finish(struct rseq_lock *rlock,
> >>> + intptr_t *p, intptr_t to_write,
> >>> + struct rseq_state start_value)
> >=20
> >>> This ABI looks like it will work fine for our use case. I don't think=
 it
> >>> has been mentioned yet, but we may still need multiple asm blocks
> >>> for differing numbers of writes. For example, an array-based freelist=
 push:
> >=20
> >>> void push(void *obj) {
> >>> if (index < maxlen) {
> >>> freelist[index++] =3D obj;
> >>> }
> >>> }
> >=20
> >>> would be more efficiently implemented with a two-write rseq_finish:
> >=20
> >>> rseq_finish2(&freelist[index], obj, // first write
> >>> &index, index + 1, // second write
> >>> ...);
> >=20
> >> Would pairing one rseq_start with two rseq_finish do the trick
> >> there ?
> >=20
> > Yes, two rseq_finish works, as long as the extra rseq management overhe=
ad
> > is not substantial.
>=20
> I've added a commit implementing rseq_finish2() in my rseq volatile
> dev branch. You can fetch it at:
>=20
> https://github.com/compudj/linux-percpu-dev/tree/rseq-fallback
>=20
> I also have a separate test and benchmark tree in addition to the
> kernel selftests here:
>=20
> https://github.com/compudj/rseq-test
>=20
> I named the first write a "speculative" write, and the second write
> the "final" write.
>=20

Maybe I miss something subtle, but if the first write is only a
"speculative" write, why can't we put it in the rseq critical section
rather than asm block? Like this:

	do_rseq(..., result, targetptr, newval
		{=09
			newval =3D index;
			targetptr =3D &index;
			if (newval < maxlen)
				freelist[newval++] =3D obj;
			else
				result =3D false;
		}

No extra rseq_finish() is needed here, but maybe a little more
"speculative" writes?

> Would you like to extend the test cases to cover your intended use-case ?
>=20

Dave, if you are going to write some test cases about your use-cases,
would you also try the away I mentioned above?


Besides, do we allow userspace programs do read-only access to the
memory objects modified by do_rseq(). If so, we have a problem when
there are two writes in a do_rseq()(either in the rseq critical section
or in the asm block), because in current implemetation, these two writes
are unordered, which makes the readers outside a do_rseq() could observe
the ordering of writes differently.

For rseq_finish2(), a simple solution would be making the "final" write
a RELEASE.

Regards,
Boqun

> Thanks,
>=20
> Mathieu
>=20
> --=20
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com

--yVhtmJPUSI46BTXb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXrSZTAAoJEEl56MO1B/q4ZZ0H/2TuVCIRnB+bk8in79bqNske
ohSj1i4XUYd5EhKBAwOEwlbcgX3ftUgbjP+VZoQDWYzJdypSkezd1bYUFR3FrFee
a5tH+623NBe7yzooDs1HrLPYdauDD+Hkr59fPDW9/NH+LFsXJMz0OxqTrIapus1J
Zo20Kw0IDMyUA1PX5KFqbymRpNADFLLe0g7Gfz1w/RDRG+1U6/jq2J9sM0VlW1E9
VXQY5U7frS54qcoQbBnJ63yccV2G9CRCRyrNFe/SoKH9oEKJLH7qxO+E9QC03ryF
AqmSqncWvIjBcpg3XJXHt3FA7Je7PG5aNzSxGsfEcVDDJdbjx1X6Twnvv9hqzt8=
=th7Q
-----END PGP SIGNATURE-----

--yVhtmJPUSI46BTXb--
