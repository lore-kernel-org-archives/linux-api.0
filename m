From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 2/2] mmap.2: MAP_FIXED updated documentation
Date: Wed, 13 Dec 2017 14:09:00 +0100
Message-ID: <20171213130900.GA19932@amd>
References: <20171213092550.2774-1-mhocko@kernel.org>
 <20171213093110.3550-1-mhocko@kernel.org>
 <20171213093110.3550-2-mhocko@kernel.org>
 <20171213125540.GA18897@amd>
 <20171213130458.GI25185@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171213130458.GI25185@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org, Khalid Aziz <khalid.aziz@oracle.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Florian Weimer <fweimer@redhat.com>, John Hubbard <jhubbard@nvidia.com>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Cyril Hrubis <chrubis@suse.cz>
List-Id: linux-api@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2017-12-13 14:04:58, Michal Hocko wrote:
> On Wed 13-12-17 13:55:40, Pavel Machek wrote:
> > On Wed 2017-12-13 10:31:10, Michal Hocko wrote:
> > > From: John Hubbard <jhubbard@nvidia.com>
> > >=20
> > >     -- Expand the documentation to discuss the hazards in
> > >        enough detail to allow avoiding them.
> > >=20
> > >     -- Mention the upcoming MAP_FIXED_SAFE flag.
> >=20
> > Pretty map everyone agreed MAP_FIXED_SAFE was a bad
> > name. MAP_FIXED_NOREPLACE (IIRC) was best replacement.
>=20
> Please read http://lkml.kernel.org/r/20171213092550.2774-1-mhocko@kernel.=
org

Please fix your patches according to the feedback...

NACCKED-by: Pavel Machek <pavel@ucw.cz>

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAloxJmwACgkQMOfwapXb+vJVYwCgiSl46pqmhEGrK0Mt2KJ+T+B0
YEQAoJVN3o5wbyRIYmj458ThYbuQifj1
=wV5t
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
