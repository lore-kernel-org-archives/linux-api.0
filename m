From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH 2/2] mmap.2: MAP_FIXED updated documentation
Date: Wed, 13 Dec 2017 14:21:05 +0100
Message-ID: <20171213132105.GA20517@amd>
References: <20171213092550.2774-1-mhocko@kernel.org>
 <20171213093110.3550-1-mhocko@kernel.org>
 <20171213093110.3550-2-mhocko@kernel.org>
 <20171213125540.GA18897@amd>
 <20171213130458.GI25185@dhcp22.suse.cz>
 <20171213130900.GA19932@amd>
 <20171213131640.GJ25185@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171213131640.GJ25185-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2017-12-13 14:16:40, Michal Hocko wrote:
> On Wed 13-12-17 14:09:00, Pavel Machek wrote:
> > On Wed 2017-12-13 14:04:58, Michal Hocko wrote:
> > > On Wed 13-12-17 13:55:40, Pavel Machek wrote:
> > > > On Wed 2017-12-13 10:31:10, Michal Hocko wrote:
> > > > > From: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > > > >=20
> > > > >     -- Expand the documentation to discuss the hazards in
> > > > >        enough detail to allow avoiding them.
> > > > >=20
> > > > >     -- Mention the upcoming MAP_FIXED_SAFE flag.
> > > >=20
> > > > Pretty map everyone agreed MAP_FIXED_SAFE was a bad
> > > > name. MAP_FIXED_NOREPLACE (IIRC) was best replacement.
> > >=20
> > > Please read http://lkml.kernel.org/r/20171213092550.2774-1-mhocko@ker=
nel.org
> >=20
> > Please fix your patches according to the feedback...
> >=20
> > NACCKED-by: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
>=20
> Good luck pursuing this further then. I am not going to spend time on
> naming bikeheds. I have more pressing stuff to work on.

You selected stupid name for a flag. Everyone and their dog agrees
with that. There's even consensus on better name (and everyone agrees
it is better than .._SAFE). Of course, we could have debate if it is
NOREPLACE or NOREMOVE or ... and that would be bikeshed. This was just
poor naming on your part.
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAloxKUEACgkQMOfwapXb+vIaDACglkA+TQweyTN40m07LVKXmmjO
BukAnjMPW+g/zwooUAygb7Qebv4t4P4K
=vJ4y
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
