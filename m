From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH] seccomp: Check flags on seccomp_notif is unset
Date: Fri, 27 Dec 2019 13:24:46 +1100
Message-ID: <20191227022446.37e64ag4uaqms2w4@yavin.dot.cyphar.com>
References: <20191225214530.GA27780@ircssh-2.c.rugged-nimbus-611.internal>
 <20191226115245.usf7z5dkui7ndp4w@wittgenstein>
 <20191226143229.sbopynwut2hhsiwn@yavin.dot.cyphar.com>
 <57C06925-0CC6-4251-AD57-8FF1BC28F049@ubuntu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="c3fft56kodyqgrhw"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57C06925-0CC6-4251-AD57-8FF1BC28F049@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Sargun Dhillon <sargun@sargun.me>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, tycho@tycho.ws, jannh@google.com, keescook@chromium.org
List-Id: linux-api@vger.kernel.org


--c3fft56kodyqgrhw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-12-26, Christian Brauner <christian.brauner@ubuntu.com> wrote:
> On December 26, 2019 3:32:29 PM GMT+01:00, Aleksa Sarai <cyphar@cyphar.co=
m> wrote:
> >On 2019-12-26, Christian Brauner <christian.brauner@ubuntu.com> wrote:
> >> On Wed, Dec 25, 2019 at 09:45:33PM +0000, Sargun Dhillon wrote:
> >> > This patch is a small change in enforcement of the uapi for
> >> > SECCOMP_IOCTL_NOTIF_RECV ioctl. Specificaly, the datastructure
> >which is
> >> > passed (seccomp_notif), has a flags member. Previously that could
> >be
> >> > set to a nonsense value, and we would ignore it. This ensures that
> >> > no flags are set.
> >> >=20
> >> > Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> >> > Cc: Kees Cook <keescook@chromium.org>
> >>=20
> >> I'm fine with this since we soon want to make use of the flag
> >argument
> >> when we add a flag to get a pidfd from the seccomp notifier on
> >receive.
> >> The major users I could identify already pass in seccomp_notif with
> >all
> >> fields set to 0. If we really break users we can always revert; this
> >> seems very unlikely to me though.
> >>=20
> >> One more question below, otherwise:
> >>=20
> >> Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
> >>=20
> >> > ---
> >> >  kernel/seccomp.c | 7 +++++++
> >> >  1 file changed, 7 insertions(+)
> >> >=20
> >> > diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> >> > index 12d2227e5786..455925557490 100644
> >> > --- a/kernel/seccomp.c
> >> > +++ b/kernel/seccomp.c
> >> > @@ -1026,6 +1026,13 @@ static long seccomp_notify_recv(struct
> >seccomp_filter *filter,
> >> >  	struct seccomp_notif unotif;
> >> >  	ssize_t ret;
> >> > =20
> >> > +	if (copy_from_user(&unotif, buf, sizeof(unotif)))
> >> > +		return -EFAULT;
> >> > +
> >> > +	/* flags is reserved right now, make sure it's unset */
> >> > +	if (unotif.flags)
> >> > +		return -EINVAL;
> >> > +
> >>=20
> >> Might it make sense to use
> >>=20
> >> 	err =3D copy_struct_from_user(&unotif, sizeof(unotif), buf,
> >sizeof(unotif));
> >> 	if (err)
> >> 		return err;
> >>=20
> >> This way we check that the whole struct is 0 and report an error as
> >soon
> >> as one of the members is non-zero. That's more drastic but it'd
> >ensure
> >> that other fields can be used in the future for whatever purposes.
> >> It would also let us get rid of the memset() below.=20
> >
> >Given that this isn't an extensible struct, it would be simpler to just
> >do
> >check_zeroed_user() -- copy_struct_from_user() is overkill. That would
> >also remove the need for any copy_from_user()s and the memset can be
> >dropped by just doing
> >
> >  struct seccomp_notif unotif =3D {};
> >
> >> >  	memset(&unotif, 0, sizeof(unotif));
> >> > =20
> >> >  	ret =3D down_interruptible(&filter->notif->request);
> >> > --=20
> >> > 2.20.1
> >> >=20
>=20
> It is an extensible struct. That's why we have notifier size checking bui=
lt in.

Ah right, NOTIF_GET_SIZES. I reckon check_zeroed_user() is still a bit
simpler since none of the fields are used right now (and really, this
patch should be checking all of them, not just ->flags, if we want to
use any of them in the future).

But sure, copy_struct_from_user() also makes sense since it is
extensible (though I personally do find the whole NOTIF_GET_SIZES thing
a bit scary -- but that's water under the bridge at this point, and as
long as userspace is clever enough it shouldn't be a problem).

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--c3fft56kodyqgrhw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXgVrawAKCRCdlLljIbnQ
Eo16APoDf/QAU6RhEHnw3Vc/rhWcWjyvYNIkYYSq/E0u0jngUgD9Gp6dj5ZDccwE
LSkj5R0pXIHgq93Cgbs9GpwFlRBY7Ao=
=gXMl
-----END PGP SIGNATURE-----

--c3fft56kodyqgrhw--
