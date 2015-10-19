From: Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] userns/capability: Add user namespace capability
Date: Sun, 18 Oct 2015 20:28:07 -0400
Message-ID: <20151019002807.GP28215@vapier.lan>
References: <5622700C.9090107@miglix.eu>
 <CAFLxGvzJONWTbpD8GFfDWDQiPxONrFaRAuXonXXUWaR1pcTUgw@mail.gmail.com>
 <5623FD86.2030609@miglix.eu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="uX2tiToO0oGq+LKk"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5623FD86.2030609-gyUQdkDHmHmHXe+LvDLADg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tobias Markus <tobias-gyUQdkDHmHmHXe+LvDLADg@public.gmane.org>
Cc: Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--uX2tiToO0oGq+LKk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18 Oct 2015 22:13, Tobias Markus wrote:
> On 17.10.2015 22:17, Richard Weinberger wrote:
> > On Sat, Oct 17, 2015 at 5:58 PM, Tobias Markus <tobias-gyUQdkDHmHmHXe+LvDLADg@public.gmane.org> wrote:
> >> One question remains though: Does this break userspace executables that
> >> expect being able to create user namespaces without priviledge? Since
> >> creating user namespaces without CAP_SYS_ADMIN was not possible before
> >> Linux 3.8, programs should already expect a potential EPERM upon calli=
ng
> >> clone. Since creating a user namespace without CAP_SYS_USER_NS would
> >> also cause EPERM, we should be on the safe side.
> >=20
> > In case of doubt, yes it will break existing software.
> > Hiding user namespaces behind CAP_SYS_USER_NS will not magically
> > make them secure.
>=20
> The goal is not to make user namespaces secure, but to limit access to
> them somewhat in order to reduce the potential attack surface.

the irony is that disallowing non-privileged processes access to userns mea=
ns
processes cannot jail themselves and thus make themselves more secure.  i've
been adding userns to various projects purely to get access to things like
mount, net, pid, sysv, and ipc namespaces.

putting this behind a cap also breaks the Chromium sandbox -- they were able
to drop set*id on the sandbox binary and utilize userns instead.
https://chromium.googlesource.com/chromium/src/+/master/docs/linux_sandboxi=
ng.md
https://code.google.com/p/chromium/issues/detail?id=3D312380
-mike

--uX2tiToO0oGq+LKk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWJDkXAAoJEEFjO5/oN/WBofsP/1qQ2m7A86ppAOihhgwhKrhl
ikxGiqv0JzlW1Dvqv+pkz6n5qKvRMgg7Tt3mKTsTKANNdHPX3IMmNIZ4uCCZe0iU
slnKl5EaSK57Jq2VM/DT51KsKmosOwOpkOcfQTZQfwnNEH7jTney7iNAznmrh8Tr
5wIBbg2wVln9VYQyGnWOgRWJgZYpOPaa/gKWqE4p12uRdSh1uZHbQTBTeZBmGbYX
H9QOJ0bynoTO4tUCglR2rLrTO0ADWOEdkslbXpiSFvsvZS0db6QcC1w8M871nKsF
fVSXS6pP66gelNb/c8qYs7ZwwbqW22pa1NAf8UsVhgYol2bQ+m1v7tm8UU7v0YmN
g22H4ueBJb5aR8Um6sUT4/SHQPCMW95CLZsEp0xq5jdLbhJ7/32lWS/YiU+hVM+l
tG2aX1CXMYmalRl1PsS6evdV5ciab3X2LI7wBPaCZ6B/AZy/f7cFy8rynb/MqCNr
UitByL5cKkDS+WbJdsYzLkn2XSlahDv/LFxM7p39c+S1SfVY/qxjoYphA2W57h7x
2wt6f6Qo/S3dxA0VIzpPeS2BVajlimX2W/toNvDRNTbXMIgZpIcvjV0dVbgU96x8
yLDTRZ4ghk850c9VhV4QCMDhvxWBTsVr5aXQEh+27EaiBTQ2VnWfDy79j/rnfSQU
rJCoRB/01SHMaQ8iokuR
=C+zO
-----END PGP SIGNATURE-----

--uX2tiToO0oGq+LKk--
