From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Re: [PATCH v3 1/2] modules:capabilities:
 automatic module loading restriction
Date: Thu, 20 Apr 2017 16:02:23 +0100
Message-ID: <1492700543.31767.23.camel@decadent.org.uk>
References: <1492640420-27345-1-git-send-email-tixxdz@gmail.com>
	 <1492640420-27345-2-git-send-email-tixxdz@gmail.com>
	 <1492654942.31767.21.camel@decadent.org.uk>
	 <CAEiveUdS=GbyxDVeNFrjTmhvQB-a6UgrJXcGY=BYJLu+3z0x_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-t9oUmhpenKVxt7D9yVez"
Return-path: <kernel-hardening-return-7455-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAEiveUdS=GbyxDVeNFrjTmhvQB-a6UgrJXcGY=BYJLu+3z0x_Q@mail.gmail.com>
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, kernel-hardening@lists.openwall.com, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Arnaldo Carvalho de Melo <acme@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Ingo Molnar <mingo@kernel.org>, Zendyani <zendyani@gmail.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org


--=-t9oUmhpenKVxt7D9yVez
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-04-20 at 14:44 +0200, Djalal Harouni wrote:
> > On Thu, Apr 20, 2017 at 4:22 AM, Ben Hutchings <ben@decadent.org.uk> wr=
ote:
> > On Thu, 2017-04-20 at 00:20 +0200, Djalal Harouni wrote:
> > [...]
> > > +modules_autoload:
> > > +
> > > +A sysctl to control if modules auto-load feature is allowed or not.
> > > +This sysctl complements "modules_disabled" which is for all module
> > > +operations where this flag applies only to automatic module loading.
> > > +Automatic module loading happens when programs request a kernel feat=
ure
> > > +that is implemented by an unloaded module, the kernel automatically
> > > +runs the program pointed by "modprobe" sysctl in order to load the
> > > +corresponding module.
> > > +
> > > +When modules_autoload is set to (0), the default, there are no
> > > +restrictions.
> > > +
> > > +When modules_autoload is set to (1), processes must have CAP_SYS_MOD=
ULE
> > > +to be able to trigger a module auto-load operation, or CAP_NET_ADMIN
> > > +for modules with a 'netdev-%s' alias.
> > > +
> > > +When modules_autoload is set to (2), automatic module loading is
> > > +disabled for all. Once set, this value can not be changed.
> >=20
> > I would expect a parameter 'modules_autoload' to be a boolean, so this
> > behaviour would be surprising.
> >=20
> > What is the point of mode 2?=C2=A0=C2=A0Why would someone want to set
> > modules_disabled=3D0 and modules_autoload=3D2?
>=20
> modules_disabled is too restrictive and once set it can't be changed,
> maybe that's why not all users use it.
>=20
> With modules_disabled=3D0 and modules_autoload=3D2
[...]

Hmm, OK.  How about naming this modules_autoload_mode, then, so that
it's obviously not a boolean?

Ben.

--=20
Ben Hutchings
It is easier to change the specification to fit the program than vice
versa.


--=-t9oUmhpenKVxt7D9yVez
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlj4zX8ACgkQ57/I7JWG
EQnWJxAAvvdhA09TsQ6xtWBB4pUjCoHzNS93HNGKSINZ6h3aTN7ySOpHgIXs8zpg
TQruIBt4f3vXHXs7P33iw9CMQT4MQPiYQGISnAmkK/4zwEZQEsBxSTEGhjyDVxKQ
0Etx4wePLXFvT1zGlJ4Mj8jmn84LfNSUPt6OxrfNpCpOUK8hjjyCHp4i3tladJcg
mJkOK/Hmz/vldwssVq/ANXjklmgWQUw8SaVrU4MIb5p0KYJjrOm27C3R4Rxs/k/b
2tb6UWjPHWNI6rDvKdTXDsiEWU237X7bUep9FbkkT9EKc66Hb7MYRFLroR7Mg1Wr
v1GRKPfZZEDh3cIqvLrHn9RQPvgTFAVh5MxxJiTLOr12yzlTQKXMMrOk7ZwNhaYT
5gK5Sizf7NSujjGlc4Zt9ApqJYfGSNtKFhN2Opk9JdYge8HiPL9tPSxwOuA9qvnw
tgZ678nvxfVjDqlEMnwz/0omJRtRjvzxbW1moMbTQ/cZFoEI4iCZV5q2notmDciP
bhFPnvp+1jHlCkzGaT6+Bp639Ukmt4gSqeenGNpI5YnBBqQy2xiwS/LprIOkdPqO
PtPHprlbXvdXUT1wIugRPUtEpUby8zF4bmUZbZWjAjEcEBAICIeZeB0kyXdPAL0z
SYhg/Pt3TvINZ0+zievQm+lMnHSpxEj/uJUTSeLF8WKZ9h3Qzw8=
=DIVS
-----END PGP SIGNATURE-----

--=-t9oUmhpenKVxt7D9yVez--
