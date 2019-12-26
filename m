From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH] seccomp: Check flags on seccomp_notif is unset
Date: Fri, 27 Dec 2019 01:32:29 +1100
Message-ID: <20191226143229.sbopynwut2hhsiwn@yavin.dot.cyphar.com>
References: <20191225214530.GA27780@ircssh-2.c.rugged-nimbus-611.internal>
 <20191226115245.usf7z5dkui7ndp4w@wittgenstein>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fgt5mo6icnbxpigg"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191226115245.usf7z5dkui7ndp4w@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Sargun Dhillon <sargun@sargun.me>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, tycho@tycho.ws, jannh@google.com, keescook@chromium.org
List-Id: linux-api@vger.kernel.org


--fgt5mo6icnbxpigg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-12-26, Christian Brauner <christian.brauner@ubuntu.com> wrote:
> On Wed, Dec 25, 2019 at 09:45:33PM +0000, Sargun Dhillon wrote:
> > This patch is a small change in enforcement of the uapi for
> > SECCOMP_IOCTL_NOTIF_RECV ioctl. Specificaly, the datastructure which is
> > passed (seccomp_notif), has a flags member. Previously that could be
> > set to a nonsense value, and we would ignore it. This ensures that
> > no flags are set.
> >=20
> > Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> > Cc: Kees Cook <keescook@chromium.org>
>=20
> I'm fine with this since we soon want to make use of the flag argument
> when we add a flag to get a pidfd from the seccomp notifier on receive.
> The major users I could identify already pass in seccomp_notif with all
> fields set to 0. If we really break users we can always revert; this
> seems very unlikely to me though.
>=20
> One more question below, otherwise:
>=20
> Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
>=20
> > ---
> >  kernel/seccomp.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >=20
> > diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> > index 12d2227e5786..455925557490 100644
> > --- a/kernel/seccomp.c
> > +++ b/kernel/seccomp.c
> > @@ -1026,6 +1026,13 @@ static long seccomp_notify_recv(struct seccomp_f=
ilter *filter,
> >  	struct seccomp_notif unotif;
> >  	ssize_t ret;
> > =20
> > +	if (copy_from_user(&unotif, buf, sizeof(unotif)))
> > +		return -EFAULT;
> > +
> > +	/* flags is reserved right now, make sure it's unset */
> > +	if (unotif.flags)
> > +		return -EINVAL;
> > +
>=20
> Might it make sense to use
>=20
> 	err =3D copy_struct_from_user(&unotif, sizeof(unotif), buf, sizeof(unoti=
f));
> 	if (err)
> 		return err;
>=20
> This way we check that the whole struct is 0 and report an error as soon
> as one of the members is non-zero. That's more drastic but it'd ensure
> that other fields can be used in the future for whatever purposes.
> It would also let us get rid of the memset() below.=20

Given that this isn't an extensible struct, it would be simpler to just do
check_zeroed_user() -- copy_struct_from_user() is overkill. That would
also remove the need for any copy_from_user()s and the memset can be
dropped by just doing

  struct seccomp_notif unotif =3D {};

> >  	memset(&unotif, 0, sizeof(unotif));
> > =20
> >  	ret =3D down_interruptible(&filter->notif->request);
> > --=20
> > 2.20.1
> >=20


--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--fgt5mo6icnbxpigg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXgTEegAKCRCdlLljIbnQ
EuTpAP4wZYtJyKgXrPhPg8m27dR0ZKvSVhgLQW+sH93GxA3prgEAq+3iCvwDomHL
7hxWTJqkQIAvqUejPuQZqKRMQ6qd5gw=
=uj2S
-----END PGP SIGNATURE-----

--fgt5mo6icnbxpigg--
