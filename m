From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH] seccomp: Check flags on seccomp_notif is unset
Date: Fri, 27 Dec 2019 13:28:22 +1100
Message-ID: <20191227022822.v2htxtxxkrkjacem@yavin.dot.cyphar.com>
References: <20191225214530.GA27780@ircssh-2.c.rugged-nimbus-611.internal>
 <20191226115245.usf7z5dkui7ndp4w@wittgenstein>
 <20191226143229.sbopynwut2hhsiwn@yavin.dot.cyphar.com>
 <20191226153753.GA15663@cisco>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gcmjli2uus7kl6h5"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191226153753.GA15663@cisco>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Christian Brauner <christian.brauner@ubuntu.com>, Sargun Dhillon <sargun@sargun.me>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, jannh@google.com, keescook@chromium.org
List-Id: linux-api@vger.kernel.org


--gcmjli2uus7kl6h5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-12-26, Tycho Andersen <tycho@tycho.ws> wrote:
> On Fri, Dec 27, 2019 at 01:32:29AM +1100, Aleksa Sarai wrote:
> > On 2019-12-26, Christian Brauner <christian.brauner@ubuntu.com> wrote:
> > > On Wed, Dec 25, 2019 at 09:45:33PM +0000, Sargun Dhillon wrote:
> > > > This patch is a small change in enforcement of the uapi for
> > > > SECCOMP_IOCTL_NOTIF_RECV ioctl. Specificaly, the datastructure whic=
h is
> > > > passed (seccomp_notif), has a flags member. Previously that could be
> > > > set to a nonsense value, and we would ignore it. This ensures that
> > > > no flags are set.
> > > >=20
> > > > Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> > > > Cc: Kees Cook <keescook@chromium.org>
> > >=20
> > > I'm fine with this since we soon want to make use of the flag argument
> > > when we add a flag to get a pidfd from the seccomp notifier on receiv=
e.
> > > The major users I could identify already pass in seccomp_notif with a=
ll
> > > fields set to 0. If we really break users we can always revert; this
> > > seems very unlikely to me though.
> > >=20
> > > One more question below, otherwise:
> > >=20
> > > Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
> > >=20
> > > > ---
> > > >  kernel/seccomp.c | 7 +++++++
> > > >  1 file changed, 7 insertions(+)
> > > >=20
> > > > diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> > > > index 12d2227e5786..455925557490 100644
> > > > --- a/kernel/seccomp.c
> > > > +++ b/kernel/seccomp.c
> > > > @@ -1026,6 +1026,13 @@ static long seccomp_notify_recv(struct secco=
mp_filter *filter,
> > > >  	struct seccomp_notif unotif;
> > > >  	ssize_t ret;
> > > > =20
> > > > +	if (copy_from_user(&unotif, buf, sizeof(unotif)))
> > > > +		return -EFAULT;
> > > > +
> > > > +	/* flags is reserved right now, make sure it's unset */
> > > > +	if (unotif.flags)
> > > > +		return -EINVAL;
> > > > +
> > >=20
> > > Might it make sense to use
> > >=20
> > > 	err =3D copy_struct_from_user(&unotif, sizeof(unotif), buf, sizeof(u=
notif));
> > > 	if (err)
> > > 		return err;
> > >=20
> > > This way we check that the whole struct is 0 and report an error as s=
oon
> > > as one of the members is non-zero. That's more drastic but it'd ensure
> > > that other fields can be used in the future for whatever purposes.
> > > It would also let us get rid of the memset() below.=20
> >=20
> > Given that this isn't an extensible struct, it would be simpler to just=
 do
> > check_zeroed_user() -- copy_struct_from_user() is overkill. That would
> > also remove the need for any copy_from_user()s and the memset can be
> > dropped by just doing
> >=20
> >   struct seccomp_notif unotif =3D {};
>=20
> This doesn't zero the padding according to the C standard, so no, you
> can't drop the memset, or you may leak kernel stack bits.

Ah right, I didn't double-check if there was any un-named. IMHO, It's a
bit odd to have un-named padding in a struct intended for extensions
(specifically to avoid these problems -- because it means userspace will
pass garbage by accident and there's nothing we can do about it). But
it's a bit late to worry about that now. :P

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--gcmjli2uus7kl6h5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXgVsQgAKCRCdlLljIbnQ
EnPqAQD08AhPvl6lJYODgxQHyFzeUyA/JZTLHQMKdFAhqycteAEA6IMt/FhsEspx
yngR77vCilypAatAOlRiZBzPmERFdA8=
=DToo
-----END PGP SIGNATURE-----

--gcmjli2uus7kl6h5--
