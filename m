From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/2 v2] fdmap(2)
Date: Wed, 25 Oct 2017 15:48:00 +0200
Message-ID: <20171025134800.GA15858@amd>
References: <20170924200620.GA24368@avx2>
 <9bc11ace-d111-cdef-5280-8cdda027ae9a@gmail.com>
 <20171023092938.GC32228@amd>
 <CACVxJT-YmJQcp9PPhA1cx3rzUF1onzg-AzpC88L+QXz9xgYGtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVxJT-YmJQcp9PPhA1cx3rzUF1onzg-AzpC88L+QXz9xgYGtQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, rdunlap@infradead.org, tglx@linutronix.de, tixxdz@gmail.com, gladkov.alexey@gmail.com, Aliaksandr Patseyenak <Aliaksandr_Patseyenak1@epam.com>
List-Id: linux-api@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2017-10-25 14:45:31, Alexey Dobriyan wrote:
> On 10/23/17, Pavel Machek <pavel@ucw.cz> wrote:
>=20
> > Binary fdmap looks... quite ugly to me. But close_all(from, to)
> > syscall kindof makes sense to me... and is not that ugly.
> >
> > Given that openbsd has something similar... perhaps we can take that?
>=20
> closefrom() can be implemented on top of fdmap().
> fdmap as is is useful for other purposes.

fdmap can be implemented on top of open('/dev/kmem').
open('/dev/kmem') as is is useful for other purposes.

Yes, fdmap is more powerful. No, that does not mean it is better idea.
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlnwlhAACgkQMOfwapXb+vIi0gCeNoi9yObnr3xrCrIIowUefeBF
arIAniGlNRdh3ZnIvv6eg+qJ1ck7cf71
=VHZR
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
