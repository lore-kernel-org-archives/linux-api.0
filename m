From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH 1/2 v2] fdmap(2)
Date: Mon, 23 Oct 2017 11:29:39 +0200
Message-ID: <20171023092938.GC32228@amd>
References: <20170924200620.GA24368@avx2>
 <9bc11ace-d111-cdef-5280-8cdda027ae9a@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="nmemrqcdn5VTmUEE"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9bc11ace-d111-cdef-5280-8cdda027ae9a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Aliaksandr Patseyenak <Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--nmemrqcdn5VTmUEE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > From: Aliaksandr Patseyenak <Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org>
> >=20
> > Implement system call for bulk retrieveing of opened descriptors
> > in binary form.
> >=20
> > Some daemons could use it to reliably close file descriptors
> > before starting. Currently they close everything upto some number
> > which formally is not reliable. Other natural users are lsof(1) and CRIU
> > (although lsof does so much in /proc that the effect is thoroughly buri=
ed).
> >=20
> > /proc, the only way to learn anything about file descriptors may not be
> > available. There is unavoidable overhead associated with instantiating
> > 3 dentries and 3 inodes and converting integers to strings and back.
> >=20
> > Benchmark:
> >=20
> > 	N=3D1<<22 times
> > 	4 opened descriptors (0, 1, 2, 3)
> > 	opendir+readdir+closedir /proc/self/fd vs fdmap
> >=20
> > 	/proc 8.31 =B1 0.37%
> > 	fdmap 0.32 =B1 0.72%
>=20
> >From the text above, I'm still trying to understand: whose problem
> does this solve? I mean, we've lived with the daemon-close-all-files
> technique forever (and I'm not sure that performance is really an=20
> important issue for the daemon case) . And you say that the effect

Binary fdmap looks... quite ugly to me. But close_all(from, to)
syscall kindof makes sense to me... and is not that ugly.

Given that openbsd has something similar... perhaps we can take that?

Except during startup, application should have good idea what fds it
has open, so maybe that's enough?
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--nmemrqcdn5VTmUEE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlnttoIACgkQMOfwapXb+vIW5wCgt3SY4RhrKfcSormjhK71xAPK
PUwAn2SQNavXg0j/w7dyikZa9uFohG+/
=RAud
-----END PGP SIGNATURE-----

--nmemrqcdn5VTmUEE--
