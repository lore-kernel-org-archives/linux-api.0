From: Joey Pabalinas <joeypabalinas@gmail.com>
Subject: Re: [PATCH v1 2/2] signal: add procfd_signal() syscall
Date: Wed, 28 Nov 2018 13:02:01 -1000
Message-ID: <20181128230201.afprnrqyvrtzghh7@gmail.com>
References: <20181119103241.5229-1-christian@brauner.io>
 <20181119103241.5229-3-christian@brauner.io>
 <20181128214534.xxqoyy7mi5dw54kj@gmail.com>
 <20181128220545.fplqmbkfhxowx3lf@brauner.io>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="msgp3xujwmcofyiu"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181128220545.fplqmbkfhxowx3lf@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Joey Pabalinas <joeypabalinas@gmail.com>, ebiederm@xmission.com, linux-kernel@vger.kernel.org, serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org


--msgp3xujwmcofyiu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 28, 2018 at 11:05:49PM +0100, Christian Brauner wrote:
> On Wed, Nov 28, 2018 at 11:45:34AM -1000, Joey Pabalinas wrote:
> > On Mon, Nov 19, 2018 at 11:32:39AM +0100, Christian Brauner wrote:
> > > +	if (info) {
> > > +		ret =3D __copy_siginfo_from_user(sig, &kinfo, info);
> > > +		if (unlikely(ret))
> > > +			goto err;
> >=20
>=20
> I think you're misreading here. It jumps to:
>=20
> err:
>         fdput(f);
> 	return ret;
>=20
> and does propagate the error. This is also an old iteration of the patch.

Whoops, that I am. Sorry about that.

--=20
Cheers,
Joey Pabalinas

--msgp3xujwmcofyiu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEENpTlWU2hUK/KMvHp2rGdfm9DtVIFAlv/HmgACgkQ2rGdfm9D
tVLwnRAAoYNn3yu6ffNJq6EY2npo/FGJKvcOE5Oxu+fBJ6VOp5lOqfhr4ZIBohwa
KvQOJK4qv67GLUkzk7y+Tc5eYgIYgKWXp+pqGppmVPGatKOE0sJupMPC8SKyK69v
XEwJpfy640YsJlOyswiX3007jdOBIk1D21JECgbiCuoN2P5UxahZgUTdSBdbjHlx
fPx+JKcC221x2ar6KseYwUbfBB60Rie0+CkIL4GefFXqUlPYcLxxlpPabn2QsNje
lY6RtUGC7VB47vnPUVVzF9vooE9L8zpJazdQgL7HhbppXmHkFu5FYaN1aY94jgtk
2MfC2px/+ESuuiT0YdLOH0ReZT69r83kASHW5P1nDepS6I36BSSJfHXshXkaiXVc
HYrHAH6rCODCFkrEFCPjbBdtFIacJ6e0RpDaPddNec84jleRtZMMD4q/E8VgN3kT
gHv4PG09wXqkq8HLplLHo4XkKetgHz1SI09LnsU1IN3IilieXiu030e/kBP1c1UP
0gotXqxTWmyMQJPm24yXJsEwIFwLcu4paHu5oroSXrHU+pFmAoILjEqddbJMy6Mp
IZTCz3fIW6iBNqEcTOHovZPfNJD3PfZu1GEjGEDfYDfI+MPofUgp73uZq51E2EoL
dFHsxwcGFhhAIPwi8sLkjfSJjRSYynRU4VCOnU5X2MphsWDAptU=
=tCf2
-----END PGP SIGNATURE-----

--msgp3xujwmcofyiu--
