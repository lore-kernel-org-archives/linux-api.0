From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH 1/2] uapi: split openat2(2) definitions from fcntl.h
Date: Fri, 20 Dec 2019 00:45:25 +1100
Message-ID: <20191219134525.mgzmjbsp4wo5b2bw@yavin.dot.cyphar.com>
References: <20191219105533.12508-1-cyphar@cyphar.com>
 <20191219105533.12508-2-cyphar@cyphar.com>
 <87a77oy3oe.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qjttenzbgeo3oe2h"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87a77oy3oe.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Shuah Khan <shuah@kernel.org>, David Laight <david.laight@aculab.com>, Christian Brauner <christian.brauner@ubuntu.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--qjttenzbgeo3oe2h
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-12-19, Florian Weimer <fweimer@redhat.com> wrote:
> * Aleksa Sarai:
>=20
> > diff --git a/include/uapi/linux/openat2.h b/include/uapi/linux/openat2.h
> > new file mode 100644
> > index 000000000000..19ef775e8e5e
> > --- /dev/null
> > +++ b/include/uapi/linux/openat2.h
> > @@ -0,0 +1,41 @@
> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > +#ifndef _UAPI_LINUX_OPENAT2_H
> > +#define _UAPI_LINUX_OPENAT2_H
>=20
> I think you should include the relevant header for __align_u64
> etc. here.

Right -- no idea why I forgot to include them.

> [=E2=80=A6]
> > + * Arguments for how openat2(2) should open the target path. If @resol=
ve is
> > + * zero, then openat2(2) operates very similarly to openat(2).
> > + *
> > + * However, unlike openat(2), unknown bits in @flags result in -EINVAL=
 rather
> > + * than being silently ignored. @mode must be zero unless one of {O_CR=
EAT,
> > + * O_TMPFILE} are set.
> > + *
> > + * @flags: O_* flags.
> > + * @mode: O_CREAT/O_TMPFILE file mode.
> > + * @resolve: RESOLVE_* flags.
> > + */
> > +struct open_how {
> > +	__aligned_u64 flags;
> > +	__u16 mode;
> > +	__u16 __padding[3]; /* must be zeroed */
> > +	__aligned_u64 resolve;
> > +};
> > +
> > +#define OPEN_HOW_SIZE_VER0	24 /* sizeof first published struct */
> > +#define OPEN_HOW_SIZE_LATEST	OPEN_HOW_SIZE_VER0
>=20
> Are these really useful for the UAPI header?  Is there a situation where
> OPEN_HOW_SIZE_LATEST would be different from sizeof (struct open_how)?
>=20
> The header is not compatible with the assembler anyway, so the numeric
> constant does not seem useful.

OPEN_HOW_SIZE_VER0 could conceivably be useful (in the future we may do
size-based checks) but maybe we can just expose it if someone actually
ends up needing it.

I will move them to the in-kernel header (we use them for BUILD_BUG_ONs
to make sure that the sizes are correct).

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--qjttenzbgeo3oe2h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXft+8gAKCRCdlLljIbnQ
Ekc2AQClb2qbHajijnt60Pk4O2cvxed5KckYXs6dwwg58HB1oQEAjQvmRi/60gTm
4X83tviudRi/oFgl8Az74op013vZHAY=
=5/Pu
-----END PGP SIGNATURE-----

--qjttenzbgeo3oe2h--
