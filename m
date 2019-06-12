From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2 0/5] Introduce MADV_COLD and MADV_PAGEOUT
Date: Wed, 12 Jun 2019 13:37:15 +0200
Message-ID: <20190612113715.GA21366@amd>
References: <20190610111252.239156-1-minchan@kernel.org>
 <20190612105945.GA16442@amd>
 <20190612111920.evedpmre63ivnxkz@butterfly.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190612111920.evedpmre63ivnxkz@butterfly.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, jannh@google.com, oleg@redhat.com, christian@brauner.io, hdanton@sina.com, lizeb@google.com
List-Id: linux-api@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > This approach is similar in spirit to madvise(MADV_WONTNEED), but the
> > > information required to make the reclaim decision is not known to the=
 app.
> > > Instead, it is known to a centralized userspace daemon, and that daem=
on
> > > must be able to initiate reclaim on its own without any app involveme=
nt.
> > > To solve the concern, this patch introduces new syscall -
> > >=20
> > >     struct pr_madvise_param {
> > >             int size;               /* the size of this structure */
> > >             int cookie;             /* reserved to support atomicity =
*/
> > >             int nr_elem;            /* count of below arrary fields */
> > >             int __user *hints;      /* hints for each range */
> > >             /* to store result of each operation */
> > >             const struct iovec __user *results;
> > >             /* input address ranges */
> > >             const struct iovec __user *ranges;
> > >     };
> > >    =20
> > >     int process_madvise(int pidfd, struct pr_madvise_param *u_param,
> > >                             unsigned long flags);
> >=20
> > That's quite a complex interface.
> >=20
> > Could we simply have feel_free_to_swap_out(int pid) syscall? :-).
>=20
> I wonder for how long we'll go on with adding new syscalls each time we n=
eed
> some amendment to existing interfaces. Yes, clone6(), I'm looking at
> you :(.
>=20
> In case of process_madvise() keep in mind it will be focused not only on
> MADV_COLD, but also, potentially, on other MADV_ flags as well. I can
> hardly imagine we'll add one syscall per each flag.

Use case described above talked about whole-process-at-a-time usage,
so I'm asking if simpler interface/code is enough. If there's
motivation for more complex version, it should be described here...

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl0A4+sACgkQMOfwapXb+vL5YQCghuEijV5YAvkI5fTH2VOxFvri
GLwAoJHEuclcX7PmhKr8Ht0OQ4+EHl8w
=CpBo
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
