From: Pavel Machek <pavel@ucw.cz>
Subject: known bad patch in -mm tree was Re: [PATCH 2/2] mmap.2: MAP_FIXED
 updated documentation
Date: Thu, 21 Dec 2017 15:59:07 +0100
Message-ID: <20171221145907.GA7604@amd>
References: <20171213125540.GA18897@amd>
 <20171213130458.GI25185@dhcp22.suse.cz>
 <20171213130900.GA19932@amd>
 <20171213131640.GJ25185@dhcp22.suse.cz>
 <20171213132105.GA20517@amd>
 <20171213144050.GG11493@rei>
 <CAGXu5jLqE6cUxk-Girx6PG7upEzz8jmu1OH_3LVC26iJc2vTxQ@mail.gmail.com>
 <c7c7a30e-a122-1bbf-88a2-3349d755c62d@gmail.com>
 <CAGXu5jJ289R9koVoHmxcvUWr6XHSZR2p0qq3WtpNyN-iNSvrNQ@mail.gmail.com>
 <87po78fe7m.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <87po78fe7m.fsf@concordia.ellerman.id.au>
Sender: owner-linux-mm@kvack.org
To: Michael Ellerman <mpe@ellerman.id.au>, vojtech@suse.cz, jikos@suse.cz
Cc: Kees Cook <keescook@chromium.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Cyril Hrubis <chrubis@suse.cz>, Michal Hocko <mhocko@kernel.org>, Linux API <linux-api@vger.kernel.org>, Khalid Aziz <khalid.aziz@oracle.com>, Russell King - ARM Linux <linux@armlinux.org.uk>, Andrea Arcangeli <aarcange@redhat.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>, John Hubbard <jhubbard@nvidia.com>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >>> And if Michal doesn't want to touch this patch any more, I'm happy to
> >>> do the search/replace/resend. :P
> >>
> >> Something with the prefix MAP_FIXED_ seems to me obviously desirable,
> >> both to suggest that the function is similar, and also for easy
> >> grepping of the source code to look for instances of both.
> >> MAP_FIXED_SAFE didn't really bother me as a name, but
> >> MAP_FIXED_NOREPLACE (or MAP_FIXED_NOCLOBBER) seem slightly more
> >> descriptive of what the flag actually does, so a little better.
> >
> > Great, thanks!
> >
> > Andrew, can you s/MAP_FIXED_SAFE/MAP_FIXED_NOREPLACE/g in the series?
>=20
> This seems to have not happened. Presumably Andrew just missed the mail
> in the flood. And will probably miss this one too ... :)

Nice way to mess up kernel development, Michal. Thank you! :-(.

Andrew, everyone and their dog agrees MAP_FIXED_SAFE is stupid name,
but Michal decided to just go ahead, ignoring feedback...

Can you either s/MAP_FIXED_SAFE/MAP_FIXED_NOREPLACE/g or drop the patches?

Thanks,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlo7zDsACgkQMOfwapXb+vJPWgCbBfYtq66FI5JTa2xsFDGf0za9
djIAoJx/7xt2XwUfdzK545naG/32MRDV
=vmt7
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
